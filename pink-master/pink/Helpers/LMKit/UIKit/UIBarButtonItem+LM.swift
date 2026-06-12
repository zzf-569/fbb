import UIKit
public extension UIBarButtonItem {
    convenience init(image: UIImage?, target: Any?, action: Selector, frame: CGRect = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)) {
        let button = UIButton(image: image, target: target, action: action, frame: frame)
        self.init(customView: button)
    }
    convenience init(title: String, font: UIFont, titleColor: UIColor, target: Any?, action: Selector, frame: CGRect = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)) {
        let button = UIButton(lmfont: font, titleColor: titleColor, target: target, action: action, frame: frame, text: title)
        self.init(customView: button)
    }
}
