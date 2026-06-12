import Foundation
enum lbType: String, SmartCaseDefaultable {
    static var defaultCase: lbType = .accomplishment
    case accomplishment = "accomplishment"
    case game = "game"
    case interest = "interest"
}
struct set_NetWork {
    struct banner: BaseTargetType {
        let scene: Int
        var path: String { "index/banner" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["scene"] = scene
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct timbre: BaseTargetType {
        var path: String { "index/timbre" }
        var parameters: [String: Any]? {
            let dict: [String: Any] = [:]
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct labelList: BaseTargetType {
        let lbType: lbType
        var path: String { "user/label" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["labelType"] = lbType.rawValue
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct uplabelList: BaseTargetType {
        let lbType: lbType
        let labelList: [labelListModel]
        let customlb: String
        var path: String { "user/update/lb" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["lbType"] = lbType.rawValue
            if labelList.count > 0 {
                var list: [[String: String]] = []
                for string in labelList {
                    list.append(["labelValue": string.labelValue])
                }
                dict["labelList"] = list
            }
            dict["customlb"] = ["labelValue": customlb]
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct reportReason: BaseTargetType {
        var path: String { "report/reason/list" }
        var parameters: [String: Any]? {
            let dict: [String: Any] = [:]
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct report: BaseTargetType {
        let targetId: String
        let reportType: Int
        let content: String
        let images: [String]
        let reportReason: [String]
        var path: String { "report/target" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["targetId"] = targetId
            dict["reportType"] = reportType
            dict["content"] = content
            dict["images"] = images
            dict["reportReason"] = reportReason
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct payProductList: BaseTargetType {
        var type: Int?
        var payType: Int?
        var path: String { "pay/product/list" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["type"] = type
            dict["payType"] = payType
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct search: BaseTargetType {
        let content: String
        var path: String { "index/search" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["content"] = content
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct searchParty: BaseTargetType {
        let content: String
        let page: Int
        var path: String { "room/party/search" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["content"] = content
            dict["page"] = page
            dict["size"] = AppConfig.pageSize
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct searchPerson: BaseTargetType {
        let content: String
        let page: Int
        var path: String { "room/podcast/search" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["content"] = content
            dict["page"] = page
            dict["size"] = AppConfig.pageSize
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct searchUser: BaseTargetType {
        let content: String
        let page: Int
        var path: String { "user/fuzzy/search" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["content"] = content
            dict["page"] = page
            dict["size"] = AppConfig.pageSize
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct roomRecommend: BaseTargetType {
        var path: String { "index/recommend/list" }
        var parameters: [String: Any]? {
            let dict: [String: Any] = [:]
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct roomTopList: BaseTargetType {
        var path: String { "index/top/list" }
        let page: Int
        let size: Int
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["page"] = page
            dict["size"] = size
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct roomTopListPodcast: BaseTargetType {
        var path: String { "index/top/listPodcast" }
        let page: Int
        let size: Int
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["page"] = page
            dict["size"] = size
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct checkVersion: BaseTargetType {
        var path: String { "config/check/version/ios" }
        var parameters: [String: Any]? {
            let dict: [String: Any] = [:]
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct set_Hat: BaseTargetType {
        let roomId: String
        var path: String { "config/hat" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct genderRoom: BaseTargetType {
        let gender: String
        var path: String { "index/top/gender/room" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["gender"] = gender
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    
    struct indexkljdsf: BaseTargetType {
       
        var path: String { "index/dfjdf/skldjf/sd" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct indexklsfkjd: BaseTargetType {
       
        var path: String { "index/dkfj/sdlfj/sd" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct indexjef22sf: BaseTargetType {
       
        var path: String { "index/3rif/df/sd" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
}
