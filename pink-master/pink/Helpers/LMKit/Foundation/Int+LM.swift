import Foundation
public extension Int {
    func toString() -> String { String(self) }
    func toFloat() -> Float { return Float(self) }
    func toCGFloat() -> CGFloat { return CGFloat(self) }
    func toNumber() -> NSNumber { return NSNumber(value: self) }
    func toDouble() -> Double { return Double(self) }
    func toBool() -> Bool { return self > 0 ? true : false }
}
