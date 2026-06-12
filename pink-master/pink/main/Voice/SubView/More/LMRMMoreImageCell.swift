import UIKit
extension LMRMMoreImageCell {
    func setDataSoure(_ model:LMRMMoreItemModel) {
        self.titydmageView.image = UIImage(named: model.imageName)
    }
}
class LMRMMoreImageCell: BaseCollectionViewCell {
    private lazy var titydmageView: UIImageView = {
        let imv = UIImageView()
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
private extension LMRMMoreImageCell {
    func setViewSnp() {
        contentView.addSubview(titydmageView)
        titydmageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
