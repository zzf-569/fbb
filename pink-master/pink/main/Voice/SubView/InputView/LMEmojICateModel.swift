import Foundation
struct LMEmojICateModel: SmartCodable {
    var categoryName: String = ""
    var emojiList: [LMEmojiListModel] = []
}
struct LMEmojiListModel: SmartCodable {
    var id: String = ""
    var name: String = ""
    var url: String = ""
    var animationUrl: String = ""
    var isPlayed: Bool = false
    static func mappingForKey() -> [SmartKeyTransformer]? {
        [
            CodingKeys.id <--- ["id", "emojiId"]
        ]
    }
}
