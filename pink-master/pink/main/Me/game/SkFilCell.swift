import UIKit
class SkFilCell: UICollectionViewCell {
    var dataSoure: SkillItem = SkillItem() {
        didSet {
            titleLab.text = dataSoure.skillName
            skillImage.set_Image(url: dataSoure.skillIcon)
        }
    }
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textDefaulColor)
        lb.textAlignment(.center)
        return lb
    }()
    lazy var skillImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        set_Subviews()
        setDataSoure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func set_Subviews() {
        contentView.backgroundColor(lmColorHex("#2B313D0A"))
        contentView.cornerRadius(9)
        contentView.addSubview(titleLab)
        contentView.addSubview(skillImage)
        skillImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kScaleWidth(8))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(32), height: kScaleWidth(32)))
        }
        titleLab.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kScaleWidth(8))
            make.centerX.equalToSuperview()
        }
        contentView.layoutIfNeeded()
    }
    func setDataSoure() {
    }
    var isSelectedItem: Bool? {
        didSet {
            if isSelectedItem == true {
                contentView.set_Border(radius: 9, borderWidth: 1, borderColor: lmColorHex("#00DBA9FF"))
                contentView.backgroundColor = lmColorHex("#00DBA914")
            } else {
                contentView.backgroundColor = lmColorHex("#2B313D0A")
                contentView.set_Border(radius: 9, borderWidth: 0, borderColor: .clear)
            }
        }
    }
}
