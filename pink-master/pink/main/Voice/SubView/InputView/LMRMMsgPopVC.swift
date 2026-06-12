import UIKit
extension LMRMMsgPopVC {
    @discardableResult
    static func show(roomId: String, aitusInfoModel: UsInfoItem? = nil) ->LMRMMsgPopVC {
        let pop = LMRMMsgPopVC(roomId:roomId, aitusInfoModel: aitusInfoModel)
        UIViewController.current?.addChild(pop)
        UIViewController.current?.view.addSubview(pop.view)
        pop.view.frame = UIScreen.main.bounds
        return pop
    }
}
class LMRMMsgPopVC: UIViewController, UITextFieldDelegate {
    private lazy var bgView: UIView = {
        let view = UIView()
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            if self.isEmoji {
                self.hide()
            } else {
                self.textField.resignFirstResponder()
            }
        }
        return view
    }()
    private lazy var bdView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var bodyimv: UIImageView = {
        let imv = UIImageView()
        let effec = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effec)
        imv.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return imv
    }()
    private lazy var aitNamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(16), textColor: .white)
            .textAlignment(.center)
        return lb
    }()
    private lazy var inputBgView: UIView = {
        let view = UIView()
            .backgroundColor(lmColorHex("#0000001F"))
            .cornerRadius(16)
        return view
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField(lmfont: lmFontF(16), textColor: .white, placeholder: "发个友善的弹幕见证当下", placeholderColor: lmColorHex("#FFFFFF14"))
        textField.returnKeyType = .send
        textField.delegate = self
        return textField
    }()
    private lazy var emojibtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_input_emoji"), target: self, action: #selector(emojibtnAction))
        return btn
    }()
    private lazy var sendbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_input_send"), target: self, action: #selector(sendMessageActon))
        return btn
    }()
    private lazy var emojiView:RoomEmojiView = {
        let emojiView = RoomEmojiView(delegate: self)
        return emojiView
    }()
    private let roomId: String
    private let aitusInfoModel: UsInfoItem?
    private var isEmoji: Bool = false
    private init(roomId: String, aitusInfoModel: UsInfoItem?) {
        self.roomId = roomId
        self.aitusInfoModel = aitusInfoModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setViewSnp()
        lmrequestData()
        addKeyboardNotification()
        self.textField.becomeFirstResponder()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEmoji = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessageActon()
        return true
    }
}
private extension LMRMMsgPopVC {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(bodyimv)
        bdView.addSubview(inputBgView)
        bdView.addSubview(emojibtn)
        bdView.addSubview(sendbtn)
        bdView.addSubview(emojiView)
        inputBgView.addSubview(textField)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom).offset(0)
            make.height.equalTo(400.0)
        }
        bodyimv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if let UsInfoItem = aitusInfoModel {
            bdView.addSubview(aitNamelb)
            aitNamelb.text = "@ " + UsInfoItem.nickname
            aitNamelb.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16.0)
                make.right.equalToSuperview().offset(-16.0)
                make.top.equalToSuperview().offset(16.0)
            }
            inputBgView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16.0)
                make.right.equalToSuperview().offset(-64.0)
                make.top.equalTo(aitNamelb.snp.bottom).offset(16.0)
                make.height.equalTo(48.0)
            }
        } else {
            inputBgView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16.0)
                make.right.equalToSuperview().offset(-64.0)
                make.top.equalToSuperview().offset(16.0)
                make.height.equalTo(48.0)
            }
        }
        emojibtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.0)
            make.centerY.equalTo(inputBgView)
            make.width.height.equalTo(28.0)
        }
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(60.0)
            make.right.equalToSuperview().offset(-18.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(40.0)
        }
        emojiView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(inputBgView.snp.bottom).offset(16.0)
            make.bottom.equalToSuperview()
        }
        sendbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20.0)
            make.centerY.equalTo(inputBgView)
            make.width.height.equalTo(28.0)
        }
        view.layoutIfNeeded()
        bdView.set_Border(radius: 16.0, conrners: [.topLeft, .topRight])
    }
    func lmrequestData() {
        UserNetWork.emojiList().lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            guard let list = [LMEmojICateModel].deserialize(from: responseModel.data as? [Any]) else {
                return
            }
            self.emojiView.setDataSoure(list)
        } failureBlock: { _ in
        }
    }
    @objc func emojibtnAction() {
        isEmoji = true
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.2) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-(self.inputBgView.bottom + 16.0 + self.emojiView.height))
            }
            self.bdView.superview?.layoutIfNeeded()
        }
    }
    @objc func sendMessageActon() {
        guard let text = textField.text else { HUD.showFailure("请输入内容"); return }
        if IMService.shared.getLoginStatus() == false {
            guard let user = UserShared.user else { return }
            IMService.shared.login(user.userId) {[weak self] _, _ in
                guard let self = self else { return }
                var userIds: [String] = []
                if let atuser = self.aitusInfoModel {
                    userIds.append(atuser.userId)
                }
                HUD.showLoading()
                MessageNetWork.send(roomId:roomId, content: text, type: .text, emojiId: nil, atUserIdList: userIds).lmrequest { _ in
                    HUD.hide()
                    self.textField.resignFirstResponder()
                } failureBlock: { error in
                    HUD.showFailure(error.message)
                }
            }
            return
        }
        var userIds: [String] = []
        if let user = aitusInfoModel {
            userIds.append(user.userId)
        }
        HUD.showLoading()
        MessageNetWork.send(roomId:roomId, content: text, type: .text, emojiId: nil, atUserIdList: userIds).lmrequest { _ in
            HUD.hide()
            self.textField.resignFirstResponder()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
private extension LMRMMsgPopVC {
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(nt_keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nt_keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func nt_keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
            UIView.animate(withDuration: duration) {
                self.bdView.snp.updateConstraints { make in
                    make.top.equalTo(self.view.snp.bottom).offset(-(self.inputBgView.bottom + 16.0 + keyboardSize.height))
                }
                self.bdView.superview?.layoutIfNeeded()
            }
        }
    }
    @objc func nt_keyboardWillHide(notification: Notification) {
        guard !isEmoji else { return }
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
        UIView.animate(withDuration: duration) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}
extension LMRMMsgPopVC:RoomEmojiViewDelegate {
    func dg_sendFace(_ model: LMEmojiListModel) {
        if IMService.shared.getLoginStatus() == false {
            guard let user = UserShared.user else { return }
            IMService.shared.login(user.userId) {[weak self] _, _ in
                guard let self = self else { return }
                MessageNetWork.send(roomId: self.roomId, content: nil, type: .face, emojiId: model.id, atUserIdList: []).lmrequest { [weak self] _ in
                    HUD.hide()
                    guard let self = self else { return }
                    self.hide()
                } failureBlock: { error in
                    HUD.showFailure(error.message)
                }
            }
            return
        }
        HUD.showLoading()
        MessageNetWork.send(roomId:roomId, content: nil, type: .face, emojiId: model.id, atUserIdList: []).lmrequest { [weak self] _ in
            HUD.hide()
            guard let self = self else { return }
            self.hide()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
