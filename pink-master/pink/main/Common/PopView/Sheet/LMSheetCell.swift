import UIKit
class LMSheetCell: BaseCollectionViewCell {
    private lazy var contentimv: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFF", alpha: 0.6))
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
private extension LMSheetCell {
    func setViewSnp() {
        contentView.addSubview(contentimv)
        contentimv.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64.0)
        }
    }
}
extension LMSheetCell {
    func setDataSoure(_ model: LMSheetItemModel) {
        self.contentimv.image = UIImage(named: model.imageName)
    }
    func set_Theme(_ theme: LMSheetCollectionVC.Theme) {
        self.titleLab.textColor = (theme == .dark ? lmColorHex("#FFFFFF", alpha: 0.6) : lmColorHex("#2B313D", alpha: 0.4))
    }
}
