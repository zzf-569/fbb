import UIKit
class LMRMPKSetupVC: UIViewController {
    private let roomId: String
    private var viewModel:VoiceVM
    private var type: Int = 0
    private var time: Int?
    private var pkViewModel :LMRMPKViewModel?
    private lazy var bgView: UIView = {
        let view = UIView()
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var bdView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var openimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_pk_open"))
        return imv
    }()
    private lazy var startView:LMRMPKSetupView = {
        let view = LMRMPKSetupView(self.viewModel, pkViewModel: self.pkViewModel) { [weak self] type, time in
            guard let self = self else { return }
            self.type = type
            self.time = time
        }
        return view
    }()
    private lazy var endimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_pk_end"))
        return imv
    }()
    private lazy var closeimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_pk_close"))
        return imv
    }()
    var selectedPKTimeblock: ((Int) -> Void)?
    var hidden: (() -> Void)?
    private lazy var actionbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(16), titleColor: .white, target: self, action: #selector(ionbtn))
            .backgroundColor(lmColorHex("#FF4F7DFF"))
            .cornerRadius(12)
            .lmtitle("开启PK")
        return btn
    }()
    init(roomId: String, viewModel:VoiceVM, pkViewModel: LMRMPKViewModel?) {
        self.roomId = roomId
        self.viewModel = viewModel
        self.pkViewModel = pkViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
    func show(_ vc: UIViewController? = nil) {
        if let viewController = vc {
            viewController.addChild(self)
            viewController.view.addSubview(self.view)
        } else {
            UIViewController.current?.addChild(self)
            UIViewController.current?.view.addSubview(self.view)
        }
        self.view.frame = UIScreen.main.bounds
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.clear()
        }
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
private extension LMRMPKSetupVC {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        set_upStatus()
    }
    func set_upStatus() {
        bdView.addSubview(startView)
        startView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 8.0 + 56.0))
        }
        bdView.addSubview(actionbtn)
        actionbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 8.0))
            make.height.equalTo(56.0)
        }
        if viewModel.roomItem.roomPkInfo != nil {
            if viewModel.roomItem.roomPkInfo?.status == .start {
                actionbtn.lmtitle("正在PK中，点击结束")
            } else {
                actionbtn.lmtitle("开始 PK")
            }
            return
        }
        switch pkViewModel?.dataSoure.status {
            case .normal, .close:
                actionbtn.lmtitle("开始 PK")
            case .open:
                actionbtn.lmtitle("开始 PK")
            case .start, .end:
                actionbtn.lmtitle("正在PK中，点击结束")
        case .none:
            break
        }
    }
    @objc func closehbtnAction() {
        self.hide()
    }
    @objc func ionbtn() {
        if viewModel.roomItem.roomPkInfo != nil {
            LMAlertCentreVC(title: "温馨提示", message: "中途结束PK后,将清空PK值", cancel: "取消", confirm: "确定") { string in
                if string == "确定" {
                   RoomPKNetWork.closePK(roomId: self.viewModel.roomItem.roomId).lmrequest { _ in
                        HUD.hide()
                        self.hidden?()
                    } failureBlock: { error in
                        HUD.show(error.message)
                    }
                }
            }.show()
            return
        }
        switch pkViewModel?.dataSoure.status {
        case .open, .normal, .close:
            guard let time = self.time, time != 0 else {
                HUD.showFailure("请选择时间")
                return
            }
            if self.type == 1 {
                self.selectedPKTimeblock?(time)
                self.hidden?()
                return
            }
            HUD.showLoading()
           RoomPKNetWork.startPK(roomId:roomId, pkTime: time).lmrequest { _ in
                HUD.hide()
                self.hidden?()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        case .start, .end:
            LMAlertCentreVC(title: "温馨提示", message: "中途结束PK后,将清空PK值", cancel: "取消", confirm: "确定") { string in
                if string == "确定" {
                    guard let roundId = self.pkViewModel?.dataSoure.roundId else {
                        HUD.showFailure("缺少轮次 ID")
                        return
                    }
                    HUD.showLoading()
                   RoomPKNetWork.endPK(roomId: self.viewModel.roomId, roundId: roundId).lmrequest { [weak self] _ in
                        HUD.hide()
                        self?.closePK()
                        self?.hidden?()
                    } failureBlock: { error in
                        HUD.showFailure(error.message)
                    }
                }
            }.show()
        case .none:
            break
        }
    }
    func closePK() {
       RoomPKNetWork.closePK(roomId:roomId).lmrequest { _ in
            HUD.hide()
            self.hidden?()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
extension LMRMPKSetupVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        self.view
    }
}
