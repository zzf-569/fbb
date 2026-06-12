import UIKit
public extension   UIWindow {
    static func keyWindow() -> UIWindow {
        if #available(iOS 15.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows.first ?? UIWindow()
            return keyWindow
        } else {
            let keyWindow = UIApplication.shared.windows.first ?? UIWindow()
            return keyWindow
        }
    }
}
