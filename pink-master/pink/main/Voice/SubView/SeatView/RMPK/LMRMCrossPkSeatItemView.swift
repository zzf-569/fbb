import UIKit
extension LMRMCrossPkSeatItemView {
    func confCrossRoomInfo(_ viewModel:VoiceVM) {
        guard let invitePkInfo = viewModel.roomItem.roomPkInfo, let RoomCountMap = invitePkInfo.roomCountMap else {
            return
        }
        if let keys = invitePkInfo.roomCountMap?.map({ $0.key }) {
            for string in keys {
                guard let model = RoomCountMap[string] else {
                    return
                }
                if string == viewModel.roomItem.roomId {
                } else {
                    otherPeopleNumlb.lmtext("对方参团人数:\(model)人")
                }
            }
        }
    }
}
class LMRMCrossPkSeatItemView:LMRMSeatItemView {
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
    private lazy var otherPeopleNumlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(8), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        return lb
    }()
    private lazy var otherRoomlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(8), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        return lb
    }()
    init(_ set_:LMRMSeatItemView.seatItems, seatInsex: Int, frame: CGRect = CGRect.zero) {
        super.init(set_, frame: frame)
        self.seatIndex = seatInsex
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setViewSnp() {
        super.setViewSnp()
        self.addSubview(self.userNamelb)
        self.addSubview(self.valueView)
        self.valueView.addSubview(self.valueimv)
        self.valueView.addSubview(self.valuelb)
        self.addSubview(self.microphoneimv)
        if seatIndex == 0 {
            self.userNamelb.textAlignment(.right)
            self.valueimv.image(UIImage(named: "rm_seat_campblue"))
            self.userusheaderView.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(-12)
                make.centerY.equalToSuperview()
                make.size.equalTo(set_.userHaederSize)
            }
            self.volumeView.snp.remakeConstraints { make in
                make.center.equalTo(self.userusheaderView)
                make.size.equalTo(set_.volumeSize)
            }
            self.userNamelb.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(-set_.volumeSize.width)
                make.top.equalToSuperview().offset(15)
                make.left.equalToSuperview().offset(30)
                make.height.equalTo(set_.nameHeight)
            }
            self.valueView.snp.remakeConstraints { make in
                make.right.equalTo(self.userNamelb.snp.right)
                make.top.equalTo(self.userNamelb.snp.bottom).offset(set_.nameAndValueInterval)
                make.height.equalTo(set_.valueHeight)
            }
            self.valuelb.snp.remakeConstraints { make in
                make.right.equalTo(self.valueView).offset(0)
                make.centerY.equalTo(self.valueView)
            }
            self.valueimv.snp.remakeConstraints { make in
                make.right.equalTo(self.valuelb.snp.left).offset(0)
                make.left.equalTo(self.valueView.snp.left).offset(0)
                make.centerY.equalTo(self.valueView)
                make.width.height.equalTo(10.0)
            }
            self.microphoneimv.snp.remakeConstraints { make in
                make.right.bottom.equalTo(self.userusheaderView)
                make.width.height.equalTo(16.0)
            }
        } else {
            self.valueView.isHidden = true
            self.addSubview(self.otherRoomlb)
            self.addSubview(self.otherPeopleNumlb)
            self.userNamelb.textAlignment(.left)
            self.valueimv.image(UIImage(named: "rm_seat_campred"))
            self.userusheaderView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(12)
                make.centerY.equalToSuperview()
                make.size.equalTo(set_.userHaederSize)
            }
            self.volumeView.snp.remakeConstraints { make in
                make.center.equalTo(self.userusheaderView)
                make.size.equalTo(set_.volumeSize)
            }
            self.userNamelb.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(set_.volumeSize.width)
                make.top.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-30)
                make.height.equalTo(set_.nameHeight)
            }
            self.otherPeopleNumlb.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(self.userNamelb.snp.left)
                make.height.equalTo(13)
            }
            self.otherRoomlb.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().offset(-17)
                make.left.equalTo(self.userNamelb.snp.left)
                make.height.equalTo(13)
            }
            self.microphoneimv.snp.remakeConstraints { make in
                make.right.bottom.equalTo(self.userusheaderView)
                make.width.height.equalTo(16.0)
            }
        }
    }
    override func setDataSoure(_ item:RoomSeatItem) {
        super.setDataSoure(item)
        if let user = item.userInfo {
            self.userNamelb.text = user.nickname
            self.microphoneimv.isHidden(!item.mute)
            valuelb.text = user.charmValue.toString()
        } else {
            self.userNamelb.text = item.seatText
            self.microphoneimv.isHidden(true)
            valuelb.text = item.seatValue.toString()
        }
        if item.seatIndex == -1 {
            self.otherRoomlb.text = item.mute == false ? "已打开对方声音" : "已关闭对方声音"
            self.microphoneimv.isHidden(item.mute == false)
        }
    }
}
