import Foundation
import SmartCodable
enum ResponseCode: Int {
    case success = 10000
    case upseatSuccess = 200
    case upseatApplySuccess = 201
    case unlogin = 10004
    case accountInvalid = 401
    case unknowNetwork = 999
    case deserializeFailed = 998
}
struct ResponseModel: SmartCodable {
    var code: Int = 1
    var success: Bool = false
    var message: String = ""
    @SmartAny
    var data: Any?
}
struct ResponseError: Error {
    let code: Int
    let message: String
    let data: Any?
    init(code: Int, message: String, data: Any? = nil) {
        self.code = code
        self.message = message
        self.data = data
    }
}
