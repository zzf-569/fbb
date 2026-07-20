import UIKit
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy private var router = RootRouter()
    lazy private var deeplinkHandler = DeeplinkHandler()
    lazy private var notificationsHandler = NotificationsHandler()
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LMUIKitLocalization.install()
        window = AppConfig.keyWindow
        window?.makeKeyAndVisible()
       
        notificationsHandler.configure()
        router.loadMainAppStructure()
        return true
    }
    func isNewDay() -> Bool {
        let calendar = Calendar.current
        let lastSavedDate = UserDefaults().object(forKey: "lastSavedDate") as? Date ?? Date.distantPast
        return !calendar.isDate(lastSavedDate, inSameDayAs: Date())
    }
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            deeplinkHandler.handleDeeplink(with: url)
        }
        return true
    }
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        notificationsHandler.handleRemoteNotification(with: userInfo)
    }
}
