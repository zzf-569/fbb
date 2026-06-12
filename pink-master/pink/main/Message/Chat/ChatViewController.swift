import UIKit
import TUIChat
import SDCycleScrollView
extension ChatViewController {
    func show(_ vc: UIViewController) {
        vc.addChild(self)
        vc.view.addSubview(self.view)
        self.view.frame = CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: vc.view.height)
        UIView.animate(withDuration: 0.3) {
            self.view.x = 0
        } completion: { _ in
        }
    }
    func hide() {
        self.callbackblock()
        UIView.animate(withDuration: 0.3) {
            self.view.x = kScreenWidth
        } completion: { _ in
            self.clear()
        }
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
class ChatViewController: LMBaseVC {
    var userInfo : UsInfoItem = UsInfoItem()
    private let isRoom: Bool
    private let converID: String
    private let imUserId: String
    private let userId: String
    private let commandCode: String?
    private let callbackblock: () -> Void
    var orderList: [OrderItem] = [] {
        didSet {
            bannerView.isHidden = orderList.count == 0
            var images: [String] = []
            for _ in orderList {
                images.append("")
            }
            pageController.currentPage = 0
            pageController.numberOfPages = images.count
            self.cycOrderView.imageURLStringsGroup = images
            if orderList.count == 0 {
                chatView.view.snp.remakeConstraints { make in
                    make.left.right.bottom.equalToSuperview()
                    make.top.equalTo(customNavigationView.snp.bottom).offset(16.0)
                }
            } else {
                chatView.view.snp.remakeConstraints { make in
                    make.left.right.bottom.equalToSuperview()
                    make.top.equalTo(customNavigationView.snp.bottom).offset(100.0)
                }
            }
        }
    }
    var chatView = TUIC2CChatViewController()
    private lazy var customNavigationView: UIView = {
        let view = UIView().backgroundColor(.clear)
        return view
    }()
    private lazy var backbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "cm_back"), target: self, action: #selector(backbtnAction))
        return btn
    }()
    private lazy var usheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_avatar)
            .contentMode(.scaleAspectFill)
            .cornerRadius(32/2)
        return imv
    }()
    private lazy var nicknamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(18), textColor: lmColorHex("#2B313D"))
        return lb
    }()
    private lazy var followbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: .white, target: self, action: #selector(followbtnAction))
            .image(UIImage(named: "chat_follow"))
        return btn
    }()
    private lazy var morebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "msg_chat_more"), target: self, action: #selector(navigationRightAction))
        return btn
    }()
    private lazy var userView: ChatUserView = {
        let userView = ChatUserView()
            .backgroundColor(.white)
            .cornerRadius(12)
        return userView
    }()
    lazy var bannerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 100))
        view.isHidden = true
        self.view.addSubview(view)
        view.addSubview(cycOrderView)
        view.addSubview(pageController)
        view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(customNavigationView.snp.bottom).offset(0)
            make.height.equalTo(100)
        }
        pageController.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.height.equalTo(6.0)
            make.width.equalToSuperview()
        }
        return view
    }()
    lazy var cycOrderView: SDCycleScrollView = {
        let view = SDCycleScrollView(frame: CGRect(x: 20, y: 0, width: kScreenWidth - 40, height: 80), delegate: self, placeholderImage: UIImage(named: "rm_seat_dispatch_action"))
            .backgroundColor(.clear)
            .cornerRadius(12.0)
        view.autoScrollTimeInterval = 5
        view.showPageControl = false
        return view
    }()
    private lazy var pageController: LMPageController = {
        let page = LMPageController(normalPointSize: CGSize(width: 6.0, height: 6.0), currentPointSize: CGSize(width: 14.0, height: 6.0), pointSpacing: 2.0, normalPointColor: lmColorHex("#2B313D1F"), currentPointColor: lmColorHex("#FF4F7DFF"))
        return page
    }()
    init(_ userId: String, isRoom: Bool, commandCode: String? = "", complete block: @escaping () -> Void) {
        self.isRoom = isRoom
        self.converID = kConversationId(userId: userId)
        self.imUserId = kImUserId(userId: userId)
        self.userId = userId
        self.callbackblock = block
        self.commandCode = commandCode
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage = nil
        view.backgroundColor = lmColorHex("#F7F8FAFF")
        setViewSnp()
        getViewData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        IMService.shared.cleanUnreadCount(self.converID) { _, _ in
            IMService.shared.upIMUnCount()
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
private extension ChatViewController {
    func setViewSnp() {
        view.addSubview(customNavigationView)
        customNavigationView.addSubview(backbtn)
        customNavigationView.addSubview(nicknamelb)
        customNavigationView.addSubview(followbtn)
        customNavigationView.addSubview(morebtn)
        customNavigationView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(isRoom ? 12 : kStatusBarHeight)
            make.height.equalTo(kNavigationBarHeight)
        }
        backbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32.0)
        }
        nicknamelb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        followbtn.snp.makeConstraints { make in
            make.left.equalTo(nicknamelb.snp.right).offset(4.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(28.0)
            make.height.equalTo(28.0)
        }
        morebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44.0)
        }
        let conversationModel = TUIChatConversationModel()
        conversationModel.userID = imUserId
        conversationModel.conversationID = converID
        let chatVC = TUIC2CChatViewController(conversationData: conversationModel)
        chatVC.delegate = self
        chatVC.view.backgroundColor = .clear
        self.addChild(chatVC)
        self.view.addSubview(chatVC.view)
        chatVC.view.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(customNavigationView.snp.bottom).offset(16.0)
        }
        chatView = chatVC
        usheaderView.addGestureTap { [weak self] _ in
                guard let self = self else { return }
                self.pushUserMainPageAction()
            }
        nicknamelb.addGestureTap { [weak self] _ in
                guard let self = self else { return }
                self.pushUserMainPageAction()
            }
        userView.addGestureTap { [weak self] _ in
                guard let self = self else { return }
                self.pushUserMainPageAction()
            }
    }
    func getViewData() {
        UserNetWork.Info(userId: self.userId, commandCode: commandCode).lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            guard let model = UsInfoItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            userInfo = model
            self.refreshSubviews()
        } failureBlock: { error in
            HUD.showFailure("获取用户信息失败")
            self.navigationController?.popViewController(animated: true)
        }
        OrderApi.orderTargetRecord(targetUserId: self.userId).lmrequest {[weak self] responseModel in
            guard let self = self else { return }
            guard let list = [OrderItem].deserialize(from: responseModel.data as? [Any]) else { return }
            self.orderList = list
        } failureBlock: { _ in
        }
    }
    func refreshSubviews() {
        self.usheaderView.set_Image(url: userInfo.avatar, placeholder: kPlaceholder_avatar)
        self.nicknamelb.text = userInfo.nickname
        self.followbtn.isHidden = userInfo.liked
        userView.setDataSoure(userInfo)
    }
    @objc func backbtnAction() {
        if isRoom {
            self.hide()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func navigationRightAction() {
        let items: [LMSheetTabModel] = [
            LMSheetTabModel(title: "举报"),
            LMSheetTabModel(title: "拉黑")
        ]
        LMSheetTableVC(title: nil, dataSource: items, cancel: "取消") { item in
            guard let item = item else { return }
            if item.title == "举报" {
                self.navigationController?.pushViewController(ReportViewController(reportType: .user, UsInfoItem: self.userInfo), animated: true)
            }
            if item.title == "拉黑" {
                HUD.showLoading()
                UserNetWork.block(toUserId: self.userInfo.userId, block: true).lmrequest { _ in
                    HUD.showSuccess("拉黑成功")
                } failureBlock: { error in
                    HUD.showFailure(error.message)
                }
            }
        }.show()
    }
    @objc func followbtnAction() {
        HUD.showLoading()
        UserNetWork.like(toUserId: userInfo.userId, liked: !self.userInfo.liked).lmrequest { [weak self] _ in
            HUD.hide()
            guard let self = self else { return }
            self.userInfo.liked = !self.userInfo.liked
            self.followbtn.isHidden = userInfo.liked
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func pushUserMainPageAction() {
        RouteService.pushUserMainPage(userInfo.userId, vc: self)
    }
}
extension ChatViewController: TUIBaseChatViewControllerDelegate {
    func didTap(in controller: TUIBaseMessageController) {
    }
    func didHideMenu(in controller: TUIBaseMessageController) {
    }
    func messageController(_ controller: TUIBaseMessageController, willShowMenuInCell view: UIView) -> Bool {
        return true
    }
    func messageController(_ controller: TUIBaseMessageController, onNewMessage message: V2TIMMessage) -> TUIMessageCellData? {
        guard message.elemType == .ELEM_TYPE_TEXT, message.cloudCustomData != nil else {
            return nil
        }
        do {
            let msgDict = try JSONSerialization.jsonObject(with: message.cloudCustomData!) as? [String: Any]
            if let msgDict = msgDict {
                if let type = msgDict["type"] as? Int, let messageType = IMMessageType(rawValue: type) {
                    let contentDict = msgDict["customData"] as! [String: Any]
                    if messageType == .dispatch_order {
                        let cellData = PDMessageCellData(direction: message.isSelf ? .MsgDirectionOutgoing : .MsgDirectionIncoming)
                        cellData.innerMessage = message
                        cellData.msgID = message.msgID!
                        cellData.toModel(contentDict)
                        return cellData
                    }
                }
            }
        } catch _ {
            lmPrint("解析失败")
        }
        return nil
    }
    func messageController(_ controller: TUIBaseMessageController, onShowMessageData data: TUIMessageCellData, at indexPath: IndexPath) -> TUIMessageCell? {
        if data is PDMessageCellData {
            let cell = controller.tableView.dequeueReusableCell(withIdentifier: BussinessID_Dispatch, for: indexPath) as! PDMessageCell
            cell.fill(with: data as! TUIBubbleMessageCellData)
            return cell
        }
        return nil
    }
    func messageController(_ controller: TUIBaseMessageController, willDisplay cell: TUIMessageCell, with cellData: TUIMessageCellData) {
    }
    func messageController(_ controller: TUIBaseMessageController, onSelectMessageAvatar cell: TUIMessageCell) {
    }
    func messageController(_ controller: TUIBaseMessageController, onLongSelectMessageAvatar cell: TUIMessageCell) {
    }
    func messageController(_ controller: TUIBaseMessageController, onSelectMessageContent cell: TUIMessageCell) {
    }
    func messageController(_ controller: TUIBaseMessageController, onSelectMessageMenu menuType: Int, with data: TUIMessageCellData) {
        if menuType == 2 {
            self.navigationController?.pushViewController(ReportViewController(reportType: .user, UsInfoItem: self.userInfo), animated: true)
        }
    }
    func messageController(_ controller: TUIBaseMessageController, onRelyMessage data: TUIMessageCellData) {
    }
    func messageController(_ controller: TUIBaseMessageController, onReferenceMessage data: TUIMessageCellData) {
    }
    func messageController(_ controller: TUIBaseMessageController, onReEditMessage data: TUIMessageCellData) {
    }
    func messageController(_ controller: TUIBaseMessageController, onForwardText text: String) {
    }
}
extension ChatViewController: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
    }
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        self.pageController.currentPage = index
    }
    func customCollectionViewCellClass(for view: SDCycleScrollView!) -> AnyClass! {
        PDCustonChatCycCell.self
    }
    func setupCustomCell(_ cell: UICollectionViewCell!, for index: Int, cycleScrollView view: SDCycleScrollView!) {
        if let Cell = cell as? PDCustonChatCycCell {
            Cell.dataSoure = self.orderList[index]
        }
    }
}
