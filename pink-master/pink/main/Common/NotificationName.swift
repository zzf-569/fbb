import Foundation
struct NotificationName {
    public static let imNewGroupMessage = NSNotification.Name("NOTIMSGGROUP")
    public static let imNewPrivateChatMessage = NSNotification.Name("NOTIMSGNEW")
    public static let imUnreadMessageCountChange = NSNotification.Name("NOTIMSGCOUNTCHANGE")
    public static let imonUserStatusChanged = NSNotification.Name("NOTIUserChanged")
    public static let networkStateChange = NSNotification.Name("NOTINETWORKCHANGE")
    public static let login = NSNotification.Name("NOTILOGIN")
    public static let logout = NSNotification.Name("NOTILOGOUT")
}
