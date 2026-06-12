import UIKit
extension LMRMPersonSeatView {
    func set_upPkSubviews(_ viewModel:VoiceVM, roomPkModel: LMinvitePkViewModel) {
        guard let invitePkInfo = viewModel.roomItem.roomPkInfo else {
            return
        }
        dataSoure = invitePkInfo
        rankbtn.isHidden = roomPkModel.dataSoure.status != .end
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
        progressView.set_Progress(leftProgress: redValue, rightProgress: buleValue)
    }
}
class LMRMPersonSeatView: UIView {
    var dataSoure: invitePkInfo = invitePkInfo()
    lazy var redbackimage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "rm_personpk_redBg"))
        return imageV
    }()
    lazy var bluebackimage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "rm_personpk_blueBg"))
        return imageV
    }()
    lazy var progressView:LMRMSeatPkProgressView = {
        let view = LMRMSeatPkProgressView(isRoomPK: true)
        return view
    }()
    lazy var rankbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_crossPk_rank"), target: self, action: #selector(rankbtnAction))
        return btn
    }()
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
        addSubview(bluebackimage)
        addSubview(redbackimage)
        addSubview(progressView)
        addSubview(rankbtn)
        bluebackimage.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: kScaleWidth(236), height: kScaleWidth(101)))
        }
        redbackimage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: kScaleWidth(236), height: kScaleWidth(101)))
        }
        progressView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalToSuperview().offset(kScaleWidth(68))
            make.height.equalTo(44.0)
        }
        rankbtn.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(kScaleWidth(2))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(64), height: kScaleWidth(24)))
        }
    }
    func setDataSoure() {
    }
    @objc func rankbtnAction() {
        let view = LMRMPkRankCenterView()
        view.setDataSoure(dataSoure)
        view.show()
    }
}
