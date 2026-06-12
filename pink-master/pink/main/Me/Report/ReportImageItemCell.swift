import UIKit
extension ReportImageItemCell {
    func setDataSoure(_ image: UIImage?) {
        if let image = image {
            self.contentimv.image = image
        } else {
            self.contentimv.image = UIImage(named: "cm_add_image")
        }
    }
}
class ReportImageItemCell: BaseCollectionViewCell {
    private lazy var contentimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "cm_add_image"))
            .contentMode(.scaleAspectFill)
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
private extension ReportImageItemCell {
    func setViewSnp() {
        contentView.addSubview(contentimv)
        contentimv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
