import UIKit
import AttributedString
extension SearchcommandUserCell {
    func setDataSoure(_ model: UsInfoItem, keyString: String? = "") {
        self.dataSoure = model
        self.usheaderView.set_usheader(url: model.avatar)
        self.nicknamelb.text = model.nickname
        self.idlb.text = "ID·" + model.showUserId
        let set_ = LMUserTagV(sex: model.gender, age: model.age)
        self.userTagView.setDataSoure(set_, maxWidth: kScreenWidth - 128.0 - 16.0)
        let keytext = "\("邀请码: ".localized)\(keyString ?? "")"
        var key: ASAttributedString = .init(string: keytext, .font(lmFontR(12)), .foreground(lmColorHex("#2B313DA3")))
        key.add(attributes: [.foreground(lmColorHex("#FF4F7DFF"))], checkings: [.regex(keyString ?? "")])
        commandlb.attributed.text = key
        self.arrowimv.isHidden = model.userId == UserShared.user?.userId
    }
}
class SearchcommandUserCell: BaseCollectionViewCell {
    var dataSoure: UsInfoItem = UsInfoItem()
    var selectedblock: ((UsInfoItem) -> Void)?
    private lazy var bgimv: UIImageView = {
        let imv = UIImageView().backgroundColor(.white).cornerRadius(12)
            .isUserInteractionEnabled(true)
        return imv
    }()
    private lazy var usheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_avatar)
            .contentMode(.scaleAspectFill)
            .cornerRadius(70/2)
        return imv
    }()
    private lazy var nicknamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#2B313D"))
        return lb
    }()
    private lazy var idlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#2B313DA3"))
        return lb
    }()
    private lazy var userTagView: UserTagView = {
        let view = UserTagView()
        return view
    }()
    private lazy var arrowimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "search_exacthi"))
            .isUserInteractionEnabled(true)
        imv.addGestureTap { [weak self] _ in
            guard let model = self?.dataSoure else {
                return
            }
            self?.selectedblock?(model)
        }
        return imv
    }()
    private lazy var commandlb: UITextView = {
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
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension SearchcommandUserCell {
    func setViewSnp() {
        contentView.addSubview(bgimv)
        bgimv.addSubview(usheaderView)
        bgimv.addSubview(nicknamelb)
        bgimv.addSubview(userTagView)
        bgimv.addSubview(idlb)
        bgimv.addSubview(arrowimv)
        bgimv.addSubview(commandlb)
        bgimv.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(94))
        }
        usheaderView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(70.0)
        }
        nicknamelb.snp.makeConstraints { make in
            make.left.equalTo(usheaderView.snp.right).offset(12.0)
            make.top.equalTo(usheaderView.snp.top).offset(1.0)
            make.height.equalTo(24.0)
            make.right.equalToSuperview().offset(-100.0)
        }
        userTagView.snp.makeConstraints { make in
            make.left.equalTo(nicknamelb)
            make.top.equalTo(nicknamelb.snp.bottom).offset(4.0)
            make.size.equalTo(CGSize(width: 100, height: 20.0))
        }
        idlb.snp.makeConstraints { make in
            make.left.equalTo(userTagView.snp.right).offset(4)
            make.centerY.equalTo(userTagView.snp.centerY)
        }
        commandlb.snp.makeConstraints { make in
            make.left.equalTo(nicknamelb.snp.left)
            make.top.equalTo(userTagView.snp.bottom).offset(1.0)
        }
        arrowimv.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 36))
        }
    }
}
