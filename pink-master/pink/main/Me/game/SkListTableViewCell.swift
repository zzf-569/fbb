import UIKit
class SkListTableViewCell: BaseCollectionViewCell {
    var dataSoure: SkillItem = SkillItem() {
        didSet {
            iconImage.set_Image(url: dataSoure.skillIcon, placeholder: kPlaceholder_image)
            skillName.text = dataSoure.skillName
            switch dataSoure.status {
            case -1:
                status.lmtitle("去申请")
                status.titleColor(.textDefaulColor)
                case 0:
                status.lmtitle("审核中")
                status.titleColor(lmColorHex("#FF9F40"))
                case 1:
                status.lmtitle("已通过")
                status.titleColor(.textDefaulColor)
                case 2:
                status.lmtitle("已驳回")
                status.titleColor(lmColorHex("#F5455C"))
            default:
                break
            }
        }
    }
    lazy var iconImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var skillName: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: .textDefaulColor)
        return lb
    }()
    lazy var status: UIButton = {
        let btn = UIButton(lmfont: lmFontR(8), titleColor: .whitePrimary).backgroundColor(lmColorHex("#2B313D0A")).cornerRadius(kScaleWidth(4))
        btn.lmtitle("去申请")
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
        contentView.addSubview(skillName)
        contentView.addSubview(status)
        iconImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(4))
            make.size.equalTo(CGSize(width: kScaleWidth(48), height: kScaleWidth(48)))
        }
        skillName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(58))
        }
        status.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(82))
            make.size.equalTo(CGSize(width: kScaleWidth(32), height: kScaleWidth(16)))
        }
    }
}
