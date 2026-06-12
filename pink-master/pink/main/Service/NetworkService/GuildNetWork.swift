import Foundation
struct GuildNetWork {
    struct MyFamile: BaseTargetType {
        var path: String {
            return "family/my"
        }
        var parameters: [String: Any]? {
            nil
        }
        var method: HTTPMethod { .post }
    }
    struct CreateFamile: BaseTargetType {
        let title: String
        let cover: String
        let notification: String
        let businessLicense: String
        var path: String {
            return "family/create"
        }
        var parameters: [String: Any]? {
            return ["title": title, "cover": cover, "notification": notification, "businessLicense": businessLicense]
        }
        var method: HTTPMethod { .post }
    }
    struct RecommendFamile: BaseTargetType {
        var path: String {
            return "family/recommend/list"
        }
        var parameters: [String: Any]? {
            return nil
        }
        var method: HTTPMethod { .post }
    }
    struct DetailFamile: BaseTargetType {
        let familyId: Int
        var path: String {
            return "family/detail"
        }
        var parameters: [String: Any]? {
            return ["familyId": familyId]
        }
        var method: HTTPMethod { .post }
    }
    struct joinFamile: BaseTargetType {
        let familyId: Int
        var path: String {
            return "family/apply"
        }
        var parameters: [String: Any]? {
            return ["familyId": familyId, "applyType": 0]
        }
        var method: HTTPMethod { .post }
    }
    struct quickFamile: BaseTargetType {
        let familyId: Int
        var path: String {
            return "family/apply"
        }
        var parameters: [String: Any]? {
            return ["familyId": familyId, "applyType": 1]
        }
        var method: HTTPMethod { .post }
    }
    struct FamilyMember: BaseTargetType {
        let familyId: Int
        let page: Int
        var path: String {
            return "family/member"
        }
        var parameters: [String: Any]? {
            return ["familyId": familyId, "page": page]
        }
        var method: HTTPMethod { .post }
    }
    struct FamilyRoom: BaseTargetType {
        let familyId: Int
        var path: String {
            return "family/room"
        }
        var parameters: [String: Any]? {
            return ["familyId": familyId, "page": 1]
        }
        var method: HTTPMethod { .post }
    }
    struct FamilyMemberCharm: BaseTargetType {
        let familyId: Int
        let page: Int
        let type: Int
        var path: String {
            return "family/member/charm-value"
        }
        var parameters: [String: Any]? {
            return ["familyId": familyId, "page": page, "type": type]
        }
        var method: HTTPMethod { .post }
    }
    struct FamilyRoomCharm: BaseTargetType {
        let familyId: Int
        let page: Int
        let type: Int
        var path: String {
            return "family/room/charm-value"
        }
        var parameters: [String: Any]? {
            return ["familyId": familyId, "page": page, "type": type]
        }
        var method: HTTPMethod { .post }
    }
    struct FamilyOperate: BaseTargetType {
        let familyId: Int
        let memberUserId: String
        let operate: Int
        var path: String {
            return "family/member/operate"
        }
        var parameters: [String: Any]? {
            return ["familyId": familyId, "memberUserId": memberUserId, "operate": operate]
        }
        var method: HTTPMethod { .post }
    }
    struct FamilyApplyList: BaseTargetType {
        let familyId: Int
        let page: Int
        var path: String {
            return "family/apply/list"
        }
        var parameters: [String: Any]? {
            return ["familyId": familyId, "page": page]
        }
        var method: HTTPMethod { .post }
    }
    struct FamilySearch: BaseTargetType {
        let content: String
        var path: String {
            return "family/search"
        }
        var parameters: [String: Any]? {
            return ["content": content]
        }
        var method: HTTPMethod { .post }
    }
    struct FamilyApplyDeal: BaseTargetType {
        let applyId: Int
        let opType: Int
        var path: String {
            return "family/apply/deal"
        }
        var parameters: [String: Any]? {
            return ["applyId": applyId, "opType": opType]
        }
        var method: HTTPMethod { .post }
    }
    struct FamilyadminList: BaseTargetType {
        let familyId: Int
        let page: Int
        var path: String {
            return "family/member"
        }
        var parameters: [String: Any]? {
            return ["familyId": familyId, "page": page, "onlyAdmin": true]
        }
        var method: HTTPMethod { .post }
    }
    
    struct familyksdf: BaseTargetType {
       
        var path: String { "family/dsfk/sdspodf" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct familyfjndf: BaseTargetType {
       
        var path: String { "family/fwpe/eff" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct familykfjndsf: BaseTargetType {
       
        var path: String { "family/dfns/dfnk" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct familykdslknsdf: BaseTargetType {
       
        var path: String { "family/sdkf/fef13f" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct familyksddf: BaseTargetType {
       
        var path: String { "family/dsff22k/sdspf/2" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
}
