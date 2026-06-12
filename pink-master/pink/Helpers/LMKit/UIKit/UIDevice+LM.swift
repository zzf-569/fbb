import UIKit
public var kScreenWidth: CGFloat { UIScreen.main.bounds.width }
public var kScreenHeight: CGFloat { UIScreen.main.bounds.height }

private var lmActiveWindowScene: UIWindowScene? {
    if #available(iOS 13.0, *) {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        return scenes.first { scene in
            scene.activationState == .foregroundActive && scene.windows.contains { $0.isKeyWindow }
        } ?? scenes.first { scene in
            scene.activationState == .foregroundActive
        } ?? scenes.first { scene in
            scene.activationState == .foregroundInactive
        }
    }
    return nil
}

private var lmActiveWindow: UIWindow? {
    if #available(iOS 13.0, *) {
        return lmActiveWindowScene?.windows.first { $0.isKeyWindow }
            ?? lmActiveWindowScene?.windows.first { !$0.isHidden && $0.alpha > 0 }
    }
    return UIApplication.shared.windows.first { $0.isKeyWindow }
        ?? UIApplication.shared.windows.first { !$0.isHidden && $0.alpha > 0 }
}

public var kStatusBarHeight: CGFloat {
    if #available(iOS 13.0, *) {
        let statusBarHeight = lmActiveWindowScene?.statusBarManager?.statusBarFrame.height ?? 0
        if statusBarHeight > 0 {
            return statusBarHeight
        }

        let safeAreaTop = lmActiveWindow?.safeAreaInsets.top ?? 0
        if safeAreaTop > 0 {
            return safeAreaTop
        }

        return 20
    } else {
        return UIApplication.shared.statusBarFrame.height > 0
        ? UIApplication.shared.statusBarFrame.height
        : 20
    }
}

public var kNavigationBarHeight: CGFloat {
    if let navigationBar = UIViewController.current?.navigationController?.navigationBar,
       navigationBar.frame.height > 0 {
        return navigationBar.frame.height
    }

    if let navigationController = lmActiveWindow?.rootViewController as? UINavigationController,
       navigationController.navigationBar.frame.height > 0 {
        return navigationController.navigationBar.frame.height
    }

    if #available(iOS 26.0, *) {
        return 62
    }
    return 44
}

