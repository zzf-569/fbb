import UIKit
class LMRMSeatItemPDView:LMRMSeatItemView {
    private lazy var userNamelb: UILabel = {
        let lb = UILabel(lmfont: set_.nameFont, textColor: lmColorHex("#FFFFFF"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var indexlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(8), textColor: .white)
            .textAlignment(.center)
            .backgroundColor(lmColorHex("#454558"))
            .cornerRadius(14/2)
        return lb
    }()
    private lazy var auditionView: UIView = {
        let view = UIView()
            .backgroundColor(.clear)
            .cornerRadius(14/2)
        view.size = CGSize(width: 32.0, height: 14.0)
        let bgimv = UIImageView()
        bgimv.image = UIImage.gradient(["#FFE640", "#FFE640"], size: view.size)
        view.addSubview(bgimv)
        bgimv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let lb = UILabel(lmfont: lmFontM(8), textColor: lmColorHex("#2B313D"))
            .textAlignment(.center)
            .lmtext("试音中")
        view.addSubview(lb)
        lb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return view
    }()
    private lazy var microphoneimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_seat_micrphone_close"))
        return imv
    }()
    override func setViewSnp() {
        super.setViewSnp()
        self.addSubview(self.userNamelb)
        self.addSubview(self.indexlb)
        self.addSubview(self.auditionView)
        self.addSubview(self.microphoneimv)
        self.userNamelb.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.userusheaderView.snp.bottom).offset(set_.avatarAndNameInterval)
            make.height.equalTo(set_.nameHeight)
        }
        self.indexlb.snp.makeConstraints { make in
            make.centerX.equalTo(self.userusheaderView)
            make.bottom.equalTo(self.userusheaderView.snp.bottom).offset(4.0)
            make.width.height.equalTo(14.0)
        }
        auditionView.snp.makeConstraints { make in
            make.centerX.equalTo(userusheaderView)
            make.bottom.equalTo(userusheaderView.snp.bottom).offset(4.0)
            make.width.equalTo(32.0)
            make.height.equalTo(14.0)
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
        } else {
            self.userNamelb.text = item.seatText
        }
        if item.seatIndex == 0 || item.seatIndex == 8 {
            indexlb.isHidden = true
        } else {
            indexlb.text = item.seatIndex.toString()
            indexlb.isHidden = false
            if item.userInfo != nil {
                indexlb.backgroundColor = .white
                indexlb.textColor = lmColorHex("#2B313D")
            } else {
                indexlb.backgroundColor = lmColorHex("#454558FF")
                indexlb.textColor = .white
            }
        }
        if item.seatIndex == 0 || item.seatIndex == 8 {
            auditionView.isHidden = true
            if item.userInfo != nil {
                self.microphoneimv.isHidden(!item.mute)
            } else {
                self.microphoneimv.isHidden(true)
            }
        } else {
            self.microphoneimv.isHidden(true)
            if item.userInfo != nil {
                if item.mute {
                    auditionView.isHidden = true
                    userNamelb.isHidden = true
                    userusheaderView.set_Border(radius: 32.0/2, borderWidth: 1.0, borderColor: lmColorHex("#FFFFFFE0"))
                } else {
                    auditionView.isHidden = false
                    userNamelb.isHidden = false
                    userusheaderView.set_Border(radius: 32.0/2, borderWidth: 1.0, borderColor: lmColorHex("#00DBA9FF"))
                }
            } else {
                auditionView.isHidden = true
                userNamelb.isHidden = true
                userusheaderView.set_Border(radius: 32.0/2, borderWidth: 1.0, borderColor: .clear)
            }
        }
    }
}
