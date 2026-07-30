import Foundation
import AttributedString
import ImSDK_Plus
enum VoiceChatListStyle {
    case normal
    case notice
    case join
    case emoji
}
class VoiceChatListModel {
    var messageModel: IMMessageModel
    var cellStyle:VoiceChatListStyle = .notice
    var cellHeight: Double = 0.0
    var user: UsInfoItem?
    var aitUser: UsInfoItem?
    var toUser: UsInfoItem?
    var userAbout: ASAttributedString = ASAttributedString(string: "")
    var content: ASAttributedString = ASAttributedString(string: "")
    var contentSize: CGSize = CGSize(width: 0, height: 0)
    var emojiModel: LMEmojiListModel?
    var localInfo: Any?
    var clickUserblock: ((_ userId: String) -> Void)?
    init(messageModel: IMMessageModel) {
        self.messageModel = messageModel
        self.ConfigMsgCellModel()
    }
    convenience init(style:VoiceChatListStyle,roomId: String, info: Any?) {
        self.init(messageModel: IMMessageModel(roomId:roomId, userId: nil, message: V2TIMMessage()))
        self.cellStyle = style
        self.localInfo = info
        self.configLocalMsgCellModel()
    }
}
private extension VoiceChatListModel {
    func ConfigMsgCellModel() {
        if messageModel.type == .join {
            guard let user = UsInfoItem.deserialize(from: messageModel.msgDict["user"] as? [String: Any]) ?? self.user else { return }
            self.cellStyle = .join
            self.user = user
            let content: ASAttributedString = .init(string: user.nickname + " 来了", .font(lmFontF(12)), .foreground(lmColorHex("#FFFFFFE0")))
            self.content = content
        }
        if messageModel.type == .at_msg {
            guard let msg = messageModel.msgDict["msg"] as? String else { return }
            guard let user = UsInfoItem.deserialize(from: messageModel.msgDict["user"] as? [String: Any]) else { return }
            guard let aitUser = [UsInfoItem].deserialize(from: messageModel.msgDict["atUserList"] as? [[String: Any]])?.first else { return }
            self.cellStyle = .normal
            self.user = user
            let userContent: ASAttributedString = configUserInfoStr()
            let aitUserContent: ASAttributedString = .init(string: "@" + aitUser.nickname + " ", .font(lmFontF(14)), .foreground(lmColorHex("#FF4F7D")), .action({ result in
                switch result.content {
                case .string(let value):
                    print("文本: \(value) range: \(result.range)")
                    self.clickUserblock?(aitUser.userId)
                case .attachment(let value):
                    print("附件: \(value) range: \(result.range)")
                }
            }))
            let content: ASAttributedString = .init(.init(string: msg, .font(lmFontF(14)), .foreground(lmColorHex("#FFFFFFE0"))), .font(lmFontF(14)))
            self.userAbout = userContent
            self.content = aitUserContent + content
        }
        if messageModel.type == .text_msg {
            guard let msg = messageModel.msgDict["msg"] as? String else { return }
            guard let user = UsInfoItem.deserialize(from: messageModel.msgDict["user"] as? [String: Any]) else { return }
            self.cellStyle = .normal
            self.user = user
            let userContent: ASAttributedString = configUserInfoStr()
            let content: ASAttributedString = .init(string: msg, .font(lmFontF(14)), .foreground(lmColorHex("#FFFFFFE0")))
            self.userAbout = userContent
            self.content = content
        }
        if messageModel.type == .face_msg {
            guard let emojiModel = LMEmojiListModel.deserialize(from: messageModel.msgDict["emoji"] as? [String: Any]) else { return }
            guard let user = UsInfoItem.deserialize(from: messageModel.msgDict["user"] as? [String: Any]) else { return }
            self.cellStyle = .emoji
            self.user = user
            self.emojiModel = emojiModel
            let userContent: ASAttributedString = configUserInfoStr()
            self.userAbout = userContent
        }
        if messageModel.type == .send_dress {
            self.cellStyle = .normal
            guard let data = messageModel.msgDict["data"] as? [String: Any] else { return }
            guard let extMap = messageModel.msgDict["extMap"] as? [String: Any] else { return }
            guard var user = UsInfoItem.deserialize(from: extMap) else { return }
            let userId = data["userId"] as? String ?? ""
            let nickname = data["nickname"] as? String ?? ""
            let avatar = data["avatar"] as? String ?? ""
            let headWear = data["headWear"] as? String ?? ""
            user.userId = userId
            user.nickname = nickname
            user.avatar = avatar
            user.headWear = headWear
            let toUserId = data["toUserId"] as? String ?? ""
            let toNickname = data["toNickname"] as? String ?? ""
            let giftNameText = data["dressUpName"] as? String ?? ""
            let iconUrl = data["dressUpIcon"] as? String ?? ""
            let giftNumber = data["days"] as? Int ?? 0
            self.user = user
            self.toUser = UsInfoItem(userId: toUserId, nickname: toNickname)
            let userContent: ASAttributedString = configUserInfoStr()
            let start: ASAttributedString = .init("赠送 ", .font(lmFontF(14)), .foreground(lmColorHex("#FFFFFFE0")))
            let userName: ASAttributedString = .init(" \(toNickname) ", .font(lmFontF(14)), .foreground(lmColorHex("#FF4F7D")), .action({ result in
                switch result.content {
                case .string(let value):
                    print("文本: \(value) range: \(result.range)")
                    self.clickUserblock?(toUserId)
                case .attachment(let value):
                    print("附件: \(value) range: \(result.range)")
                }
            }))
            let giftName: ASAttributedString = .init("\(giftNameText) ", .font(lmFontF(14)), .foreground(lmColorHex("#FFFFFFE0")))
            let imv = UIImageView(image: kPlaceholder_image)
                .contentMode(.scaleAspectFill)
                .frame(CGRect(x: 0, y: 0, width: 20.0, height: 20.0))
            imv.set_Image(url: iconUrl)
            let giftImage: ASAttributedString = .init("\(.view(imv, .original(.center))) ", .font(lmFontF(14)))
            let giftCount: ASAttributedString = .init("\(giftNumber.toString())天", .font(lmFontF(14)), .foreground(lmColorHex("#DDC006")))
            self.userAbout = userContent
            self.content = start + userName + giftName + giftImage + giftCount
            if let magicGift = data["magicGift"] as? [String: Any] {
                let magicgiftName = magicGift["giftName"] as? String ?? ""
                let magicgiftIcon = magicGift["giftIcon"] as? String ?? ""
                let magicgiftNameAs: ASAttributedString = .init("\(magicgiftName) ", .font(lmFontF(14)), .foreground(lmColorHex("#FFFFFFE0")))
                let imv = UIImageView(image: kPlaceholder_image)
                    .contentMode(.scaleAspectFill)
                    .frame(CGRect(x: 0, y: 0, width: 20.0, height: 20.0))
                imv.set_Image(url: magicgiftIcon)
                let magicgiftImageAs: ASAttributedString = .init("\(.view(imv, .original(.center))) ", .font(lmFontF(14)))
                let magicgiftCount: ASAttributedString = .init("x1", .font(lmFontF(14)), .foreground(lmColorHex("#DDC006")))
                let getText: ASAttributedString = .init("获得 ", .font(lmFontF(14)), .foreground(lmColorHex("#FFFFFFE0")))
                self.content = start + userName + magicgiftNameAs + magicgiftImageAs + magicgiftCount + getText + giftName + giftImage + giftCount
            }
        }
        if messageModel.type == .send_animation_gift {
            self.cellStyle = .normal
            guard let data = messageModel.msgDict["data"] as? [String: Any] else { return }
            guard let extMap = messageModel.msgDict["extMap"] as? [String: Any] else { return }
            guard var user = UsInfoItem.deserialize(from: extMap) else { return }
            let userId = data["userId"] as? String ?? ""
            let nickname = data["nickname"] as? String ?? ""
            let avatar = data["avatar"] as? String ?? ""
            let headWear = data["headWear"] as? String ?? ""
            user.userId = userId
            user.nickname = nickname
            user.avatar = avatar
            user.headWear = headWear
            let toUserId = data["toUserId"] as? String ?? ""
            let toNickname = data["toNickname"] as? String ?? ""
            let giftNameText = data["giftName"] as? String ?? ""
            let iconUrl = data["iconUrl"] as? String ?? ""
            let giftNumber = data["giftNumber"] as? String ?? ""
            self.user = user
            self.toUser = UsInfoItem(userId: toUserId, nickname: toNickname)
            let userContent: ASAttributedString = configUserInfoStr()
            let start: ASAttributedString = .init("赠送 ", .font(lmFontF(14)), .foreground(lmColorHex("#FFFFFFE0")))
            let userName: ASAttributedString = .init(" \(toNickname) ", .font(lmFontF(14)), .foreground(lmColorHex("#FF4F7DFF")), .action({ result in
                switch result.content {
                case .string(let value):
                    print("文本: \(value) range: \(result.range)")
                    self.clickUserblock?(toUserId)
                case .attachment(let value):
                    print("附件: \(value) range: \(result.range)")
                }
            }))
            let giftName: ASAttributedString = .init("\(giftNameText) ", .font(lmFontF(14)), .foreground(lmColorHex("#FFFFFFE0")))
            let imv = UIImageView(image: kPlaceholder_image)
                .contentMode(.scaleAspectFill)
                .frame(CGRect(x: 0, y: 0, width: 20.0, height: 20.0))
            imv.set_Image(url: iconUrl)
            let giftImage: ASAttributedString = .init("\(.view(imv, .original(.center))) ", .font(lmFontF(14)))
            let giftCount: ASAttributedString = .init("x\(giftNumber)", .font(lmFontF(14)), .foreground(lmColorHex("#DDC006")))
            self.userAbout = userContent
            self.content = start + userName + giftName + giftImage + giftCount
            if let magicGift = data["magicGift"] as? [String: Any] {
                let magicgiftName = magicGift["giftName"] as? String ?? ""
                let magicgiftIcon = magicGift["giftIcon"] as? String ?? ""
                
                let magicgiftNameAs: ASAttributedString = .init("\(magicgiftName) ", .font(lmFontF(14)), .foreground(lmColorHex("#FFFFFFE0")))
                
                // 礼物图片
                let imageView = UIImageView(image: kPlaceholder_image)
                    .contentMode(.scaleAspectFill)
                    .frame(CGRect(x: 0, y: 0, width: 20.0, height: 20.0))
                imageView.set_Image(url: magicgiftIcon)
                let magicgiftImageAs: ASAttributedString = .init("\(.view(imageView, .original(.center))) ", .font(lmFontF(14)))
                
                let magicgiftCount: ASAttributedString = .init("x1", .font(lmFontF(14)), .foreground(lmColorHex("#DDC006")))
                
                
                let getText: ASAttributedString = .init("获得 ", .font(lmFontF(14)), .foreground(lmColorHex("#FFFFFFE0")))
                
                
                self.content = start + userName + magicgiftNameAs + magicgiftImageAs + magicgiftCount + getText + giftName + giftImage + giftCount
                
            }
        }
        self.cellHeight = configCellHeight()
    }
    func configLocalMsgCellModel() {
        if cellStyle == .notice {
            guard let text = localInfo as? String else { return }
            let content: ASAttributedString = .init(string: text, with: [.font(lmFontF(14)), .foreground(lmColorHex("#26D49DFF"))])
            self.content = content
        }
        if cellStyle == .join {
            guard let user = localInfo as? UsInfoItem else { return }
            self.user = user
            let content: ASAttributedString = .init(string: user.nickname + " 来了", .font(lmFontF(12)), .foreground(lmColorHex("#FFFFFFE0")))
            self.content = content
        }
        self.cellHeight = configCellHeight()
    }
    func configUserInfoStr() -> ASAttributedString {
        guard let user = user else { return ASAttributedString("") }
        var content: ASAttributedString = ASAttributedString(string: "")
        if let role = user.role, role != .audience {
            let roydmageView = UIImageView(image: kPlaceholder_image)
                .contentMode(.scaleAspectFill)
                .frame(CGRect(x: 0, y: 0, width: 20.0, height: 20.0))
            var url = ""
            switch role {
            case .admin:
                url = "https://assets.cyanmo.com/icon_img/room-admin.png"
            case .owner:
                url = "https://assets.cyanmo.com/icon_img/homeowner.png"
            case .host:
                url = "https://assets.cyanmo.com/icon_img/room-host.png"
            default:
                break
            }
            roydmageView.set_Image(url: url)
            let roleAttributedString: ASAttributedString = .init("\(.view(roydmageView, .original(.center))) ", .font(lmFontF(12)))
            content += roleAttributedString
        }
        let sexAndAgeview = LMSexAgeView(frame: CGRect(x: 0, y: 0, width: 32.0, height: 20.0))
        sexAndAgeview.setDataSoure(gender: user.gender, age: user.age)
        if user.richLevel > 0, user.medal.isEmpty == false {
            let richimv = UIImageView(image: kPlaceholder_image)
                .contentMode(.scaleAspectFill)
                .frame(CGRect(x: 0, y: 0, width: 54.0, height: 20.0))
            richimv.set_Image(url: user.medal)
            let rich = UILabel(lmfont: lmFontASHTB(12), textColor: .white)
                .textAlignment(.right)
                .lmtext(user.richLevel.toString())
            richimv.addSubview(rich)
            rich.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-6)
                make.centerY.equalToSuperview()
            }
            let richLevel: ASAttributedString = .init("\(.view(richimv, .original(.center))) ", .font(lmFontF(12)))
            content += richLevel
        }
        return content
    }
    func configCellHeight() -> Double {
        let cellWidth = kScreenWidth - 61.0 - 106.0
        var cellHeight = 0.0
        let userAttributedString = userAbout.value
        let contentAttributedString = content.value
        if self.cellStyle == .notice {
           
            var contentSize = contentAttributedString.textSize(width: cellWidth)
            contentSize.height += 46
            self.contentSize = contentSize
            cellHeight += contentSize.height
        }
        if self.cellStyle == .normal {
           
            cellHeight = 24
            
            let contentWidth = cellWidth - 36.0 - 12.0 - 12.0
            var contentSize = contentAttributedString.textSize(width: contentWidth)
            contentSize.height += 12
            self.contentSize = contentSize
            cellHeight += contentSize.height
        }
        if self.cellStyle == .join {
            var contentSize = contentAttributedString.textSize(width: cellWidth)
            self.contentSize = contentSize
            contentSize.height += 46
            cellHeight += contentSize.height
        }
        if self.cellStyle == .emoji {
            
            cellHeight = 24
            
            let contentWidth = cellWidth - 36.0 - 12.0 - 12.0
            let contentSize = contentAttributedString.textSize(width: contentWidth)
            self.contentSize = contentSize
            cellHeight += contentSize.height
        }
        cellHeight += 20.0
        return cellHeight
    }
}
