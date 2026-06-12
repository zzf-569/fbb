import Foundation
struct SkillItem: SmartCodable {
    var skillName: String = ""
    var userId: String = ""
    var skillId: String = ""
    var status: Int = 0
    var rejectReason: String = ""
    var skillIcon: String = ""
    var skillLevel: String = ""
    var skillLevelList: [String] = []
    var skillCard: String = ""
    var skillIntroduce: String = ""
    var skillUrl: String = ""
    var skillPriceList: [Int] = []
    var skillUnit: String = ""
    var skillPrice: Int = 0
}
struct SkillCommonModel: SmartCodable {
    var skillName: String = ""
    var userId: String = ""
    var skillId: String = ""
    var status: Int = 0
    var rejectReason: String = ""
    var skillIcon: String = ""
    var skillLevel: [String] = []
    var skillIntroduce: String = ""
    var skillUrl: String = ""
    var skillPrice: [Int] = []
    var skillUnit: String = ""
}
