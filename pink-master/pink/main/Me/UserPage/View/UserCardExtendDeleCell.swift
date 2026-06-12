import UIKit
extension UserCardExtendDeleCell {
    func setDataSoure(_ model: String) {
        contentlb.text = model
    }
    static func getCellWidth(_ model: String) -> Double {
        let contentWidth = model.textWidth(height: 24.0, font: lmFontM(12), minWidth: 0.0)
        return contentWidth + 30
    }
}
class UserCardExtendDeleCell: BaseCollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var contentlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#2B313D"))
            .textAlignment(.center)
        return lb
    }()
    lazy var deleImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "card_dele"))
        return imageV
    }()
}
private extension UserCardExtendDeleCell {
    func setViewSnp() {
        contentView.backgroundColor(lmColorHex("#2B313D0A"))
            .cornerRadius(4)
        contentView.addSubview(contentlb)
        contentView.addSubview(deleImage)
        contentlb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
        }
        deleImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-8)
        }
    }
}
