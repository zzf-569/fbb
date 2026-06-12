import Foundation
import SVProgressHUD
typealias HUD = LMToast
struct LMToast {
    static var iswhiting = false
    static func config() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setForegroundColor(.green)
        SVProgressHUD.setBackgroundColor(.magenta)
        SVProgressHUD.setCornerRadius(5.0)
        SVProgressHUD.setDefaultMaskType(.custom)
    }
    static func hide() {
        LMToast.iswhiting = false
        SVProgressHUD.dismiss()
    }
    static func showLoading(_ message: String? = nil) {
        LMToast.iswhiting = true
        DispatchQueue.asyncDelay(0.2) {
        } _: {
            if SVProgressHUD.isVisible() == false && LMToast.iswhiting == true {
                SVProgressHUD.setDefaultStyle(.dark)
                SVProgressHUD.setCornerRadius(5.0)
                SVProgressHUD.setDefaultAnimationType(.native)
                SVProgressHUD.setDefaultMaskType(.custom)
                if let msg = message {
                    SVProgressHUD.show(withStatus: msg.localized)
                } else {
                    SVProgressHUD.show()
                }
            }
        }
    }
    static func show(_ message: String) {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setCornerRadius(5.0)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.showInfo(withStatus: message.localized)
        SVProgressHUD.dismiss(withDelay: 2.0)
    }
    static func showSuccess(_ message: String) {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setCornerRadius(5.0)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.showSuccess(withStatus: message.localized)
        SVProgressHUD.dismiss(withDelay: 2.0)
    }
    static func showFailure(_ message: String) {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setCornerRadius(5.0)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.showError(withStatus: message.localized)
        SVProgressHUD.dismiss(withDelay: 2.0)
    }
}
