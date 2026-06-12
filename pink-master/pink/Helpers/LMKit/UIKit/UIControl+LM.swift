import UIKit
public extension UIControl {
}
public extension UIControl {
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    @discardableResult
    func isSelected(_ isSelected: Bool) -> Self {
        self.isSelected = isSelected
        return self
    }
    @discardableResult
    func add(_ target: Any?, action: Selector, events: UIControl.Event = .touchUpInside) -> Self {
        self.addTarget(target, action: action, for: events)
        return self
    }
    @discardableResult
    func remove(_ target: Any?, action: Selector, events: UIControl.Event = .touchUpInside) -> Self {
        self.removeTarget(target, action: action, for: events)
        return self
    }
}
private struct AssociateKeys {
    static var block = UnsafeRawPointer("UIControlblock".withCString { $0 })
}
