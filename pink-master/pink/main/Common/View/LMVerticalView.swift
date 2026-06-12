import UIKit
class LMVerticalView: UIView {
    enum rightType {
        case lbType, switchType, image, nomal
    }
    var title: String = ""
    var icon: String = ""
    var subTitle: String = ""
    var rightImage: String = ""
    var type: rightType = .nomal
    var isSelected: Bool = false
    lazy var iconImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: .textDefaulColor)
        return lb
    }()
    lazy var subtitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: .textDefaulColor)
        lb.textAlignment = .right
        return lb
    }()
    lazy var switchbtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "cm_switchOn"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "cm_switchOn"), for: .selected)
        return btn
    }()
    lazy var moreIcon: UIImageView = {
        let imageV = UIImageView(image: .init(named: "me_more"))
        imageV.contentMode = .scaleAspectFill
        return imageV
    }()
    lazy var rightimage: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        return imageV
    }()
    init(icon: String = "", title: String = "", type: rightType = .nomal, subTitle: String = "", isSelected: Bool = false, rightImage: String = "") {
        super.init(frame: .zero)
        self.icon = icon
        self.title = title
        self.subTitle = subTitle
        self.type = type
        self.isSelected = isSelected
        self.rightImage = rightImage
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        backgroundColor = lmColorHex("#F8F8FAFF")
        titleLab.text = self.title.localized
        if self.icon.isEmpty == true {
            addSubview(titleLab)
            addSubview(moreIcon)
            titleLab.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(kScaleWidth(16))
                make.height.equalTo(kScaleWidth(24))
            }
            moreIcon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-kScaleWidth(16))
                make.size.equalTo(CGSize(width: kScaleWidth(12), height: kScaleWidth(12)))
            }
        } else {
            addSubview(iconImage)
            addSubview(titleLab)
            addSubview(moreIcon)
            iconImage.image = UIImage(named: icon)
            iconImage.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(kScaleWidth(16))
                make.size.equalTo(CGSize(width: kScaleWidth(24), height: kScaleWidth(24)))
            }
            titleLab.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(kScaleWidth(52))
                make.height.equalTo(kScaleWidth(24))
            }
            moreIcon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-kScaleWidth(16))
                make.size.equalTo(CGSize(width: kScaleWidth(12), height: kScaleWidth(12)))
            }
        }
        switch self.type {
        case .lbType:
            addSubview(subtitleLab)
            subtitleLab.text = subTitle.localized
            subtitleLab.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-kScaleWidth(28))
                make.left.equalToSuperview().offset(kScaleWidth(92))
                make.height.equalTo(kScaleWidth(22))
            }
        case .switchType:
            moreIcon.isHidden = true
            addSubview(switchbtn)
            switchbtn.isSelected = isSelected
            switchbtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-kScaleWidth(16))
                make.height.equalTo(kScaleWidth(16))
            }
        case .image:
            moreIcon.isHidden = true
            addSubview(rightimage)
            rightimage.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-kScaleWidth(16))
                make.top.equalToSuperview().offset(kScaleWidth(8))
                make.bottom.equalToSuperview().offset(-kScaleWidth(8))
                make.width.equalTo(rightimage.snp.height).multipliedBy(1)
            }
            rightimage.set_Image(url: self.rightImage, placeholder: kPlaceholder_avatar)
            self.layoutIfNeeded()
            rightimage.cornerRadius(kScaleWidth(4))
        default:
            break
        }
    }
    func setDataSoure(icon: String = "", subTitle: String = "", isSelected: Bool = false, rightImage: String = "") {
        self.icon = icon
        self.subTitle = subTitle
        self.isSelected = isSelected
        self.rightImage = rightImage
        rightimage.set_Image(url: self.rightImage)
        subtitleLab.text = subTitle.localized
        switchbtn.isSelected = isSelected
    }
}
