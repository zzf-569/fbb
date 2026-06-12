import UIKit
struct findOrderApi {
    struct findOrderList: BaseTargetType {
        let page: Int
        var path: String  = "order/publish/list"
        var parameters: [String: Any]? {
            return ["status": 1, "page": page, "size": AppConfig.pageSize]
        }
        var method: HTTPMethod { .post }
    }
    struct findOrderSub: BaseTargetType {
        let orderNo: String
        var path: String  = "order/submit"
        var parameters: [String: Any]? {
            return ["status": 0, "orderNo": orderNo]
        }
        var method: HTTPMethod { .post }
    }
    
    struct finddf: BaseTargetType {
        let tagId: String
        var path: String  = "find/df/ds1"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
}
