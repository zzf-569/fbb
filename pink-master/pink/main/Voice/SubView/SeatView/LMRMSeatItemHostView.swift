import UIKit
class LMRMSeatItemHostView:LMRMSeatItemView {
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
        return lb
    }()
    private lazy var microphoneimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_seat_micrphone_close"))
        return imv
    }()
    override func setViewSnp() {
        super.setViewSnp()
        self.addSubview(self.userNamelb)
        self.addSubview(self.valueView)
        self.valueView.addSubview(self.valueimv)
        self.valueView.addSubview(self.valuelb)
        self.addSubview(self.microphoneimv)
        self.userusheaderView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
            make.size.equalTo(set_.userHaederSize)
        }
        self.volumeView.snp.remakeConstraints { make in
            make.center.equalTo(self.userusheaderView)
            make.size.equalTo(set_.volumeSize)
        }
        self.userNamelb.snp.remakeConstraints { make in
            make.left.equalTo(self.userusheaderView.snp.right).offset(set_.avatarAndNameInterval)
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(set_.nameHeight)
        }
        self.valueView.snp.remakeConstraints { make in
            make.left.equalTo(self.userNamelb.snp.left)
            make.top.equalTo(self.userNamelb.snp.bottom).offset(set_.nameAndValueInterval)
            make.height.equalTo(set_.valueHeight)
        }
        self.valueimv.snp.remakeConstraints { make in
            make.left.equalTo(self.valueView.snp.left).offset(0)
            make.centerY.equalTo(self.valueView)
            make.width.height.equalTo(10.0)
        }
        self.valuelb.snp.remakeConstraints { make in
            make.left.equalTo(self.valueimv.snp.right).offset(2)
            make.centerY.equalTo(self.valueView)
        }
        self.microphoneimv.snp.remakeConstraints { make in
            make.right.bottom.equalTo(self.userusheaderView)
            make.width.height.equalTo(16.0)
        }
    }
    override func setDataSoure(_ item:RoomSeatItem) {
        super.setDataSoure(item)
        if let user = item.userInfo {
            self.userNamelb.text = user.nickname
            self.microphoneimv.isHidden(!item.mute)
            self.valuelb.text = user.charmValue.toString()
            if item.seatIndex != 0 {
                self.valueView.isHidden = true
            }
        } else {
            self.userNamelb.text = item.seatText
            self.valuelb.text = "0"
            self.microphoneimv.isHidden(true)
            if item.seatIndex == 1 {
                self.isHidden(true)
            }
        }
    }
}
