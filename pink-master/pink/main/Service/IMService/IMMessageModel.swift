import Foundation
import ImSDK_Plus
struct IMMessageModel {
    var type: IMMessageType = .unknown
    var msgDict: [String: Any] = [:]
    let roomId: String?
    let userId: String?
    let message: V2TIMMessage
}
