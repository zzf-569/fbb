import Foundation
public let kAppName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
public let kAppShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
public let kAppBundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
