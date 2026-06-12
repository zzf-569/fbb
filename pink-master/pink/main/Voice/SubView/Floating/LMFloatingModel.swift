import Foundation
import AttributedString
private let UserNameColor = lmColorHex("#FFDD00")
private let RoomNameColor = lmColorHex("#00D96D")
private let TextColor = lmColorHex("#FFFFFF")
private let TextFont = lmFontM(14)
enum LMFloatingStyle {
    case gift
    case allRoomGift
}
class LMFloatingModel {
    let message: IMMessageModel
    var style: LMFloatingStyle = .gift
    var content: ASAttributedString = ASAttributedString(string: "")
    init(message: IMMessageModel) {
        self.message = message
        self.configMsgModel()
    }
}
private extension LMFloatingModel {
    func configMsgModel() {
        if message.type == .float_screen_gift {
            self.style = .gift
            let fromNickname = message.msgDict["fromNickname"] as? String ?? ""
            let toNickname = message.msgDict["toNickname"] as? String ?? ""
            let giftName = message.msgDict["giftName"] as? String ?? ""
            let giftNumber = message.msgDict["giftNumber"] as? String ?? ""
            let fromNicknameS: ASAttributedString = .init(string: fromNickname, .font(TextFont), .foreground(UserNameColor))
            let startS: ASAttributedString = .init(" 赠送 ", .font(TextFont), .foreground(TextColor))
            let toNicknameS: ASAttributedString = .init(string: toNickname, .font(TextFont), .foreground(UserNameColor))
            let giftNameS: ASAttributedString = .init(" \(giftName) ", .font(TextFont), .foreground(TextColor))
            let giftNumberS: ASAttributedString = .init("x\(giftNumber)", .font(TextFont), .foreground(TextColor))
            self.content = fromNicknameS + startS + toNicknameS + giftNameS + giftNumberS
        }
        if message.type == .all_float_screen_gift {
            self.style = .allRoomGift
            let fromNickname = message.msgDict["fromNickname"] as? String ?? ""
            let toNickname = message.msgDict["toNickname"] as? String ?? ""
            let giftName = message.msgDict["giftName"] as? String ?? ""
            let giftNumber = message.msgDict["giftNumber"] as? String ?? ""
            let RoomName = message.msgDict["roomName"] as? String ?? ""
            let fromNicknameS: ASAttributedString = .init(string: fromNickname, .font(TextFont), .foreground(UserNameColor))
            let onS: ASAttributedString = .init(" 在 ", .font(TextFont), .foreground(TextColor))
            let roomNameS: ASAttributedString = .init(string:RoomName, .font(TextFont), .foreground(RoomNameColor))
            let startS: ASAttributedString = .init(" 赠送 ", .font(TextFont), .foreground(TextColor))
            let toNicknameS: ASAttributedString = .init(string: toNickname, .font(TextFont), .foreground(UserNameColor))
            let giftNameS: ASAttributedString = .init(" \(giftName) ", .font(TextFont), .foreground(TextColor))
            let giftNumberS: ASAttributedString = .init("x\(giftNumber)", .font(TextFont), .foreground(TextColor))
            self.content = fromNicknameS + onS + roomNameS + startS + toNicknameS + giftNameS + giftNumberS
        }
    }
}
