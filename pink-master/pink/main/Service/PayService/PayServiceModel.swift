import Foundation
struct PayServiceModel: SmartCodable {
    var orderId: String = "" 
    var timeStamp: UInt32 = 0 
    var nonceStr: String = "" 
    var packageValue: String = "" 
    var prepayId: String = ""  
    var signType: String = ""
    var paySign: String = "" 
    var appId: String = "" 
    var partnerId: String = "" 
    var payType: String = "" 
    var outTradeNo: String = "" 
    var productName: String = "" 
    var orderNo: String = "" 
    var pamentId: String = ""
}
