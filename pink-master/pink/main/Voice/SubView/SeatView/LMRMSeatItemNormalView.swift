import UIKit
class LMRMSeatItemNormalView:LMRMSeatItemView {
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
        self.userNamelb.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.userusheaderView.snp.bottom).offset(set_.avatarAndNameInterval)
            make.height.equalTo(set_.nameHeight)
        }
        self.valueView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.userNamelb.snp.bottom).offset(set_.nameAndValueInterval)
            make.height.equalTo(set_.valueHeight)
        }
        self.valueimv.snp.makeConstraints { make in
            make.left.equalTo(self.valueView).offset(0)
            make.centerY.equalTo(self.valueView)
            make.width.height.equalTo(10.0)
        }
        self.valuelb.snp.makeConstraints { make in
            make.left.equalTo(self.valueimv.snp.right).offset(2.0)
            make.centerY.equalTo(self.valueView)
            make.right.equalTo(self.valueView).offset(0)
        }
        self.microphoneimv.snp.makeConstraints { make in
            make.right.bottom.equalTo(self.userusheaderView)
            make.width.height.equalTo(16.0)
        }
    }
    override func setDataSoure(_ item:RoomSeatItem) {
        super.setDataSoure(item)
        valueimv.image = UIImage(named: "rm_seat_value")
        if let user = item.userInfo {
            userNamelb.text = user.nickname
            valuelb.text = user.charmValue.toString()
            microphoneimv.isHidden(!item.mute)
        } else {
            userNamelb.text = item.seatText
            valuelb.text = "0"
            microphoneimv.isHidden(true)
        }
        if item.pkCamp != .normal {
            valuelb.text = item.seatValue.toString()
            if item.pkCamp == .blue {
                valueimv.image = UIImage(named: "rm_seat_campblue")
            } else if item.pkCamp == .red {
                valueimv.image = UIImage(named: "rm_seat_campred")
            }
        }
    }
}
