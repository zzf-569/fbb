import Foundation
enum LMUserMenuType: String {
    case DressingCenter
    case GiftWall
    case MyLevel
    case MyRoom
    case MyGuild
    case YouthMode
    case Feedback
    case AboutUs
    case skill
    case order
    var title: String {
        switch self {
        case .DressingCenter:
            return "装扮中心"
        case .GiftWall:
            return "礼物展馆"
        case .MyLevel:
            return "我的等级"
        case .MyRoom:
            return "我的房间"
        case .MyGuild:
            return "我的公会"
        case .YouthMode:
            return "青少年模式"
        case .Feedback:
            return "意见反馈"
        case .AboutUs:
            return "关于我们"
        case .skill:
            return "技能认证"
        case .order:
            return "我的下单"
        }
    }
}
struct LMUserMenuItemModel {
    let type: LMUserMenuType
}
