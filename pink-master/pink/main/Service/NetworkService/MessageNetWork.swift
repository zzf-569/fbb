import Foundation
struct MessageNetWork {
    enum SendType: String {
        case text
        case face
    }
    struct send: BaseTargetType {
        let roomId: String
        let content: String?
        let type: SendType
        let emojiId: String?
        let atUserIdList: [String]
        var path: String { "message/send" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["type"] = type.rawValue
            if atUserIdList.count > 0 {
                dict["atUserIdList"] = atUserIdList
            }
            if let content = content {
                dict["content"] = content
            }
            if let emojiId = emojiId {
                dict["emojiId"] = emojiId
            }
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct notice: BaseTargetType {
        let userId: String
        var path: String { "push/notice" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["userId"] = userId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct getCustomer: BaseTargetType {
        var path: String { "room/getCustomer" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            return dict
        }
        var method: HTTPMethod { .get }
    }
    struct sendPublicMsg: BaseTargetType {
        let imRoomId: String
        let content: String?
        let type: SendType
        let emojiId: String?
        let atUserIdList: [String]
        var path: String { "message/sendCommentGroupMessage" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["imRoomId"] = imRoomId
            dict["type"] = type.rawValue
            if atUserIdList.count > 0 {
                dict["atUserIdList"] = atUserIdList
            }
            if let content = content {
                dict["content"] = content
            }
            if let emojiId = emojiId {
                dict["emojiId"] = emojiId
            }
            return dict
        }
        var method: HTTPMethod { .post }
    }
}
