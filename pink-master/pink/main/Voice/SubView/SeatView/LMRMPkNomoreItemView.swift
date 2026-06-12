import UIKit
class LMRMPkNomoreItemView:LMRMSeatItemView {
    lazy var userNamelb: UILabel = {
        let lb = UILabel(lmfont: set_.nameFont, textColor: lmColorHex("#FFFFFF"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var microphoneimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_seat_micrphone_close"))
        return imv
    }()
    override func setViewSnp() {
        super.setViewSnp()
        self.addSubview(self.userNamelb)
        self.addSubview(self.microphoneimv)
        self.userNamelb.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.userusheaderView.snp.bottom).offset(set_.avatarAndNameInterval)
            make.height.equalTo(set_.nameHeight)
        }
        self.microphoneimv.snp.makeConstraints { make in
            make.right.bottom.equalTo(self.userusheaderView)
            make.width.height.equalTo(16.0)
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
    }
}
