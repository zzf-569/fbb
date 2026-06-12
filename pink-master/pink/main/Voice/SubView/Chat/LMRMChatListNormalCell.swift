import UIKit
class LMRMChatListNormalCell:LMRMChatListBaseCell {
    private lazy var usheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_avatar)
            .contentMode(.scaleAspectFill)
            .cornerRadius(30/2)
        imv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickUserAction))
        imv.addGestureRecognizer(tap)
        return imv
    }()
    private lazy var headwearimv: LMAnimationPlayer = {
        let volume = LMAnimationPlayer()
        return volume
    }()
    private lazy var nicknamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        lb.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickUserAction))
        lb.addGestureRecognizer(tap)
        return lb
    }()
    private lazy var tagView: UITextView = {
        let textView = UITextView(lmfont: lmFontF(12), textColor: lmColorHex("#FFFFFFE0"))
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickUserAction))
        textView.addGestureRecognizer(tap)
        return textView
    }()
    private lazy var contentlb: UITextView = {
        let textView = UITextView(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFFE0"))
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setDataSoure(_ model:VoiceChatListModel) {
        super.setDataSoure(model)
        self.usheaderView.set_Image(url: model.user?.avatar)
        self.headwearimv.play(url: model.user?.headWear ?? "", repeatCount: 0)
        self.nicknamelb.text = model.user?.nickname
        self.tagView.attributed.text = model.userAbout
        self.contentlb.attributed.text = model.content
        contentlb.snp.updateConstraints { make in
            make.size.equalTo(model.contentSize)
        }
    }
}
private extension LMRMChatListNormalCell {
    func setViewSnp() {
        contentView.addSubview(usheaderView)
        contentView.addSubview(headwearimv)
        contentView.addSubview(nicknamelb)
        contentView.addSubview(tagView)
        contentView.addSubview(contentlb)
        usheaderView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(0)
            make.width.height.equalTo(30.0)
        }
        headwearimv.snp.makeConstraints { make in
            make.center.equalTo(usheaderView)
            make.width.height.equalTo(36.0)
        }
        nicknamelb.snp.makeConstraints { make in
            make.left.equalTo(usheaderView.snp.right).offset(4.0)
            make.centerY.equalTo(usheaderView.snp.centerY)
        }
        tagView.snp.makeConstraints { make in
            make.left.equalTo(nicknamelb.snp.right).offset(4.0)
            make.right.equalToSuperview().offset(0)
            make.centerY.equalTo(usheaderView.snp.centerY)
        }
        contentlb.snp.makeConstraints { make in
            make.left.equalTo(nicknamelb)
            make.top.equalTo(tagView.snp.bottom).offset(2.0)
            make.size.equalTo(CGSize())
        }
    }
    @objc func clickUserAction() {
        guard let user = self.dataSoure?.user else { return }
        self.delegate?.dg_cellUserAction(userId: user.userId)
    }
}
