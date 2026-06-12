import UIKit
extension SearchexactUserCell {
    func act_setConfigData(_ model: UserModel, keyString: String? = "") {
        self.model = model
        self.avatarImageView.act_setAvatarImage(url: model.avatar)
        self.nicknameLabel.text = model.nickname
        self.idLabel.text = "ID·" + model.showUserId
        self.arrowImageView.isHidden = model.userId == UserShared.user?.userId
        if keyString == model.nickname {
            nicknameLabel.act_textColor(lmColorHex("#FF4F7DFF"))
        } else {
            nicknameLabel.act_textColor(lmColorHex("#1C1C29FF"))
        }
    }
}
class SearchexactUserCell: BaseCollectionViewCell {
    var model: UserModel = UserModel()
    var selectedClosure: ((UserModel) -> Void)?
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView().act_backgroundColor(.white).act_cornerRadius(12)
        return imageView
    }()
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: kPlaceholder_avatar)
            .act_contentMode(.scaleAspectFill)
            .act_cornerRadius(56/2)
            .act_isUserInteractionEnabled(true)
        return imageView
    }()
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#FF4F7DFF"))
        return label
    }()
    private lazy var idLabel: UILabel = {
        let label = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#1C1C29A3"))
        return label
    }()
    private lazy var arrowImageView: UIButton = {
        let imageView = UIButton(lmfont: lmFontM(12), titleColor: .white)
            .act_backgroundColor(lmColorHex("#FF4F7DFF"))
            .act_cornerRadius(kScaleWidth(14))
            .act_lmtitle("打招呼")
        imageView.act_addGestureTap { [weak self] _ in
            guard let model = self?.model else {
                return
            }
            self?.selectedClosure?(model)
        }
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        act_setUISubViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension SearchexactUserCell {
    func act_setUISubViews() {
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(avatarImageView)
        bgImageView.addSubview(nicknameLabel)
        bgImageView.addSubview(idLabel)
        bgImageView.addSubview(arrowImageView)
        bgImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(94))
        }
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(56.0)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(12.0)
            make.top.equalTo(avatarImageView.snp.top).offset(11.0)
            make.height.equalTo(24.0)
            make.right.equalToSuperview().offset(-24.0)
        }
        idLabel.snp.makeConstraints { make in
            make.left.equalTo(nicknameLabel)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4.0)
        }
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 56, height: 28))
        }
    }
}
