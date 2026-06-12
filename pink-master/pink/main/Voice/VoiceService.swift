import Foundation
import UIKit
public let VoiceShared = VoiceService.shared
protocol VoiceServiceDelegate: NSObjectProtocol {
    func quiteRM()
    func reduceRM()
    func showRM()
}
public class VoiceService: NSObject {
    static let shared = VoiceService()
    private override init() {}
    var roomViewController:VoiceVC?
    var floatingView:LMRMFloatingView?
}
extension VoiceService {
    @MainActor func turnToRM(_ roomId: String, commandCode: String? = "") {
        guard roomId.count > 0 else {
            HUD.showFailure("roomId 不能为空")
            return
        }
        guard UserShared.isLogin else {
            let login = LoginViewController()
            RootRouter().setRootViewController(controller: BaseNavigationController(rootViewController: login), animatedWithOptions: nil)
            return
        }
        RoomNetWork.detail(roomId:roomId, commandCode: commandCode).lmrequest { responseModel in
            guard let modelDict = responseModel.data as? [String: Any] else { return }
            guard var dataSoure = RoomItem.deserialize(from: modelDict) else {
                return
            }
            switch ConfigService.shared.reviewStatus {
            case true:
                dataSoure.roomType = .dispatch
            case false:
                break
            }
            switch dataSoure.status {
            case 1:
                self.enterRoom(dataSoure)
            default:
                if roomId == UserShared.user?.roomId {
                    let view = LMRMOpenVC()
                    view.dataSoure = dataSoure
                    view.show()
                } else {
                    HUD.show("当前主播暂未开播哦~")
                }
               break
            }
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @MainActor private func enterRoom(_ model:RoomItem) {
        guard let RoomVC = self.roomViewController else {
            self.roomViewController = VoiceVC(model: model, delegate: self)
            show()
            return
        }
        RoomVC.navigationController?.popToRootViewController(animated: true)
        if RoomVC.viewModel.roomItem.roomId != model.roomId {
            RoomVC.switchRoom(model)
        }
        if floatingView != nil {
            show()
        }
        lmPrint("已进入房间RoomId：\(model.roomId)")
    }
    func exit(completion: @escaping () -> Void) {
        self.roomViewController?.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.roomViewController?.exitRoom {
                self.roomViewController = nil
                completion()
                lmPrint("已退出房间")
            }
        })
        self.floatingView?.deleteView.removeFromSuperview()
        self.floatingView?.removeFromSuperview()
        self.floatingView = nil
    }
    func show() {
        guard let RoomViewController = self.roomViewController else { return }
        let nav = BaseNavigationController(rootViewController:RoomViewController)
        nav.modalPresentationStyle = .fullScreen
        UIViewController.current?.present(nav, animated: true)
        self.floatingView?.deleteView.removeFromSuperview()
        self.floatingView?.removeFromSuperview()
        self.floatingView = nil
        lmPrint("房间已放大")
    }
    func dismiss() {
        guard let roomVC = self.roomViewController else {
            return
        }
        roomVC.dismiss(animated: true)
        if let window = UIApplication.shared.delegate?.window {
            let floatingView = LMRMFloatingView(frame: CGRect(x: kScreenWidth - 72.0 - 10.0, y: kScreenHeight - kTabHeight - 70.0 - 72.0, width: 72.0, height: 72.0), delegate: self)
            window?.addSubview(floatingView)
            floatingView.setDataSoure(roomVC.viewModel.roomItem)
            self.floatingView = floatingView
        }
    }
    func removeFloatingView() {
        self.floatingView?.removeFromSuperview()
        self.floatingView = nil
    }
}
extension VoiceService:VoiceServiceDelegate {
    func quiteRM() {
        exit {}
    }
    func reduceRM() {
        dismiss()
    }
    func showRM() {
        show()
    }
}
