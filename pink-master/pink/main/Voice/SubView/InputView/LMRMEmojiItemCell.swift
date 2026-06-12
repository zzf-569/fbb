import UIKit
extension RoomEmojiItemCell {
    func setDataSoure(_ model: LMEmojiListModel) {
        self.contentimv.set_Image(url: model.url)
        self.contenttitleLab.text = model.name
    }
}
class RoomEmojiItemCell: BaseCollectionViewCell {
    private lazy var contentimv: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
        return imv
    }()
    private lazy var contenttitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#FFFFFFA3"))
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
private extension RoomEmojiItemCell {
    func setViewSnp() {
        contentView.addSubview(contentimv)
        contentView.addSubview(contenttitleLab)
        contentimv.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(4.0)
            make.width.height.equalTo(52.0)
        }
        contenttitleLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(contentimv.snp.bottom).offset(4.0)
            make.height.equalTo(20.0)
        }
    }
}
