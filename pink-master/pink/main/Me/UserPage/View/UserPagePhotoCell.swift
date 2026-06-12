import UIKit
extension UserPagePhotoCell {
    func setDataSoure(_ photoModel: photoWallModel) {
        imv.set_Image(url: photoModel.url)
    }
}
class UserPagePhotoCell: UICollectionViewCell {
    lazy var imv: UIImageView = {
        let imagev = UIImageView()
            .contentMode(.scaleAspectFill)
            .cornerRadius(9)
        return imagev
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(imv)
        imv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
