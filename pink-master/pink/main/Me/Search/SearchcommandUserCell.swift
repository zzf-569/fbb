import UIKit
import AttributedString
extension SearchcommandUserCell {
    func act_setConfigData(_ model: UserModel, keyString: String? = "") {
        self.model = model
        self.avatarImageView.act_setAvatarImage(url: model.avatar)
        self.nicknameLabel.text = model.nickname
        self.idLabel.text = "ID·" + model.showUserId
        let config = UserTagConfig(sex: model.gender, age: model.age)
        self.userTagView.act_setConfigData(config, maxWidth: kScreenWidth - 128.0 - 16.0)
        let keytext = "\("邀请码: ".localized)\(keyString ?? "")"
        var key: ASAttributedString = .init(string: keytext, .font(lmFontR(12)), .foreground(lmColorHex("#1C1C29A3")))
        key.add(attributes: [.foreground(lmColorHex("#FF4F7DFF"))], checkings: [.regex(keyString ?? "")])
        commandLabel.attributed.text = key
        self.arrowImageView.isHidden = model.userId == UserShared.user?.userId
    }
}
class SearchcommandUserCell: BaseCollectionViewCell {
    var model: UserModel = UserModel()
    var selectedClosure: ((UserModel) -> Void)?
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView().act_backgroundColor(.white).act_cornerRadius(12)
            .act_isUserInteractionEnabled(true)
        return imageView
    }()
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: kPlaceholder_avatar)
            .act_contentMode(.scaleAspectFill)
            .act_cornerRadius(70/2)
        return imageView
    }()
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#1C1C29"))
        return label
    }()
    private lazy var idLabel: UILabel = {
        let label = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#1C1C29A3"))
        return label
    }()
    private lazy var userTagView: UserTagView = {
        let view = UserTagView()
        return view
    }()
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "search_exacthi"))
            .act_isUserInteractionEnabled(true)
        imageView.act_addGestureTap { [weak self] _ in
            guard let model = self?.model else {
                return
            }
            self?.selectedClosure?(model)
        }
        return imageView
    }()
    private lazy var commandLabel: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        return textView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        act_setUISubViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension SearchcommandUserCell {
    func act_setUISubViews() {
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(avatarImageView)
        bgImageView.addSubview(nicknameLabel)
        bgImageView.addSubview(userTagView)
        bgImageView.addSubview(idLabel)
        bgImageView.addSubview(arrowImageView)
        bgImageView.addSubview(commandLabel)
        bgImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(94))
        }
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(70.0)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(12.0)
            make.top.equalTo(avatarImageView.snp.top).offset(1.0)
            make.height.equalTo(24.0)
            make.right.equalToSuperview().offset(-100.0)
        }
        userTagView.snp.makeConstraints { make in
            make.left.equalTo(nicknameLabel)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4.0)
            make.size.equalTo(CGSize(width: 100, height: 20.0))
        }
        idLabel.snp.makeConstraints { make in
            make.left.equalTo(userTagView.snp.right).offset(4)
            make.centerY.equalTo(userTagView.snp.centerY)
        }
        commandLabel.snp.makeConstraints { make in
            make.left.equalTo(nicknameLabel.snp.left)
            make.top.equalTo(userTagView.snp.bottom).offset(1.0)
        }
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 36))
        }
    }
}
