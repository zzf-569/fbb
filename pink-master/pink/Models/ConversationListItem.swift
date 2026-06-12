import Foundation
import TIMCommon
struct ConversationListItem {
    let imConversation: V2TIMConversation?
    let converID: String
    let avatarImage: String?
    let avatar: String?
    let title: String
    let subtitle: NSAttributedString
    let time: String
    var status: Int = 0
    let badge: Int
    init(converID: String, imConversation: V2TIMConversation? = nil) {
        self.converID = converID
        self.imConversation = imConversation
        guard let imConversation = self.imConversation else {
            if converID == kConversationId(imUserId: AppConfig.IMConfig.officialIMID) {
                title = "官方消息"
                avatarImage = "msg_official"
            }  else if converID == kConversationId(imUserId: AppConfig.IMConfig.walletIMID) {
                title = "钱包"
                avatarImage = "msg_wallet"
            } else if converID == kConversationId(imUserId: AppConfig.IMConfig.dispatchIMID) {
                title = "派单"
                avatarImage = "msg_partner"
            } else if converID == kConversationId(imUserId: AppConfig.IMConfig.customUserId) {
                title = "专属客服"
                avatarImage = "msg_custom"
            } else {
                title = "未知"
                avatarImage = "msg_wallet"
            }
            avatar = nil
            subtitle = NSAttributedString(string: "暂无消息", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
            time = ""
            badge = 0
            return
        }
        if converID == kConversationId(imUserId: AppConfig.IMConfig.officialIMID) {
            title = "官方消息"
            avatarImage = "msg_official"
            avatar = nil
        }  else if converID == kConversationId(imUserId: AppConfig.IMConfig.walletIMID) {
            title = "钱包"
            avatarImage = "msg_wallet"
            avatar = nil
        } else if converID == kConversationId(imUserId: AppConfig.IMConfig.dispatchIMID) {
            title = "派单"
            avatarImage = "msg_partner"
            avatar = nil
        } else if converID == kConversationId(userId: AppConfig.IMConfig.customUserId) {
            title = "专属客服"
            avatarImage = "msg_custom"
            avatar = nil
        } else {
            avatarImage = nil
            title = imConversation.showName!
            avatar = imConversation.faceUrl
        }
        badge = Int(imConversation.unreadCount)
        if let lastMessage = imConversation.lastMessage {
            subtitle = Self.getSubtitle(lastMessage)
            time = lastMessage.timestamp!.dateToFormatString()
        } else {
            subtitle = NSAttributedString(string: "暂无消息", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
            time = ""
        }
    }
    static func getSubtitle(_ msg: V2TIMMessage) -> NSAttributedString {
        var subtitle: NSAttributedString?
        switch msg.elemType {
        case .ELEM_TYPE_TEXT:
            if msg.textElem!.text != nil {
                if msg.isPeerRead == true && msg.isSelf {
                    subtitle = ("[已读]" +  msg.textElem!.text!).getFormatEmojiString(with: lmFontF(12), emojiLocations: [])
                } else {
                    subtitle = msg.textElem!.text!.getFormatEmojiString(with: lmFontF(12), emojiLocations: [])
                }
            } else {
                do {
                    let msgDict = try JSONSerialization.jsonObject(with: msg.cloudCustomData!) as? [String: Any]
                    if let msgDict = msgDict {
                        if let type = msgDict["type"] as? Int {
                            if let messageType = IMMessageType(rawValue: type) {
                                let contentDict = msgDict["customData"] as! [String: Any]
                                if messageType == .dispatch_release {
                                    if let demandInfo = DispatchItem.deserialize(from: contentDict["demandInfo"] as? [String: Any]) {
                                        subtitle = NSAttributedString(string: "[\(demandInfo.bizName) x\(demandInfo.demandPrice)]", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
                                    }
                                }
                                if messageType == .dispatch_order {
                                    subtitle = NSAttributedString(string: "[陪玩消息]", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
                                }
                            }
                        } else {
                            if let title = msgDict["title"] as? String {
                                if msg.isPeerRead == true && msg.isSelf {
                                    subtitle = NSAttributedString(string: "[已读]" + title, attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
                                } else {
                                    subtitle = NSAttributedString(string: title, attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
                                }
                            }
                        }
                    }
                } catch _ {
                }
            }
        case .ELEM_TYPE_CUSTOM:
            subtitle = NSAttributedString(string: "[自定义]", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
        case .ELEM_TYPE_IMAGE:
            subtitle = NSAttributedString(string: "[图片]", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
        case .ELEM_TYPE_SOUND:
            if msg.isPeerRead == true && msg.isSelf {
                subtitle = NSAttributedString(string: "[已读]" + "[语音]", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
            } else {
                subtitle = NSAttributedString(string: "[语音]", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
            }
        case .ELEM_TYPE_VIDEO:
            subtitle = NSAttributedString(string: "[视频]", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
        case .ELEM_TYPE_FACE:
            subtitle = NSAttributedString(string: "[表情]", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
        default:
            subtitle = NSAttributedString(string: "[暂不支持此消息展示]", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
        }
        if msg.status == .MSG_STATUS_LOCAL_REVOKED {
            if kUserId(imUserId: msg.sender!) == UserShared.user?.userId {
                subtitle = NSAttributedString(string: "您撤回了一条消息", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
            } else {
                subtitle = NSAttributedString(string: "对方撤回了一条消息", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
            }
        }
        return subtitle ?? NSAttributedString(string: "[暂不支持此消息展示]", attributes: [.font: lmFontF(12), .foregroundColor: lmColorHex("#2B313DA3")])
    }
}
