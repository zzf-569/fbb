import UIKit
extension LMRMCrossRoomPKSeatPKView {
    func set_upPkSubviews(_ viewModel:VoiceVM, roomPkModel: LMinvitePkViewModel) {
        guard let invitePkInfo = viewModel.roomItem.roomPkInfo, let RoomMap = invitePkInfo.roomMap else {
            return
        }
        dataSoure = invitePkInfo
        if let keys = invitePkInfo.roomMap?.map({ $0.key }) {
            for string in keys {
                guard let model = RoomMap[string] else {
                    return
                }
                if string == viewModel.roomItem.roomId {
                   roomAvatar.set_Image(url: model.cover)
                   roomName.lmtext(model.roomName)
                } else {
                    redroomAvatar.set_Image(url: model.cover)
                    redroomName.lmtext(model.roomName)
                }
            }
        }
        if viewModel.roomItem.seatList.count > 0 {
            let seatitem = viewModel.roomItem.seatList[0]
            redRoom.image(UIImage(named: seatitem.mute == true ? "rm_seat_micrphone_close" : "rm_pk_mic_open"))
            self.seatitem = seatitem
        }
        escapebtn.isHidden = VoiceShared.roomViewController?.viewModel.isHostSeat(UserShared.user?.userId) == false
        if roomPkModel.dataSoure.status == .end {
            escapebtn.image(UIImage(named: "rm_crossPk_quit"))
        } else {
            escapebtn.image(UIImage(named: "rm_crossPk_quit"))
        }
    }
    func set_PKValue(_ roomItem:RoomItem) {
        var redValue = 0
        var buleValue = 0
        let campValueMap = roomItem.roomPkInfo?.campValueMap
        let keys = campValueMap?.map({ $0.key })
        if let keys = keys {
            for string in keys {
                let model = campValueMap?[string]
                if string == VoiceService.shared.roomViewController?.viewModel.roomItem.roomId {
                    buleValue = model?.pkValue ?? 0
                } else {
                    redValue = model?.pkValue ?? 0
                }
            }
        }
        var blueList: [LMtopAvatarModel] = []
        var redList: [LMtopAvatarModel] = []
        if let keys = keys {
            for string in keys {
                if let model = campValueMap?[string] {
                    if string == VoiceService.shared.roomViewController?.viewModel.roomItem.roomId {
                        blueList = model.topAvatarList
                    } else {
                        redList = model.topAvatarList
                    }
                }
            }
        }
        blueRankView.set_CrossData(blueList)
        redRankView.set_CrossData(redList)
        progressView.set_Progress(leftProgress: buleValue, rightProgress: redValue)
    }
}
class LMRMCrossRoomPKSeatPKView: UIView {
    var seatitem:RoomSeatItem?
    lazy var backimage: UIImageView = {
        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 272))
        imageV.addGradientLayer(colors: [lmColorHex("#5660F3FF").cgColor, lmColorHex("#D354CFFF").cgColor], startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5), locations: [0.0, 1.0])
        return imageV
    }()
    lazy var roomAvatar: UIImageView = {
        let imageV = UIImageView().cornerRadius(12, borderColor: lmColorHex("#FF9FF2FF"), borderWidth: 3)
        return imageV
    }()
    lazy var roomName: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#FFFFFFF5"))
            .textAlignment(.right)
        return lb
    }()
    lazy var escapebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_crossPk_quit"), target: self, action: #selector(escapeClick))
            .font(lmFontM(8))
            .tintColor(.white)
            .lmtitle("逃跑")
            .cornerRadius(10)
            .backgroundColor(lmColorHex("#FFFFFF1F"))
        return btn
    }()
    lazy var iconImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "rm_pk_icon"))
        return imageV
    }()
    lazy var redroomAvatar: UIImageView = {
        let imageV = UIImageView().cornerRadius(12, borderColor: lmColorHex("#A1C7FFFF"), borderWidth: 3)
        return imageV
    }()
    lazy var redroomName: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#FFFFFFF5"))
            .textAlignment(.left)
        return lb
    }()
    lazy var redRoom: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_pk_mic_open"), target: self, action: #selector(redRoomClick))
        return btn
    }()
    lazy var progressView:LMRMSeatPkProgressView = {
        let view = LMRMSeatPkProgressView(isRoomPK: true)
        return view
    }()
    lazy var rankbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_crossPk_rank"), target: self, action: #selector(rankbtnAction))
            .isHidden(true)
        return btn
    }()
    private lazy var blueRankView:LMRMSeatPKRankView = {
        let view = LMRMSeatPKRankView(frame: .zero, alignment: .left)
        return view
    }()
    private lazy var redRankView:LMRMSeatPKRankView = {
        let view = LMRMSeatPKRankView(frame: .zero, alignment: .right)
        return view
    }()
    var dataSoure: invitePkInfo = invitePkInfo()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
        setDataSoure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        backgroundColor(.clear)
        addSubview(backimage)
        addSubview(roomAvatar)
        addSubview(roomName)
        addSubview(escapebtn)
        addSubview(redroomAvatar)
        addSubview(redroomName)
        addSubview(redRoom)
        addSubview(iconImage)
        addSubview(progressView)
        addSubview(redRankView)
        addSubview(blueRankView)
        backimage.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(272)
        }
       roomAvatar.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(41)
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 72, height: 72))
        }
        iconImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 80, height: 55))
        }
       roomName.snp.makeConstraints { make in
            make.centerX.equalTo(roomAvatar.snp.centerX)
            make.top.equalToSuperview().offset(96)
            make.height.equalTo(22)
        }
        escapebtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(75)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 42, height: 20))
        }
        redroomAvatar.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-41)
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 72, height: 72))
        }
        redroomName.snp.makeConstraints { make in
            make.centerX.equalTo(redroomAvatar.snp.centerX)
            make.top.equalToSuperview().offset(96)
            make.height.equalTo(22)
        }
        redRoom.snp.makeConstraints { make in
            make.right.bottom.equalTo(redroomAvatar)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        progressView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(134.0)
        }
        blueRankView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(168.0)
            make.width.equalTo(28 * 3)
            make.height.equalTo(28.0)
        }
        redRankView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(168.0)
            make.width.equalTo(28 * 3)
            make.height.equalTo(28.0)
        }
        redRoom.isHidden = VoiceShared.roomViewController?.viewModel.isHostSeat(UserShared.user?.userId) == false
        escapebtn.isHidden = VoiceShared.roomViewController?.viewModel.isHostSeat(UserShared.user?.userId) == false
    }
    func setDataSoure() {
    }
    @objc func escapeClick() {
        Mediator.shared.dispatch(event: LMRMViewMethon.roomPKendAction, data: "")
    }
    @objc func redRoomClick() {
        guard let seatitem = self.seatitem else {
            return
        }
        Mediator.shared.dispatch(event: LMRMViewMethon.redRoomAction, data: !seatitem.mute)
    }
    @objc func rankbtnAction() {
        let view = LMRMPkRankCenterView()
        view.setDataSoure(dataSoure)
        view.show()
    }
}
