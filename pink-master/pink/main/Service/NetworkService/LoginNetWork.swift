import Foundation
struct LoginNetWork {
    struct SendVerifyCode: BaseTargetType {
        let username: String
        let type: String
        let ver: String? = ""
        var path: String  = "send/verifyCode"
        var parameters: [String: Any]? {
            ["username": username, "type": type]
        }
        var method: HTTPMethod { .post }
    }
    struct SmsLogin: BaseTargetType {
        let username: String
        let verifyCode: String
        let sms: String? = ""
        var path: String  = "user/smsLogin"
        var parameters: [String: Any]? {
            ["username": username, "verifyCode": verifyCode]
        }
        var method: HTTPMethod { .post }
    }
}
