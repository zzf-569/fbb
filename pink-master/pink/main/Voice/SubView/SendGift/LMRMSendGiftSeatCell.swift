import UIKit
extension LMRMSendGiftSeatCell {
    func setDataSoure(_ model:RoomSeatItem) {
        if let user = model.userInfo {
            self.contentimv.set_Image(url: user.avatar)
            if model.isSelected {
                self.contentimv.set_Border(radius: 32/2, borderWidth: 1.0, borderColor: lmColorHex("#FF4F7DFF"))
                self.numlb.backgroundColor = lmColorHex("#FF4F7DFF")
            } else {
                self.contentimv.set_Border(radius: 32/2)
                self.numlb.backgroundColor = lmColorHex("#454558")
            }
        } else {
            self.contentimv.image = UIImage(named: "rm_gift_seat")
            self.contentimv.set_Border(radius: 32/2)
            self.numlb.backgroundColor = lmColorHex("#454558")
        }
        if model.seatIndex == 0 {
            self.numlb.text = "主"
        } else {
            self.numlb.text = model.seatIndex.toString()
        }
    }
}
class LMRMSendGiftSeatCell: BaseCollectionViewCell {
    private lazy var contentimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_gift_seat"))
        return imv
    }()
    private lazy var numlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(8), textColor: .white)
            .textAlignment(.center)
            .cornerRadius(10/2)
            .backgroundColor(lmColorHex("#FF4F7DFF"))
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMSendGiftSeatCell {
    func setViewSnp() {
        contentView.addSubview(contentimv)
        contentView.addSubview(numlb)
        contentimv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(32.0)
        }
        numlb.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.width.height.equalTo(10.0)
        }
    }
}