// 导航栏整体高度 = 状态栏 + 导航栏
public var kNavigationHeight: CGFloat {
    kStatusBarHeight + kNavigationBarHeight
}
public var kTabBarSafeHeight: CGFloat {
    if #available(iOS 13.0, *) {
        return lmActiveWindow?.safeAreaInsets.bottom ?? 0
    } else if #available(iOS 11.0, *) {
        return lmActiveWindow?.safeAreaInsets.bottom ?? 0
    }
    return 0
}
public var kTabBarHeight: CGFloat { 49.0 }
public var kTabHeight: CGFloat { kTabBarHeight + kTabBarSafeHeight }
public func kScaleWidth(_ width: CGFloat) -> CGFloat { kScreenWidth / CGFloat(390.0)  * width }
public let kButtonHeight = 48.0
extension UIDevice {
    static var deviceId: String {
        let key = "deviceIdentifier"
        return ""
    }
    static var deviceModel: String {
        UIDevice.current.model
    }
    static var deviceSystemVersion: String {
        UIDevice.current.systemVersion
    }
    static var deviceType: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPhone8,1":                                       return "iPhone 6s"
        case "iPhone8,2":                                       return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                          return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                          return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                        return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                        return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                        return "iPhone X"
        case "iPhone11,8":                                      return "iPhone XR"
        case "iPhone11,2":                                      return "iPhone XS"
        case "iPhone11,6", "iPhone11,4":                        return "iPhone XS Max"
        case "iPhone12,1":                                      return "iPhone 11"
        case "iPhone12,3":                                      return "iPhone 11 Pro"
        case "iPhone12,5":                                      return "iPhone 11 Pro Max"
        case "iPhone12,8":                                      return "iPhone SE(2nd generation)"
        case "iPhone13,1":                                      return "iPhone 12 mini"
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,3": return "iPhone 12 Pro"
        case "iPhone13,4": return "iPhone 12 Pro Max"
        case "iPhone14,4": return "iPhone 13 mini"
        case "iPhone14,5": return "iPhone 13"
        case "iPhone14,2": return "iPhone 13 Pro"
        case "iPhone14,3": return "iPhone 13 Pro Max"
        case "iPhone14,6": return "iPhone SE (3rd generation)"
        case "iPhone14,7": return "iPhone 14"
        case "iPhone14,8": return "iPhone 14 Plus"
        case "iPhone15,2": return "iPhone 14 Pro"
        case "iPhone15,3": return "iPhone 14 Pro Max"
        case "iPhone15,4": return "iPhone_15"
        case "iPhone15,5": return "iPhone_15_Plus"
        case "iPhone16,1": return "iPhone_15_Pro"
        case "iPhone16,2": return "iPhone_15_Pro_Max"
        case "iPhone17,3": return "iPhone_16"
        case "iPhone17,4": return "iPhone_16_Plus"
        case "iPhone17,1": return "iPhone_16_Pro"
        case "iPhone17,2": return "iPhone_16_Pro_Max"
        case "iPod1,1":   return "iPod Touch 1"
        case "iPod2,1":   return "iPod Touch 2"
        case "iPod3,1":   return "iPod Touch 3"
        case "iPod4,1":   return "iPod Touch 4"
        case "iPod5,1":   return "iPod Touch 5"
        case "iPod7,1":   return "iPod Touch 6"
        case "iPod9,1":   return "iPod Touch 7"
        case "iPad2,5":   return "iPad Mini 1"
        case "iPad2,6":   return "iPad Mini 1"
        case "iPad2,7":   return "iPad Mini 1"
        case "iPad4,4":   return "iPad Mini 2"
        case "iPad4,5":   return "iPad Mini 2"
        case "iPad4,6":   return "iPad Mini 2"
        case "iPad4,7":   return "iPad Mini 3"
        case "iPad4,8":   return "iPad Mini 3"
        case "iPad4,9":   return "iPad Mini 3"
        case "iPad5,1":   return "iPad Mini 4"
        case "iPad5,2":   return "iPad Mini 4"
        case "iPad11,1":  return "iPad Mini 5"
        case "iPad11,2":  return "iPad Mini 5"
        case "iPad14,1":  return "iPad Mini 6"
        case "iPad14,2":  return "iPad Mini 6"
        case "iPad6,3":   return "iPad Pro_9.7"
        case "iPad6,4":   return "iPad Pro_9.7"
        case "iPad6,7":   return "iPad Pro_12.9"
        case "iPad6,8":   return "iPad Pro_12.9"
        case "iPad7,1":   return "iPad Pro 2_12.9"
        case "iPad7,2":   return "iPad Pro 2_12.9"
        case "iPad7,3":   return "iPad Pro_10.5"
        case "iPad7,4":   return "iPad Pro_10.5"
        case "iPad8,1":   return "iPad Pro_11"
        case "iPad8,2":   return "iPad Pro_11"
        case "iPad8,3":   return "iPad Pro_11"
        case "iPad8,4":   return "iPad Pro_11"
        case "iPad8,5":   return "iPad Pro 3_12.9"
        case "iPad8,6":   return "iPad Pro 3_12.9"
        case "iPad8,7":   return "iPad Pro 3_12.9"
        case "iPad8,8":   return "iPad Pro 3_12.9"
        case "iPad8,10":  return "iPad Pro 2_11"
        case "iPad8,11":  return "iPad Pro 4_12.9"
        case "iPad8,12":  return "iPad Pro 4_12.9"
        case "iPad13,4":  return "iPad Pro 3_11"
        case "iPad13,5":  return "iPad Pro 3_11"
        case "iPad13,6":  return "iPad Pro 3_11"
        case "iPad13,7":  return "iPad Pro 3_11"
        case "iPad13,8":  return "iPad Pro 5_12.9"
        case "iPad13,9":  return "iPad Pro 5_12.9"
        case "iPad13,10":  return "iPad Pro 5_12.9"
        case "iPad13,11":  return "iPad Pro 5_12.9"
        case "iPad14,3":   return "iPad Pro 4_11"
        case "iPad14,4":   return "iPad Pro 4_11"
        case "iPad14,5":   return "iPad Pro 6_12.9"
        case "iPad14,6":   return "iPad Pro 6_12.9"
        case "iPad16,3":   return "iPad Pro M4_11"
        case "iPad16,4":   return "iPad Pro M4_11"
        case "iPad16,5":   return "iPad Pro M4_13"
        case "iPad16,6":   return "iPad Pro M4_13"
        case "iPad4,1":    return "iPad Air"
        case "iPad4,2":    return "iPad Air"
        case "iPad4,3":    return "iPad Air"
        case "iPad5,3":    return "iPad Air 2"
        case "iPad5,4":    return "iPad Air 2"
        case "iPad11,3":   return "iPad Air 3"
        case "iPad11,4":   return "iPad Air 3"
        case "iPad13,1":   return "iPad Air 4"
        case "iPad13,2":   return "iPad Air 4"
        case "iPad13,3":   return "iPad Air 4"
        case "iPad13,16":  return "iPad Air 5"
        case "iPad13,17":  return "iPad Air 5"
        case "iPad14,8":   return "iPad Air M2_11"
        case "iPad14,9":   return "iPad Air M2_11"
        case "iPad14,10":  return "iPad Air M2_13"
        case "iPad14,11":  return "iPad Air M2_13"
        case "iPad1,1":    return "iPad 1"
        case "iPad2,1":    return "iPad 2"
        case "iPad2,2":    return "iPad 2"
        case "iPad2,3":    return "iPad 2"
        case "iPad2,4":    return "iPad 2"
        case "iPad3,1":    return "iPad 3"
        case "iPad3,2":    return "iPad 3"
        case "iPad3,3":    return "iPad 3"
        case "iPad3,4":    return "iPad 4"
        case "iPad3,5":    return "iPad 4"
        case "iPad3,6":    return "iPad 4"
        case "iPad6,11":   return "iPad 5"
        case "iPad6,12":   return "iPad 5"
        case "iPad7,5":    return "iPad 6"
        case "iPad7,6":    return "iPad 6"
        case "iPad7,11":   return "iPad 7"
        case "iPad7,12":   return "iPad 7"
        case "iPad11,6":   return "iPad 8"
        case "iPad11,7":   return "iPad 8"
        case "iPad12,1":   return "iPad 9"
        case "iPad12,2":   return "iPad 9"
        case "iPad13,18":  return "iPad 10"
        case "iPad13,19":  return "iPad 10"
        case "i386": return "iPhone Simulator"
        case "x86_64": return "iPhone Simulator"
        default:
            return identifier 
        }
    }
}
