import Foundation
import UIKit
public func lmFontF(_ ofSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: ofSize)
}
public func lmFontR(_ ofSize: CGFloat) -> UIFont {
    return UIFont.pingFangR(ofSize)
}
public func lmFontM(_ ofSize: CGFloat) -> UIFont {
    return UIFont.pingFangM(ofSize)
}
public func lmFontS(_ ofSize: CGFloat) -> UIFont {
    return UIFont.pingFangSB(ofSize)
}
public func lmFontASHTB(_ ofSize: CGFloat) -> UIFont {
    return UIFont.customFont(ofSize, fontName: "荆南波波黑")
}
enum UIFontWeight: String {
    case Regular = "Regular"
    case Medium = "Medium"
    case Thin = "Thin"
    case Light = "Light"
    case Ultralight = "Ultralight"
    case Semibold = "Semibold"
}
public extension   UIFont {
    static func pingFangR(_ ofSize: CGFloat) -> UIFont {
        return pingFangText(ofSize, W: .Regular)
    }
    static func pingFangM(_ ofSize: CGFloat) -> UIFont {
        return pingFangText(ofSize, W: .Medium)
    }
    static func pingFangT(_ ofSize: CGFloat) -> UIFont {
        return pingFangText(ofSize, W: .Thin)
    }
    static func pingFangL(_ ofSize: CGFloat) -> UIFont {
        return pingFangText(ofSize, W: .Light)
    }
    static func pingFangUL(_ ofSize: CGFloat) -> UIFont {
        return pingFangText(ofSize, W: .Ultralight)
    }
    static func pingFangSB(_ ofSize: CGFloat) -> UIFont {
        return pingFangText(ofSize, W: .Semibold)
    }
}
public extension   UIFont {
    static func customFont(_ ofSize: CGFloat, fontName: String) -> UIFont {
        return appCustomFont(fontName: fontName, ofSize: ofSize)
    }
    static func showAllFont() {
        var i = 0
        for family in UIFont.familyNames {
            debugPrint("\(i)---项目字体---\(family)")
            for names in UIFont.fontNames(forFamilyName: family) {
                debugPrint("== \(names)")
            }
            i += 1
        }
    }
}
private extension   UIFont {
    static func pingFangText(_ ofSize: CGFloat, W Weight: UIFontWeight) -> UIFont {
        let fontName = "PingFangSC-" + Weight.rawValue
        return appCustomFont(fontName: fontName, ofSize: ofSize)
    }
    static func appCustomFont(fontName: String, ofSize: CGFloat) -> UIFont {
        if let font = UIFont(name: fontName, size: ofSize) {
            return font
        } else {
            return UIFont.systemFont(ofSize: ofSize)
        }
    }
}
