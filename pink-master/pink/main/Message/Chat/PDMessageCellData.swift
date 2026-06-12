import TIMCommon
class PDMessageCellData: TUIBubbleMessageCellData {
    var order: DispatchOrderModel?
    var orderTime: String = ""
    var bizIcon: String = ""
    var bizCard: String = ""
    var sourceUserInfo: UsInfoItem?
    var targetUserInfo: UsInfoItem?
    var chairImUserId: String = ""
    func toModel(_ contentDict: [String: Any]) {
        bizIcon = contentDict["bizIcon"] as? String ?? ""
        bizCard = contentDict["bizCard"] as? String ?? ""
        chairImUserId = contentDict["chairImUserId"] as? String ?? ""
        orderTime = (contentDict["time"] as? Int)?.toString() ?? ""
        sourceUserInfo = UsInfoItem.deserialize(from: contentDict["sourceUserInfo"] as? [String: Any])
        targetUserInfo = UsInfoItem.deserialize(from: contentDict["targetUserInfo"] as? [String: Any])
        order = DispatchOrderModel.deserialize(from: contentDict["order"] as? [String: Any])
    }
}
struct DispatchOrderModel: SmartCodable {
    var bizId: String = ""
    var bizName: String = ""
    var bizNum: Int = 0
    var createUserId: String = ""
    var orderNo: String = ""
    var orderPrice: String = ""
    var sourceType: Int = 0
    var status: OrderStatus = .missed
    var targetId: String = ""
    var targetUserId: String = ""
    var userId: String = ""
}
