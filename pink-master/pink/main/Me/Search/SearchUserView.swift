import UIKit
class SearchUserView: LMBaseView {
    var model: UserModel = UserModel() {
        didSet {
            headImage.act_setImage(url: model.avatar)
            nameLabel.act_lmtext(model.nickname)
            idLabel.act_lmtext("ID: \(model.showUserId)")
            levingImage.isHidden = (model.currentRoom == nil)
        }
    }
    lazy var headImage: UIImageView = {
        let imageV = UIImageView()
            .act_cornerRadius(kScaleWidth(28))
        return imageV
    }()
    lazy var levingImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "search_living"))
            .act_isHidden(true)
        return imageV
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel(lmfont: lmFontM(14), textColor: .textPrimary)
            .act_textAlignment(.center)
        return label
    }()
    lazy var idLabel: UILabel = {
        let label = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#1C1C29AD"))
            .act_textAlignment(.center)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        act_setUISubViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func act_setUISubViews() {
        addSubview(headImage)
        addSubview(levingImage)
        addSubview(nameLabel)
        addSubview(idLabel)
        headImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(56)))
        }
        levingImage.snp.makeConstraints { make in
            make.edges.equalTo(headImage)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headImage.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        idLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headImage.snp.bottom).offset(34)
            make.height.equalTo(20)
        }
    }
}
