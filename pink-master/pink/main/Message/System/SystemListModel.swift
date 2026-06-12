import Foundation
import ImSDK_Plus
struct SystemListModel {
    let msg: V2TIMMessage
    var style: String = IMSystemMessageStyle.common.rawValue
    var title: String = ""
    var content: String = ""
    var time: String = ""
    var amount: Int = 0
    var money: String = ""
    var account: String = ""
    var cash: Int  = 0
    var coin: Int = 0
    var cellHeight: Double = 0
    init(msg: V2TIMMessage) {
        self.msg = msg
        self.time = msg.timestamp!.dateToFormatString()
        do {
            let msgDict = try JSONSerialization.jsonObject(with: msg.cloudCustomData!) as? [String: Any]
            if let msgDict = msgDict, let style = msgDict["type"] as? String {
                self.style = style
                if style == IMSystemMessageStyle.common.rawValue || style == IMSystemMessageStyle.familyApply.rawValue || style == IMSystemMessageStyle.reward.rawValue || style == IMSystemMessageStyle.rule.rawValue {
                    self.title = msgDict["title"] as? String ?? ""
                    self.content = msgDict["content"] as? String ?? ""
                }
                if style == IMSystemMessageStyle.income.rawValue {
                    self.title = msgDict["title"] as? String ?? ""
                    self.amount = msgDict["money"] as? Int ?? 0
                    self.cash = msgDict["cash"] as? Int ?? 0
                    self.account = msgDict["accountName"] as? String ?? ""
                }
                if style == IMSystemMessageStyle.outcome.rawValue {
                    self.title = msgDict["title"] as? String ?? ""
                    self.amount = msgDict["money"] as? Int ?? 0
                    self.coin = msgDict["coin"] as? Int ?? 0
                    self.money = msgDict["money"] as? String ?? ""
                }
            } else {
                self.style = IMSystemMessageStyle.common.rawValue
                self.title = "暂不支持此消息"
                self.content = "暂不支持此消息"
            }
        } catch let error {
            self.style = IMSystemMessageStyle.common.rawValue
            self.title = "暂不支持此消息"
            self.content = error.localizedDescription
        }
        self.cellHeight = Self.getCellHeight(self)
    }
    static func getCellHeight(_ model: SystemListModel) -> Double {
        switch model.style {
        case IMSystemMessageStyle.common.rawValue, IMSystemMessageStyle.familyApply.rawValue:
            var allHeight = 12.0
            let titleHeight = model.title.textHeight(width: kScreenWidth - 16.0 * 2 - 12.0 * 2, font: lmFontASHTB(18))
            allHeight += titleHeight
            allHeight += 2.0
            allHeight += 20.0
            allHeight += 16.0
            let contentHeight = model.content.textHeight(width: kScreenWidth - 16.0 * 2 - 12.0 * 2, font: lmFontF(16))
            allHeight += contentHeight
            allHeight += 12.0
            return allHeight + 20.0
        case IMSystemMessageStyle.income.rawValue:
            return 258.0 + 20.0
        case IMSystemMessageStyle.outcome.rawValue:
            return 228.0 + 20.0
        default:
            return 0
        }
    }
}
