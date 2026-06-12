import UIKit
extension BindBankCardViewController {
}
class BindBankCardViewController: LMBaseVC {
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var tipView: UIView = {
        let view = UIView()
            .backgroundColor(lmColorHex("#FF9F40", alpha: 0.08))
        return view
    }()
    private lazy var tiplb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(14), textColor: lmColorHex("#FF9F40"))
            .numberOfLines(0)
            .lmtext("身份证信息、手机号、银行卡、实名认证请确保一致，以免出现不到账情况。")
        return lb
    }()
    private lazy var bankNameItem: BankCardItemView = {
        let view = BankCardItemView(title: "开户行", placeholder: "请输入开户行全称包括支行名称", returnKeyType: .next)
            .backgroundColor(.white)
            .cornerRadius(12.0)
        view.returnClickblock = { [weak self] in
            self?.bankCardNumItem.becomeFirstResponder()
        }
        return view
    }()
    private lazy var bankCardNumItem: BankCardItemView = {
        let view = BankCardItemView(title: "银行卡号", placeholder: "请输入银行卡号", returnKeyType: .next)
            .backgroundColor(.white)
            .cornerRadius(12.0)
        view.returnClickblock = { [weak self] in
            self?.realNameItem.becomeFirstResponder()
        }
        return view
    }()
    private lazy var realNameItem: BankCardItemView = {
        let view = BankCardItemView(title: "真实姓名", placeholder: "请输入银行卡本人姓名", returnKeyType: .next)
            .backgroundColor(.white)
            .cornerRadius(12.0)
        view.returnClickblock = { [weak self] in
            self?.idCardItem.becomeFirstResponder()
        }
        return view
    }()
    private lazy var idCardItem: BankCardItemView = {
        let view = BankCardItemView(title: "身份证号", placeholder: "请输入银行卡本人身份证号码", returnKeyType: .next)
            .backgroundColor(.white)
            .cornerRadius(12.0)
        view.returnClickblock = { [weak self] in
            self?.mobileItem.becomeFirstResponder()
        }
        return view
    }()
    private lazy var mobileItem: BankCardItemView = {
        let view = BankCardItemView(title: "手机号", placeholder: "输入银行卡预留手机号", returnKeyType: .done)
            .backgroundColor(.white)
            .cornerRadius(12.0)
        view.returnClickblock = { [weak self] in
            self?.mobileItem.resignFirstResponder()
        }
        return view
    }()
    private lazy var sendbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .white, target: self, action: #selector(sendbtnAction))
            .backgroundImage(UIImage.image(color: lmColorHex("#FF4F7D"), size: CGSize(width: kScreenWidth -  kScaleWidth(16.0) * 2, height: kScaleWidth(56.0))))
            .cornerRadius(12.0)
            .lmtitle("提交")
            .isEnabled(false)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的银行卡"
        self.view.backgroundColor = lmColorHex("#F5F6FA")
        setViewSnp()
        lmrequestData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
