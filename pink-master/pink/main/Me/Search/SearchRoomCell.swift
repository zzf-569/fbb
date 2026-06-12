import UIKit
import APNGKit
import AttributedString
extension SearchRoomCell {
    func act_setConfigData(_ model: RoomModel, keyString: String? = "") {
        self.model = model
        self.tagImageView.act_setImage(url: model.tagUrl)
        self.coverImageView.act_setImage(url: model.cover)
        self.idLabel.text = "ID: " + model.showRoomId
        let text = model.roomName
        var string: ASAttributedString = .init(string: text, .font(lmFontM(14)), .foreground(.textPrimary))
        string.add(attributes: [.background(lmColorHex("#FF4F7D1A"))], checkings: [.regex(keyString ?? "")])
        titleLabel.attributed.text = string
        openImageView.act_isHidden(model.status != 1)
    }
}
class SearchRoomCell: BaseCollectionViewCell {
    var selectedClosure: ((String, RoomModel) -> Void)?
    var model: RoomModel = RoomModel()
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
            .act_backgroundColor(.white)
            .act_isUserInteractionEnabled(true)
        return imageView
    }()
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(image: kPlaceholder_image)
            .act_contentMode(.scaleAspectFill)
            .act_cornerRadius(kScaleWidth(8))
        return imageView
    }()
    private lazy var titleLabel: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.act_backgroundColor(.white)
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        return textView
    }()
    private lazy var tagImageView: UIImageView = {
        let imageView = UIImageView(image: kPlaceholder_image)
            .act_contentMode(.scaleAspectFill)
        return imageView
    }()
    private lazy var openImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "search_room_open"))
            .act_contentMode(.scaleAspectFill)
        return imageView
    }()
    private lazy var idLabel: UILabel = {
        let label = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#1C1C29A3"))
        return label
    }()
    private lazy var sceneImageView: APNGImageView = {
        let apngView = APNGImageView()
        apngView.isHidden = true
        return apngView
    }()
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "fans_more"))
            .act_isUserInteractionEnabled(true)
        imageView.act_addGestureTap { [weak self] _ in
            self?.act_selectedCellBack()
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
private extension SearchRoomCell {
    func act_setUISubViews() {
        contentView.addSubview(bgImageView)
        contentView.addSubview(coverImageView)
        contentView.addSubview(openImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(idLabel)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        coverImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.top.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 54.0, height: 54.0))
        }
        openImageView.snp.makeConstraints { make in
            make.center.equalTo(coverImageView)
            make.size.equalTo(CGSize(width: 56.0, height: 56.0))
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(coverImageView.snp.right).offset(12)
            make.top.equalTo(coverImageView.snp.top).offset(4.0)
            make.right.equalToSuperview().offset(-100)
            make.height.equalTo(24.0)
        }
        idLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(4.0)
        }
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
    }
    func act_selectedCellBack() {
        if model.status == 1 {
            self.selectedClosure?("去房间", model)
        } else {
            self.selectedClosure?("关注", model)
        }
    }
}
