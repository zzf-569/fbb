import UIKit
protocol LMRMPersonSeatPKItemViewDelegate: NSObjectProtocol {
    func dg_roomPKendAction()
    func dg_redRoomAction(mute: Bool)
}
class LMRMPersonSeatPKItemView:LMRMSeatItemView {
    var seatitem:RoomSeatItem?
    weak var delegate:LMRMPersonSeatPKItemViewDelegate?
    private lazy var tipslb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFF"))
        return lb
    }()
    private lazy var userNamelb: UILabel = {
        let lb = UILabel(lmfont: set_.nameFont, textColor: lmColorHex("#FFFFFF"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var valueView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var valueimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_seat_value"))
        return imv
    }()
    private lazy var valuelb: UILabel = {
        let lb = UILabel(lmfont: set_.valueFont, textColor: lmColorHex("#FFFFFF", alpha: 0.6))
            .lmtext("0")
        return lb
    }()
    private lazy var microphoneimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_seat_micrphone_close"))
        return imv
    }()
    lazy var escapebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_crossPk_quit"), target: self, action: #selector(escapeClick))
        return btn
    }()
    lazy var redRoom: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_pk_mic_open"), target: self, action: #selector(redRoomClick))
        return btn
    }()
    init(_ set_:LMRMSeatItemView.seatItems, seatInsex: Int, frame: CGRect = CGRect.zero) {
        super.init(set_, frame: frame)
        self.seatIndex = seatInsex
        configUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configUI() {
        self.addSubview(self.userNamelb)
        self.addSubview(self.valueView)
        self.addSubview(self.tipslb)
        self.addSubview(self.microphoneimv)
        self.valueView.isHidden = true
        if seatIndex == 0 {
            tipslb.textAlignment(.right)
            tipslb.lmtext("我方")
            self.addSubview(self.escapebtn)
            self.escapebtn.isHidden = false
            self.userusheaderView.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(-12)
                make.centerY.equalToSuperview()
                make.size.equalTo(set_.userHaederSize)
            }
            self.volumeView.snp.remakeConstraints { make in
                make.center.equalTo(self.userusheaderView)
                make.size.equalTo(set_.volumeSize)
            }
            self.tipslb.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(-set_.volumeSize.width)
                make.top.equalToSuperview().offset(14)
                make.height.equalTo(20)
            }
            self.userNamelb.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(-set_.volumeSize.width)
                make.top.equalToSuperview().offset(36)
                make.left.equalToSuperview()
                make.height.equalTo(20)
            }
            self.valueView.snp.remakeConstraints { make in
                make.right.equalTo(self.userNamelb.snp.right)
                make.top.equalTo(self.userNamelb.snp.bottom).offset(set_.nameAndValueInterval)
                make.height.equalTo(set_.valueHeight)
            }
            self.microphoneimv.snp.remakeConstraints { make in
                make.right.bottom.equalTo(self.userusheaderView)
                make.width.height.equalTo(16.0)
            }
            self.escapebtn.snp.makeConstraints { make in
                make.right.equalTo(tipslb.snp.left).offset(-4)
                make.centerY.equalTo(tipslb.snp.centerY)
                make.size.equalTo(CGSize(width: 38, height: 14))
            }
        } else {
            self.escapebtn.isHidden = true
            tipslb.textAlignment(.left)
            tipslb.lmtext("对方")
            self.addSubview(self.redRoom)
            self.userusheaderView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(12)
                make.centerY.equalToSuperview()
                make.size.equalTo(set_.userHaederSize)
            }
            self.volumeView.snp.remakeConstraints { make in
                make.center.equalTo(self.userusheaderView)
                make.size.equalTo(set_.volumeSize)
            }
            self.tipslb.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(set_.volumeSize.width)
                make.top.equalToSuperview().offset(14)
                make.height.equalTo(20)
            }
            self.userNamelb.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(set_.volumeSize.width)
                make.top.equalToSuperview().offset(36)
                make.right.equalToSuperview()
                make.height.equalTo(20)
            }
            self.valueView.snp.remakeConstraints { make in
                make.left.equalTo(self.userNamelb.snp.left)
                make.top.equalTo(self.userNamelb.snp.bottom).offset(set_.nameAndValueInterval)
                make.height.equalTo(set_.valueHeight)
            }
            self.microphoneimv.snp.makeConstraints { make in
                make.right.bottom.equalTo(self.userusheaderView)
                make.width.height.equalTo(16.0)
            }
            redRoom.snp.makeConstraints { make in
                make.left.equalTo(tipslb.snp.right).offset(4)
                make.centerY.equalTo(tipslb.snp.centerY)
                make.size.equalTo(CGSize(width: 38, height: 14))
            }
        }
    }
    override func setDataSoure(_ item:RoomSeatItem) {
        super.setDataSoure(item)
        if let user = item.userInfo {
            self.userNamelb.text = user.nickname
            self.microphoneimv.isHidden(!item.mute)
        } else {
            self.userNamelb.text = item.seatText
            self.microphoneimv.isHidden(true)
        }
        if item.seatIndex == -1 {
            let seatitem = item
            redRoom.image(UIImage(named: seatitem.mute == true ? "rm_pk_mic_open" : "rm_pk_mic_close"))
            self.seatitem = seatitem
        } else {
        }
        redRoom.isHidden = VoiceShared.roomViewController?.viewModel.isHostSeat(UserShared.user?.userId) == false
        escapebtn.isHidden = VoiceShared.roomViewController?.viewModel.isHostSeat(UserShared.user?.userId) == false
        escapebtn.image(UIImage(named: "rm_crossPk_escape"))
    }
    @objc func escapeClick() {
        self.delegate?.dg_roomPKendAction()
    }
    @objc func redRoomClick() {
        guard let seatitem = self.seatitem else {
            return
        }
        self.delegate?.dg_redRoomAction(mute: !seatitem.mute)
    }
    @objc func rankbtnAction() {
    }
}
