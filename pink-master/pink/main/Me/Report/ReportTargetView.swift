import UIKit
extension ReportTargetView {
    func setDataSoure(_ model: SmartCodable) {
        if let UsInfoItem = model as? UsInfoItem {
            self.imv.set_Image(url: UsInfoItem.avatar, placeholder: kPlaceholder_avatar)
            self.contentlb.text = UsInfoItem.nickname
        }
    }
}
class ReportTargetView: UIView {
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#2B313D"))
        let attributedString = NSMutableAttributedString(string: "*", attributes: [.font: lmFontM(16), .foregroundColor: lmColorHex("#F5455C")])
        attributedString.append(NSAttributedString(string: "举报对象：", attributes: [.font: lmFontM(16), .foregroundColor: lmColorHex("#2B313D")]))
        lb.attributedText = attributedString
        return lb
    }()
    private lazy var imv: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .cornerRadius(4.0)
        return imv
    }()
    private lazy var contentlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(16), textColor: lmColorHex("#2B313D"))
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension ReportTargetView {
    private func setViewSnp() {
        addSubview(titleLab)
        addSubview(imv)
        addSubview(contentlb)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
        }
        imv.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right).offset(16.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32.0)
        }
        contentlb.snp.makeConstraints { make in
            make.left.equalTo(imv.snp.right).offset(4.0)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualToSuperview().offset(-16.0)
        }
    }
}
