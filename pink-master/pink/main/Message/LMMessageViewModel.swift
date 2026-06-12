import Foundation
import ImSDK_Plus
class LMMessageViewModel: NSObject {
    var block: (() -> Void)?
    var dataSource: [ConversationListItem] = [] {
        didSet {
            self.block?()
        }
    }
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(notiNewMsg), name: NotificationName.imNewPrivateChatMessage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notiNewMsg), name: NotificationName.imUnreadMessageCountChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notiUserChange), name: NotificationName.imonUserStatusChanged, object: nil)
    }
    func getCustomer() {
        guard AppConfig.IMConfig.customUserId.count == 0 else {
            self.getConversationList()
            return
        }
        MessageNetWork.getCustomer().lmrequest { responseModel in
            guard let customerID = responseModel.data as? Int else {
                self.getConversationList()
                return
            }
            AppConfig.IMConfig.customUserId = customerID.toString()
            self.getConversationList()
        } failureBlock: { _ in
            self.getConversationList()
        }
    }
    func getConversationList() {
        IMService.shared.getConversationList { list in
            lmPrint("Conversation List：\(list)")
            var tempDataSource: [ConversationListItem] = []
            let converID1 = kConversationId(imUserId: AppConfig.IMConfig.officialIMID)
            if let message = list.first(where: { $0.conversationID == converID1 }) {
                let model = ConversationListItem(converID: message.conversationID!, imConversation: message)
                tempDataSource.append(model)
            } else {
                let model = ConversationListItem(converID: converID1)
                tempDataSource.append(model)
            }
            let converIDcus = kConversationId(imUserId: AppConfig.IMConfig.customUserId)
            if AppConfig.IMConfig.customUserId.isEmpty == false {
                if let message = list.first(where: { $0.conversationID == converIDcus }) {
                    let model = ConversationListItem(converID: message.conversationID!, imConversation: message)
                    tempDataSource.append(model)
                } else {
                    let model = ConversationListItem(converID: converIDcus)
                    tempDataSource.append(model)
                }
            }
            for message in list {
                if message.conversationID == converID1 || message.conversationID == converIDcus {
                    continue
                }
                let model = ConversationListItem(converID: message.conversationID!, imConversation: message)
                tempDataSource.append(model)
            }
            self.dataSource = tempDataSource
            var userList: [String] = []
            userList = list.map({$0.userID!})
            self.getUserStatus(userList)
            self.subscribeUserStatus(userList)
        }
    }
    func getUserStatus(_ userList: [String]) {
        IMService.shared.getUserStatus(userList) { status in
            self.set_UserStaus(status)
        }
    }
    func subscribeUserStatus(_ userList: [String]) {
        IMService.shared.subscribeUserStatus(userList)
    }
    func set_UserStaus(_ status: [V2TIMUserStatus]) {
        var data = self.dataSource
        for (_, user) in status.enumerated() {
            for (index, item) in self.dataSource.enumerated() {
                if item.imConversation?.userID == user.userID {
                    data[index].status = user.statusType.rawValue
                }
            }
        }
        self.dataSource = data
    }
    @objc func notiUserChange(_ notification: Notification) {
        guard let userStatusList = notification.userInfo?["userStatusList"] as? [V2TIMUserStatus] else { return }
        self.set_UserStaus(userStatusList)
    }
    @objc func notiNewMsg(_ notification: Notification) {
        guard let msgModel = notification.userInfo?["msg"] as? IMMessageModel else { return }
        if  msgModel.roomId == nil {
            getConversationList()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        lmPrint("NSObject deinit：----------------\(Self.className)已被销毁")
    }
}
