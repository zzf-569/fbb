import UIKit
public extension UITextView {
    convenience init(lmfont: UIFont, textColor: UIColor, delegate: UITextViewDelegate? = nil, frame: CGRect = CGRect.zero) {
        self.init(frame: frame)
        self.font = lmfont
        self.textColor = textColor
        self.delegate = delegate
        self.backgroundColor = .clear
    }
}
extension UITextView {
    private static let kPlaceholderTag = 20240202
    var placeholder: String {
        set {
            if let lb = viewWithTag(UITextView.kPlaceholderTag) as? UILabel {
                lb.text = newValue
            } else {
                let lb = UILabel()
                lb.tag = UITextView.kPlaceholderTag
                lb.font = font
                lb.numberOfLines = 0
                lb.textColor = .lightGray
                lb.text = newValue
                addSubview(lb)
                setValue(lb, forKey: "_placeholderLabel")
            }
        }
        get {
            let lb = value(forKey: "_placeholderLabel") as? UILabel
            return lb?.text ?? ""
        }
    }
    var placeholderColor: UIColor {
        set {
            if let lb = viewWithTag(UITextView.kPlaceholderTag) as? UILabel {
                lb.textColor = newValue
            } else {
                let lb = UILabel()
                lb.tag = UITextView.kPlaceholderTag
                lb.font = font
                lb.numberOfLines = 0
                lb.textColor = newValue
                addSubview(lb)
                setValue(lb, forKey: "_placeholderLabel")
            }
        }
        get {
            let lb = value(forKey: "_placeholderLabel") as? UILabel
            return lb?.textColor ?? .lightGray
        }
    }
}