private extension BindBankCardViewController {
    func setViewSnp() {
        view.backgroundColor = .white
        view.addSubview(contentView)
        contentView.addSubview(bankNameItem)
        contentView.addSubview(bankCardNumItem)
        contentView.addSubview(realNameItem)
        contentView.addSubview(idCardItem)
        contentView.addSubview(mobileItem)
        contentView.addSubview(sendbtn)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        bankNameItem.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(0.0))
            make.top.equalToSuperview().offset(kNavigationHeight + kScaleWidth(12.0))
            make.height.equalTo(kScaleWidth(56.0))
        }
        bankCardNumItem.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(0.0))
            make.top.equalTo(bankNameItem.snp.bottom).offset(kScaleWidth(12.0))
            make.height.equalTo(kScaleWidth(56.0))
        }
        realNameItem.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(0.0))
            make.top.equalTo(bankCardNumItem.snp.bottom).offset(kScaleWidth(12.0))
            make.height.equalTo(kScaleWidth(56.0))
        }
        idCardItem.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(0.0))
            make.top.equalTo(realNameItem.snp.bottom).offset(kScaleWidth(12.0))
            make.height.equalTo(kScaleWidth(56.0))
        }
        mobileItem.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(0.0))
            make.top.equalTo(idCardItem.snp.bottom).offset(kScaleWidth(12.0))
            make.height.equalTo(kScaleWidth(56.0))
        }
        sendbtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(10.0))
            make.top.equalTo(mobileItem.snp.bottom).offset(kScaleWidth(40.0))
            make.height.equalTo(kScaleWidth(56.0))
        }
        let lineView = UIView().backgroundColor(lmColorHex("#FF4F7DFF"))
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalTo(sendbtn.snp.bottom).offset(kScaleWidth(20))
            make.size.equalTo(CGSize(width: 4, height: 16))
        }
        let tipslb = UILabel(lmfont: lmFontASHTB(16), textColor: lmColorHex("#2B313D")).lmtext("温馨提示:")
        view.addSubview(tipslb)
        tipslb.snp.makeConstraints { make in
            make.left.equalTo(lineView.snp.right).offset(kScaleWidth(8))
            make.centerY.equalTo(lineView.snp.centerY)
            make.size.equalTo(CGSize(width: kScreenWidth, height: 21))
        }
        let textlb = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#2B313DAD"))
            .lmtext("身份证信息、手机号、银行卡、实名认证请确保一致，以免出现不到账情况。")
            .numberOfLines(0)
        view.addSubview(textlb)
        textlb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.width.equalTo(kScreenWidth - kScaleWidth(40))
            make.top.equalTo(lineView.snp.bottom).offset(15)
        }
    }
    func lmrequestData() {
    }
    func refreshSubviews() {
    }
    @objc func sendbtnAction() {
        guard let bankName = bankNameItem.text else { HUD.showFailure("请输入银行卡名字"); return }
        guard let account = bankCardNumItem.text else { HUD.showFailure("请输入银行卡卡号"); return }
        guard let realName = realNameItem.text else { HUD.showFailure("请输入真实姓名"); return }
        guard let idCard = idCardItem.text else { HUD.showFailure("请输入身份证号"); return }
        guard let mobile = mobileItem.text else { HUD.showFailure("请输入银行卡预留手机号"); return }
        HUD.showLoading()
        WalletNetWork.withdrawBindAccount(account: account, bankName: bankName, mobile: mobile, realName: realName, idCard: idCard).lmrequest { [weak self] _ in
            HUD.showSuccess("绑定成功")
            self?.navigationController?.popViewController(animated: true)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    func checkbtnStatus() {
        if let bankName = bankNameItem.text, bankName.isNoBlank,
           let bankCardNum = bankCardNumItem.text, bankCardNum.isNoBlank,
           let realName = realNameItem.text, realName.isNoBlank,
           let idCard = idCardItem.text, idCard.isNoBlank,
           let mobile = mobileItem.text, mobile.isNoBlank {
            sendbtn.isEnabled(true)
            return
        }
        sendbtn.isEnabled(false)
    }
}
private extension BindBankCardViewController {
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
            let keyY = kScreenHeight - keyboardSize.height
            if let currentView = currentEditingView(), currentView.bottom > keyY {
                UIView.animate(withDuration: duration) { [weak self] in
                    self?.contentView.snp.updateConstraints { make in
                        make.top.equalToSuperview().offset(keyY - currentView.bottom)
                    }
                    self?.contentView.superview?.layoutIfNeeded()
                }
            }
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
        UIView.animate(withDuration: duration) {[weak self] in
            self?.contentView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(0)
            }
            self?.contentView.superview?.layoutIfNeeded()
        }
        checkbtnStatus()
    }
    func currentEditingView() -> UIView? {
        if bankNameItem.isEditing {
            return bankNameItem
        }
        if bankCardNumItem.isEditing {
            return bankCardNumItem
        }
        if realNameItem.isEditing {
            return realNameItem
        }
        if idCardItem.isEditing {
            return idCardItem
        }
        if mobileItem.isEditing {
            return mobileItem
        }
        return nil
    }
}
extension BankCardItemView {
}
class BankCardItemView: UIView {
    var text: String? { textField.text }
    var isEditing: Bool = false
    @discardableResult override func resignFirstResponder() -> Bool { textField.resignFirstResponder() }
    @discardableResult override func becomeFirstResponder() -> Bool { textField.becomeFirstResponder() }
    var returnClickblock: (() -> Void)?
    private let title: String
    private let placeholder: String
    private let returnKeyType: UIReturnKeyType
    required init(title: String, placeholder: String, returnKeyType: UIReturnKeyType) {
        self.title = title
        self.placeholder = placeholder
        self.returnKeyType = returnKeyType
        super.init(frame: .zero)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var radPointView: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#F5455C"))
            .lmtext("*")
        return lb
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#2B313D"))
            .lmtext(title)
        return lb
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField(lmfont: lmFontF(16), textColor: lmColorHex("#2B313D"), placeholder: placeholder, placeholderColor: lmColorHex("#2B313D", alpha: 0.24), delegate: self)
        textField.returnKeyType = returnKeyType
        return textField
    }()
}
private extension BankCardItemView {
    private func setViewSnp() {
        addSubview(radPointView)
        addSubview(titleLab)
        addSubview(textField)
        radPointView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16.0))
            make.centerY.equalToSuperview()
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(radPointView.snp.right).offset(kScaleWidth(0.0))
            make.centerY.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right).offset(kScaleWidth(16.0))
            make.right.lessThanOrEqualToSuperview().offset(-kScaleWidth(16.0))
            make.centerY.equalToSuperview()
            make.height.equalTo(kScaleWidth(40.0))
        }
    }
}
extension BankCardItemView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.isEditing = true
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.isEditing = false
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.returnClickblock?()
        return true
    }
}
