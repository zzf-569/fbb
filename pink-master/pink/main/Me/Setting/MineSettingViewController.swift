import UIKit
import Kingfisher
import WebKit
class MineSettingViewController: LMBaseVC {
    private var languageView: LMVerticalView?

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        languageView?.setDataSoure(subTitle: AppLanguageManager.shared.currentLanguage.displayName)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        backgroundImage = nil
        self.title = "设置中心"
        setViewSnp()
    }
    private func setViewSnp() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavigationHeight)
            make.left.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.bottom.equalToSuperview()
        }
        let accountSafeView = LMVerticalView(title: "账号资料")
        accountSafeView.backgroundColor = .white
        accountSafeView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(MinePhoneViewController(), animated: true)
        }
        let realView = LMVerticalView(title: "实名认证")
        realView.backgroundColor = .white
        realView.addGestureTap { [weak self] _ in
            if UserShared.user?.realAuth == true {
                self?.navigationController?.pushViewController(RealAuthSuccessViewController(), animated: true)
            } else {
                self?.navigationController?.pushViewController(RealAuthViewController(routetype: .popView), animated: true)
            }
        }
        scrollView.addSubview(accountSafeView)
        scrollView.addSubview(realView)
        accountSafeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.size.equalTo(CGSize(width: kScreenWidth - kScaleWidth(32), height: kScaleWidth(56)))
        }
        realView.snp.makeConstraints { make in
            make.top.equalTo(accountSafeView.snp.bottom)
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.size.equalTo(CGSize(width: kScreenWidth - kScaleWidth(32), height: kScaleWidth(56)))
        }
        let noticenter = UIView()
        noticenter.backgroundColor = .white
        scrollView.addSubview(noticenter)
        let privacyView = UIView()
        privacyView.backgroundColor = .white
        scrollView.addSubview(privacyView)
        let ruleView = LMVerticalView(title: "隐私权限", type: .nomal)
            .backgroundColor(.white)
        let balckView = LMVerticalView(title: "黑名单", type: .nomal)
            .backgroundColor(.white)
        ruleView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(LimitsViewController(), animated: true)
        }
        balckView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(BlackLiskViewController(), animated: true)
        }
        privacyView.addSubview(ruleView)
        privacyView.addSubview(balckView)
        for (index, view) in privacyView.subviews.enumerated() {
            view.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(CGFloat(index) * kScaleWidth(56) )
                make.height.equalTo(kScaleWidth(56))
                if index == privacyView.subviews.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
        }
        privacyView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.width.equalTo(kScreenWidth - kScaleWidth(32))
            make.top.equalTo(realView.snp.bottom).offset(kScaleWidth(0))
        }
        let otherView = UIView()
        otherView.backgroundColor = .white
        scrollView.addSubview(otherView)
        let diskView = LMVerticalView(title: "清理缓存", type: .nomal)
            .backgroundColor(.white)
        diskView.addGestureTap { [weak self] _ in
            self?.clear()
        }
        let youngView = LMVerticalView(title: "青少年模式", type: .nomal)
            .backgroundColor(.white)
        youngView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(TeenagerModeViewController(), animated: true)
        }
        let languageView = LMVerticalView(title: "语言设置", type: .lbType, subTitle: AppLanguageManager.shared.currentLanguage.displayName)
            .backgroundColor(.white)
        self.languageView = languageView
        languageView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(LanguageSettingViewController(), animated: true)
        }
        let aboutView = LMVerticalView(title: "关于我们", type: .nomal)
            .backgroundColor(.white)
        aboutView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(MineAboutUsViewController(), animated: true)
        }
        otherView.addSubview(diskView)
        otherView.addSubview(youngView)
        otherView.addSubview(languageView)
        otherView.addSubview(aboutView)
        for (index, view) in otherView.subviews.enumerated() {
            view.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(CGFloat(index) * kScaleWidth(56))
                make.height.equalTo(kScaleWidth(56))
                if index == otherView.subviews.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
        }
        otherView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.width.equalTo(kScreenWidth - kScaleWidth(32))
            make.top.equalTo(privacyView.snp.bottom).offset(kScaleWidth(0))
        }
        let logOutbtn = LMVerticalView(title: "退出登录", type: .nomal)
            .backgroundColor(.clear)
        logOutbtn.titleLab.textColor = lmColorHex("#F5455CFF")
        scrollView.addSubview(logOutbtn)
        logOutbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.width.equalTo(kScreenWidth - kScaleWidth(32))
            make.top.equalTo(otherView.snp.bottom).offset(kScaleWidth(0))
            make.height.equalTo(kScaleWidth(56))
            make.bottom.equalToSuperview()
        }
        logOutbtn.addGestureTap { [weak self] _ in
            UserShared.logout {
                let login = LoginViewController()
                RootRouter().setRootViewController(controller: BaseNavigationController(rootViewController: login), animatedWithOptions: nil)
            }
        }
    }
    func setDataSoure() {
    }
    func clear() {
        clearWebCache()
        clearImageCache()
        clearAnimationCache()
        HUD.show("清理成功")
    }
    func clearWebCache() {
        let types = [WKWebsiteDataTypeCookies, WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeOfflineWebApplicationCache]
        let dateFrom: NSDate = NSDate.init(timeIntervalSince1970: 0)
        let set = Set.init(types)
        WKWebsiteDataStore.default().removeData(ofTypes: set, modifiedSince: dateFrom as Date) {
            print("清空缓存完成")
        }
    }
    func clearImageCache() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        FileManager.removeFile(filePath: kDocumentPath + "/" + emojiDirectoryName)
    }
    func clearAnimationCache() {
        FileManager.removeFile(filePath: kDocumentPath + "/" + animationDirectoryName)
        FileManager.removeFile(filePath: kDocumentPath + "/" + nineDirectoryName)
    }
}
