import UIKit
public extension UIButton {
    convenience init(lmfont: UIFont, titleColor: UIColor, target: Any?, action: Selector, frame: CGRect = CGRect.zero, backgroundColor: UIColor = .clear, text: String = "") {
        self.init(type: .custom)
        self.titleLabel?.font = lmfont
        self.setTitleColor(titleColor, for: .normal)
        self.setTitleColor(titleColor, for: .highlighted)
        self.addTarget(target, action: action, for: .touchUpInside)
        self.backgroundColor = .clear
        self.frame = frame
        self.setTitle(text.localized, for: .normal)
    }
    convenience init(lmfont: UIFont, titleColor: UIColor, frame: CGRect = CGRect.zero, backgroundColor: UIColor = .clear, text: String = "") {
        self.init(type: .custom)
        self.titleLabel?.font = lmfont
        self.setTitleColor(titleColor, for: .normal)
        self.setTitleColor(titleColor, for: .highlighted)
        self.backgroundColor = backgroundColor
        self.frame = frame
        self.setTitle(text.localized, for: .normal)
    }
    convenience init(image: UIImage?, target: Any?, action: Selector, frame: CGRect = CGRect.zero, backgroundColor: UIColor = .clear) {
        self.init(type: .custom)
        self.setImage(image, for: .normal)
        self.setImage(image, for: .highlighted)
        self.addTarget(target, action: action, for: .touchUpInside)
        self.backgroundColor = backgroundColor
        self.frame = frame
    }
    convenience init(image: UIImage?, frame: CGRect = CGRect.zero, backgroundColor: UIColor = .clear) {
        self.init(type: .custom)
        self.setImage(image, for: .normal)
        self.setImage(image, for: .highlighted)
        self.backgroundColor = backgroundColor
        self.frame = frame
    }
}
public extension UIButton {
    @discardableResult
    func lmtitle(_ title: String, _ state: UIControl.State = .normal) -> Self {
        self.setTitle(title.localized, for: state)
        return self
    }
    @discardableResult
    func titleColor(_ titleColor: UIColor, _ state: UIControl.State = .normal) -> Self {
        self.setTitleColor(titleColor, for: state)
        return self
    }
    @discardableResult
    func font(_ titleFont: UIFont) -> Self {
        self.titleLabel?.font = titleFont
        return self
    }
    @discardableResult
    func image(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        self.setImage(image, for: state)
        return self
    }
    @discardableResult
    func backgroundImage(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }
    

}
public extension   UIButton {
    enum ImageTitleLayout {
        case imgTop
        case imgBottom
        case imgLeft
        case imgRight
    }
    @discardableResult
    func set_ImageTitleLayout(_ layout: ImageTitleLayout, spacing: CGFloat = 0) -> UIButton {
        switch layout {
        case .imgLeft:
            alignHorizontal(spacing: spacing, imageFirst: true)
        case .imgRight:
            alignHorizontal(spacing: spacing, imageFirst: false)
        case .imgTop:
            alignVertical(spacing: spacing, imageTop: true)
        case .imgBottom:
            alignVertical(spacing: spacing, imageTop: false)
        }
        return self
    }
    private func alignHorizontal(spacing: CGFloat, imageFirst: Bool) {
        let edgeOffset = spacing / 2
         self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -edgeOffset,
                                            bottom: 0, right: edgeOffset)
         self.titleEdgeInsets = UIEdgeInsets(top: 0, left: edgeOffset,
                                            bottom: 0, right: -edgeOffset)
        if !imageFirst {
             self.transform = CGAffineTransform(scaleX: -1, y: 1)
             self.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
             self.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
         self.contentEdgeInsets = UIEdgeInsets(top: 0, left: edgeOffset, bottom: 0, right: edgeOffset)
    }
    private func alignVertical(spacing: CGFloat, imageTop: Bool) {
        guard let imageSize =  self.imageView?.image?.size,
              let text =  self.titleLabel?.text,
              let font =  self.titleLabel?.font
        else {
            return
        }
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
        let imageVerticalOffset = (titleSize.height + spacing) / 2
        let titleVerticalOffset = (imageSize.height + spacing) / 2
        let imageHorizontalOffset = (titleSize.width) / 2
        let titleHorizontalOffset = (imageSize.width) / 2
        let sign: CGFloat = imageTop ? 1 : -1
         self.imageEdgeInsets = UIEdgeInsets(top: -imageVerticalOffset * sign,
                                            left: imageHorizontalOffset,
                                            bottom: imageVerticalOffset * sign,
                                            right: -imageHorizontalOffset)
         self.titleEdgeInsets = UIEdgeInsets(top: titleVerticalOffset * sign,
                                            left: -titleHorizontalOffset,
                                            bottom: -titleVerticalOffset * sign,
                                            right: titleHorizontalOffset)
        let edgeOffset = (min(imageSize.height, titleSize.height) + spacing) / 2
         self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0, bottom: edgeOffset, right: 0)
    }
}
private var LMUIButtonExpandSizeKey = UnsafeRawPointer("LMUIButtonExpandSizeKey".withCString { $0 })
public extension UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.touchExtendInset == .zero || isHidden || !isEnabled {
            return super.point(inside: point, with: event)
        }
        var hitFrame = bounds.inset(by: self.touchExtendInset)
        hitFrame.size.width = max(hitFrame.size.width, 0)
        hitFrame.size.height = max(hitFrame.size.height, 0)
        return hitFrame.contains(point)
    }
}
public extension UIButton {
    var touchExtendInset: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &LMUIButtonExpandSizeKey) {
                var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
                (value as AnyObject).getValue(&edgeInsets)
                return edgeInsets
            } else {
                return UIEdgeInsets.zero
            }
        }
        set {
            objc_setAssociatedObject(self, &LMUIButtonExpandSizeKey, NSValue(uiEdgeInsets: newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}
private var isIgnoreEvent = false
private var defaultInterval = 0.6
extension UIButton {
    var clickInterval: TimeInterval {
        get {
            if let interval = objc_getAssociatedObject(self, &defaultInterval) as? TimeInterval {
                return interval
            }
            return defaultInterval
        }
        set {
            objc_setAssociatedObject(self, &defaultInterval, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
