import UIKit
extension LMRMMoreVerCell {
    func setDataSoure(_ model:LMRMMoreItemModel, index: Int, lastIndex: Bool) {
        self.titydmageView.image = UIImage(named: model.imageName)
        self.titleLab.text = model.title
        contentView.set_Border(radius: 0, conrners: [.bottomLeft, .bottomRight])
        if index == 0, lastIndex == false {
            contentView.set_Border(radius: 8, conrners: [.topLeft, .topRight])
        } else if lastIndex == true, index != 0 {
            contentView.set_Border(radius: 8, conrners: [.bottomLeft, .bottomRight])
        } else if index == 0, lastIndex == true {
            contentView.set_Border(radius: 8, conrners: [.allCorners])
        } else {
            contentView.set_Border(radius: 0)
        }
    }
}
class LMRMMoreVerCell: BaseCollectionViewCell {
    private lazy var titydmageView: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#FFFFFF"))
            .textAlignment(.center)
        return lb
    }()
    lazy var moreImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "rm_more_right"))
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
private extension LMRMMoreVerCell {
    func setViewSnp() {
        contentView.backgroundColor(lmColorHex("#FFFFFF14"))
        contentView.addSubview(titydmageView)
        contentView.addSubview(titleLab)
        contentView.addSubview(moreImage)
        titydmageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(20.0)
        }
        titleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(titydmageView.snp.right).offset(8.0)
            make.height.equalTo(20.0)
        }
        moreImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20.0)
        }
    }
}
