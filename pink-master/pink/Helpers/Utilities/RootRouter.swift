import UIKit
class RootRouter {
    func setRootViewController(controller: UIViewController, animatedWithOptions: UIView.AnimationOptions?) {
        let window = AppConfig.keyWindow
        if let animationOptions = animatedWithOptions, window.rootViewController != nil {
            window.rootViewController = controller
            UIView.transition(with: window, duration: 0.33, options: animationOptions, animations: {
            }, completion: nil)
        } else {
            window.rootViewController = controller
        }
    }
    func loadMainAppStructure() {
        self.enterAppMainPage()
    }
    func enterAppMainPage() {
        IMService.shared.initSDK()
        if TeenagerModeManager.shared.isOpen {
            let vc = TeenagerModeViewController()
            vc.isMain = true
            setRootViewController(controller: BaseNavigationController(rootViewController: vc), animatedWithOptions: nil)
        } else {
            if UserShared.isLogin, let LoginItem = UserShared.loginToken {
                let tabBar = BaseNavigationController(rootViewController: MainTabBarViewController())
                self.setRootViewController(controller: tabBar, animatedWithOptions: nil)
                UserShared.login(model: LoginItem) {
                    guard let _ = UserShared.user else {
                        AppConfig.keyWindow.rootViewController = BaseNavigationController(rootViewController: LoginViewController())
                        return
                    }
                   
                }
            } else {
                AppConfig.keyWindow.rootViewController = BaseNavigationController(rootViewController: LoginViewController())
            }
        }
        checkVersion()
        ConfigService.shared.getCustomer()
    }
    func checkVersion() {
        ConfigService.shared.getConfig { model in
            if model.code != 0 && model.status != 1 {
                LMVeisionVC(model: model) { isturn in
                    if isturn == true {
                    }
                }.show()
            }
        }
    }
    func checkUserStatus() {
        if UserShared.isLogin, let LoginItem = UserShared.loginToken {
            UserShared.login(model: LoginItem) {
                guard let _ = UserShared.user else {
                    return
                }
            }
        } else {
            AppConfig.keyWindow.rootViewController = BaseNavigationController(rootViewController: LoginViewController())
        }
    }
}
