import Foundation
struct OrderApi {
    struct create: BaseTargetType {
        let targetUserId: String
        let bizId: String
        let num: Int
        let bizType: Int = 1
        let totalPrice: Int
        var path: String { "order/create" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["targetUserId"] = targetUserId
            dict["bizId"] = bizId
            dict["num"] = num
            dict["bizType"] = bizType
            dict["totalPrice"] = totalPrice
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct publish: BaseTargetType {
        let bizId: String
        let roomId: String
        let gender: Int
        let demandPrice: String
        let remark: String
        var path: String { "order/demand/publish" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["bizId"] = bizId
            dict["roomId"] = roomId
            dict["gender"] = gender
            dict["demandPrice"] = demandPrice
            dict["remark"] = remark
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct roomCreate: BaseTargetType {
        let sourceUserId: String
        let targetUserId: String
        let bizId: String
        var path: String { "order/allocation/create" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["sourceUserId"] = sourceUserId
            dict["targetUserId"] = targetUserId
            dict["bizId"] = bizId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct submit: BaseTargetType {
        let orderNo: String
        let status: Int
        var path: String { "order/submit" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["orderNo"] = orderNo
            dict["status"] = status
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct demandList: BaseTargetType {
        let page: Int
        let size: Int
        var path: String { "order/demand/list" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["page"] = page
            dict["size"] = size
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct orderList: BaseTargetType {
        let page: Int
        let status: Int
        var path: String { "order/send/list" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["page"] = page
            dict["status"] = status
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct orderReceiveList: BaseTargetType {
        let page: Int
        let status: Int
        var path: String { "order/receive/list" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["page"] = page
            dict["status"] = status
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct cancelDemand: BaseTargetType {
        let demandId: String
        var path: String { "order/demand/close" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["demandId"] = demandId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct orderTargetRecord: BaseTargetType {
        let targetUserId: String
        var path: String { "order/target/record" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["targetUserId"] = targetUserId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct sendCreate: BaseTargetType {
        let bizId: String
        let remark: String
        let level: String
        let num: Int
        let price: Int
        let totalPrice: Int
        var path: String { "order/publish" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["bizId"] = bizId
            dict["num"] = num
            dict["remark"] = remark
            dict["totalPrice"] = totalPrice
            dict["price"] = price
            dict["level"] = level
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct orderkdnf: BaseTargetType {
       
        var path: String { "roder/jdfdf/sd" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct orderkfdsf: BaseTargetType {
       
        var path: String { "roder/fdf/sdd" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
}
