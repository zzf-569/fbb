import UIKit
class LMFamilyListCell: UITableViewCell {
    lazy var backImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var numlb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(14), textColor: .textDefaulColor)
        return lb
    }()
    lazy var usheader: UIImageView = {
        let imageV = UIImageView(image: kPlaceholder_avatar)
        imageV.cornerRadius(kScaleWidth(12))
        imageV.contentMode = .scaleAspectFill
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: .textDefaulColor)
        return lb
    }()
    lazy var hotlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textDisColor)
        return lb
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(backImage)
        backImage.addSubview(numlb)
        backImage.addSubview(usheader)
        backImage.addSubview(namelb)
        backImage.addSubview(hotlb)
        backImage.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(80))
        }
        numlb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.width.height.equalTo(kScaleWidth(24))
        }
        usheader.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(56))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(56)))
        }
        namelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(124))
            make.top.equalToSuperview().offset(18)
            make.height.equalTo(kScaleWidth(24))
        }
        hotlb.snp.makeConstraints { make in
            make.left.equalTo(namelb.snp.left)
            make.bottom.equalToSuperview().offset(-kScaleWidth(17))
            make.size.equalTo(CGSize(width: 100, height: 20))
        }
    }
    func setData(_ model: GuildItem, index: Int) {
        namelb.text = model.title
        usheader.set_Image(url: model.cover, placeholder: kPlaceholder_avatar)
        hotlb.text = "热度值: \(model.hotValue.toString())"
        numlb.text = (index + 1).toString()
    }
}
