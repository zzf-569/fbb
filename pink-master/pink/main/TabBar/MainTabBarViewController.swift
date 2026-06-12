import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = lmColorHex("#F3F3F5")
        NotificationCenter.default.addObserver(self, selector: #selector(nt_imUnreadMessageCountChange), name: NotificationName.imUnreadMessageCountChange, object: nil)
        
        if UserShared.isLogin {
            IMService.shared.upIMUnCount()
        }
        
        if #available(iOS 13.0, *) {
            let standardAppearance = self.tabBar.standardAppearance
            standardAppearance.shadowImage = UIImage();
            standardAppearance.shadowColor = UIColor.clear
            self.tabBar.standardAppearance = standardAppearance;
        } else {
            self.tabBar.shadowImage = UIImage()
        }
        
//        // 设置tabBar的高度
        let tabBarHeight: CGFloat = 49
        let tabBarFrame = CGRect(x: 0, y: view.frame.size.height - tabBarHeight, width: view.frame.size.width, height: tabBarHeight)
        let customTabBar = MainTabBar(frame: tabBarFrame)
        view.addSubview(customTabBar)
        customTabBar.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth]
            
        // 调整additionalSafeAreaInsets以适应自定义tabBar的高度
        additionalSafeAreaInsets.bottom = 5
        
        customTabBar.isTranslucent = false
        customTabBar.backgroundColor = UIColor.white
        customTabBar.barTintColor = UIColor.white
        customTabBar.set_Border(radius: 14)
        self.setValue(customTabBar, forKey: "tabBar")
    
     
        /// 首页
        let listen = LMHearVC()
        addChildViewController(listen,
                               title: "听听",
                               image: UIImage(named: "tab_hear"),
                               selectedImage: UIImage(named: "tab_hear_s"))

        ///
        let order = findOrderViewController()
        addChildViewController(order,
                               title: "派单",
                               image: UIImage(named: "tab_order"),
                               selectedImage: UIImage(named: "tab_order_s"))
        
        let zodiav = ZodiacViewController()
        addChildViewController(zodiav,
                               title: "生肖",
                               image: UIImage(named: "tab_zodiac"),
                               selectedImage: UIImage(named: "tab_zodiac_s"))
        
        
        ///
        let message = LMMsgVC(isRoom: false)
        addChildViewController(message,
                               title: "消息",
                               image: UIImage(named: "tab_msg"),
                               selectedImage: UIImage(named: "tab_msg_s"))
        
        
        /// 我的
        let mineVC = LMUserViewController(user: UserShared.user!)
        addChildViewController(mineVC,
                               title: "小窝",
                               image: UIImage(named: "tab_user"),
                               selectedImage: UIImage(named: "tab_user_s"))
    
        
    }
    
    @objc func nt_imUnreadMessageCountChange(_ notification: Notification) {
        guard let count = notification.userInfo?["count"] as? Int else { return }
        self.tabBar.items?[3].badgeValue = count == 0 ? nil : count.toString()
    }
     

    
    func addChildViewController(_ childController: UIViewController, title:String?, image:UIImage? ,selectedImage:UIImage?) {
        
        childController.title = title
        childController.tabBarItem = UITabBarItem(title: title,
                                                  image: image?.withRenderingMode(.alwaysOriginal),
                                                  selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        childController.tabBarItem .setTitleTextAttributes([.font: lmFontM(12), .foregroundColor: lmColorHex("#2B313D", alpha: 0.4)], for: .normal)
        childController.tabBarItem .setTitleTextAttributes([.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313D")], for: .selected)
        addChild(childController)
    }
    
    
    
    
}

extension MainTabBarViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let select = selectedViewController else { return .lightContent }
        return select.preferredStatusBarStyle
    }
}

