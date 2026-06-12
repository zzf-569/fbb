import UIKit
extension UINavigationController {
    func popToViewControllerAtIndex(index: Int) {
        for (indexN, view) in self.viewControllers.enumerated() {
            if indexN == index {
                self.popToViewController(view, animated: true)
            }
        }
    }
}
