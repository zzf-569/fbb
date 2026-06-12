import Foundation
import ImSDK_Plus
import TUICore
import TUIChat
protocol IMServiceDelegate: NSObjectProtocol {
    func d_imNewGroupMessage(_ message: IMMessageModel?)
}
let BussinessID_Dispatch = "text_pd"
class IMService: NSObject {
    weak var delegate: IMServiceDelegate?
    var unreadCount: Int = 0
    static let shared = IMService()
    private override init() {
        super.init()
        initSDK()
    }
}
extension IMService {
    func initSDK() {
        let config = V2TIMSDKConfig()
        config.logLevel = .LOG_NONE
        V2TIMManager.sharedInstance().addIMSDKListener(listener: self)
        V2TIMManager.sharedInstance().initSDK(Int32(AppConfig.IMConfig.AppId), config: config)
        V2TIMManager.sharedInstance().addAdvancedMsgListener(listener: self)
        let uiConfig = TUIConfig.default()!
        uiConfig.defaultAvatarImage = kPlaceholder_avatar
        uiConfig.avatarType = .TAvatarTypeRounded
        let chatUIConfig = TUIChatConfig.default()
        chatUIConfig.backgroudColor = .clear
        chatUIConfig.enableWelcomeCustomMessage = false
        chatUIConfig.msgNeedReadReceipt = false
        chatUIConfig.enablePopMenuEmojiReactAction = false
        guard let info = Bundle.main.infoDictionary,
              let projectName = info["CFBundleExecutable"] as? String else { return }
        let nameSpace = projectName.replacingOccurrences(of: "-", with: "_")
        TUIChatConfig.default().registerCustomMessage(BussinessID_Dispatch, messageCellClassName: nameSpace + "." + PDMessageCell.className, messageCellDataClassName: nameSpace + "." + PDMessageCellData.className)
    }
}
extension IMService {
    func login(_ imUserId: String, completion block: @escaping (Bool, String?) -> Void) {
        getUserToken(imUserId, completion: block)
    }
    func getUserToken(_ imUserId: String, completion block: @escaping (Bool, String?) -> Void) {
        UserNetWork.imToken().lmrequest { responseModel in
            guard let imToken = responseModel.data as? String else {
                block(false, "IM Token 获取失败")
                return
            }
            self.tuiLogin(imUserId, imUserToken: imToken, completion: block)
        } failureBlock: { error in
            block(false, error.message)
        }
    }
    func tuiLogin(_ imUserId: String, imUserToken: String ,completion block: @escaping (Bool, String?) -> Void) {
        TUILogin.login(Int32(AppConfig.IMConfig.AppId), userID: imUserId, userSig: imUserToken) {
            lmPrint("IM ----- 登录成功 userId：\(imUserId) userSig:\(imUserToken)")
            self.upIMUnCount()
            block(true, nil)
        } fail: { code, msg in
            lmPrint("IM ----- 登录失败 userId：\(imUserId) userSig:\(imUserToken), code：\(code), msg:\(String(describing: msg))")
            block(false, msg)
        }
    }
    func logout() {
        V2TIMManager.sharedInstance().logout {
            lmPrint("IM ----- 退出成功")
        } fail: { code, msg in
            lmPrint("IM ----- 登录失败 code：\(code), msg:\(String(describing: msg))")
        }
    }
    func enterRoom(_ roomId: String) {
        V2TIMManager.sharedInstance().joinGroup(groupID: roomId, msg: "") {
            lmPrint("IM ----- 进入房间成功 imRoomId：\(roomId)")
        } fail: { code, msg in
            lmPrint("IM ----- 进入房间失败 imRoomId：\(roomId) code：\(code), msg:\(String(describing: msg))")
        }
    }
    func quitRoom(_ roomId: String) {
        V2TIMManager.sharedInstance().quitGroup(groupID: roomId) {
            lmPrint("IM ----- 退出房间成功 imRoomId：\(roomId)")
        } fail: { code, msg in
            lmPrint("IM ----- 退出房间失败 imRoomId：\(roomId) code：\(code), msg:\(String(describing: msg))")
        }
    }
    func getConversationList(completion block: @escaping ([V2TIMConversation]) -> Void) {
        let filter = V2TIMConversationListFilter()
        filter.type = .C2C
        V2TIMManager.sharedInstance().getConversationListByFilter(filter: filter, nextSeq: 0, count: UInt32(INT_MAX)) { list, _, _ in
            lmPrint("IM ----- 获取会话列表成功 \n")
            block(list ?? [])
        } fail: { code, msg in
            lmPrint("IM ----- 获取会话列表失败 code：\(code), msg:\(String(describing: msg))")
            block([])
        }
    }
    func getUnreadMessageCount(completion block: @escaping (Int) -> Void) {
        let filter = V2TIMConversationListFilter()
        filter.type = .C2C
        V2TIMManager.sharedInstance().getUnreadMessageCountByFilter(filter: filter) { count in
            lmPrint("IM ----- 获取单聊会话的未读总数:\(count)")
            block(Int(count))
        } fail: { code, msg in
            lmPrint("IM ----- 获取单聊会话的未读总数 code：\(code), msg:\(String(describing: msg))")
            block(0)
        }
    }
    func cleanUnreadCount(_ converID: String? = nil, completion block: @escaping (Bool, String?) -> Void) {
        V2TIMManager.sharedInstance().cleanConversationUnreadMessageCount(conversationID: converID, cleanTimestamp: 0, cleanSequence: 0) {
            lmPrint("IM ----- 清理指定单聊会话的未读数成功 filter:\(String(describing: converID))")
            block(true, nil)
        } fail: { code, msg in
            lmPrint("IM ----- 清理指定单聊会话的未读数失败 code：\(code), msg:\(String(describing: msg))")
            block(false, msg)
        }
    }
    func deleteConversation(_ converID: String, completion block: @escaping (Bool, String?) -> Void) {
        V2TIMManager.sharedInstance().deleteConversation(conversation: converID) {
            lmPrint("IM ----- 删除会话成功 converID：\(converID)")
            block(true, nil)
        } fail: { code, msg in
            lmPrint("IM ----- 删除会话失败 code：\(code), msg:\(String(describing: msg))")
            block(false, msg)
        }
    }
    func deleteConversationList(_ converIDList: [String], completion block: @escaping (Bool, String?) -> Void) {
        guard converIDList.count > 0 else {
            block(true, nil)
            return
        }
        V2TIMManager.sharedInstance().deleteConversationList(conversationIDList: converIDList, clearMessage: true) { _ in
            lmPrint("IM ----- 删除会话列表成功 converID：\(converIDList)")
            block(true, nil)
        } fail: { code, msg in
            lmPrint("IM ----- 删除会话列表失败 code：\(code), msg:\(String(describing: msg))")
            block(false, msg)
        }
    }
    func getC2CHistoryMessageList(_ imUserId: String, count: Int = 20, lastMsg: V2TIMMessage? = nil, completion block: @escaping ([V2TIMMessage], String?) -> Void) {
        V2TIMManager.sharedInstance().getC2CHistoryMessageList(userID: imUserId, count: Int32(count), lastMsg: lastMsg) { list in
            if let list = list {
                block(list, nil)
            } else {
                block([], nil)
            }
        } fail: { code, msg in
            lmPrint("IM ----- 获取私聊消息列表失败 code：\(code), msg:\(String(describing: msg))")
            block([], msg)
        }
    }
    func getGroupHistoryMessageList(_ groupId: String, count: Int = 20, lastMsg: V2TIMMessage? = nil, completion block: @escaping ([V2TIMMessage]) -> Void) {
        let filter = V2TIMConversationListFilter()
        filter.type = .GROUP
        V2TIMManager.sharedInstance().getGroupHistoryMessageList(groupID: groupId, count: Int32(count), lastMsg: lastMsg) { list in
            if let list = list {
                block(list)
            } else {
                block([])
            }
        } fail: { code, msg in
            lmPrint("IM ----- 获取公聊大厅消息记录失败 code：\(code), msg:\(String(describing: msg))")
            block([])
        }
    }
    func updateUserInfo(_ user: UsInfoItem) {
        let info = V2TIMUserFullInfo()
        info.nickName = user.nickname
        info.faceURL = user.avatar
        V2TIMManager.sharedInstance().setSelfInfo(info: info) {
            lmPrint("IM ----- 修改用户资料成功")
        } fail: { code, msg in
            lmPrint("IM ----- 修改用户资料成功 code：\(code), msg:\(String(describing: msg))")
        }
    }
    func upIMUnCount() {
        getUnreadMessageCount(completion: { count in
            self.unreadCount = count
            NotificationCenter.default.post(name: NotificationName.imUnreadMessageCountChange, object: self, userInfo: ["count": count])
        })
    }
    func getUserStatus(_ userList: [String], completion block: @escaping ([V2TIMUserStatus]) -> Void) {
        V2TIMManager.sharedInstance().getUserStatus(userIDList: userList) { status in
            block(status ?? [])
        } fail: { _, _ in
            block([])
        }
    }
    func subscribeUserStatus(_ userList: [String]) {
        V2TIMManager.sharedInstance().subscribeUserStatus(userIDList: userList) {
        } fail: { code, msg in
            print(code, msg as Any)
        }
    }
    func getLoginStatus() -> Bool {
        return !(V2TIMManager.sharedInstance().getLoginStatus() == .STATUS_LOGOUT)
    }
}
extension IMService: V2TIMSDKListener {
    func onConnecting() {
        lmPrint("IM ----- 正在连接到服务器")
    }
    func onConnectSuccess() {
        lmPrint("IM ----- 已经成功连接到服务器")
    }
    func onConnectFailed(_ code: Int32, err: String?) {
        lmPrint("IM ----- 连接服务器失败 code:\(code), err:\(String(describing: err))")
    }
    func onKickedOffline() {
        UserShared.logout {
            let alert = LMAlertCentreVC(title: "提示", message: "当前账户已在其他设备上登录，是否要重新登录？", cancel: nil, confirm: "知道了") { _ in
                let login = LoginViewController()
                RootRouter().setRootViewController(controller: BaseNavigationController(rootViewController: login), animatedWithOptions: nil)
            }
            alert.show(UIViewController.current)
        }
        lmPrint("IM ----- 当前用户被踢下线")
    }
    func onUserSigExpired() {
        lmPrint("IM ----- 当前用户 token 失效")
        if UserShared.isLogin, let user = UserShared.user {
            login(user.imUserId) { _, _ in
            }
        }
    }
    func onSelfInfoUpdated(info Info: V2TIMUserFullInfo!) {
        lmPrint("IM ----- 当前用户的资料发生了更新 info:\(String(describing: Info))")
    }
    func onUserStatusChanged(userStatusList: [V2TIMUserStatus]) {
        NotificationCenter.default.post(name: NotificationName.imonUserStatusChanged, object: self, userInfo: ["userStatusList": userStatusList])
        lmPrint("IM ----- 用户状态变更通知: userStatusList: \(String(describing: userStatusList))")
    }
}
extension IMService: V2TIMAdvancedMsgListener {
    func onRecvNewMessage(msg: V2TIMMessage!) {
        lmPrint("IM ----- 收到新消息 \nmsg:\(String(describing: msg))")
        let msgModel: IMMessageModel
        if let roomId = msg.groupID {
            do {
                let msgDict = try JSONSerialization.jsonObject(with: msg.cloudCustomData!) as? [String: Any]
                if let msgDict = msgDict {
                    lmPrint("IM ----- 新消息解析成功：\n\(msgDict)")
                    let type = msgDict["type"] as! Int
                    if let messageType = IMMessageType(rawValue: type) {
                        let contentDict = msgDict["customData"]
                        msgModel = IMMessageModel(type: messageType, msgDict: contentDict as! [String: Any], roomId: roomId, userId: nil, message: msg)
                    } else {
                        msgModel = IMMessageModel(type: .unknown, msgDict: [:], roomId: roomId, userId: nil, message: msg)
                    }
                } else {
                    lmPrint("IM ----- 新消息解析失败")
                    msgModel = IMMessageModel(type: .unknown, msgDict: [:], roomId: roomId, userId: nil, message: msg)
                }
            } catch let error {
                lmPrint("IM ----- 新消息解析失败: \(error.localizedDescription)")
                msgModel = IMMessageModel(type: .unknown, msgDict: [:], roomId: roomId, userId: nil, message: msg)
            }
            delegate?.d_imNewGroupMessage(msgModel);
        } else {
            let userId = msg.userID!
            if msg.cloudCustomData != nil {
                do {
                    let msgDict = try JSONSerialization.jsonObject(with: msg.cloudCustomData!) as? [String: Any]
                    if let msgDict = msgDict {
                        lmPrint("IM ----- 新消息解析成功：\n\(msgDict)")
                        if let type = msgDict["type"] as? Int, let messageType = IMMessageType(rawValue: type) {
                            let contentDict = msgDict["customData"] as! [String: Any]
                            if messageType == .dispatch_release {
                                if let demandInfo = DispatchItem.deserialize(from: contentDict["demandInfo"] as? [String: Any]) {
                                    DispatchService.shared.addDispatch(demandInfo)
                                }
                            }
                            msgModel = IMMessageModel(type: messageType, msgDict: contentDict, roomId: nil, userId: userId, message: msg)
                        } else {
                            msgModel = IMMessageModel(type: .unknown, msgDict: [:], roomId: nil, userId: userId, message: msg)
                        }
                    } else {
                        lmPrint("IM ----- 新消息解析失败")
                        msgModel = IMMessageModel(type: .unknown, msgDict: [:], roomId: nil, userId: userId, message: msg)
                    }
                } catch let error {
                    lmPrint("IM ----- 新消息解析失败: \(error.localizedDescription)")
                    msgModel = IMMessageModel(type: .unknown, msgDict: [:], roomId: nil, userId: userId, message: msg)
                }
            } else {
                msgModel = IMMessageModel(type: .unknown, msgDict: [:], roomId: nil, userId: userId, message: msg)
            }
            DispatchQueue.mainDelay(0.3) {
                self.upIMUnCount()
                NotificationCenter.default.post(name: NotificationName.imNewPrivateChatMessage, object: self, userInfo: ["msg": msgModel])
            }
        }
    }
    private func onRecvMessageRead(_ receiptList: [V2TIMMessageReceipt]!) {
        lmPrint("IM ----- 消息已读回执通知 \nreceiptList:\(String(describing: receiptList))")
    }
    func onRecvMessageRevoked(msgID: String!, operateUser: V2TIMUserFullInfo!, reason: String?) {
        let msgModel = IMMessageModel(roomId: nil, userId: operateUser.userID, message: V2TIMMessage())
        NotificationCenter.default.post(name: NotificationName.imNewPrivateChatMessage, object: self, userInfo: ["msg": msgModel])
        self.upIMUnCount()
    }
}
