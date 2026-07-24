import UIKit
class LoginViewController: LMBaseVC {
    
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(36), textColor: UIColor.textDefaulColor)
            .lmtext("Hi")
        lb.textAlignment = .left
        return lb
    }()
    lazy var subtitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontR(28), textColor: .textDefaulColor)
            .lmtext("Welcome to")
        lb.textAlignment = .left
        return lb
    }()
    lazy var subdtitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontR(36), textColor: .textDefaulColor)
            .lmtext("Voiro~")
        lb.textAlignment = .left
        return lb
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView().image(UIImage(named: "login_icon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var userField: LMTextFiledView = {
        let field = LMTextFiledView()
        return field
    }()
    
    lazy var enterField: LMTextFiledView = {
        let field = LMTextFiledView()
        field.textField.placeholder = "Enter code"
        field.textField.rightView = sendCodebtn
        field.textField.rightViewMode = .always
        return field
    }()

    lazy var agreementlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(14), textColor: UIColor.textSecondColor)
            .textAlignment(.center)
            .lmtext("")
            .numberOfLines(0)
        return lb
    }()
    lazy var nextbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(18), titleColor: lmColorHex("#A0FA19"), target: self, action: #selector(nextAction))
        btn.backgroundColor = lmColorHex("#192218")
        btn.lmtitle("next")
        return btn
    }()
    private lazy var sendCodebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: lmColorHex("#7DCE02"), target: self, action: #selector(resetSendCodebtnAction))
            .titleColor(UIColor.textDisColor, .disabled)
            .frame(CGRectMake(0, 0, 40, kScaleWidth(40)))
        btn.lmtitle("Get")
        return btn
    }()
    
    
    private lazy var codeBtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: lmColorHex("#192218"), target: self, action: #selector(showCountrySelectView))
            .titleColor(UIColor.textDisColor, .disabled)
            .image(UIImage(named: "more_down"))
            .frame(CGRectMake(0, 0, 60, kScaleWidth(40)))
        btn.lmtitle("+86")
        btn.set_ImageTitleLayout(.imgRight, spacing: 1)
        return btn
    }()
    
    private let maxSeconds: Int = 60
    private var currentSeconds: Int = 0
    private var timer: Timer?
    var type: loginType = .emaile
    
    init(type: loginType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch type {
        case .emaile:
            title = "Sign in with Mail"
            userField.textField.placeholder = "Enter email"
        case .phone:
            title = "Sign in with Phone"
            userField.textField.placeholder = "Enter phone"
            userField.textField.leftView = codeBtn
            userField.textField.leftViewMode = .always
        case .userName:
            title = "Sign In With Account"
            userField.textField.placeholder = "Enter user ID or email"

        }
        
        setViewSnp()
        set_upAgreement()
        IMService.shared.initSDK()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func setViewSnp() {
       
        view.addSubview(titleLab)
        view.addSubview(subtitleLab)
        view.addSubview(subdtitleLab)
        view.addSubview(heroImageView)
        
        view.addSubview(enterField)
        view.addSubview(userField)

        view.addSubview(agreementlb)
        view.addSubview(nextbtn)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(18))
            make.top.equalToSuperview().offset(kNavigationHeight + kScaleWidth(99))
        }
        subtitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(18))
            make.top.equalToSuperview().offset(kNavigationHeight + kScaleWidth(137))
        }
        
        
        subdtitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(18))
            make.top.equalToSuperview().offset(kNavigationHeight + kScaleWidth(165))
        }
        
        heroImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavigationHeight + kScaleWidth(8))
            make.right.equalToSuperview().offset(kScaleWidth(-24))
            make.size.equalTo(CGSize(width: kScaleWidth(191), height: kScaleWidth(218)))
        }
        
        userField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(40))
            make.right.equalToSuperview().offset(kScaleWidth(-40))
            make.top.equalToSuperview().offset(kNavigationHeight + kScaleWidth(315))
            make.height.equalTo(kScaleWidth(40))
        }
        
        enterField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(40))
            make.right.equalToSuperview().offset(kScaleWidth(-40))
            make.top.equalTo(userField.snp.bottom).offset(kScaleWidth(32))
            make.height.equalTo(kScaleWidth(40))
        }
        
        
       
      
       
        agreementlb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(kScaleWidth(24))
            make.top.equalTo(nextbtn.snp.bottom).offset(kScaleWidth(16))
        }
        
        nextbtn.snp.makeConstraints { make in
            make.top.equalTo(enterField.snp.bottom).offset(kScaleWidth(66))
            make.left.equalToSuperview().offset(kScaleWidth(34.0))
            make.right.equalToSuperview().offset(kScaleWidth(-34.0))
            make.height.equalTo(kScaleWidth(56))
        }
    }
  
    func set_upAgreement() {
        let text = "By logging in or registering, you agree to the "
        let textAction1 = "User Service Terms"
       
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: lmFontR(12), .foregroundColor: lmColorHex("#192218", alpha: 0.64)])
        attributedString.append(NSAttributedString(string: textAction1, attributes: [.font: lmFontR(12), .foregroundColor: lmColorHex("#192218", alpha: 0.4), .underlineStyle: NSUnderlineStyle.single]))
      
        self.agreementlb.attributedText = attributedString
        self.agreementlb.addGestureTap { [weak self] tap in
            (tap as? UITapGestureRecognizer)?.didTapLabelAttributedText([textAction1]) { [weak self] text in
                guard let self = self else { return }
                if textAction1 == text {
                    self.navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.service), animated: true)
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
    @objc func showCountrySelectView() {
        view.endEditing(true)
        let countryView = CountrySelectView()
        countryView.didSelectCountry = { [weak self] country in
            self?.codeBtn.lmtitle(country.dialCode)
            self?.codeBtn.set_ImageTitleLayout(.imgRight, spacing: 1)
        }
        countryView.show()
    }

    @objc func resetSendCodebtnAction() {
        guard let phone = self.userField.textField.text, phone.length == 11 else {
            return
        }
        HUD.showLoading()
        LoginNetWork.SendVerifyCode(username: phone, type: "login").lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            if let succ = responseModel.data as? Bool, succ == true {
                HUD.hide()
                changeCodeBtn()
            } else {
                HUD.showFailure("failed")
            }
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func loginAction(_ code: String?) {
        guard let phone = self.userField.textField.text, phone.length == 11 else {
            return
        }
        guard let code = code else {  return }
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
            self.sendCodebtn.lmtitle("(\(self.currentSeconds)s)")
        })
    }
    func ChangeFailureCodeBtn() {
        self.sendCodebtn.isEnabled = true
        self.timer?.invalidate()
        self.timer = nil
        self.sendCodebtn.lmtitle("Get")
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
                let vc = DateOfBirthViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let login = BaseNavigationController(rootViewController: MainTabBarViewController())
                RootRouter().setRootViewController(controller: login, animatedWithOptions: nil)
            }
        }
    }
    @objc func backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
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
      
        guard let phone = self.userField.textField.text, phone.count >= 11 else { HUD.showFailure("请输入正确的手机号"); return }
        guard let code = self.enterField.textField.text else {return}
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
