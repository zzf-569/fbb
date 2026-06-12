import UIKit
class LMRMTopView: UIView {
    lazy var titleImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "rm_title"))
        return image
    }()
    lazy var title: UILabel = {
        let lb = UILabel(lmfont: lmFontM(18), textColor: .white)
        return lb
    }()
    private lazy var idlb: UIButton = {
        let lb = UIButton(lmfont: lmFontM(10), titleColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .image(UIImage(named: "rm_topid"), .normal)
            .lmtitle("0")
        return lb
    }()
    private lazy var hotlb: UIButton = {
        let lb = UIButton(lmfont: lmFontM(10), titleColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .image(UIImage(named: "rm_tophot"), .normal)
            .lmtitle("0")
        return lb
    }()
    private lazy var morebtn: UIButton = {
        let btn = UIButton(type: .custom)
            .image(UIImage(named: "rm_topmore"), .normal)
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.clickMoreAction, data: "")
        }
        return btn
    }()
    private lazy var rankbtn: UIButton = {
        let btn = UIButton(type: .custom)
            .image(UIImage(named: "rm_toprank"), .normal)
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.topRankAction, data: "")
        }
        return btn
    }()
    private lazy var collectbtn: UIButton = {
        let btn = UIButton(type: .custom)
            .image(UIImage(named: "rm_topcollect"), .normal)
            .image(UIImage(named: "rm_topcollect_s"), .selected)
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.topCollectAction, data: "")
            btn.isSelected = !btn.isSelected
        }
        return btn
    }()
    private lazy var noticebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(10), titleColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .image(UIImage(named: "rm_topnotice"), .normal)
            .lmtitle("玩法")
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.topNoticeAction, data: "")
        }
        return btn
    }()
    private lazy var onlinebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(10), titleColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .image(UIImage(named: "rm_toponline"), .normal)
            .lmtitle("在线")
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.topOnlineUserAction, data: "")
        }
        return btn
    }()
    lazy var hostItem:LMRMSeatItemHostView = {
        let view = LMRMSeatItemHostView(LMRMSeatItemView.seatItems.hostIndexView())
            .backgroundColor(lmColorHex("#00000052"))
        view.set_Border(radius: 24, borderWidth: 0.5, borderColor: lmColorHex("#FFFFFF1F"))
        view.addGestureTap { [weak self] tap in
            guard let self = self else { return }
            if let view = tap.view {
                Mediator.shared.dispatch(event: LMRMViewMethon.seatClickAction, data: ["seatIndex": 0, "seatView": view])
            }
        }
        return view
    }()
    var roomItem:RoomItem?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LMRMTopView {
    func reConfigUI() {
    }
    func setDataSoure(_ room:RoomItem) {
        if room.roomType == .dispatch {
            hostItem.isHidden = true
            titleImage.isHidden = false
            title.isHidden = false
        } else {
            hostItem.isHidden = false
            titleImage.isHidden = true
            title.isHidden = true
        }
        title.text = room.roomName
        self.roomItem = room
        let idText = room.showRoomId
        let idWidth = idText.singleLineWidth(lmfont: lmFontM(10))
        self.idlb.snp.updateConstraints { make in
            make.width.equalTo(idWidth + 16.0)
        }
        self.idlb.lmtitle(idText)
        let hotText = room.hotValue.toString().StringToHotVaule()
        let hotWidth = hotText.singleLineWidth(lmfont: lmFontM(10))
        self.hotlb.snp.updateConstraints { make in
            make.width.equalTo(hotWidth + 16.0)
        }
        self.hotlb.lmtitle(hotText)
        set_CollectStatus(room.like)
    }
    func set_Seats(_ seats: [RoomSeatItem]) {
        if self.roomItem?.roomPkInfo != nil {
            self.hostItem.setDataSoure(seats[1])
        } else {
            self.hostItem.setDataSoure(seats[0])
        }
    }
    func set_CollectStatus(_ status: Bool) {
        self.collectbtn.isSelected(status)
    }
}
private extension LMRMTopView {
    private func setViewSnp() {
        self.addSubview(self.titleImage)
        self.addSubview(self.title)
        self.addSubview(self.hostItem)
        self.addSubview(self.idlb)
        self.addSubview(self.hotlb)
        self.addSubview(self.noticebtn)
        self.addSubview(self.collectbtn)
        self.addSubview(self.rankbtn)
        self.addSubview(self.morebtn)
        self.addSubview(self.onlinebtn)
        titleImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        title.snp.makeConstraints { make in
            make.left.equalTo(titleImage.snp.right).offset(4)
            make.centerY.equalTo(titleImage)
        }
        self.hostItem.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 160, height: 48))
        }
        self.noticebtn.snp.makeConstraints { make in
            make.left.equalTo(self.hostItem)
            make.top.equalTo(hostItem.snp.bottom).offset(4.0)
            make.height.equalTo(kScaleWidth(16))
            make.width.equalTo(kScaleWidth(34))
        }
        self.idlb.snp.makeConstraints { make in
            make.left.equalTo(self.noticebtn.snp.right).offset(16.0)
            make.centerY.equalTo(self.noticebtn)
            make.height.equalTo(16.0)
            make.width.equalTo(28.0)
        }
        self.hotlb.snp.makeConstraints { make in
            make.left.equalTo(self.idlb.snp.right).offset(16.0)
            make.centerY.equalTo(self.noticebtn)
            make.height.equalTo(16.0)
            make.width.equalTo(28.0)
        }
        self.onlinebtn.snp.makeConstraints { make in
            make.left.equalTo(self.hotlb.snp.right).offset(16.0)
            make.centerY.equalTo(self.noticebtn)
            make.height.equalTo(16.0)
            make.width.equalTo(32.0)
        }
        self.morebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12.0)
            make.top.equalToSuperview().offset(2.0)
            make.width.height.equalTo(36.0)
        }
        self.collectbtn.snp.makeConstraints { make in
            make.right.equalTo(morebtn.snp.left).offset(-8.0)
            make.top.equalToSuperview().offset(2.0)
            make.width.height.equalTo(36.0)
        }
        self.rankbtn.snp.makeConstraints { make in
            make.right.equalTo(collectbtn.snp.left).offset(-8.0)
            make.top.equalToSuperview().offset(2.0)
            make.width.height.equalTo(36.0)
        }
    }
}
private extension LMRMTopView {
}
