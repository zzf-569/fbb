import UIKit
extension LMRMPDReleaseVC {
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
class LMRMPDReleaseVC: UIViewController {
    enum Sex: Int, SmartCaseDefaultable {
        static var defaultCase: Sex = .unlimited
        case unlimited = -1
        case girl = 2
        case boy = 1
    }
    private let roomId: String
    private let DispatchItem: DispatchItem?
    private var skillList: [SkillItem] = []
    private var skillItem: SkillItem?
    private var sex: LMRMPDReleaseVC.Sex?
    private var price: String?
    private var remark: String?
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
        view.addGestureTap {[weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
            }
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
            .lmtext("发布需求")
        return lb
    }()
    private lazy var closebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_pop_close"), target: self, action: #selector(closehbtnAction))
        return btn
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
            .backgroundColor(.clear)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private lazy var scrollContentView: UIView = {
        let view = UIView()
            .backgroundColor(.clear)
        return view
    }()
    private lazy var typeTextField: UITextField = {
        let textField = UITextField(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFF", alpha: 0.96), placeholder: "请选择品类", placeholderColor: lmColorHex("#FFFFFF", alpha: 0.24))
        let rightimv = UIImageView(image: UIImage(named: "rm_dispatch_release_down"))
        rightimv.frame = CGRect(x: 0, y: 0, width: 16.0, height: 16.0)
        textField.rightView = rightimv
        textField.rightViewMode = .always
        textField.delegate = self
        return textField
    }()
    private lazy var sexView: LMRMPDReleaseSexView = {
        let sexView = LMRMPDReleaseSexView()
        sexView.clickActionblock = { [weak self] sex in
            guard let self = self else { return }
            self.sex = sex
            checkReleaseStatus()
        }
        return sexView
    }()
    private lazy var priceTextField: UITextField = {
        let textField = UITextField(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFF", alpha: 0.96), placeholder: "请输入单价说明 ", placeholderColor: lmColorHex("#FFFFFF", alpha: 0.24))
        return textField
    }()
    private lazy var remarkTextView: UITextView = {
        let textView = UITextView(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .backgroundColor(lmColorHex("#000000", alpha: 0.2))
            .cornerRadius(9.0, borderColor: lmColorHex("#FFFFFF", alpha: 0.16), borderWidth: 0.5)
        textView.placeholder = "请输入备注说明"
        textView.delegate = self
        textView.placeholderColor = lmColorHex("#FFFFFF", alpha: 0.24)
        textView.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        return textView
    }()
    private lazy var releasebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_dispatch_release_s"))
            .image(UIImage(named: "rm_dispatch_release_n"), .disabled)
            .isEnabled(false)
        btn.addTarget(self, action: #selector(releasebtnAction), for: .touchUpInside)
        return btn
    }()
    init(roomId: String, DispatchItem: DispatchItem?) {
        self.roomId = roomId
        self.DispatchItem = DispatchItem
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        set_Subviews()
        getViewData()
        refreshSubviews()
        addKeyboardNotification()
    }
    deinit {
        self.removeKeyboardNotification()
    }
}
extension LMRMPDReleaseVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedSkillAction()
        return false
    }
}
private extension LMRMPDReleaseVC {
    func set_Subviews() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(bodyimv)
        bdView.addSubview(titleV)
        titleV.addSubview(titleLab)
        titleV.addSubview(closebtn)
        bdView.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        let typeView = createTypeView(0.0)
        scrollContentView.addSubview(typeView)
        let sexView = createSexView(typeView.bottom + 24.0)
        scrollContentView.addSubview(sexView)
        let priceView = createPriceView(sexView.bottom + 24.0)
        scrollContentView.addSubview(priceView)
        let remarkView = createRemarkView(priceView.bottom + 24.0)
        scrollContentView.addSubview(remarkView)
        bdView.addSubview(releasebtn)
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
        closebtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36.0)
        }
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleV.snp.bottom).offset(8.0)
            make.bottom.equalTo(releasebtn.snp.top).offset(-20.0)
        }
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.bottom.equalTo(remarkView.snp.bottom).offset(20.0)
        }
        releasebtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 8.0))
            make.height.equalTo(56.0)
        }
        view.layoutIfNeeded()
        bdView.set_Border(radius: 16.0, conrners: [.topLeft, .topRight])
    }
    func createTypeView(_ y: Double) -> UIView {
        let view = UIView(frame: CGRect(x: 16.0, y: y, width: kScreenWidth - 16.0 * 2, height: 78.0))
        let markimv = UIImageView(image: UIImage(named: "rm_dispatch_release_mark"))
        view.addSubview(markimv)
        let titleLab = UILabel(lmfont: lmFontM(14), textColor: .white)
        titleLab.text = "品类"
        view.addSubview(titleLab)
        let bgView = UIView()
            .backgroundColor(lmColorHex("#000000", alpha: 0.2))
            .cornerRadius(9.0, borderColor: lmColorHex("#FFFFFF", alpha: 0.16), borderWidth: 0.5)
        view.addSubview(bgView)
        bgView.addSubview(typeTextField)
        markimv.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(5.0)
            make.width.equalTo(3.0)
            make.height.equalTo(12.0)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(markimv.snp.right).offset(8.0)
            make.centerY.equalTo(markimv)
        }
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(48.0)
        }
        typeTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(40.0)
        }
        return view
    }
    func createSexView(_ y: Double) -> UIView {
        let view = UIView(frame: CGRect(x: 16.0, y: y, width: kScreenWidth - 16.0 * 2, height: 70.0))
        let markimv = UIImageView(image: UIImage(named: "rm_dispatch_release_mark"))
        view.addSubview(markimv)
        let titleLab = UILabel(lmfont: lmFontM(14), textColor: .white)
        titleLab.text = "性别"
        view.addSubview(titleLab)
        view.addSubview(sexView)
        markimv.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(5.0)
            make.width.equalTo(3.0)
            make.height.equalTo(12.0)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(markimv.snp.right).offset(8.0)
            make.centerY.equalTo(markimv)
        }
        sexView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(40.0)
        }
        return view
    }
    func createPriceView(_ y: Double) -> UIView {
        let view = UIView(frame: CGRect(x: 16.0, y: y, width: kScreenWidth - 16.0 * 2, height: 78.0))
        let markimv = UIImageView(image: UIImage(named: "rm_dispatch_release_mark"))
        view.addSubview(markimv)
        let titleLab = UILabel(lmfont: lmFontM(14), textColor: .white)
        titleLab.text = "单价"
        view.addSubview(titleLab)
        let bgView = UIView()
            .backgroundColor(lmColorHex("#000000", alpha: 0.2))
            .cornerRadius(9.0, borderColor: lmColorHex("#FFFFFF", alpha: 0.16), borderWidth: 0.5)
        view.addSubview(bgView)
        bgView.addSubview(priceTextField)
        markimv.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(5.0)
            make.width.equalTo(3.0)
            make.height.equalTo(12.0)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(markimv.snp.right).offset(8.0)
            make.centerY.equalTo(markimv)
        }
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(48.0)
        }
        priceTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(40.0)
        }
        return view
    }
    func createRemarkView(_ y: Double) -> UIView {
        let view = UIView(frame: CGRect(x: 16.0, y: y, width: kScreenWidth - 16.0 * 2, height: 150.0))
        let markimv = UIImageView(image: UIImage(named: "rm_dispatch_release_mark"))
        view.addSubview(markimv)
        let titleLab = UILabel(lmfont: lmFontM(14), textColor: .white)
        titleLab.text = "备注"
        view.addSubview(titleLab)
        view.addSubview(remarkTextView)
        markimv.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(5.0)
            make.width.equalTo(3.0)
            make.height.equalTo(12.0)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(markimv.snp.right).offset(8.0)
            make.centerY.equalTo(markimv)
        }
        remarkTextView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(120.0)
        }
        return view
    }
    func checkReleaseStatus() {
        price = self.priceTextField.text
        guard
        skillItem != nil,
        sex != nil,
        price != nil,
        remark != nil else {
            releasebtn.isEnabled = false
            return
        }
        releasebtn.isEnabled = true
    }
    func getViewData() {
        CommonNetWork.skillList().lmrequest { responseModel in
            guard let list = [SkillItem].deserialize(from: responseModel.data as? [Any]) else { return }
            self.skillList = list
        } failureBlock: { _ in
        }
    }
    func refreshSubviews() {
        guard let DispatchItem = DispatchItem else { return }
        skillItem = SkillItem(skillName: DispatchItem.bizName, skillIcon: DispatchItem.bizIcon)
        sex = DispatchItem.gender
        price = DispatchItem.demandPrice
        remark = DispatchItem.remark
        typeTextField.text = skillItem?.skillName
        sexView.set_Status(sex ?? .unlimited)
        priceTextField.text = price
        remarkTextView.text = remark
    }
    @objc func closehbtnAction() {
        self.hide()
    }
    @objc func releasebtnAction() {
        guard let skillItem = skillItem else {
            HUD.showFailure("请选择技能")
            return
        }
        guard let sex = sex else {
            HUD.showFailure("请选择性别")
            return
        }
        guard let price = price else {
            HUD.showFailure("请输入价格")
            return
        }
        guard let remark = remark else {
            HUD.showFailure("请输入备注")
            return
        }
        HUD.showLoading()
        OrderApi.publish(bizId: skillItem.skillId,roomId:roomId, gender: sex.rawValue, demandPrice: price, remark: remark).lmrequest { [weak self] _ in
            HUD.hide()
            guard let self = self else { return }
            self.hide()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func selectedSkillAction() {
        let items = self.skillList.map { model -> PickerListModel in
            return PickerListModel(title: model.skillName, value: model)
        }
        let picker = LMPickerVC(theme: .light, title: "请选择品类", dataSource: items, cancel: "取消", confirm: "确定") { [weak self] item in
            guard let self = self else { return }
            guard let item = item else { return }
            guard let model = item.value as? SkillItem else { return }
            self.skillItem = model
            self.typeTextField.text = model.skillName
            checkReleaseStatus()
        }
        picker.show()
    }
}
extension LMRMPDReleaseVC: UITextViewDelegate {
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
    func textViewDidChange(_ textView: UITextView) {
        self.remark = textView.text
         checkReleaseStatus()
    }
}
