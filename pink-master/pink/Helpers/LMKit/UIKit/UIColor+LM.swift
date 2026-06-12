import Foundation
import UIKit
public func lmColorHex(_ hexString: String, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor.hex(hexString, alpha: alpha)
}
extension   UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    static func hex(_ hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        kAssert(hexString.count == 7 || hexString.count == 9, "请输入有效的颜色 hex 字符串：\(hexString)")
        var tempHex = hexString.uppercased()
        if tempHex.hasPrefix("#") {
            tempHex = String(tempHex[tempHex.index(tempHex.startIndex, offsetBy: 1)..<tempHex.endIndex])
        }
        var range = NSRange(location: 0, length: 2)
        let rHex = (tempHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (tempHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0, a: UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        if tempHex.count == 8 {
            range.location = 6
            let aHex = (tempHex as NSString).substring(with: range)
            Scanner(string: aHex).scanHexInt32(&a)
            return UIColor.rgb(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), alpha: CGFloat(a) / 255.0)
        }
        return UIColor.rgb(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), alpha: alpha)
    }
}
public func kTheme(style: UIUserInterfaceStyle, lightColor: UIColor, darkColor: UIColor) -> UIColor {
    if #available(iOS 13.0, *) {
        if style == .dark {
            return darkColor
        } else {
            return lightColor
        }
    } else {
        return lightColor
    }
}
public func kTheme(lightColor: UIColor, darkColor: UIColor) -> UIColor {
    UIColor.theme(lightColor: lightColor, darkColor: darkColor)
}
public extension   UIColor {
    static func theme(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
           return UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkColor
                } else {
                    return lightColor
                }
            }
        } else {
           return lightColor
        }
    }
}
 public extension UIColor {
    static var textDefaulColor: UIColor { lmColorHex("#2B313D") }
    static var textSecondColor: UIColor { lmColorHex("#2B313DA3") }
    static var textTerColor: UIColor { lmColorHex("#2B313D66") }
    static var textDisColor: UIColor { lmColorHex("#3D2B313D") }
    static var textAnti: UIColor { lmColorHex("#ffffff") }
    static var textBrand: UIColor { lmColorHex("#00DBA8") }
    static var textLink: UIColor { lmColorHex("#328BF9FF") }
    static var background: UIColor { lmColorHex("#FFFFFF") }
     static var whitePrimary: UIColor { lmColorHex("#FFFFFF", alpha: 0.88) }
     static var whiteSecondary: UIColor { lmColorHex("#FFFFFF", alpha: 0.64) }
     static var whiteTertiary: UIColor { lmColorHex("#FFFFFF", alpha: 0.24) }
}
