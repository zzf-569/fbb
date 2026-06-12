import Foundation
struct SuiteAnimationModel: SmartCodable {
    var needAnimation: Bool = false
    var animationId: String = ""
    var animationUrl: String = ""
    enum CodingKeys: String, CodingKey {
        case needAnimation
        case animationId = "giftId"
        case animationUrl
    }
}
