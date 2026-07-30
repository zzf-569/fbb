import UIKit
extension LMRMMoreItemCell {
    func setDataSoure(_ model:LMRMMoreItemModel) {
        self.titydmageView.image = UIImage(named: model.imageName)
        self.titleLab.text = model.title
        self.isNewImage.isHidden = !model.isNew
    }
}
class LMRMMoreItemCell: BaseCollectionViewCell {
    private lazy var titydmageView: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#192218"))
            .textAlignment(.center)
        return lb
    }()
    lazy var isNewImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "rm_more_isnew"))
            .isHidden(true)
        return imageV
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMMoreItemCell {
    func setViewSnp() {
        contentView.addSubview(titydmageView)
        contentView.addSubview(titleLab)
        contentView.addSubview(isNewImage)
        titydmageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titydmageView.snp.bottom).offset(2.0)
            make.height.equalTo(20.0)
        }
        isNewImage.snp.makeConstraints { make in
            make.top.right.equalTo(titydmageView)
            make.size.equalTo(CGSize(width: 8.0, height: 8.0))
        }
    }
}
