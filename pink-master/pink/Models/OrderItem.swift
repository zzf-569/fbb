import Foundation
struct OrderItem: SmartCodable {
    var userId: String = ""
    var orderNo: String = ""
    var number: String = ""
   
    var createTime: String = ""
    var targetUserInfo: UsInfoItem = UsInfoItem()
    var imUserId: String = ""
    var itemIcon: String = ""
    
    var itemName: String = ""
    var status: Int = 0
    var totalAmount: Int = 0
    var sourceType: String = ""
}
