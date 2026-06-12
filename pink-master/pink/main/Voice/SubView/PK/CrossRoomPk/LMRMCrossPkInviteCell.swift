import UIKit
class LMRMCrossPkInviteCell: LMBaseTableViewCell {
    var dataSoure:RoomItem = RoomItem() {
        didSet {
           roomAvatar.set_Image(url: dataSoure.cover)
           roomNamelb.lmtext(dataSoure.roomName)
           roomIdlb.lmtext("ID: \(dataSoure.showRoomId)")
            hotlb.lmtext(dataSoure.hotValue.toString().StringToHotVaule())
        }
    }
    lazy var roomAvatar: UIImageView = {
        let imageV = UIImageView()
            .cornerRadius(6)
            .contentMode(.scaleAspectFill)
        return imageV
    }()
    lazy var roomNamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#FFFFFFF5"))
        return lb
    }()
    lazy var roomIdlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .whiteSecondary)
        return lb
    }()
    lazy var hotImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "he_rmHot"))
        return imageV
    }()
    lazy var hotlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .whiteSecondary)
        return lb
    }()
    lazy var invitebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_crossPK_Invitebtn"), target: self, action: #selector(invitebtnAction))
        return btn
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        contentView.addSubview(roomAvatar)
        contentView.addSubview(roomNamelb)
        contentView.addSubview(roomIdlb)
        contentView.addSubview(hotImage)
        contentView.addSubview(hotlb)
        contentView.addSubview(invitebtn)
       roomAvatar.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(8))
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(56)))
        }
       roomNamelb.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kScaleWidth(13))
            make.left.equalTo(roomAvatar.snp.right).offset(kScaleWidth(12))
            make.height.equalTo(kScaleWidth(24))
        }
       roomIdlb.snp.makeConstraints { make in
            make.left.equalTo(roomNamelb.snp.left)
            make.top.equalTo(roomNamelb.snp.bottom).offset(kScaleWidth(2))
            make.height.equalTo(kScaleWidth(20))
        }
        hotImage.snp.makeConstraints { make in
            make.left.equalTo(roomIdlb.snp.right).offset(kScaleWidth(8))
            make.centerY.equalTo(roomIdlb.snp.centerY)
            make.size.equalTo(CGSize(width: kScaleWidth(12), height: kScaleWidth(12)))
        }
        hotlb.snp.makeConstraints { make in
            make.left.equalTo(hotImage.snp.right).offset(kScaleWidth(1))
            make.centerY.equalTo(roomIdlb.snp.centerY)
            make.height.equalTo(kScaleWidth(20))
        }
        invitebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.centerY.equalTo(roomAvatar.snp.centerY)
            make.size.equalTo(CGSize(width: kScaleWidth(52), height: kScaleWidth(32)))
        }
    }
    @objc func invitebtnAction() {
        Mediator.shared.dispatch(event: LMRMViewMethon.invitebtnClick, data: dataSoure)
    }
}
