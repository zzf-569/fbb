import Foundation
class LoginItem: NSObject, NSCoding, NSSecureCoding, SmartCodable {
    var isLogin: Bool = false
    var userId: String = ""
    var accessToken: String = ""
    var imToken: String = ""
    var newUser: Bool = false
    var tokenType: String = ""
    required override init() {
        super.init()
    }
    func encode(with coder: NSCoder) {
        coder.encode(isLogin, forKey: "isLogin")
        coder.encode(accessToken, forKey: "accessToken")
        coder.encode(userId, forKey: "userId")
        coder.encode(imToken, forKey: "imToken")
        coder.encode(newUser, forKey: "newUser")
        coder.encode(tokenType, forKey: "tokenType")
    }
    required init?(coder: NSCoder) {
        isLogin = coder.decodeBool(forKey: "isLogin")
        accessToken = coder.decodeObject(forKey: "accessToken") as? String ?? ""
        userId = coder.decodeObject(forKey: "userId") as? String ?? ""
        imToken = coder.decodeObject(forKey: "imToken") as? String ?? ""
        newUser = coder.decodeBool(forKey: "newUser")
        tokenType = coder.decodeObject(forKey: "tokenType") as? String ?? ""
    }
    static var supportsSecureCoding: Bool { true }
}
