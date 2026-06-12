import Foundation
let UserShared = UserService.shared
public final class UserService {
    static let shared = UserService()
    private init() {
        if let user = getCurrentLoginUser() {
            self.loginToken = user
            self.user = UsInfoItem(userId: user.userId)
        }
    }
    var isNotified = false
    var loginToken: LoginItem?
    var user: UsInfoItem?
    var isLogin: Bool {
        if let model = UserShared.loginToken, model.isLogin {
            return true
        }
        return false
    }
    func login(model: LoginItem, complete: @escaping () -> Void) {
        if model.accessToken.isEmpty {
            complete()
            return
        }
        self.loginToken = model
        getUserInfo { [weak self] in
            guard let self = self else {
                complete()
                return
            }
            loginAbout(model: model, complete: complete)
        }
    }
    func loginAbout(model: LoginItem, complete: @escaping () -> Void) {
        guard let user = self.user else {
            self.loginToken = nil
            complete()
            return
        }
        model.isLogin = true
        self.isNotified = false
        model.userId = user.userId
        self.loginToken = model
        setLoginUser(model)
        IMService.shared.login(user.imUserId) { _, _ in
        }
        NotificationCenter.default.post(name: NotificationName.login, object: nil)
        lmPrint("用户登录成功")
        complete()
    }
    func getUserInfo(complete: @escaping () -> Void) {
        UserNetWork.Info().lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            guard let user = UsInfoItem.deserialize(from: responseModel.data as? [String: Any]) else {
                complete()
                return
            }
            self.user = user
            complete()
        } failureBlock: { error in
            if error.message.isEmpty == false {
                HUD.showFailure(error.message)
            }
            complete()
        }
    }
    @discardableResult
    func logout(complete: @escaping () -> Void) -> Bool {
        IMService.shared.logout()
        self.loginToken = nil
        self.user = nil
        UserDefaults().setValue("", forKey: "zodiacData")
        UserDefaults().set(false, forKey: "isgyged")
        setLoginUser(nil)
        NotificationCenter.default.post(name: NotificationName.login, object: nil)
        lmPrint("用户退出成功")
        complete()
        return true
    }
}
private let userFileName = "Account"
fileprivate extension UserService {
    func getCurrentLoginUser() -> LoginItem? {
        guard let user = getLoginUsers() else {
            return nil
        }
        if user.isLogin {
            return user
        }
        return nil
    }
    func getLoginUsers() -> LoginItem? {
        let userDicr = UserDefaults().object(forKey: "loginUser")
        guard let loginItem = LoginItem.deserialize(from: userDicr as? [String: Any]) else {
            return nil
        }
        return loginItem
    }
    func setLoginUser(_ currentUser: LoginItem?) {
        let user = currentUser?.toDictionary()
        UserDefaults().setValue(user, forKey: "loginUser")
    }
}
