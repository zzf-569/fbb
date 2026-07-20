import UIKit
class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        set_upTheme()
        addNavigationPopGes()
    }
    fileprivate func set_upTheme() {
        let navbarTintColor = UIColor.clear
        let titleTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: lmFontM(18)]
        if #available(iOS 13, *) {
            var scrollEdgeAppearance = self.navigationBar.scrollEdgeAppearance
            if scrollEdgeAppearance == nil {
                scrollEdgeAppearance = UINavigationBarAppearance()
            }
            scrollEdgeAppearance?.configureWithOpaqueBackground()
            scrollEdgeAppearance?.backgroundColor = navbarTintColor
            scrollEdgeAppearance?.shadowImage = UIImage()
            scrollEdgeAppearance?.shadowColor = .clear
            scrollEdgeAppearance?.titleTextAttributes = titleTextAttributes
            navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
            let standardAppearance = self.navigationBar.standardAppearance
            standardAppearance.configureWithOpaqueBackground()
            standardAppearance.backgroundColor = navbarTintColor
            standardAppearance.shadowImage = UIImage()
            standardAppearance.shadowColor = .clear
            standardAppearance.titleTextAttributes = titleTextAttributes
            navigationBar.standardAppearance = standardAppearance
        } else {
            navigationBar.barTintColor = navbarTintColor
            navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count >= 1 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.backBarButtonItem = nil
            viewController.navigationItem.setHidesBackButton(true, animated: true)
            let btn = UIButton(image: UIImage(named: "backicon"), target: self, action: #selector(backItemDidiClick))
            btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            let leftBarButtonItem = UIBarButtonItem(customView: btn)
            if #available(iOS 26.0, *) {
                leftBarButtonItem.hidesSharedBackground = true
            } else {
                // Fallback on earlier versions
            }
            viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        super.pushViewController(viewController, animated: animated)
    }
    @objc func backItemDidiClick() {
        popViewController(animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension BaseNavigationController: UIGestureRecognizerDelegate {
    func addNavigationPopGes() {
        guard let interactivePopGes = interactivePopGestureRecognizer else { return }
        guard let interactivePopView = interactivePopGes.view else { return }
        guard let targets = interactivePopGes.value(forKey: "_targets") as? [NSObject] else { return }
        guard let target = targets.first?.value(forKey: "target") else { return }
        let action = Selector(("handleNavigationTransition:"))
        let pan = UIPanGestureRecognizer()
        interactivePopView.addGestureRecognizer(pan)
        pan.addTarget(target, action: action)
        pan.delegate = self
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
        guard let ges = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        if ges.translation(in: gestureRecognizer.view).x * (isLeftToRight ? 1 : -1) <= 0 {
            return false
        }
        return viewControllers.count != 1
    }
}
extension UIScrollView: UIGestureRecognizerDelegate {
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if panBack(gestureRecognizer: gestureRecognizer) {
            return false
        }
        return true
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if panBack(gestureRecognizer: gestureRecognizer) {
            return true
        }
        return false
    }
    func panBack(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGestureRecognizer {
            let point = self.panGestureRecognizer.translation(in: self)
            let state = gestureRecognizer.state
            let locationDistance = UIScreen.main.bounds.size.width
            if state == UIGestureRecognizer.State.began || state == UIGestureRecognizer.State.possible {
                let location = gestureRecognizer.location(in: self)
                if point.x > 0 && location.x < locationDistance && self.contentOffset.x <= 0 {
                    return true
                }
            }
        }
        return false
    }
}
