import UIKit
public extension   UIView {
    var viewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    func toImage() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions( self.frame.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
         self.layer.render(in: context)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage
    }
    func addTapGestureRecognizerAction(_ target: Any, _ selector: Selector) {
         self.isUserInteractionEnabled = true
         self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
    }
}
public extension UIView {
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.x = newValue
            self.frame = tempFrame
        }
    }
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.y = newValue
            self.frame = tempFrame
        }
    }
    var height: CGFloat {
        get {
            return self.frame.height
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.size.height = newValue
            self.frame = tempFrame
        }
    }
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.size.width = newValue
            self.frame = tempFrame
        }
    }
    var size: CGSize {
        get {
            return self.frame.size
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.size = newValue
            self.frame = tempFrame
        }
    }
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newValue) {
            var tempCenter: CGPoint = self.center
            tempCenter.x = newValue
            self.center = tempCenter
        }
    }
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(newValue) {
            var tempCenter: CGPoint = self.center
            tempCenter.y = newValue
            self.center = tempCenter
        }
    }
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.y = newValue
            self.frame = tempFrame
        }
    }
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.x = newValue
            self.frame = tempFrame
        }
    }
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set(newValue) {
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }
    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set(newValue) {
            self.frame.origin.x = newValue - self.frame.size.width
        }
    }
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set(newValue) {
            var tempOrigin: CGPoint = self.frame.origin
            tempOrigin = newValue
            self.frame.origin = tempOrigin
        }
    }
}
public enum LMDashLineDirection: Int {
    case vertical = 0
    case horizontal = 1
}
public extension   UIView {
    func set_Border(radius: CGFloat, borderWidth: CGFloat = 1, borderColor: UIColor = .clear) {
         self.layer.masksToBounds = true
         self.layer.borderWidth = borderWidth
         self.layer.borderColor = borderColor.cgColor
         self.layer.cornerRadius = radius
    }
    func set_Border(radius: CGFloat, borderWidth: CGFloat = 1, borderColor: UIColor = .clear, conrners: UIRectCorner = .allCorners) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame =  self.bounds
        maskLayer.path = maskPath.cgPath
         self.layer.mask = maskLayer
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame =  self.bounds
         self.layer.addSublayer(borderLayer)
    }
    func set_Shadow(shadowColor: UIColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat = 3) {
         self.layer.shadowColor = shadowColor.cgColor
         self.layer.shadowOpacity = shadowOpacity
         self.layer.shadowRadius = shadowRadius
         self.layer.shadowOffset = shadowOffset
    }
    func set_CornerAndShadow(superview: UIView, conrners: UIRectCorner = .allCorners, radius: CGFloat = 3, shadowColor: UIColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat = 3) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame =  self.bounds
        maskLayer.path = maskPath.cgPath
         self.layer.mask = maskLayer
        let subLayer = CALayer()
        let fixframe =  self.frame
        subLayer.frame = fixframe
        subLayer.cornerRadius = radius
        subLayer.backgroundColor = shadowColor.cgColor
        subLayer.masksToBounds = false
        subLayer.shadowColor = shadowColor.cgColor
        subLayer.shadowOffset = shadowOffset
        subLayer.shadowOpacity = shadowOpacity
        subLayer.shadowRadius = shadowRadius
        subLayer.shadowPath = maskPath.cgPath
        superview.layer.insertSublayer(subLayer, below: self.layer)
    }
    func addViewCornerAndShadow(conrners: UIRectCorner = .allCorners, radius: CGFloat = 3, shadowColor: UIColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat = 3) {
         self.layer.shadowColor = shadowColor.cgColor
         self.layer.shadowOffset = shadowOffset
         self.layer.shadowOpacity = shadowOpacity
         self.layer.shadowRadius = shadowRadius
         self.layer.cornerRadius = radius
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize.init(width: radius, height: radius))
         self.layer.shadowPath = path.cgPath
    }
    func drawCircle(fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) {
        let ciecleRadius =  self.width >  self.height ?  self.height :  self.width
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: ciecleRadius, height: ciecleRadius), cornerRadius: ciecleRadius / 2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeWidth
         self.layer.addSublayer(shapeLayer)
    }
    func drawDashLine(strokeColor: UIColor,
                       lineLength: CGFloat = 4,
                      lineSpacing: CGFloat = 4,
                        direction: LMDashLineDirection = .horizontal) {
        let lineWidth = direction == .horizontal ?  self.height :  self.width
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds =  self.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        let path = CGMutablePath()
        if direction == .horizontal {
            path.move(to: CGPoint(x: 0, y: lineWidth / 2))
            path.addLine(to: CGPoint(x: self.width, y: lineWidth / 2))
        } else {
            path.move(to: CGPoint(x: lineWidth / 2, y: 0))
            path.addLine(to: CGPoint(x: lineWidth / 2, y: self.height))
        }
        shapeLayer.path = path
         self.layer.addSublayer(shapeLayer)
    }
    func set_InnerShadowLayer(shadowColor: UIColor, shadowOffset: CGSize = CGSize(width: 0, height: 0), shadowOpacity: Float = 0.5, shadowRadius: CGFloat = 3, insetBySize: CGSize = CGSize(width: -42, height: -42)) {
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame =  self.bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.fillRule = .evenOdd
        let path = CGMutablePath()
        path.addRect( self.bounds.insetBy(dx: insetBySize.width, dy: insetBySize.height))
        let someInnerPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: shadowRadius).cgPath
        path.addPath(someInnerPath)
        path.closeSubpath()
        shadowLayer.path = path
        let maskLayer = CAShapeLayer()
        maskLayer.path = someInnerPath
        shadowLayer.mask = maskLayer
         self.layer.addSublayer(shadowLayer)
    }
    func addSubviews(_ views: [UIView]) {
        for view in views {
             self.addSubview(view)
        }
    }
    func removeAllSubViews() {
        for subView in  self.subviews {
            subView.removeFromSuperview()
        }
    }
    func addGradientLayer(colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint, locations: [NSNumber]) {
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = colors
        bgLayer1.locations = locations
        bgLayer1.frame =  self.bounds
        bgLayer1.startPoint = startPoint
        bgLayer1.endPoint = endPoint
         self.layer.addSublayer(bgLayer1)
    }
}
public extension UIView {
    @discardableResult
    func tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat, borderColor: UIColor = .clear, borderWidth: Double = 1.0) -> Self {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        return self
    }
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        contentMode = mode
        return self
    }
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
    @discardableResult
    func frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    @discardableResult
    func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    @discardableResult
    func tintColor(_ tintColor: UIColor) -> Self {
        self.tintColor = tintColor
        return self
    }
}
public extension   UIView {
    @discardableResult
    func addGestureTap(_ action: @escaping Recognizerblock) -> UITapGestureRecognizer {
        let obj = UITapGestureRecognizer(target: nil, action: nil)
        obj.numberOfTapsRequired = 1
        obj.numberOfTouchesRequired = 1
        addCommonGestureRecognizer(obj)
        obj.addAction { (recognizer) in
            action(recognizer)
        }
        self.isUserInteractionEnabled = true
        return obj
    }
    @discardableResult
    func addGestureLongPress(_ action: @escaping Recognizerblock, for minimumPressDuration: TimeInterval) -> UILongPressGestureRecognizer {
        let obj = UILongPressGestureRecognizer(target: nil, action: nil)
        obj.minimumPressDuration = minimumPressDuration
        addCommonGestureRecognizer(obj)
        obj.addAction { (recognizer) in
            action(recognizer)
        }
        return obj
    }
    @discardableResult
    func addGesturePan(_ action: @escaping Recognizerblock) -> UIPanGestureRecognizer {
        let obj = UIPanGestureRecognizer(target: nil, action: nil)
        obj.minimumNumberOfTouches = 1
        obj.maximumNumberOfTouches = 3
        addCommonGestureRecognizer(obj)
        obj.addAction { (recognizer) in
            if let sender = recognizer as? UIPanGestureRecognizer, let senderView = sender.view {
                let translate: CGPoint = sender.translation(in: senderView.superview)
                senderView.center = CGPoint(x: senderView.center.x + translate.x, y: senderView.center.y + translate.y)
                sender.setTranslation( .zero, in: senderView.superview)
                action(recognizer)
            }
        }
        return obj
    }
    @discardableResult
    func addGestureEdgPan(_ target: Any?, action: Selector?, for edgs: UIRectEdge) -> UIScreenEdgePanGestureRecognizer {
        let obj = UIScreenEdgePanGestureRecognizer(target: target, action: action)
        obj.edges = edgs
        addCommonGestureRecognizer(obj)
        return obj
    }
    @discardableResult
    func addGestureEdgPan(_ action: @escaping Recognizerblock, for edgs: UIRectEdge) -> UIScreenEdgePanGestureRecognizer {
        let obj = UIScreenEdgePanGestureRecognizer(target: nil, action: nil)
        obj.edges = edgs
        addCommonGestureRecognizer(obj)
        obj.addAction { (recognizer) in
            action(recognizer)
        }
        return obj
    }
    @discardableResult
    func addGestureSwip(_ target: Any?, action: Selector?, for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let obj = UISwipeGestureRecognizer(target: target, action: action)
        obj.direction = direction
        addCommonGestureRecognizer(obj)
        return obj
    }
    @discardableResult
    func addGestureSwip(_ action: @escaping Recognizerblock, for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let obj = UISwipeGestureRecognizer(target: nil, action: nil)
        obj.direction = direction
        addCommonGestureRecognizer(obj)
        obj.addAction { (recognizer) in
            action(recognizer)
        }
        return obj
    }
    @discardableResult
    func addGesturePinch(_ action: @escaping Recognizerblock) -> UIPinchGestureRecognizer {
        let obj = UIPinchGestureRecognizer(target: nil, action: nil)
        addCommonGestureRecognizer(obj)
        obj.addAction { (recognizer) in
            if let sender = recognizer as? UIPinchGestureRecognizer {
                let location = recognizer.location(in: sender.view!.superview)
                sender.view!.center = location
                sender.view!.transform = sender.view!.transform.scaledBy(x: sender.scale, y: sender.scale)
                sender.scale = 1.0
                action(recognizer)
            }
        }
        return obj
    }
    @discardableResult
    func addGestureRotation(_ action: @escaping Recognizerblock) -> UIRotationGestureRecognizer {
        let obj = UIRotationGestureRecognizer(target: nil, action: nil)
        addCommonGestureRecognizer(obj)
        obj.addAction { (recognizer) in
            if let sender = recognizer as? UIRotationGestureRecognizer {
                sender.view!.transform = sender.view!.transform.rotated(by: sender.rotation)
                sender.rotation = 0.0
                action(recognizer)
            }
        }
        return obj
    }
    private func addCommonGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
         self.isUserInteractionEnabled = true
         self.isMultipleTouchEnabled = true
         self.addGestureRecognizer(gestureRecognizer)
    }
}
private var ListViewDidScrollKey: Void?
extension JXPagingViewListViewDelegate where Self: UIView {
    var listViewDidScrollCallback: ((UIScrollView) -> Void)? {
        get { objc_getAssociatedObject(self, &ListViewDidScrollKey) as? (UIScrollView) -> Void }
        set { objc_setAssociatedObject(self, &ListViewDidScrollKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
