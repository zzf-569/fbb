import Foundation
public extension NSObject {
    var className: String {
        return type(of: self).className
    }
    static var className: String {
        return String(describing: self)
    }
}
