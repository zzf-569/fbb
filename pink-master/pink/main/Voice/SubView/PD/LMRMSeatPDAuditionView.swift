import UIKit
extension LMRMSeatPDAuditionView {
    func setDataSoure(_ viewModel:VoiceVM, PDViewModel: LMRMPDViewModel?) {
        guard let DispatchItem = PDViewModel?.DispatchItem else { return }
        skilllb.text = "\(DispatchItem.bizName) \(DispatchItem.genderText) \(DispatchItem.demandPrice)"
        remarklb.text = DispatchItem.remark
        let seat = viewModel.seats.first(where: { $0.seatIndex != 0 && $0.seatIndex != 8 && $0.userInfo != nil })
        if (seat?.userInfo) != nil {
            updateAuditionSeatUser(seat)
        } else {
            userusheaderView.image = UIImage(named: "rm_seat")
            userNamelb.text = ""
        }
    }
    func updateAuditionSeatUser(_ seat:RoomSeatItem?) {
        stopVolumeAnimation()
        self.seat = seat
        if let user = seat?.userInfo {
            userusheaderView.set_Image(url: user.avatar)
            userNamelb.text = user.nickname
        } else {
            userusheaderView.image = UIImage(named: "rm_seat")
            userNamelb.text = ""
        }
    }
    func auditionUserDownSeat(_ userId: String) {
        if userId == seat?.userInfo?.userId {
            updateAuditionSeatUser(nil)
        }
    }
    func playVolume(_ volume: Int, seatIndex: Int) {
        if seatIndex == seat?.seatIndex {
            if volume > 5 {
                guard let path = Bundle.main.path(forResource: "voice_volume", ofType: "pag") else { return }
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(stopVolumeAnimation), object: nil)
                if !self.volumeView.isPlaying {
                    self.volumeView.play(path: path, repeatCount: 0)
                }
                self.perform(#selector(stopVolumeAnimation), with: nil, afterDelay: 1.0)
            }
        }
    }
    @objc func stopVolumeAnimation() {
        self.volumeView.clear()
    }
}
class LMRMSeatPDAuditionView: UIView {
    var seat:RoomSeatItem?
    private lazy var skilltitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(10), textColor: lmColorHex("#FFFFFFA3"))
            .lmtext("类型：")
        return lb
    }()
    private lazy var skilllb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(10), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        return lb
    }()
    private lazy var remarktitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(10), textColor: lmColorHex("#FFFFFFA3"))
            .lmtext("备注：")
        return lb
    }()
    private lazy var remarklb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(10), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        return lb
    }()
    private lazy var volumeView: LMAnimationPlayer = {
        let volume = LMAnimationPlayer()
        return volume
    }()
    private lazy var userusheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_avatar)
            .contentMode(.scaleAspectFill)
        imv.cornerRadius(70/2)
        return imv
    }()
    lazy var userNamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFF"))
            .textAlignment(.center)
        lb.isHidden = true
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMSeatPDAuditionView {
    private func set_Subviews() {
        addSubview(skilltitleLab)
        addSubview(skilllb)
        addSubview(remarktitleLab)
        addSubview(remarklb)
        addSubview(volumeView)
        addSubview(userusheaderView)
        skilltitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.top.equalToSuperview().offset(4)
            make.height.equalTo(20.0)
        }
        skilllb.snp.makeConstraints { make in
            make.left.equalTo(skilltitleLab.snp.right).offset(0.0)
            make.top.equalToSuperview().offset(4)
            make.height.equalTo(20.0)
            make.right.lessThanOrEqualToSuperview().offset(-12.0)
        }
        remarktitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.top.equalToSuperview().offset(108.0)
            make.height.equalTo(20.0)
        }
        remarklb.snp.makeConstraints { make in
            make.left.equalTo(remarktitleLab.snp.right).offset(0.0)
            make.centerY.equalTo(remarktitleLab.snp.centerY)
            make.right.lessThanOrEqualToSuperview().offset(-12.0)
            make.height.equalTo(20.0)
        }
        volumeView.snp.makeConstraints { make in
            make.center.equalTo(userusheaderView)
            make.width.height.equalTo(90.0)
        }
        userusheaderView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(29.0)
            make.height.width.equalTo(70.0)
        }
    }
}
