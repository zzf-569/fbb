import Foundation
struct SkillApi {
    struct skillList: BaseTargetType {
        var path: String  = "user/skill/list"
        var parameters: [String: Any]? {
            return nil
        }
        var method: HTTPMethod { .post }
    }
    struct skillApply: BaseTargetType {
        var skillId: String
        var skillLevel: String
        var skillUrl: String
        var skillName: String
        var skillPrice: Int
        var path: String  = "user/skill/apply"
        var parameters: [String: Any]? {
            return ["skillId": skillId, "skillLevel": skillLevel, "skillName": skillName, "skillUrl": skillUrl, "skillPrice": skillPrice]
        }
        var method: HTTPMethod { .post }
    }
    
    struct siillkjsndfk: BaseTargetType {
       
        var path: String { "skill/jdfjsd/sd" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
}
