import UIKit
extension LMMessageListCell {
    func setDataSoure(_ model: ConversationListItem) {
        if let avatarName = model.avatarImage {
            self.usheaderView.image = UIImage(named: avatarName)
        } else {
            self.usheaderView.set_Image(url: model.avatar, placeholder: kPlaceholder_avatar)
        }
        self.titleLab.text = model.title
        self.subtitleLab.attributedText = model.subtitle
        self.timelb.text = model.time
        self.badgelb.set_Badge(model.badge)
        self.lineView.isHidden = model.status != 1
    }
}
class LMMessageListCell: LMBaseTableViewCell {
    private lazy var usheaderView: UIImageView = {
        let imv = UIImageView()
            .contentMode(.scaleAspectFill)
            .cornerRadius(56.0/2)
        return imv
    }()
    lazy var lineView: UILabel = {
        let lb = UILabel(lmfont: lmFontM(10), textColor: lmColorHex("#26D477FF"))
            .backgroundColor(lmColorHex("#26D47714"))
            .lmtext("• 在线")
            .cornerRadius(8)
        return lb
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#2B313D"))
        return lb
    }()
    private lazy var subtitleLab: UILabel = {
        let lable = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#2B313DA3"))
        return lable
    }()
    private lazy var subtitleTextView: UITextView = {
        let textView = UITextView(lmfont: lmFontF(10), textColor: lmColorHex("#FFFFFFA3"))
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        return textView
    }()
    private lazy var timelb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(10), textColor: lmColorHex("#2B313D66"))
            .textAlignment(.right)
        return lb
    }()
    private lazy var badgelb: Badgelb = {
        let lb = Badgelb()
        return lb
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMMessageListCell {
    func setViewSnp() {
        contentView.addSubview(usheaderView)
        contentView.addSubview(titleLab)
        contentView.addSubview(subtitleLab)
        contentView.addSubview(timelb)
        contentView.addSubview(badgelb)
        contentView.addSubview(lineView)
        usheaderView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(56.0)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(usheaderView.snp.right).offset(12.0)
            make.top.equalTo(usheaderView.snp.top).offset(4.0)
            make.height.equalTo(24.0)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right).offset(4)
            make.centerY.equalTo(lineView.snp.centerY)
            make.size.equalTo(CGSize(width: 37, height: 16))
        }
        timelb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalTo(titleLab)
            make.left.equalTo(titleLab.snp.right).offset(10.0)
        }
        subtitleLab.snp.makeConstraints { make in
            make.left.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom).offset(4.0)
            make.height.equalTo(20.0)
        }
        badgelb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalTo(subtitleLab)
            make.width.equalTo(16.0)
            make.height.equalTo(16.0)
            make.left.equalTo(subtitleLab.snp.right).offset(10.0)
        }
    }
}
