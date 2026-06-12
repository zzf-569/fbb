import Foundation
struct GiftNetWork {
    struct list: BaseTargetType {
        let scene: Int
        var path: String {
            "gift/list"
        }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["scene"] = scene
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct giftcategory: BaseTargetType {
        var path: String {
            "gift/category"
        }
        var parameters: [String: Any]? {
            let dict: [String: Any] = [:]
            return dict
        }
        var method: HTTPMethod { .get }
    }
    struct giftList: BaseTargetType {
        var page: Int
        var size: Int = AppConfig.pageSize
        var categoryId: Int
        var path: String {
            "gift/giftList"
        }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["page"] = page
            dict["size"] = size
            dict["categoryId"] = categoryId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct send: BaseTargetType {
        let giftId: String
        let count: Int
        let toUserIdList: [String]
        let roomId: String
        var path: String {
            "gift/send"
        }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["giftId"] = giftId
            dict["count"] = count
            dict["toUserIdList"] = toUserIdList
            dict["roomId"] = roomId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct sendV2: BaseTargetType {
        let giftId: String
        let count: Int
        let toUserIdList: [String]
        let roomId: String
        let isMagicGift: Bool
        var path: String {
            "gift/send/v2"
        }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["giftId"] = giftId
            dict["count"] = count
            dict["toUserIdList"] = toUserIdList
            dict["roomId"] = roomId
            dict["isMagicGift"] = isMagicGift
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct rankList: BaseTargetType {
        let roomId: String?
        let type: Int
        let scene: RMRTimeType
        var path: String {
            "rank/list"
        }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            if let roomId = roomId {
                dict["roomId"] = roomId
            }
            dict["type"] = type
            dict["scene"] = scene.rawValue
            return dict
        }
        var method: HTTPMethod { .post }
        init(roomId: String? = nil, type: Int, scene: RMRTimeType) {
            self.roomId = roomId
            self.type = type
            self.scene = scene
        }
    }
    struct lightingUpDetail: BaseTargetType {
        let id: Int
        let userId: String?
        var path: String {
            "ih/lightingUpDetail"
        }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["id"] = id
            dict["userId"] = userId
            return dict
        }
        var method: HTTPMethod { .get }
    }
    struct receiveReward: BaseTargetType {
        let ihId: Int
        var path: String {
            "ih/receiveReward"
        }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["ihId"] = ihId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct giftkdf: BaseTargetType {
       
        var path: String { "giftkdf/fkjdf/sdljwo/vkml" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct giftkdfdf: BaseTargetType {
       
        var path: String { "giftklfdf/fkjdkfdf/sdljwo/vkml" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
}
