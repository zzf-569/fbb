import UIKit
public extension UITextField {
    convenience init(lmfont: UIFont, textColor: UIColor, placeholder: String = "", placeholderColor: UIColor = UIColor.gray, delegate: UITextFieldDelegate? = nil, frame: CGRect = CGRect.zero) {
        self.init(frame: frame)
        self.font = font
        self.textColor = textColor
        self.placeholder = placeholder.localized
        self.set_PlaceholderAttribute(lmfont: lmfont, color: placeholderColor)
        if let d = delegate {
            self.delegate = d
        }
        self.backgroundColor = .clear
    }
}
public extension   UITextField {
    func set_PlaceholderAttribute(lmfont: UIFont, color: UIColor = .black) {
        let arrStr = NSMutableAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: lmfont])
         self.attributedPlaceholder = arrStr
    }
}
public extension UITextField {
    @discardableResult
    func lmtext(_ text: String) -> Self {
        self.text = text.localized
        return self
    }
    @discardableResult
    func attributedText(_ attributedString: NSAttributedString) -> Self {
        self.attributedText = attributedString
        return self
    }
    @discardableResult
    func placeholder(_ text: String) -> Self {
        placeholder = text.localized
        return self
    }
    @discardableResult
    func attributedPlaceholder(_ text: NSAttributedString) -> Self {
        attributedPlaceholder = text
        return self
    }
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }
    @discardableResult
    func color(_ color: UIColor) -> Self {
        textColor = color
        return self
    }
    @discardableResult
    func color(_ hex: String) -> Self {
        textColor = UIColor.hex(hex)
        return self
    }
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    @discardableResult
    func delegate(_ delegate: UITextFieldDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    @discardableResult
    func keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }
}
