import Foundation
struct WalletItem: SmartCodable {
    var userId: Int = 0 
    var coin: Int = 0 
    var cash: Float = 0.0 
}
struct RechargeItem: SmartCodable {
    var productId: String = ""
    var price: Int = 0
    var name: String = "" 
    var extName: String = "" 
    var extPrice: Int = 0
    var productAmount: Int = 0
    var tagUrl: String = "" 
    var appleProductId: String = ""
    var icon: String = "" 
}
struct WalletRecordsItem: SmartCodable {
    var text: String = "" 
    var amount: String = "" 
    var createTime: String = "" 
    var markText: String = "" 
    var toUserId: String = "" 
    var type: incomeType =  .gift
}
struct WithdrawConfig: SmartCodable {
    var cash: String = "" 
    var toCoinConfig: [WithdrawConfigItem] = [] 
    var toCashConfig: [WithdrawConfigItem] = [] 
}
struct WithdrawConfigItem: SmartCodable {
    var itemId: Int = 0 
    var targetName: String = "" 
    var requireName: String = "" 
    var requireValue: Int = 0 
    var targetValue: Int = 0 
    var targetUnit: String = "" 
}
