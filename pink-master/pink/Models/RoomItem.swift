import Foundation
struct RoomItem: SmartCodable {
    var ownerUserId: String = ""
    var ownerNickname: String = ""
    var imRoomId: String = ""
    var token: String = ""
    var roomType: RMCORType = .normal
    var categoryId: String = ""
    var categoryName: String = "陪玩"
 
    var cornerMark: String = ""
    var scene: scene = .normal
    var gameStatus: gameStatus = .normal
    var gameId: Int = 0
    var roovk: String = ""
    var roomllfd: String = ""
    var roomnnvj: String = ""
    var typeValue: String = ""
    
    var roomId: String = ""
    var roomName: String = ""
    var showRoomId: String = ""
    var cover: String = ""
    var role: RMRoleType = .audience
    var hotValue: Int = 0
    var roomvjid: String = ""
    var room0pe: String = ""
    var roomvo2: String = ""
    var like: Bool = false
    var notification: String = ""
    var background: String = ""
    var status: Int = 0
    var tagUrl: String = ""
    
    
    var seatList: [RoomSeatItem] = [] {
        didSet {
            if roomType == .normal || roomType == .party {
                if VoiceShared.roomViewController?.pkViewModel?.dataSoure.status == .open || VoiceShared.roomViewController?.pkViewModel?.dataSoure.status == .start || VoiceShared.roomViewController?.pkViewModel?.dataSoure.status == .end {
                    for (index, seat) in seatList.enumerated() {
                        if seat.seatIndex == 0 {
                            seatList[index].pkCamp = .host
                        } else if seat.seatIndex == 1 || seat.seatIndex == 2 || seat.seatIndex == 5 || seat.seatIndex == 6 {
                            seatList[index].pkCamp = .blue
                        } else {
                            seatList[index].pkCamp = .red
                        }
                    }
                    return
                }
            }
            if roomPkInfo != nil {
                for (index, seat) in seatList.enumerated() {
                    seatList[index].pkCamp = .blue
                }
                return
            }
            for (index, _) in seatList.enumerated() {
                seatList[index].pkCamp = .normal
            }
        }
    }
    var onlineAvatarList: [String] = []
    @SmartAny var demandInfo: [String: Any]?
    var pk: Bool = false
    @SmartAny var pkInfo: [String: Any]?
    var inviteInfo: inviteInfo?
    var roomPkInfo: invitePkInfo?
    static func mappingForKey() -> [SmartKeyTransformer]? {
        [
            CodingKeys.roomType <--- ["category"],
            CodingKeys.categoryId <--- ["type"]
        ]
    }
}
struct CollectRoomModel: SmartCodable {
    var bizId: String = ""
    var name: String = ""
    var image: String = ""
    var category: Int = 0
    var hotValue: Int = 0
    var roomp2: String = ""
    var roomnv8: String = ""
    var roomfet: String = ""
    var type: Int = 0
    var onlineAvatarList: [String] = []
}
struct RoomCloseModel: SmartCodable {
    var openTime: Int = 0 
    var turnover: Int = 0 
    var sendGiftPeopleCount: Int = 0 
    var audienceCount: Int = 0 
    var addFansCount: Int = 0
    var roomfdkn: String = ""
    var roomcls: String = ""
    var room73f: String = ""
}
struct inviteInfo: SmartCodable {
    var cover: String = ""
    var inviteId: String = ""
    var nickname: String = ""
    var currentTime: Double = 0
    var inviteTime: Double = 0
    var pkTime: Int = 0
    var role: Int = 0
    var eemfroom: String = ""
    var room881d: String = ""
    var dispa9mmv: String = ""
    var roomId: String = ""
    var roomName: String = ""
    var type: inviteType = .defaultCase
    var userId: String = ""
}
struct invitePkInfo: SmartCodable {
    var currentTime: Double = 0
    var startTime: Double = 0
    var endTime: Double = 0
    var status: RMKFPKStatus = .defaultCase
    var pkTime: Int = 0
    var inviteId: String = ""
    var result: RMPKResult?
    var campValueMap: [String: campValueMap]?
    var roomCountMap: [String: Int]?
    var roomMap: [String: RoomMapValue]?
    var roomb2ed: String = ""
    var roomnnv8: String = ""
    var roomhskjd2vfv: String = ""
    var seatList: [RoomSeatItem]?
}
struct campValueMap: SmartCodable {
    var pkValue: Int = 0
    var topAvatarList: [LMtopAvatarModel] = []
}
struct LMtopAvatarModel: SmartCodable {
    var amount: Int = 0
    var avatar: String = ""
    var userId: String = ""
    var nickname: String = ""
}
struct RoomMapValue: SmartCodable {
    var ownerUserId: String = ""
    var ownerNickname: String = ""
    var categoryName: String = "交友"
    var roomId: String = ""
    var roomName: String = ""
    var showRoomId: String = ""
    var cover: String = ""
    var role: RMRoleType = .audience
    var hotValue: Int = 0
    var notification: String = ""
    var background: String = ""
    var status: Int = 0
    var tagUrl: String = ""
    var cornerMark: String = ""
}
