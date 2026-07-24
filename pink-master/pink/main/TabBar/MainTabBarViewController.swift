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
        let listen = LMHomeViewController()
        addChildViewController(listen,
                               title: "Home",
                               image: UIImage(named: "tabbar_home"),
                               selectedImage: UIImage(named: "tabbar_homesele"))

        ///
//        let order = findOrderViewController()
//        addChildViewController(order,
//                               title: "Chats",
//                               image: UIImage(named: "tabbar_msg"),
//                               selectedImage: UIImage(named: "tabbar_msgsele"))
//        
//        let zodiav = ZodiacViewController()
//        addChildViewController(zodiav,
//                               title: "Me",
//                               image: UIImage(named: "tabbar_mine"),
//                               selectedImage: UIImage(named: "tabbar_minesele"))
        
        
        ///
        let message = LMMsgVC(isRoom: false)
        addChildViewController(message,
                               title: "Chats",
                               image: UIImage(named: "tabbar_msg"),
                               selectedImage: UIImage(named: "tabbar_msgsele"))
        
        
        /// 我的
        let mineVC = LMUserViewController(user: UserShared.user!)
        addChildViewController(mineVC,
                               title: "Me",
                               image: UIImage(named: "tabbar_mine"),
                               selectedImage: UIImage(named: "tabbar_minesele"))
    
        
    }
    
    @objc func nt_imUnreadMessageCountChange(_ notification: Notification) {
        guard let count = notification.userInfo?["count"] as? Int else { return }
        self.tabBar.items?[1].badgeValue = count == 0 ? nil : count.toString()
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

