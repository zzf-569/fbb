import UIKit
extension VoicePDOrderVC {
    func updateSkill(_ model: DispatchItem) {
        DispatchItem = model
        guestModel = model.guestUser
        anchorModel = model.anchorUser
        dispatchInfoView.setDataSoure(model)
        if guestModel != nil {
            guestView.set_User(guestModel)
        }
        if anchorModel != nil {
            anchorView.set_User(anchorModel)
        }
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
            self.view.isHidden = true
        }
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
class VoicePDOrderVC: UIViewController {
    private let roomId: String
    private let dispatchblock: () -> Void
    private let cancelblock: () -> Void
    private let editblock: () -> Void
    private let updateGuestblock: (UsInfoItem?) -> Void
    private let updateAnchorblock: (UsInfoItem?) -> Void
    private var guestModel: UsInfoItem?
    private var anchorModel: UsInfoItem?
    private var DispatchItem: DispatchItem?
    init(roomId: String, dispatchblock: @escaping () -> Void, cancelblock: @escaping () -> Void, editblock: @escaping () -> Void, updateGuestblock: @escaping (UsInfoItem?) -> Void, updateAnchorblock: @escaping (UsInfoItem?) -> Void) {
        self.roomId = roomId
        self.dispatchblock = dispatchblock
        self.cancelblock = cancelblock
        self.editblock = editblock
        self.updateGuestblock = updateGuestblock
        self.updateAnchorblock = updateAnchorblock
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
    private lazy var bodyimv: UIImageView = {
        let imv = UIImageView()
        let effec = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effec)
        imv.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imv.addGestureTap {[weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
            }
        return imv
    }()
    private lazy var titleV: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(18), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .textAlignment(.center)
            .lmtext("派单")
        return lb
    }()
    private lazy var closehbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_pop_close"), target: self, action: #selector(closehbtnAction))
        return btn
    }()
    private lazy var dispatchInfoView: LMRMPDOrderInfoView = {
        let view = LMRMPDOrderInfoView()
        view.editblock = { [weak self] in
            guard let self = self else { return }
            self.editblock()
            self.hide()
        }
        return view
    }()
    private lazy var guestView: LMRMPDOrderUserView = {
        let view = LMRMPDOrderUserView(frame: .zero, title: "下单嘉宾") { [weak self] user in
            guard let self = self else { return }
            self.guestModel = user
            self.updateGuestblock(user)
        } removeUserblock: { [weak self] in
            guard let self = self else { return }
            self.guestModel = nil
            self.updateGuestblock(nil)
        }
        return view
    }()
    private lazy var anchorView: LMRMPDOrderUserView = {
        let view = LMRMPDOrderUserView(frame: .zero, title: "接单陪玩") { [weak self] user in
            guard let self = self else { return }
            self.anchorModel = user
            self.updateAnchorblock(user)
        } removeUserblock: { [weak self] in
            guard let self = self else { return }
            self.anchorModel = nil
            self.updateAnchorblock(nil)
        }
        return view
    }()
    private lazy var cancelbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_dispatch_order_cancel"), target: self, action: #selector(cancelbtnAction))
        return btn
    }()
    private lazy var dispatchbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_dispatch_order_send"), target: self, action: #selector(dispatchbtnAction))
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        set_Subviews()
        getViewData()
        addKeyboardNotification()
    }
    deinit {
        self.removeKeyboardNotification()
    }
}
private extension VoicePDOrderVC {
    func set_Subviews() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(bodyimv)
        bdView.addSubview(titleV)
        titleV.addSubview(titleLab)
        titleV.addSubview(closehbtn)
        bdView.addSubview(dispatchInfoView)
        bdView.addSubview(guestView)
        bdView.addSubview(anchorView)
        bdView.addSubview(cancelbtn)
        bdView.addSubview(dispatchbtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(0)
            make.height.equalTo(kScreenHeight/3*2)
        }
        bodyimv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(56.0)
        }
        titleLab.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        closehbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36.0)
        }
        dispatchInfoView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(titleV.snp.bottom).offset(8.0)
            make.height.equalTo(88.0)
        }
        guestView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(dispatchInfoView.snp.bottom).offset(24.0)
            make.height.equalTo(78.0)
        }
        anchorView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(guestView.snp.bottom).offset(24.0)
            make.height.equalTo(78.0)
        }
        cancelbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 8.0))
            make.height.equalTo(48.0)
        }
        dispatchbtn.snp.makeConstraints { make in
            make.left.equalTo(cancelbtn.snp.right).offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 8.0))
            make.height.equalTo(48.0)
            make.width.equalTo(cancelbtn.snp.width)
        }
        view.layoutIfNeeded()
        bdView.set_Border(radius: 16.0, conrners: [.topLeft, .topRight])
    }
    func getViewData() {
    }
    func refreshSubviews() {
    }
    @objc func closehbtnAction() {
        self.hide()
    }
    @objc func cancelbtnAction() {
        guard let id = DispatchItem?.id else { HUD.showFailure("请选择派单"); return }
        view.endEditing(true)
        HUD.showLoading()
        OrderApi.cancelDemand(demandId: id).lmrequest { [weak self] _ in
            HUD.showSuccess("撤单成功")
            guard let self = self else { return }
            self.hide()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func dispatchbtnAction() {
        guard let sourceUserId = guestModel?.userId else { HUD.showFailure("请选择下单嘉宾");  return }
        guard let targetUserId = anchorModel?.userId else { HUD.showFailure("请选择接单陪玩");  return }
        guard let id = DispatchItem?.id else { HUD.showFailure("请选择派单"); return }
        view.endEditing(true)
        HUD.showLoading()
        OrderApi.roomCreate(sourceUserId: sourceUserId, targetUserId: targetUserId, bizId: id).lmrequest { [weak self] _ in
            HUD.showSuccess("派单成功")
            guard let self = self else { return }
            self.hide()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
private extension VoicePDOrderVC {
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
            UIView.animate(withDuration: duration) {
                self.bdView.snp.updateConstraints { make in
                    make.top.equalTo(self.view.snp.bottom).offset(-(self.bdView.height + keyboardSize.height))
                }
                self.bdView.superview?.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
        UIView.animate(withDuration: duration) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
}
