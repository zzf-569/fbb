import UIKit
class UserPageSkillCell: LMBaseTableViewCell {
    var dataSoure: SkillItem = SkillItem() {
        didSet {
            iconImage.set_Image(url: dataSoure.skillCard)
            skillName.lmtext(dataSoure.skillName)
            levellb.lmtext(dataSoure.skillLevel)
            pricelb.text = "\(dataSoure.skillPrice)钻石/\(dataSoure.skillUnit)"
        }
    }
    var userId: String = "" {
        didSet {
            if userId == UserShared.user?.userId {
                findbtn.isHidden = true
            }
        }
    }
    lazy var backImage: UIImageView = {
        let imageV = UIImageView()
        imageV.cornerRadius(kScaleWidth(12))
        imageV.backgroundColor = .white
        return imageV
    }()
    lazy var iconImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var skillName: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
        return lb
    }()
    lazy var levellb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textSecondColor)
        return lb
    }()
    lazy var pricelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#FFCC00"))
        return lb
    }()
    lazy var findbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: .textDefaulColor, backgroundColor: lmColorHex("#FF4F7D"), text: "下单")
        btn.cornerRadius(kScaleWidth(16))
        btn.backgroundColor = lmColorHex("#FFEC3BFF")
        btn.addTarget(self, action: #selector(a_findbtnClick), for: .touchUpInside)
        return btn
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func set_Subviews() {
        contentView.addSubview(backImage)
        backImage.addSubview(iconImage)
        backImage.addSubview(skillName)
        backImage.addSubview(levellb)
        backImage.addSubview(pricelb)
        backImage.addSubview(findbtn)
        backImage.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(96))
        }
        iconImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(72), height: kScaleWidth(72)))
        }
        skillName.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(kScaleWidth(12))
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.height.equalTo(kScaleWidth(20))
        }
        levellb.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(kScaleWidth(12))
            make.centerY.equalToSuperview()
            make.height.equalTo(kScaleWidth(20))
        }
        pricelb.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(kScaleWidth(12))
            make.bottom.equalToSuperview().offset(kScaleWidth(-12))
            make.height.equalTo(kScaleWidth(20))
        }
        findbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(14))
            make.top.equalToSuperview().offset(kScaleWidth(36))
            make.size.equalTo(CGSize(width: kScaleWidth(64), height: kScaleWidth(32)))
        }
    }
    @objc func a_findbtnClick() {
    }
}
