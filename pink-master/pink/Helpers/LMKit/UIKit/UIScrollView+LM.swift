import UIKit
public extension UIScrollView {
    func neverAdjustContentInset() {
        if #available(iOS 11, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
}
