import UIKit
class BuidingNewPhoneViewController: LMBaseVC {
    lazy var phoneTextField: UITextField = {
        let textField = UITextField(lmfont: lmFontM(16), textColor: UIColor.textDefaulColor, placeholder: "输入新手机号", placeholderColor: UIColor.textTerColor)
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .phonePad
        textField.addTarget(self, action: #selector(textFieldDidChangeText), for: .editingChanged)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: kScaleWidth(20), height: kScaleWidth(56)))
        textField.leftView = leftView
        textField.leftViewMode = .always
        return textField
    }()
    private lazy var sendCodebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: lmColorHex("#FF4F7DFF"), target: self, action: #selector(sendSms))
            .titleColor(UIColor.textDisColor, .disabled)
            .lmtitle("获取")
            .frame(CGRect(x: 0, y: 0, width: kScaleWidth(71), height: kScaleWidth(56)))
        return btn
    }()
    lazy var numField: UITextField = {
        let textField = UITextField(lmfont: lmFontR(16), textColor: .textDefaulColor, placeholder: "请输入验证码", placeholderColor: .textDisColor)
        textField.backgroundColor = lmColorHex("#2B313D0A")
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: kScaleWidth(71), height: kScaleWidth(56)))
        rightView.addSubview(sendCodebtn)
        textField.rightView = rightView
        textField.rightViewMode = .always
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: kScaleWidth(20), height: kScaleWidth(56)))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.cornerRadius(8)
        return textField
    }()
    lazy var nextbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .whitePrimary, target: self, action: #selector(nextAction))
            .isEnabled(false)
        btn.lmtitle("更换")
        btn.cornerRadius(kScaleWidth(12))
        btn.backgroundColor = lmColorHex("#FF4F7D")
        return btn
    }()
    private let maxSeconds: Int = 60
    private var currentSeconds: Int = 0
    private var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        getViewData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    func setViewSnp() {
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#FFFFFF")
        title = "更换手机号"
        view.addSubview(phoneTextField)
        view.addSubview(numField)
        view.addSubview(nextbtn)
        phoneTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40.0)
            make.right.equalToSuperview().offset(-40.0)
            make.top.equalToSuperview().offset(40 + kNavigationHeight)
            make.height.equalTo(40.0)
        }
        numField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40.0)
            make.right.equalToSuperview().offset(-40.0)
            make.top.equalToSuperview().offset(40 + kNavigationHeight)
            make.height.equalTo(40.0)
        }
        nextbtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(kScaleWidth(56) + kTabBarSafeHeight))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(310), height: kScaleWidth(56)))
        }
        view.addGestureTap { [weak self] _ in
            self?.phoneTextField.resignFirstResponder()
            self?.numField.resignFirstResponder()
        }
    }
    func getViewData() {
    }
    func refreshSubviews() {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
extension BuidingNewPhoneViewController {
    @objc func backItemDidiClick() {
        self.dismiss(animated: true)
    }
    @objc func textFieldDidChangeText(_ textField: UITextField) {
        if let text = textField.text, text.count >= 11 {
            nextbtn.isEnabled(true)
        } else {
            nextbtn.isEnabled(false)
        }
    }
    @objc func boxbtnAction(_ btn: UIButton) {
        btn.isSelected(!btn.isSelected)
    }
    @objc func nextAction() {
        guard let phone = self.phoneTextField.text, phone.count >= 11, let code = numField.text else { HUD.showFailure("请输入正确的手机号"); return }
        UserNetWork.ReplaceCheck(mobile: phone, verifyCode: code).lmrequest { [weak self] _ in
            HUD.hide()
            guard let self = self else { return }
            HUD.showSuccess("更换成功")
            self.navigationController?.popToRootViewController(animated: true)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func sendSms() {
        guard let phone = self.phoneTextField.text, phone.count >= 11 else { HUD.showFailure("请输入正确的手机号"); return }
        LoginNetWork.SendVerifyCode(username: phone, type: "replace").lmrequest { [weak self] _ in
            guard let self = self else { return }
            changeCodeBtn()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
private extension BuidingNewPhoneViewController {
    func changeCodeBtn() {
        self.sendCodebtn.isEnabled = false
        self.currentSeconds = maxSeconds
        timer = Timer(safeTimerWithTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            if self.currentSeconds == 0 {
                self.ChangeFailureCodeBtn()
                return
            }
            self.currentSeconds -= 1
            self.sendCodebtn.lmtitle("\(self.currentSeconds)s")
        })
    }
    func ChangeFailureCodeBtn() {
        self.sendCodebtn.isEnabled = true
        self.timer?.invalidate()
        self.timer = nil
        self.sendCodebtn.lmtitle("获取")
    }
}
