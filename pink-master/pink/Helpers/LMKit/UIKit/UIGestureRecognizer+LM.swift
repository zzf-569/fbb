import UIKit
public extension UIGestureRecognizer {
    private struct AssociateKeys {
        static var funcName = UnsafeRawPointer("UIGestureRecognizerFuncName".withCString { $0 })
        static var block = UnsafeRawPointer("UIGestureRecognizerblock".withCString { $0 })
    }
    var funcName: String {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociateKeys.funcName) as? String {
                return obj
            }
            let string = String(describing: self.classForCoder)
            objc_setAssociatedObject(self, &AssociateKeys.funcName, string, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return string
        }
        set {
            objc_setAssociatedObject(self, &AssociateKeys.funcName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func addAction(_ block: @escaping (UIGestureRecognizer) -> Void) {
        objc_setAssociatedObject(self, &AssociateKeys.block, block, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        addTarget(self, action: #selector(pinvoke))
    }
    @objc private func pinvoke() {
        if let block = objc_getAssociatedObject(self, &AssociateKeys.block) as? ((UIGestureRecognizer) -> Void) {
            block(self)
        }
    }
}
