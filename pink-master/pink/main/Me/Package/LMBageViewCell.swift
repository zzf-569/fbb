import UIKit
protocol LMBageViewCellDelegate: NSObjectProtocol {
    func dg_userDressClick(dressModel: UserDressModel)
}
class LMBageViewCell: BaseCollectionViewCell {
    var dataSoure: UserDressModel = UserDressModel() {
        didSet {
            iconImage.set_Image(url: dataSoure.dressUpIcon)
            namelb.lmtext(dataSoure.resourceName)
            timelb.lmtext("剩余时间：\(dataSoure.remainTime)")
            if dataSoure.isActive == true {
                statusbtn.backgroundColor(lmColorHex("#FF4F7D14"))
                statusbtn.titleColor(lmColorHex("#FF4F7DFF"))
                statusbtn.lmtitle("使用中")
            } else {
                statusbtn.backgroundColor(lmColorHex("#2B313D0A"))
                statusbtn.titleColor(.textDefaulColor)
                statusbtn.lmtitle("立即装扮")
            }
        }
    }
    weak var delegate: LMBageViewCellDelegate?
    lazy var iconImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
        return lb
    }()
    lazy var timelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: .textTerColor)
        return lb
    }()
    lazy var statusbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: .textDefaulColor)
            .lmtitle("立即装扮")
            .backgroundColor(lmColorHex("#2B313D0A"))
            .cornerRadius(4)
        btn.addGestureTap { [weak self] _ in
            self?.clickStatus()
        }
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        contentView.addSubview(iconImage)
        contentView.addSubview(namelb)
        contentView.addSubview(timelb)
        contentView.addSubview(statusbtn)
        iconImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(50), height: kScaleWidth(50)))
        }
        namelb.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(kScaleWidth(15))
            make.top.equalToSuperview().offset(kScaleWidth(19))
            make.height.equalTo(kScaleWidth(24))
        }
        timelb.snp.makeConstraints { make in
            make.left.equalTo(namelb.snp.left)
            make.bottom.equalToSuperview().offset(-kScaleWidth(19))
            make.height.equalTo(kScaleWidth(22))
        }
        statusbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(68), height: kScaleWidth(32)))
        }
        contentView.backgroundColor(.white)
        contentView.cornerRadius(12)
    }
    func clickStatus() {
        delegate?.dg_userDressClick(dressModel: dataSoure)
    }
}
