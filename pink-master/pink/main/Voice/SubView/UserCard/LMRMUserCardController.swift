import UIKit
typealias UserCardblock = (UsInfoItem,LMRMUserCardController.CardAction,RoomSeatItem?) -> Void
extension LMRMUserCardController {
    enum CardAction {
        case chat
        case aitTA
        case sendGift
        case seatDown
        case lock
        case Room
        case mic
        case admin
        case quite
    }
    @discardableResult
    static func show(roomId: String, userId: String, isHost: Bool, seat:RoomSeatItem?, cardblock: @escaping UserCardblock) ->LMRMUserCardController {
        let pop = LMRMUserCardController(roomId:roomId, userId: userId, isHost: isHost, seat: seat, cardblock: cardblock)
        UIViewController.current?.addChild(pop)
        UIViewController.current?.view.addSubview(pop.view)
        pop.view.frame = UIScreen.main.bounds
        return pop
    }
}
class LMRMUserCardController: UIViewController {
    private lazy var bgView: UIView = {
        let view = UIView()
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var bdView: UIView = {
        let view = UIView()
            .isHidden(true)
        return view
    }()
    private lazy var bodyimv: UIImageView = {
        let imv = UIImageView()
            .backgroundColor(lmColorHex("#37355B8F"))
        let effec = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effec)
        imv.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return imv
    }()
    private lazy var userusheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
            .cornerRadius(72/2)
        imv.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            RouteService.pushUserMainPage(usInfoItem.userId, vc: self)
        }
        return imv
    }()
    private lazy var userNamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontS(20), textColor: .white)
            .textAlignment(.left)
        return lb
    }()
    private lazy var introducelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .white)
            .textAlignment(.center)
            .isHidden(true)
        return lb
    }()
    private lazy var userTagView: UserTagView = {
        let view = UserTagView()
        return view
    }()
    private lazy var userlbTagView: UserTaglb = {
        let view = UserTaglb()
        return view
    }()
    private lazy var btnView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var followbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: .white, target: self, action: #selector(followbtnAction))
            .lmtitle("关注")
            .lmtitle("已关注", .disabled)
            .titleColor(lmColorHex("#FFFFFF", alpha: 0.24), .disabled)
        return btn
    }()
    private lazy var chatbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: .white, target: self, action: #selector(chatbtnAction))
            .lmtitle("私信")
            .titleColor(lmColorHex("#FFFFFF", alpha: 0.24), .disabled)
        return btn
    }()
    private lazy var aitbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: .white, target: self, action: #selector(aitbtnAction))
            .lmtitle("@TA")
            .titleColor(lmColorHex("#FFFFFF", alpha: 0.24), .disabled)
        return btn
    }()
    private lazy var giftbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: .white, target: self, action: #selector(giftbtnAction))
            .lmtitle("送礼")
            .titleColor(lmColorHex("#FFFFFF", alpha: 0.24), .disabled)
        return btn
    }()
    private lazy var morebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_user_card_home"), target: self, action: #selector(morebtnAction))
            .lmtitle("主页")
            .font(lmFontM(10))
            .backgroundColor(lmColorHex("#FFFFFF14"))
            .cornerRadius(11)
        return btn
    }()
    private lazy var rolebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_user_card_report"), target: self, action: #selector(rolebtnAction))
        return btn
    }()
    private lazy var blackbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_user_card_black"), target: self, action: #selector(blackAction))
        return btn
    }()
    private lazy var roleView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var seatDownbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_user_card_seatD"), target: self, action: #selector(seatDownbtnAction))
        return btn
    }()
    private lazy var lockbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_user_card_lock"), target: self, action: #selector(lockbtnAction))
        return btn
    }()
    private lazy var Roombtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_user_card_room"), target: self, action: #selector(RoombtnAction))
        return btn
    }()
    private lazy var micbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_user_card_mic"), target: self, action: #selector(micbtnAction))
        return btn
    }()
    private lazy var adminbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_user_card_admin"), target: self, action: #selector(adminbtnAction))
        return btn
    }()
    private lazy var quitebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_user_card_quite"), target: self, action: #selector(quitebtnAction))
        return btn
    }()
    private let isHost: Bool
    private let roomId: String
    private var usInfoItem: UsInfoItem
    private let cardblock: UserCardblock
    private let seat:RoomSeatItem?
    private init(roomId: String, userId: String, isHost: Bool, seat:RoomSeatItem?, cardblock: @escaping UserCardblock) {
        self.roomId = roomId
        self.usInfoItem = UsInfoItem(userId: userId)
        self.cardblock = cardblock
        self.isHost = isHost
        self.seat = seat
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setViewSnp()
        getViewData()
        show()
    }
}
private extension LMRMUserCardController {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(bodyimv)
        bdView.addSubview(userusheaderView)
        bdView.addSubview(userNamelb)
        bdView.addSubview(introducelb)
        bdView.addSubview(userTagView)
        bdView.addSubview(btnView)
        bdView.addSubview(morebtn)
        bdView.addSubview(rolebtn)
        bdView.addSubview(blackbtn)
        bdView.addSubview(userlbTagView)
        btnView.addSubview(followbtn)
        btnView.addSubview(chatbtn)
        btnView.addSubview(aitbtn)
        btnView.addSubview(giftbtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(326), height: isHost ? kScaleWidth(264) : kScaleWidth(196)))
        }
        bodyimv.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.bottom.right.equalToSuperview()
        }
        userusheaderView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(54)
            make.width.height.equalTo(72.0)
        }
        userNamelb.snp.makeConstraints { make in
            make.left.equalTo(userusheaderView.snp.right).offset(12.0)
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalTo(userusheaderView.snp.top).offset(4.0)
            make.height.equalTo(23.0)
        }
        introducelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalTo(userNamelb.snp.bottom).offset(2.0)
            make.height.equalTo(20.0)
        }
        userlbTagView.snp.makeConstraints { make in
            make.left.equalTo(userusheaderView.snp.right).offset(12.0)
            make.centerY.equalTo(userusheaderView.snp.centerY)
            make.size.equalTo(CGSize(width: kScreenWidth, height: 16))
        }
        userTagView.snp.makeConstraints { make in
            make.left.equalTo(userusheaderView.snp.right).offset(12.0)
            make.bottom.equalTo(userusheaderView.snp.bottom).offset(-4)
            make.size.equalTo(CGSize(width: kScreenWidth - 24.0 * 2, height: 20.0))
        }
        btnView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.top.equalTo(userusheaderView.snp.bottom).offset(16.0)
            make.height.equalTo(53.0)
        }
        followbtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(48.0)
        }
        chatbtn.snp.makeConstraints { make in
            make.left.equalTo(followbtn.snp.right).offset(12.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(48.0)
            make.width.equalTo(followbtn)
        }
        aitbtn.snp.makeConstraints { make in
            make.left.equalTo(chatbtn.snp.right).offset(12.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(48.0)
            make.width.equalTo(chatbtn)
        }
        giftbtn.snp.makeConstraints { make in
            make.left.equalTo(aitbtn.snp.right).offset(12.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(48.0)
            make.width.equalTo(aitbtn)
            make.right.equalToSuperview()
        }
        let centerLine = UIView().backgroundColor(lmColorHex("#FFFFFF29"))
        btnView.addSubview(centerLine)
        centerLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        if isHost == true {
            bdView.addSubview(roleView)
            roleView.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(67)
            }
            let bottomLine = UIView().backgroundColor(lmColorHex("#FFFFFF29"))
            roleView.addSubview(bottomLine)
            bottomLine.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(16)
                make.top.equalToSuperview()
                make.height.equalTo(0.5)
            }
            roleView.addSubview(Roombtn)
            roleView.addSubview(micbtn)
            roleView.addSubview(adminbtn)
            roleView.addSubview(quitebtn)
            if seat != nil {
                roleView.addSubview(seatDownbtn)
                seatDownbtn.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(16)
                    make.centerY.equalToSuperview()
                    make.width.height.equalTo(36.0)
                }
                Roombtn.snp.makeConstraints { make in
                    make.left.equalTo(seatDownbtn.snp.right).offset(16.0)
                    make.centerY.equalToSuperview()
                    make.width.height.equalTo(36.0)
                }
            } else {
                Roombtn.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(16)
                    make.centerY.equalToSuperview()
                    make.width.height.equalTo(36.0)
                }
            }
            micbtn.snp.makeConstraints { make in
                make.left.equalTo(Roombtn.snp.right).offset(16.0)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(36.0)
            }
            adminbtn.snp.makeConstraints { make in
                make.left.equalTo(micbtn.snp.right).offset(16.0)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(36.0)
            }
            quitebtn.snp.makeConstraints { make in
                make.left.equalTo(adminbtn.snp.right).offset(16.0)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(36.0)
            }
        }
        morebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-6.0)
            make.top.equalTo(bodyimv.snp.top).offset(6.0)
            make.size.equalTo(CGSize(width: 50, height: 22))
        }
        rolebtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6.0)
            make.top.equalTo(bodyimv.snp.top).offset(6.0)
            make.width.height.equalTo(20.0)
        }
        blackbtn.snp.makeConstraints { make in
            make.left.equalTo(rolebtn.snp.right).offset(20.0)
            make.top.equalTo(bodyimv.snp.top).offset(6.0)
            make.width.height.equalTo(20.0)
        }
        view.layoutIfNeeded()
        bodyimv.set_Border(radius: 16.0)
    }
    func getViewData() {
        UserNetWork.Info(userId: usInfoItem.userId).lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            guard let model = UsInfoItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self.usInfoItem = model
            self.refreshSubviews()
        } failureBlock: { error in
            HUD.showFailure(error.message)
            self.hide()
        }
    }
    func refreshSubviews() {
        self.userusheaderView.set_Image(url: usInfoItem.avatar)
        self.userNamelb.text = usInfoItem.nickname
        self.introducelb.text = usInfoItem.signature
        let set_ = LMUserTagV(roomRole: usInfoItem.currentRoom?.role, id: usInfoItem.showUserId, richLeve: usInfoItem.richLevel, medal: usInfoItem.medal, isCopy: false)
        self.userTagView.setDataSoure(set_, maxWidth: kScreenWidth - 24.0 * 2)
        let lbset_ = LMUserTagLB(sex: usInfoItem.gender, age: usInfoItem.age, city: usInfoItem.city, constellation: usInfoItem.constellation)
        self.userlbTagView.setDataSoure(lbset_, maxWidth: kScreenWidth - 24.0 * 2)
        if let user = UserShared.user, usInfoItem.userId == user.userId {
            followbtn.isEnabled = false
            chatbtn.isEnabled = false
            aitbtn.isEnabled = true
            giftbtn.isEnabled = false
            morebtn.isHidden = true
            rolebtn.isHidden = true
            blackbtn.isHidden = true
        } else {
            followbtn.isEnabled = !usInfoItem.liked
            chatbtn.isEnabled = true
            aitbtn.isEnabled = true
            if (VoiceShared.roomViewController?.viewModel.isUserOnSeat(usInfoItem.userId)) != nil {
                giftbtn.isEnabled = true
            } else {
                giftbtn.isEnabled = false
            }
            morebtn.isHidden = false
            blackbtn.isHidden = usInfoItem.block
        }
    }
    @objc func followbtnAction() {
        HUD.showLoading()
        UserNetWork.like(toUserId: usInfoItem.userId, liked: !usInfoItem.liked).lmrequest { [weak self] _ in
            HUD.hide()
            guard let self = self else { return }
            self.usInfoItem.liked = !self.usInfoItem.liked
            self.followbtn.isEnabled = !usInfoItem.liked
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func chatbtnAction() {
        self.cardblock(usInfoItem, .chat, seat)
        self.hide()
    }
    @objc func aitbtnAction() {
        self.cardblock(usInfoItem, .aitTA, seat)
        self.hide()
    }
    @objc func giftbtnAction() {
        self.cardblock(usInfoItem, .sendGift, seat)
        self.hide()
    }
    @objc func seatDownbtnAction() {
        self.cardblock(usInfoItem, .seatDown, seat)
        self.hide()
    }
    @objc func lockbtnAction() {
        self.cardblock(usInfoItem, .lock, seat)
        self.hide()
    }
    @objc func RoombtnAction() {
        self.cardblock(usInfoItem, .Room, seat)
        self.hide()
    }
    @objc func micbtnAction() {
        self.cardblock(usInfoItem, .mic, seat)
        self.hide()
    }
    @objc func adminbtnAction() {
        self.cardblock(usInfoItem, .admin, seat)
        self.hide()
    }
    @objc func quitebtnAction() {
        self.cardblock(usInfoItem, .quite, seat)
        self.hide()
    }
    @objc func blackAction() {
        HUD.showLoading()
        UserNetWork.block(toUserId: self.usInfoItem.userId, block: true).lmrequest { _ in
            HUD.showSuccess("拉黑成功")
            self.blackbtn.isHidden = true
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func morebtnAction() {
        RouteService.pushUserMainPage(usInfoItem.userId, vc: UIViewController.current)
    }
    @objc func rolebtnAction() {
        UIViewController.current?.navigationController?.pushViewController(ReportViewController(reportType: .user, UsInfoItem: self.usInfoItem), animated: true)
    }
    func show() {
        UIView.animate(withDuration: 0.3) {
            self.bdView.isHidden = false
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bdView.isHidden = true
        } completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}
