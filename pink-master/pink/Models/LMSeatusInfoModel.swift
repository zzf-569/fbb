import Foundation
struct LMSeatusInfoModel: SmartCodable {
    var userId: String = ""
    var nickname: String = ""
    var avatar: String = ""
    var charmValue: Int = 0
    var headWear: String = ""
    var soundByte: String = ""
    var streamId: String = ""
    var seatinfo12: String = ""
    var seatinfomkdf: String = ""
    var seatinfo2mf: String = ""
    var gender: UserGenderType = .boy
}
