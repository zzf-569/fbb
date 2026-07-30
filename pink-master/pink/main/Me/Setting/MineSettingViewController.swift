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
        backgroundImage = nil
        view.backgroundColor(lmColorHex("#F5F6FA"))
        self.title = "Setting"
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
        
        let managerCenter = UIView()
        managerCenter.backgroundColor = .white
        managerCenter.set_Border(radius: 16)
        scrollView.addSubview(managerCenter)
        managerCenter.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.width.equalTo(kScreenWidth - kScaleWidth(32))
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.height.equalTo(kScaleWidth(56 * 3))
        }
        
        let accountSafeView = LMVerticalView(title: "Account Management")
        accountSafeView.backgroundColor = .white
        accountSafeView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(LMAccountManagerViewController(), animated: true)
        }
        let realView = LMVerticalView(title: "Message Settings")
        realView.backgroundColor = .white
        realView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(LMMessageSettingsViewController(), animated: true)
        }
        managerCenter.addSubview(accountSafeView)
        managerCenter.addSubview(realView)
        accountSafeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kScaleWidth(0))
            make.left.equalToSuperview().offset(kScaleWidth(0 ))
            make.size.equalTo(CGSize(width: kScreenWidth - kScaleWidth(32), height: kScaleWidth(56)))
        }
        realView.snp.makeConstraints { make in
            make.top.equalTo(accountSafeView.snp.bottom)
            make.left.equalToSuperview().offset(kScaleWidth(0))
            make.size.equalTo(CGSize(width: kScreenWidth - kScaleWidth(32), height: kScaleWidth(56)))
        }
        
        let languageView = LMVerticalView(title: "Language Settings", type: .lbType, subTitle: AppLanguageManager.shared.currentLanguage.displayName)
            .backgroundColor(.white)
        self.languageView = languageView
        languageView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(LanguageSettingViewController(), animated: true)
        }
        managerCenter.addSubview(languageView)
        languageView.snp.makeConstraints { make in
            make.top.equalTo(realView.snp.bottom)
            make.left.equalToSuperview().offset(kScaleWidth(0))
            make.size.equalTo(CGSize(width: kScreenWidth - kScaleWidth(32), height: kScaleWidth(56)))
        }
        
        let privacyView = UIView()
        privacyView.backgroundColor = .white
        managerCenter.set_Border(radius: 16)
        scrollView.addSubview(privacyView)
        let ruleView = LMVerticalView(title: "Privacy", type: .nomal)
            .backgroundColor(.white)
        let balckView = LMVerticalView(title: "Blocklist", type: .nomal)
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
            make.top.equalTo(managerCenter.snp.bottom).offset(kScaleWidth(12))
        }
        let otherView = UIView()
        otherView.backgroundColor = .white
        otherView.set_Border(radius: 16)

        scrollView.addSubview(otherView)
        let diskView = LMVerticalView(title: "Clear cache", type: .nomal)
            .backgroundColor(.white)
        diskView.addGestureTap { [weak self] _ in
            self?.clear()
        }
//        let youngView = LMVerticalView(title: "青少年模式", type: .nomal)
//            .backgroundColor(.white)
//        youngView.addGestureTap { [weak self] _ in
//            self?.navigationController?.pushViewController(TeenagerModeViewController(), animated: true)
//        }
//       
//        let aboutView = LMVerticalView(title: "关于我们", type: .nomal)
//            .backgroundColor(.white)
//        aboutView.addGestureTap { [weak self] _ in
//            self?.navigationController?.pushViewController(MineAboutUsViewController(), animated: true)
//        }
        otherView.addSubview(diskView)
        let aboutView = LMVerticalView(title: "About Us", type: .nomal).backgroundColor(.white)
        aboutView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(MineAboutUsViewController(), animated: true)
        }
        otherView.addSubview(aboutView)
//        otherView.addSubview(youngView)
//        otherView.addSubview(aboutView)
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
            make.top.equalTo(privacyView.snp.bottom).offset(kScaleWidth(12))
        }
        let logOutbtn = LMVerticalView(title: "logOut", type: .nomal)
            .backgroundColor(.clear)
        logOutbtn.titleLab.textColor = lmColorHex("#F5455CFF")
        logOutbtn.set_Border(radius: 16)
        scrollView.addSubview(logOutbtn)
        logOutbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.width.equalTo(kScreenWidth - kScaleWidth(32))
            make.top.equalTo(otherView.snp.bottom).offset(kScaleWidth(12))
            make.height.equalTo(kScaleWidth(56))
            make.bottom.equalToSuperview()
        }
        logOutbtn.addGestureTap { [weak self] _ in
            UserShared.logout {
                let login = FirstLoginViewController()
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
        HUD.show("success")
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
