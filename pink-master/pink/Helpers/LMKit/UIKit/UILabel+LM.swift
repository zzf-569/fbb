import UIKit

private var lmAutoLocalizesTextKey: UInt8 = 0

public protocol LMAutoTextLocalizable: AnyObject {
    var lmAutoLocalizesText: Bool { get set }
}

public extension LMAutoTextLocalizable where Self: NSObject {
    var lmAutoLocalizesText: Bool {
        get {
            (objc_getAssociatedObject(self, &lmAutoLocalizesTextKey) as? Bool) ?? true
        }
        set {
            objc_setAssociatedObject(self, &lmAutoLocalizesTextKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public enum LMUIKitLocalization {
    private static var hasInstalled = false

    public static func install() {
        guard !hasInstalled else { return }
        hasInstalled = true

        LMRuntime.exchangeMethod(selector: #selector(setter: UILabel.text),
                                 replace: #selector(UILabel.lm_setText(_:)),
                                 class: UILabel.self)
        LMRuntime.exchangeMethod(selector: #selector(setter: UILabel.attributedText),
                                 replace: #selector(UILabel.lm_setAttributedText(_:)),
                                 class: UILabel.self)
        LMRuntime.exchangeMethod(selector: #selector(setter: UITextField.text),
                                 replace: #selector(UITextField.lm_setText(_:)),
                                 class: UITextField.self)
        LMRuntime.exchangeMethod(selector: #selector(setter: UITextField.attributedText),
                                 replace: #selector(UITextField.lm_setAttributedText(_:)),
                                 class: UITextField.self)
        LMRuntime.exchangeMethod(selector: #selector(setter: UITextView.text),
                                 replace: #selector(UITextView.lm_setText(_:)),
                                 class: UITextView.self)
        LMRuntime.exchangeMethod(selector: #selector(setter: UITextView.attributedText),
                                 replace: #selector(UITextView.lm_setAttributedText(_:)),
                                 class: UITextView.self)
        LMRuntime.exchangeMethod(selector: #selector(UIButton.setTitle(_:for:)),
                                 replace: #selector(UIButton.lm_setTitle(_:for:)),
                                 class: UIButton.self)
        LMRuntime.exchangeMethod(selector: #selector(UIButton.setAttributedTitle(_:for:)),
                                 replace: #selector(UIButton.lm_setAttributedTitle(_:for:)),
                                 class: UIButton.self)
    }
}

extension UILabel: LMAutoTextLocalizable {
    @objc func lm_setText(_ text: String?) {
        lm_setText(lmAutoLocalizesText ? text?.localized : text)
    }

    @objc func lm_setAttributedText(_ attributedText: NSAttributedString?) {
        lm_setAttributedText(lmAutoLocalizesText ? attributedText?.localized : attributedText)
    }
}

extension UITextField: LMAutoTextLocalizable {
    @objc func lm_setText(_ text: String?) {
        lm_setText(lmAutoLocalizesText ? text?.localized : text)
    }

    @objc func lm_setAttributedText(_ attributedText: NSAttributedString?) {
        lm_setAttributedText(lmAutoLocalizesText ? attributedText?.localized : attributedText)
    }
}

extension UITextView: LMAutoTextLocalizable {
    @objc func lm_setText(_ text: String?) {
        lm_setText(lmAutoLocalizesText ? text?.localized : text)
    }

    @objc func lm_setAttributedText(_ attributedText: NSAttributedString?) {
        lm_setAttributedText(lmAutoLocalizesText ? attributedText?.localized : attributedText)
    }
}

extension UIButton: LMAutoTextLocalizable {
    @objc func lm_setTitle(_ title: String?, for state: UIControl.State) {
        lm_setTitle(lmAutoLocalizesText ? title?.localized : title, for: state)
    }

    @objc func lm_setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {
        lm_setAttributedTitle(lmAutoLocalizesText ? title?.localized : title, for: state)
    }
}

public extension UILabel {
    convenience init(lmfont: UIFont, textColor: UIColor) {
        self.init()
        self.font = lmfont
        self.textColor = textColor
        self.backgroundColor = .clear
    }
}
public extension UILabel {
    @discardableResult
    func lmtext(_ text: String) -> Self {
        self.text = text.localized
        return self
    }
    
    func text(_ text: String) -> Self {
        self.text = text.localized
        return self
    }
    
    @discardableResult
    func numberOfLines(_ number: Int) -> Self {
        self.numberOfLines = number
        return self
    }
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString) -> Self {
        self.attributedText = attributedText
        return self
    }
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    @discardableResult
    func font(_ lmfont: UIFont) -> Self {
        self.font = lmfont
        return self
    }
}
