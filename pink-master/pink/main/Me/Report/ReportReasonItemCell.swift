import UIKit
extension ReportReasonItemCell {
    func setDataSoure(_ model: ReportReasonItemModel) {
        self.contentlb.text = model.desc
        if model.isSelected {
            self.contentlb.textColor = lmColorHex("#FF4F7DFF")
            self.contentView.backgroundColor = lmColorHex("#FF4F7D14")
        } else {
            self.contentlb.textColor = lmColorHex("#2B313D")
            self.contentView.backgroundColor = lmColorHex("#2B313D0A")
        }
    }
}
class ReportReasonItemCell: BaseCollectionViewCell {
    private lazy var contentlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#2B313D"))
            .textAlignment(.center)
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension ReportReasonItemCell {
    func setViewSnp() {
        contentView.backgroundColor = lmColorHex("#F5F6FA")
        contentView.set_Border(radius: 4.0)
        contentView.addSubview(contentlb)
        contentlb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
