import Foundation
struct ShopNetWork {
    struct getDressTypeList: BaseTargetType {
        var path: String  = "dressUpType/list"
        var parameters: [String: Any]? {
            return nil
        }
        var method: HTTPMethod { .post }
    }
    struct getDressUpList: BaseTargetType {
        var type: Int?
        var page: Int
        var path: String  = "dressUp/list"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["type"] = type
            dict["page"] = page
            dict["size"] = AppConfig.pageSize
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct getPackageList: BaseTargetType {
        var type: Int?
        var page: Int
        var path: String  = "dressUpUser/list"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["type"] = type
            dict["page"] = page
            dict["size"] = AppConfig.pageSize
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct buyDress: BaseTargetType {
        var id: Int
        var priceId: Int
        var days: Int
        var path: String  = "dressUpUser/purchaseDressUp"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["id"] = id
            dict["priceId"] = priceId
            dict["days"] = days
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct sendDress: BaseTargetType {
        var id: Int
        var priceId: Int
        var days: Int
        var toUserIds: [Int]
        var roomId: String
        var path: String  = "dressUpUser/purchaseDressUp"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["id"] = id
            dict["priceId"] = priceId
            dict["days"] = days
            dict["toUserIds"] = toUserIds
            dict["roomId"] = roomId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct useDress: BaseTargetType {
        var id: Int
        var type: Int
        var roomId: String?
        var path: String  = "dressUpUser/useDressUp"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["id"] = id
            dict["type"] = type
            dict["roomId"] = roomId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct cancelDress: BaseTargetType {
        var id: Int
        var type: Int
        var roomId: String?
        var path: String  = "dressUpUser/cancelUseDressUp"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["id"] = id
            dict["type"] = type
            dict["roomId"] = roomId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct getPackageRecord: BaseTargetType {
        var page: Int
        var path: String  = "dressUpUser/record"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["page"] = page
            dict["size"] = AppConfig.pageSize
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct Packagekfdw: BaseTargetType {
        let tagId: String
        var path: String  = "dressUpUser/dfke/few"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
    
    struct Packagekffk2w: BaseTargetType {
        let tagId: String
        var path: String  = "dressUpUser/dffedke/dfw2"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
}
