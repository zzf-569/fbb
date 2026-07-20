import Foundation
enum OrderStatus: Int, SmartCaseDefaultable {
    static var defaultCase: OrderStatus = .missed
    case missed = -1
    case received = 0
    case underWay = 1
    case cancel = 2
    case finish = 3
    case reject = 4
    var text: String {
        switch self {
        case .received:
            "已接单"
        case .underWay:
            "进行中"
        case .cancel:
            "已取消"
        case .finish:
            "已完成"
        case .reject:
            "已拒绝"
        case .missed:
            "待接单"
        }
    }
}
enum PayType: String {
    case apple = "APPLE"
    case wechat = "wechat"
    case ali = "ali"
}
enum incomeType: String, SmartCaseDefaultable {
    static var defaultCase: incomeType = .gift
    case gift = "gift"
    case order = "order"
    case room = "room"
}
enum UserGenderType: Int, SmartCaseDefaultable {
    static var defaultCase: UserGenderType = .girl
    case unlimited = -1
    case boy = 1
    case girl = 2
}

enum loginType: Int, SmartCaseDefaultable {
    static var defaultCase: loginType = .emaile
    case emaile = 1
    case phone = 2
    case userName = 3
}

enum SearchResult: String, SmartCaseDefaultable {
    static var defaultCase: SearchResult = .commandRoom
    case commandRoom = "commandRoom"
    case commandUser = "commandUser"
    case exactRoom = "exactRoom"
    case exactUser = "exactUser"
    case party = "派对"
    case person = "播客"
    case user = "用户"
}
enum identityType: String, SmartCaseDefaultable {
    static var defaultCase: identityType = .USER
    case USER = "USER"
    case HOST = "HOST"
}
enum RMCORType: Int, SmartCaseDefaultable {
    static var defaultCase:RMCORType = .normal
    case normal = 1
    case party = 8
    case dispatch = 2
    case person = 3
}
enum RMRANKType: Int {
    case RY = 0
    case RQ = 1
    case room = 2
    var text: String {
        switch self {
        case .RY:
            return "荣誉榜"
        case .RQ:
            return "人气榜"
        case .room:
            return "房间榜"
        }
    }
}
enum RMRTimeType: String {
    case daily
    case weekly
    case lastWeekly
    case yesterday
    case month
    var text: String {
        switch self {
        case .daily:
            return "日榜"
        case .weekly:
            return "周榜"
        case .lastWeekly:
            return "上周榜"
        case .yesterday:
            return "昨日榜"
        case .month:
            return "月榜"
        }
    }
}
enum RMRoleType: Int, SmartCaseDefaultable {
    static var defaultCase:RMRoleType = .audience
    case owner = 0
    case host = 3
    case admin = 1
    case audience = 2
}
enum RMUserListType: Int {
    case all = 0
    case host = 2
    case admin = 1
    case disableMessage = 3
}
enum RMMoreSetType {
    case setTing
    case role
    case callFans
    case clearStar
    case pkSet
    case waterList
    case muteOn
    case aniSet
    case report
    case close
    case mini
    case quite
    case game
    case bid
    case clearChat
}
enum RoomMoreCellType {
    case item
    case itemW
    case imageItem
    case vertical
}
enum RoomPDStatus: Int {
    case normal = 0
    case consult = 1
    case release = 2
    case audition = 3
    case dispatch = 4
}
enum RMPKStatusEnum: Int, SmartCaseDefaultable {
    static var defaultCase:RMPKStatusEnum = .normal
    case normal = -1
    case open = 0
    case start = 1
    case end = 2
    case close = 3
}
enum RMKFPKStatus: Int, SmartCaseDefaultable {
    static var defaultCase:RMKFPKStatus = .normal
    case normal = 0
    case start = 1
    case refuse = 2
    case end = 4
    case close = 3
}
enum RMPKResult: Int, SmartCaseDefaultable {
    static var defaultCase:RMPKResult = .dogfall
    case dogfall = 0
    case blue = 1
    case red = 2
}
enum RoomPKCampType: String, SmartCaseDefaultable {
    static var defaultCase:RoomPKCampType = .normal
    case normal = "normal"
    case host = "host"
    case blue = "blue"
    case red = "red"
}
enum scene: String, SmartCaseDefaultable {
    static var defaultCase: scene = .normal
    case normal = ""
    case pk = "pk"
}
enum gameStatus: Int, SmartCaseDefaultable {
    static var defaultCase: gameStatus = .normal
    case normal = 0
    case isGame = 1
}
enum inviteType: String, SmartCaseDefaultable {
    static var defaultCase: inviteType = .send
    case send = "send"
    case receive = "receive"
    case reject = "reject"
    case cancel = "cancel"
}
enum RoomHatStatus: Int, SmartCaseDefaultable {
    static var defaultCase:RoomHatStatus = .normal
    case normal = 0
    case start = 1
    case end = 2
}
