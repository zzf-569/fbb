import UIKit
class PerFectNameViewController: LMBaseVC {
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(28), textColor: .textDefaulColor)
            .lmtext("您的昵称是?")
            .textAlignment(.center)
        return lb
    }()
    lazy var nameView: UIView = {
        let view = UIView()
            .backgroundColor(.white)
            .cornerRadius(12.0)
        return view
    }()
    lazy var nameField: UITextField = {
        let textField = UITextField(lmfont: lmFontR(16), textColor: UIColor.textDefaulColor, placeholder: "", placeholderColor: UIColor.textTerColor)
        textField.clearButtonMode = .whileEditing
        textField.text = UserShared.user?.nickname
        return textField
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
            .textAlignment(.center)
        return lb
    }()
    lazy var nextbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(18), titleColor: .white, target: self, action: #selector(nextAction))
            .cornerRadius(12)
            .lmtitle("下一步")
        btn.backgroundColor(lmColorHex("#FF4F7D", alpha: 1))
        return btn
    }()
    lazy var skipbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontF(16), titleColor: lmColorHex("#2B313DAD"), target: self, action: #selector(skipAction))
            .cornerRadius(12)
            .lmtitle("跳过")
        return btn
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
    private func setViewSnp() {
        backgroundImage = UIImage(named: "login_bg")
        view.addSubview(skipbtn)
        view.addSubview(titleLab)
        view.addSubview(nameView)
        view.addSubview(namelb)
        nameView.addSubview(nameField)
        view.addSubview(nextbtn)
        skipbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(kStatusBarHeight + 20)
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24 + kNavigationHeight)
            make.centerX.equalToSuperview()
        }
        nameView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(kScaleWidth(40))
            make.size.equalTo(CGSize(width: kScaleWidth(310), height: kScaleWidth(56)))
        }
        nameField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.right.top.bottom.equalToSuperview()
        }
        namelb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextbtn.snp.top).offset(kScaleWidth(-12))
        }
        nextbtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(56 + kTabBarSafeHeight))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(310), height: kScaleWidth(56)))
        }
        view.addGestureTap { [weak self] _ in
            self?.view.resignFirstResponder()
        }
    }
    @objc func skipAction() {
        let login = BaseNavigationController(rootViewController: MainTabBarViewController())
        AppConfig.keyWindow.rootViewController = login
        AppConfig.keyWindow.makeKeyAndVisible()
    }
    @objc func nextAction() {
        guard let text = nameField.text else { HUD.showFailure("请输入昵称～"); return }
        HUD.showLoading()
        UserNetWork.updateUserInfo(nickname: text).lmrequest {[weak self] _ in
            HUD.hide()
            guard let self = self else { return }
            self.navigationController?.pushViewController(PerFectAvatarViewController(), animated: true)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
