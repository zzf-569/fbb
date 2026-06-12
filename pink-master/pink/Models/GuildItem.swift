import Foundation
struct GuildItem: SmartCodable {
    var status: Int = 0 
    var joinStatus: Int = 0 
    var applyId: Int = 0 
    var familyId: Int = 0 
    var showFamilyId: Int = 0 
    var specialId: Int = 0 
    var hotValue: Int = 0 
    var ownerNickname: String = ""
    var familymf: String = ""
    var familfdfm: String = ""
    var familymfiin: String = ""
    var cover: String = ""
    var title: String = "" 
    var admin: Bool = false 
    var owner: Bool = false 
    var applyCnt: Int = 0 
    var notification: String = ""
    var ownerUserId: Int = 0 
}
struct GuildusInfoModel: SmartCodable {
    var userId: String = ""
    var showUserId: String = ""
    var infow1d: String = ""
    var infommvo: String = ""
    var info1mfk: String = ""
    var nickname: String = ""
    var avatar: String = ""
    var age: Int = 0
    var gender: Int = 0
    var richLevel: Int = 0
    var charmLevel: Int = 0
    var role: Int = 0
    var userCharmValue: String = ""
}
struct GuildRoomModel: SmartCodable {
    var ownerUserId: String = ""
    var imRoomId: String = ""
    var token: String = ""
    var roomType: RMCORType = .normal
    var roomId: String = ""
    var roomName: String = "我是房间名字"
    var showRoomId: String = "8888"
    var cover: String = ""
    var role: RMRoleType = .audience
    var hotValue: Int = 0
    var roomCharmValue: String = ""
    var like: Bool = false
    var notification: String = "我是公告我是公告我是公告我是公告我是公告我是公告我是公告我是公告"
    var background: String = ""
    var tagId: String = "123"
    var tagName: String = "交友"
    var seatList: [RoomSeatItem] = []
    var onlineAvatarList: [String] = []
    var failydwd: String = ""
    var failydffd: String = ""
    var failyddv: String = ""
}
struct GuildApplyModel: SmartCodable {
    var userId: String = ""
    var appdd1: String = ""
    var appfsdn: String = ""
    var appvok: String = ""
    var nickname: String = ""
    var createTime: String = ""
    var avatar: String = ""
    var applyType: Int = 0
    var applyId: Int = 0
    var desc: String = ""
}
