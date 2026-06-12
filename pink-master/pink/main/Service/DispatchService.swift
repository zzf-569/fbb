import Foundation
class DispatchService: NSObject {
    static let shared = DispatchService()
    private override init() {
        super.init()
    }
    private var dispatchList: [DispatchItem] = []
    private var popWindow: UIWindow?
    private var animations: [() -> Void] = []
    private var isAnimating = false
    func addDispatch(_ model: DispatchItem) {
        dispatchList.append(model)
        if popWindow == nil {
            startNextAnimation()
        }
    }
    private func addAnimation(_ animation: @escaping () -> Void) {
        animations.append(animation)
        if !isAnimating {
            startNextAnimation()
        }
    }
    private func startNextAnimation() {
        guard let model = dispatchList.first else {
            clear()
            return
        }
        if popWindow == nil {
            popWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kStatusBarHeight + 108.0))
            popWindow?.windowLevel = .alert + 1
            popWindow?.isHidden = false
            popWindow?.backgroundColor = .clear
        }
        let pop = LMRMPDPopView(frame: CGRect(x: 16.0, y: -(kStatusBarHeight + 108.0), width: popWindow!.width - 16.0 * 2, height: 108.0), model: model) { [weak self] tempModel in
            guard let self = self else { return }
            if let tempModel = tempModel {
                Task {
                    await VoiceShared.turnToRM(tempModel.roomId)
                }
            }
            dispatchList.removeFirst()
            startNextAnimation()
        }
        pop.backgroundColor = lmColorHex("#FFFFFF")
        pop.set_Border(radius: 18, borderWidth: 0.5, borderColor: lmColorHex("#2B313D", alpha: 0.16))
        pop.show(popWindow!)
    }
    private func clear() {
        popWindow?.isHidden = true
        popWindow = nil
    }
}
