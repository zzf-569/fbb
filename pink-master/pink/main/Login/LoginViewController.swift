import UIKit
class LoginViewController: LMBaseVC {
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(32), textColor: UIColor.textDefaulColor)
            .lmtext("欢迎使用")
        lb.textAlignment = .left
        return lb
    }()
    lazy var subtitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontR(20), textColor: .textDefaulColor)
            .lmtext("立即登录一起开始找大神")
        lb.textAlignment = .left
        return lb
    }()
    lazy var phoneView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "login_phone"))
        view.isUserInteractionEnabled = true
        return view
    }()
    lazy var phoneCodelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(16), textColor: UIColor.textDefaulColor)
            .lmtext("+86")
        return lb
    }()
    lazy var phoneTextField: UITextField = {
        let textField = UITextField(lmfont: lmFontR(16), textColor: UIColor.textDefaulColor, placeholder: "输入手机号", placeholderColor: UIColor.textTerColor)
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .phonePad
        textField.addTarget(self, action: #selector(textFieldDidChangeText), for: .editingChanged)
        return textField
    }()
    lazy var codeView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "login_psw"))
        view.isUserInteractionEnabled = true
        return view
    }()
    lazy var codeTextField: UITextField = {
        let textField = UITextField(lmfont: lmFontR(16), textColor: UIColor.textDefaulColor, placeholder: "请输入短信验证码", placeholderColor: UIColor.textTerColor)
        textField.keyboardType = .phonePad
        return textField
    }()
    lazy var agreementBoxbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "cm_box"), target: self, action: #selector(boxbtnAction))
            .image(UIImage(named: "cm_box_s"), .selected)
        return btn
    }()
    lazy var agreementlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(14), textColor: UIColor.textSecondColor)
            .textAlignment(.center)
            .lmtext("已同意并阅读软件服务协议和隐私政策")
        return lb
    }()
    lazy var nextbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(18), titleColor: .textDefaulColor, target: self, action: #selector(nextAction))
        btn.setBackgroundImage(UIImage(named: "login_next"), for: .normal)
        btn.lmtitle("登录")
        return btn
    }()
    private lazy var sendCodebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: .textDefaulColor, target: self, action: #selector(resetSendCodebtnAction))
            .titleColor(UIColor.textDisColor, .disabled)
        btn.lmtitle("点击获取")
        return btn
    }()
    private let maxSeconds: Int = 60
    private var currentSeconds: Int = 0
    private var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        set_upAgreement()
        getViewData()
        IMService.shared.initSDK()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    func setViewSnp() {
        backgroundImage = UIImage(named: "login_bg")
        let btn = UIButton(image: UIImage(named: "login_back"), target: self, action: #selector(backItemDidiClick))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        view.addSubview(titleLab)
        view.addSubview(subtitleLab)
        view.addSubview(phoneView)
        phoneView.addSubview(phoneCodelb)
        phoneView.addSubview(phoneTextField)
        view.addSubview(codeView)
        codeView.addSubview(codeTextField)
        codeView.addSubview(sendCodebtn)
        view.addSubview(agreementBoxbtn)
        view.addSubview(agreementlb)
        view.addSubview(nextbtn)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(40))
            make.top.equalToSuperview().offset(kNavigationHeight + kScaleWidth(40))
        }
        subtitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(40))
            make.top.equalToSuperview().offset(kNavigationHeight + kScaleWidth(82))
        }
        phoneView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(30.0))
            make.right.equalToSuperview().offset(-kScaleWidth(30.0))
            make.top.equalToSuperview().offset(kScaleWidth(292))
            make.height.equalTo(kScaleWidth(76))
        }
        codeView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(30.0))
            make.right.equalToSuperview().offset(-kScaleWidth(30.0))
            make.top.equalTo(phoneView.snp.bottom).offset(kScaleWidth(6))
            make.height.equalTo(kScaleWidth(76))
        }
        phoneCodelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(32))
            make.centerY.equalToSuperview()
            make.width.equalTo(40.0)
        }
        phoneTextField.snp.makeConstraints { make in
            make.left.equalTo(phoneCodelb.snp.right).offset(kScaleWidth(12))
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(40.0)
        }
        codeTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(32))
            make.right.equalToSuperview().offset(-150)
            make.centerY.equalToSuperview()
            make.height.equalTo(40.0)
        }
        sendCodebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(32))
            make.centerY.equalToSuperview()
        }
        agreementBoxbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(40))
            make.top.equalTo(nextbtn.snp.bottom).offset(kScaleWidth(32.0))
            make.width.height.equalTo(16.0)
        }
        agreementlb.snp.makeConstraints { make in
            make.centerY.equalTo(agreementBoxbtn.snp.centerY)
            make.left.equalTo(agreementBoxbtn.snp.right).offset(kScaleWidth(6))
        }
        nextbtn.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom).offset(kScaleWidth(88))
            make.left.equalToSuperview().offset(kScaleWidth(30.0))
            make.width.equalTo(kScaleWidth(168))
            make.height.equalTo(kScaleWidth(76))
        }
    }
    func getViewData() {
    }
    func refreshSubviews() {
    }
    func set_upAgreement() {
        let text = "已同意并阅读 "
        let textAction1 = "服务协议"
        let textAnd = " 和 "
        let textAction2 = "隐私政策"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: lmFontR(12), .foregroundColor: lmColorHex("#2B313DA3")])
        attributedString.append(NSAttributedString(string: textAction1, attributes: [.font: lmFontR(12), .foregroundColor: UIColor.textLink]))
        attributedString.append(NSAttributedString(string: textAnd, attributes: [.font: lmFontR(12), .foregroundColor: lmColorHex("#2B313DA3")]))
        attributedString.append(NSAttributedString(string: textAction2, attributes: [.font: lmFontR(12), .foregroundColor: UIColor.textLink]))
        self.agreementlb.attributedText = attributedString
        self.agreementlb.addGestureTap { [weak self] tap in
            (tap as? UITapGestureRecognizer)?.didTapLabelAttributedText([textAction1, textAction2]) { [weak self] text in
                guard let self = self else { return }
                if textAction1 == text {
                    self.navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.service), animated: true)
                }
                if textAction2 == text {
                    self.navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.privacy), animated: true)
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
extension LoginViewController {
    @objc func resetSendCodebtnAction() {
        guard let phone = self.phoneTextField.text, phone.length == 11 else {
            return
        }
        HUD.showLoading()
        LoginNetWork.SendVerifyCode(username: phone, type: "login").lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            if let succ = responseModel.data as? Bool, succ == true {
                HUD.hide()
                changeCodeBtn()
            } else {
                HUD.showFailure("发送失败")
            }
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func loginAction(_ code: String?) {
        guard let phone = self.phoneTextField.text, phone.length == 11 else {
            return
        }
        guard let code = code, code.count == 6 else { HUD.showFailure("请输入正确的验证码"); return }
        HUD.showLoading()
        LoginNetWork.SmsLogin(username: phone, verifyCode: code).lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            guard let LoginItem = LoginItem.deserialize(from: responseModel.data as? [String: Any]) else {
                HUD.showFailure(responseModel.message)
                return
            }
            self.loginUser(LoginItem)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
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
            self.sendCodebtn.lmtitle("重新发送（\(self.currentSeconds)s）")
        })
    }
    func ChangeFailureCodeBtn() {
        self.sendCodebtn.isEnabled = true
        self.timer?.invalidate()
        self.timer = nil
        self.sendCodebtn.lmtitle("重新发送")
    }
    func loginUser(_ model: LoginItem) {
        UserShared.login(model: model) { [weak self] in
            guard let self = self else { return }
            guard UserShared.user != nil else {
                return
            }
            self.timer?.invalidate()
            self.timer = nil
            HUD.hide()
            if model.newUser {
                let vc = PerFectSexAgeViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let login = BaseNavigationController(rootViewController: MainTabBarViewController())
                RootRouter().setRootViewController(controller: login, animatedWithOptions: nil)
            }
        }
    }
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
        guard agreementBoxbtn.isSelected else {
            let alert = LMAlertCentreVC(title: "提示", message: "是否同意服务协议和隐私政策", cancel: "取消", confirm: "同意", type: 1) { [weak self] title in
                guard let self = self else { return }
                if title == "同意" {
                    self.agreementBoxbtn.isSelected(true)
                    self.nextAction()
                }
            }
            alert.show(self)
            return
        }
        guard let phone = self.phoneTextField.text, phone.count >= 11 else { HUD.showFailure("请输入正确的手机号"); return }
        guard let code = self.codeTextField.text else {return}
        self.view.endEditing(true)
        HUD.showLoading()
        LoginNetWork.SmsLogin(username: phone, verifyCode: code).lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            guard let LoginItem = LoginItem.deserialize(from: responseModel.data as? [String: Any]) else {
                HUD.showFailure(responseModel.message)
                return
            }
            self.loginUser(LoginItem)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
