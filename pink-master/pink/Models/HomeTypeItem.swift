import Foundation
class HomeTypeItem: NSObject, NSCoding, NSSecureCoding, SmartCodable {
    var tagId: Int = 0
    var tagName: String = ""
    var tagIcon: String = ""
    var tagUrl: String = ""
    required override init() {
        super.init()
    }
    func encode(with coder: NSCoder) {
        coder.encode(tagId, forKey: "tagId")
        coder.encode(tagName, forKey: "tagName")
        coder.encode(tagIcon, forKey: "tagIcon")
        coder.encode(tagUrl, forKey: "tagUrl")
    }
    required init?(coder: NSCoder) {
        tagId = coder.decodeInteger(forKey: "tagId")
        tagName = coder.decodeObject(forKey: "tagName") as? String ?? ""
        tagIcon = coder.decodeObject(forKey: "tagIcon") as? String ?? ""
        tagUrl = coder.decodeObject(forKey: "tagUrl") as? String ?? ""
    }
    static var supportsSecureCoding: Bool { true }
}
