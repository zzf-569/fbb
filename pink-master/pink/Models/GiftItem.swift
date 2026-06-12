import Foundation
struct GiftItem: SmartCodable {
    var id: String = ""
    var name: String = ""
    var iconUrl: String = ""
    var price: Int = 123
    var tagUrl: String = ""
    var giftCard: String = ""
    var eemfroom: String = ""
    var room881d: String = ""
    var dispa9mmv: String = ""
    var cardInfo: String = ""
    var isSelected: Bool = false
    var isMagicGift: Bool = false
}
struct GiftWallModel: SmartCodable {
    var show: String = ""
    var total: String = ""
    var eemfroom: String = ""
    var gittnvd: String = ""
    var gittnvddff: String = ""
    var iconUrl: String = ""
    var giftList: [GiftWallListL] = []
}
struct GiftWallListL: SmartCodable {
    var giftId: Int = 0
    var name: String = ""
    var iconUrl: String = ""
    var animationUrl: String = ""
    var tagUrl: String = ""
    var count: Int = 0
    var giftName: String = ""
    var unLocked: Bool = false
    var price: Int = 0
    var efmfigtm: String = ""
    var gittnf2: String = ""
    var gittnmv82: String = ""
    var latestLightingUpUser: String = ""
    var lightingUpTime: String = ""
    var lightingUpCount: String = ""
}
struct GiftCategoryModel: SmartCodable {
    var id: Int = 0
    var name: String = ""
}
struct IhListModel: SmartCodable {
    var id: Int = 0
    var ihName: String = ""
    var ihSourceMaterial: String = ""
    var ihSelect: Bool = false
    var ihmfm2: String = ""
    var ihmf222: String = ""
    var oh39fmf: String = ""
    var detail: GiftWallSectionModel = GiftWallSectionModel()
    var unlocked: Bool = false
    var canReceive: Bool = false
}
struct GiftWallSectionModel: SmartCodable {
    var ihGiftList: [GiftWallListL] = []
    var rewards: [GiftWallReawrdModel] = []
    var ihGiftCount: Int = 0
    var unlockedGiftCount: Int = 0
}
struct GiftWallReawrdModel: SmartCodable {
    var id: Int = 0
    var type: Int = 0
    var dressUpIcon: String = ""
    var dressUpName: String = ""
    var days: Int = 0
    var unlocked: Bool = false
    var canReceive: Bool = false
    var name: String = ""
}
