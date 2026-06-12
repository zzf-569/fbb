import Foundation
struct ShopTypeModel: SmartCodable {
    var id: Int = 0
    var typeName: String = ""
}
struct ShopListItem: SmartCodable {
    var id: Int = 0
    var dressUpName: String = ""
    var dressUpIcon: String = ""
    var type: Int = 0 
    var resource: String = ""
    var typeIcon: String = ""
    var dailyPrice: Int = 0
    var priceList: [ShopPriceList] = []
    var isSelected = false
}
struct ShopPriceList: SmartCodable {
    var id: Int = 0
    var days: Int = 0
    var discount: Int = 0
    var totalPrice: Int = 0
}
struct UserDressModel: SmartCodable {
    var id: Int = 0
    var resourceName: String = ""
    var dressUpIcon: String = ""
    var type: Int = 0 
    var resource: String = ""
    var typeIcon: String = ""
    var remainTime: String = ""
    var isActive: Bool = false
    var isSelected: Bool = false
}
struct DressRecordModel: SmartCodable {
    var resourceName: String = ""
    var giftGiver: String = ""
    var giftGiverName: String = ""
    var resourceId: Int = 0
    var source: Int = 0
    var duration: Int = 0
    var createTime: String = ""
}
