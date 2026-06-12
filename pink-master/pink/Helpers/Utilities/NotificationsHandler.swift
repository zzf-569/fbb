import Foundation
import UIKit
import UserNotifications
class NotificationsHandler: NSObject {
    func configure() {
        UNUserNotificationCenter.current().delegate = self
    }
    func registerForRemoteNotifications() {
        let application = UIApplication.shared
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {_, _ in
        }
        application.registerForRemoteNotifications()
    }
    func handleRemoteNotification(with userInfo: [AnyHashable: Any]) {
    }
}
extension NotificationsHandler: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
