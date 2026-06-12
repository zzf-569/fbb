import Foundation
struct UsInfoItem: SmartCodable {
    var userId: String = ""
    var showUserId: String = ""
    var mobile: String = ""
    var nickname: String = ""
    var avatar: String = ""
    var gender: Int = 1
    var age: Int = 25
    var signature: String = "这个人有点懒"
   
    var photoWall: [photoWallModel] = []
    var city: String = ""
    var constellation: String = ""
    var timbre: String = ""
    var birthday: String = ""
    var voiceUrl: String = ""
    var voiceSec: String = ""
    var fansCnt: Int = 0 
    var newFansCnt: Int = 0
    var visitorCnt: Int = 0
    var newVisitorCnt: Int = 0
    var collectCnt: Int = 0
    var focusCnt: Int = 0 
    var giftList: [GiftWallListL] = []
    var userSkills: [SkillItem] = []
    var userGiftCount: Int = 0
    var giftCount: Int = 0
    var userIhCount: Int = 0
    var ihCount: Int = 0
    
    var userlmf: Bool = false
    var useroom: Int = 0
    var usermfo: Int = 0
    var userm1: Bool = false
    var user2e: String = ""
    var usermm: String = ""
    var usermo1: String = ""
    var user02ff: Bool = false
    var usermdwfe: Bool = false
    var dksdjf: identityType = .defaultCase
    var sdfjdk: Int = 0
    
    
    var currentRoom: RoomItem?
    var headWear: String = ""
    var balloon: String = ""
    var levelEntryEffect: String = ""
    var medal: String = ""
    var onlineStatus: String = ""
    var currentRoomId: String = ""
    var hostLiked: Bool = false
    var bodyMd5: String = ""
    var labelList: [labelListModel] = []
    var userLabel: UserLabel = UserLabel()
    var role: RMRoleType?
    var accomplishments: [String] = []
    var customAccomplishment: String = ""
    var interests: [String] = []
    var customInterest: String = ""
    var games: [String] = []
    var customGame: String = ""
    
    var realAuth: Bool = false
    var richLevel: Int = 0
    var charmLevel: Int = 0
    var onSeat: Bool = false
    var roomId: String = ""
    var userSig: String = ""
    var imUserId: String = ""
    var liked: Bool = false
    var block: Bool = false
    var identity: identityType = .defaultCase
    var balance: Int = 0
    
    
}
struct photoWallModel: SmartCodable {
    var photoId: Int = 0
    var userId: String = ""
    var url: String = ""
    var checkStatus: Int = 0
}
struct relationModel: SmartCodable {
    var userId: String = ""
    var collect: Int = 0
    var liked: Int = 0
    var fans: Int = 0
}
struct labelListModel: SmartCodable {
    var labelType: lbType = .defaultCase
    var labelName: String = ""
    var labelValue: String = ""
    var labelIcon: String = ""
    var status: Int = 0
}
struct UserLabel: SmartCodable {
    var accomplishmentList: [labelListModel] = []
    var customAccomplishment: labelListModel?
    var interestList: [labelListModel] = []
    var customInterest: labelListModel?
    var gameList: [labelListModel] = []
    var customGame: labelListModel?
}
struct likeCountModel: SmartCodable {
    var likeNum: Int = 0
}
