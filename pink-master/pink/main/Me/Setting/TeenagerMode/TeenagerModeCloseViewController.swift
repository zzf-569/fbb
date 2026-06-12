import UIKit
extension TeenagerModeCloseViewController {
}
class TeenagerModeCloseViewController: LMBaseVC {
    var isMain: Bool = false
    private var password: String?
    lazy var textField: UITextField = {
        let textField = UITextField(lmfont: lmFontR(16), textColor: .textDefaulColor)
            .placeholder("输入青少年模式6位数字密码")
            .cornerRadius(16)
        textField.backgroundColor(lmColorHex("#2B313D0A"))
        textField.textAlignment = .center
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setViewSnp()
        getViewData()
        view.addGestureTap { [weak self] _ in
            self?.textField.resignFirstResponder()
        }
    }
}
private extension TeenagerModeCloseViewController {
    func setViewSnp() {
        let logoimv = UIImageView(image: UIImage(named: "me_teenagerMode_logo"))
        view.addSubview(logoimv)
        logoimv.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight + 12.0)
            make.width.equalTo(kScaleWidth(240))
            make.height.equalTo(kScaleWidth(160))
        }
        let titleLab = UILabel(lmfont: lmFontASHTB(24), textColor: .textDefaulColor)
        let isOpen = TeenagerModeManager.shared.isOpen
        titleLab.lmtext(isOpen ? "关闭青少年模式" : "开启青少年模式")
        view.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoimv.snp.bottom).offset(kScaleWidth(40))
        }
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoimv.snp.bottom).offset(kScaleWidth(104))
            make.size.equalTo(CGSize(width: kScaleWidth(310), height: kScaleWidth(56)))
        }
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .white, target: self, action: #selector(btnAction))
            .backgroundColor(lmColorHex("#26D477"))
            .cornerRadius(56/2)
            .lmtitle("立即开启")
        view.addSubview(btn)
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavigationHeight + 40.0)
            make.centerX.equalToSuperview()
        }
        btn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50.0)
            make.right.equalToSuperview().offset(-50.0)
            make.bottom.equalToSuperview().offset(-(kScaleWidth(56) + kTabBarSafeHeight))
            make.height.equalTo(56.0)
        }
    }
    func getViewData() {
    }
    func refreshSubviews() {
    }
    @objc func btnAction() {
        guard let password = self.textField.text, password.count == 6 else {
            HUD.showFailure("请输入6位数密码")
            return
        }
        let originalPassword = TeenagerModeManager.shared.password
        if password == originalPassword {
            TeenagerModeManager.shared.close()
            let tabBar = BaseNavigationController(rootViewController: MainTabBarViewController())
            AppConfig.keyWindow.rootViewController = tabBar
        } else {
            HUD.showFailure("密码错误")
        }
    }
}
