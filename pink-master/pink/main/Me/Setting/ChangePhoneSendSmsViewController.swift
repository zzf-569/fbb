import UIKit
class ChangePhoneSendSmsViewController: LMBaseVC {
    lazy var safView: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "setting_safe"))
        return imageV
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#2B313DAD"))
            .textAlignment(.center)
            .lmtext("为了您的账号安全，需要验证您的设备")
        return lb
    }()
    lazy var bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScaleWidth(188))).backgroundColor(lmColorHex("#FFFFFF"))
        view.addGradientLayer(colors: [lmColorHex("#F5F5F5FF").cgColor, lmColorHex("#FFFFFF00").cgColor, lmColorHex("#000000FF").cgColor], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 1, y: 1), locations: [0, 1])
        return view
    }()
    private lazy var phonelb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(20), textColor: UIColor.textDefaulColor)
            .textAlignment(.center)
        return lb
    }()
    private lazy var sendCodebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: lmColorHex("#FF4F7DFF"), target: self, action: #selector(resetSendCodebtnAction))
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
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .white, target: self, action: #selector(loginAction))
            .isEnabled(false)
        btn.lmtitle("更换")
        btn.cornerRadius(kScaleWidth(12))
        btn.backgroundColor = lmColorHex("#FF4F7D")
        return btn
    }()
    private let phone: String
    private let type: String
    private let maxSeconds: Int = 60
    private var currentSeconds: Int = 0
    private var timer: Timer?
    init(phone: String, type: String) {
        self.phone = phone
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        getViewData()
    }
    func setViewSnp() {
        title = "验证手机号"
        view.backgroundColor = lmColorHex("#FFFFFF")
        backgroundImage = nil
        view.addSubview(self.safView)
        view.addSubview(self.titleLab)
        view.addSubview(self.bottomView)
        view.addSubview(self.nextbtn)
        bottomView.addSubview(self.phonelb)
        bottomView.addSubview(self.numField)
        safView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kScaleWidth(32) + kNavigationHeight)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight + kScaleWidth(132.0))
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(172) + kNavigationHeight)
            make.height.equalTo(kScaleWidth(188))
        }
        phonelb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(40.0))
        }
        numField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(92))
            make.size.equalTo(CGSize(width: kScaleWidth(310), height: kScaleWidth(56)))
        }
        nextbtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(kScaleWidth(56) + kTabBarSafeHeight))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(310), height: kScaleWidth(56)))
        }
        view.addGestureTap { [weak self] _ in
            self?.numField.resignFirstResponder()
        }
    }
    func getViewData() {
        guard let mobel = UserShared.user?.mobile else {
            return
        }
        phonelb.lmtext("\( mobel.hide12BitsPhone())")
    }
    func refreshSubviews() {
    }
}
extension ChangePhoneSendSmsViewController {
    @objc func resetSendCodebtnAction() {
        HUD.showLoading()
        LoginNetWork.SendVerifyCode(username: self.phone, type: type).lmrequest { [weak self] _ in
            guard let self = self else { return }
            HUD.hide()
            changeCodeBtn()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func loginAction() {
        guard let code = numField.text, code.count == 6 else { HUD.showFailure("请输入正确的验证码"); return }
        HUD.showLoading()
        UserNetWork.MobileCheck(mobile: self.phone, verifyCode: code).lmrequest { [weak self] _ in
            HUD.hide()
            guard let self = self else { return }
            self.navigationController?.pushViewController(BuidingNewPhoneViewController(), animated: true)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
private extension ChangePhoneSendSmsViewController {
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
