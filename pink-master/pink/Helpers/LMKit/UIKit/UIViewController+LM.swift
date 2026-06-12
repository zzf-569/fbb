import UIKit
extension UIViewController {
    static var current: UIViewController? {
        let keyWindow = AppConfig.keyWindow
        var current = keyWindow.rootViewController
        while current?.presentedViewController != nil {
            current = current?.presentedViewController
        }
        if let tabBar = current as? MainTabBarViewController,
            tabBar.selectedViewController != nil {
            current = tabBar.selectedViewController
        }
        while let nav = current as? BaseNavigationController, nav.topViewController != nil {
            current = nav.topViewController
        }
        return current
    }
}
private var ListControllerViewDidScrollKey: Void?
extension JXPagingViewListViewDelegate where Self: UIViewController {
    var listViewDidScrollCallback: ((UIScrollView) -> Void)? {
        get { objc_getAssociatedObject(self, &ListControllerViewDidScrollKey) as? (UIScrollView) -> Void }
        set { objc_setAssociatedObject(self, &ListControllerViewDidScrollKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
