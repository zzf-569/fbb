import Foundation
struct RoomSeatItem: SmartCodable {
    var seatIndex: Int = 0
    var locked: Bool = false
    var mute: Bool = false
    var seat9j: String = ""
    var seatdf: String = ""
    var seatmmk: String = ""
    var bossSeat: Bool = false
    var hat: Bool = false
    var roomfp1: String = ""
    var roomnv: String = ""
    var seatnnv: String = ""
    var userInfo: LMSeatusInfoModel?
    var isSelected: Bool = false
    var seatText: String {
        if seatIndex == 0 {
            return "主持麦"
        } else if seatIndex == 8 {
            return "老板麦"
        } else if seatIndex == -1 {
            return "对方主持"
        } else {
            return "\(seatIndex)号麦"
        }
    }
    var pkCamp: RoomPKCampType = .normal
    var seatValue: Int = 0
}
