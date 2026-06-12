import UIKit
extension LMRMSeatPDDanmuItemView {
    static func getWidth(_ model: LMRMPDusInfoModel) -> Double {
        var allWidth = 4.0 + 16.0 + 2.0
        let content = model.nickname + " | " + model.bizName
        let contentWidth = content.textWidth(height: 20.0, font: lmFontM(12))
        allWidth += contentWidth
        allWidth += 6.0
        return allWidth
    }
    func setDataSoure(_ model: LMRMPDusInfoModel) {
        self.userusheaderView.set_Image(url: model.avatar)
        self.contentlb.text = model.nickname + " | " + model.bizName
    }
}
class LMRMSeatPDDanmuItemView: UIView {
    private lazy var userusheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_avatar)
            .contentMode(.scaleAspectFill)
            .cornerRadius(16.0/2)
        return imv
    }()
    private lazy var contentlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFF", alpha: 0.64))
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
}
private extension LMRMSeatPDDanmuItemView {
    private func set_Subviews() {
        backgroundColor = .clear
        addSubview(userusheaderView)
        addSubview(contentlb)
        userusheaderView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16.0)
        }
        contentlb.snp.makeConstraints { make in
            make.left.equalTo(userusheaderView.snp.right).offset(2.0)
            make.right.equalToSuperview().offset(-6.0)
            make.centerY.equalToSuperview()
        }
    }
}
