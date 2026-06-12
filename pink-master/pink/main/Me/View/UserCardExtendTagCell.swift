import UIKit
extension UserCardExtendTagCell {
    func setDataSoure(_ model: String) {
        contentlb.text = model
    }
    static func getCellWidth(_ model: String) -> Double {
        let contentWidth = model.textWidth(height: 32.0, font: lmFontF(14), minWidth: 72.0)
        return contentWidth
    }
}
class UserCardExtendTagCell: BaseCollectionViewCell {
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
}
private extension UserCardExtendTagCell {
    func setViewSnp() {
        contentView.backgroundColor(lmColorHex("#2B313D0A"))
            .cornerRadius(4)
        contentView.addSubview(contentlb)
        contentlb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
