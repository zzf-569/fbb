import UIKit
class LMUserMenuCell: LMBaseTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI() {
        contentView.addSubview(titleLab)
        contentView.addSubview(arrowimv)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        arrowimv.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16.0)
        }
    }
    public func setData(model: LMUserMenuItemModel) {
        titleLab.text = model.type.title
    }
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontS(16), textColor: lmColorHex("#2B313D"))
        return lb
    }()
    private lazy var arrowimv: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "user_menu_arrow"))
        return iv
    }()
}
