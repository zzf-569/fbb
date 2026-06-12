import UIKit
import TUIChat
extension CustomChatController {
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
class CustomChatController: LMBaseVC {
    private let imUserId: String
    private let userId: String
    private let isRoom: Bool
    private let converID: String
    private lazy var customNavigationView: UIView = {
        let view = UIView().backgroundColor(.clear)
        return view
    }()
    private lazy var backbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "cm_back"), target: self, action: #selector(backbtnAction))
        return btn
    }()
    private lazy var nicknamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(18), textColor: lmColorHex("#2B313D"))
        return lb
    }()
    init(_ userId: String, isRoom: Bool) {
        self.isRoom = isRoom
        self.converID = kConversationId(imUserId: userId)
        self.imUserId = userId
        self.userId = kImUserId(converID: userId)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage = nil
        view.backgroundColor = .white
        setViewSnp()
        refreshSubviews()
        IMService.shared.cleanUnreadCount(self.converID) { _, _ in
            IMService.shared.upIMUnCount()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
private extension CustomChatController {
    func setViewSnp() {
        view.addSubview(customNavigationView)
        customNavigationView.addSubview(backbtn)
        customNavigationView.addSubview(nicknamelb)
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
            make.top.equalToSuperview().offset(kNavigationHeight + 12)
        }
    }
    func refreshSubviews() {
        self.nicknamelb.text = "人工客服"
    }
    @objc func backbtnAction() {
        if isRoom {
            self.hide()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension CustomChatController: TUIBaseChatViewControllerDelegate {
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
        return nil
    }
    func messageController(_ controller: TUIBaseMessageController, onShowMessageData data: TUIMessageCellData, at indexPath: IndexPath) -> TUIMessageCell? {
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
