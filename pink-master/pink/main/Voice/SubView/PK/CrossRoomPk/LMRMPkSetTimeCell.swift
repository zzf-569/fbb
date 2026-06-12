import UIKit
extension LMRMPkSetTimeCell {
    func setDataSoure(_ model:LMRMPKSetupModel) {
        self.titydmageView.image = UIImage(named: model.imageName)
        self.titleLab.text = model.title
        self.selectimv.isHidden = !model.selected
    }
}
class LMRMPkSetTimeCell: BaseCollectionViewCell {
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: lmColorHex("#FFFFFF"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var titydmageView: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    private lazy var selectimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_pktime_click"))
        imv.isHidden = true
        return imv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMPkSetTimeCell {
    func setViewSnp() {
        contentView.addSubview(titydmageView)
        contentView.addSubview(titleLab)
        contentView.addSubview(selectimv)
        titydmageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        selectimv.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 20))
        }
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(16))
        }
    }
}
