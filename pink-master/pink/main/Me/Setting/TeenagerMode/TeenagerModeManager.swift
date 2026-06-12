import Foundation
class TeenagerModeManager {
    static let shared = TeenagerModeManager()
    private init() {
    }
    var isOpen: Bool {
        let password = UserDefaults().string(forKey: UserDefaultKeys.teengerModelPassword)
        return password != nil
    }
    var password: String? {
        UserDefaults().string(forKey: UserDefaultKeys.teengerModelPassword)
    }
    func open(_ password: String) {
        UserDefaults().set(password, forKey: UserDefaultKeys.teengerModelPassword)
    }
    func close() {
        UserDefaults().removeObject(forKey: UserDefaultKeys.teengerModelPassword)
    }
}
