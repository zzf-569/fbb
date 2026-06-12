import Foundation
struct zodiacModel: SmartCodable {
    var zodiacName: String = ""
    var luckyNumber: String = ""
    var openLuckNumber: Bool = false
    var overallScore: String = ""
    var matchUser: UsInfoItem = UsInfoItem()
}
