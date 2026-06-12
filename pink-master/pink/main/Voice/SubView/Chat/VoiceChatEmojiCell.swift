import UIKit
import APNGKit
class VoiceChatEmojiCell:LMRMChatListBaseCell {
    private lazy var nicknamelb: UITextView = {
        let textView = UITextView(lmfont: lmFontF(12), textColor: lmColorHex("#FFFFFFE0"))
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.textContainerInset = .zero
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickUserAction))
        textView.addGestureRecognizer(tap)
        return textView
    }()
    private lazy var usheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_avatar)
            .contentMode(.scaleAspectFill)
            .cornerRadius(36/2)
        imv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickUserAction))
        imv.addGestureRecognizer(tap)
        return imv
    }()
    private lazy var bubbydmageView: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_chat_list_content_bubble")?.strechAsBubble())
        imv.isUserInteractionEnabled = true
        return imv
    }()
    private lazy var apngimv: APNGImageView = {
        let apngView = APNGImageView()
        return apngView
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
        self.nicknamelb.attributed.text = model.userAbout
        self.bubbydmageView.snp.updateConstraints { make in
            make.width.equalTo(model.contentSize.width + 12.0 * 2)
            make.height.equalTo(model.contentSize.height + 7.0 * 2)
        }
        guard let emojiModel = model.emojiModel else { return }
        self.apngimv.image = nil
        LMDownloadManager().downloadEmoji(emojiId: emojiModel.id, url: emojiModel.animationUrl) { [weak self] url, _ in
            guard let self = self else { return }
            guard let url = url else { return }
            guard let indexPath = self.indexPath else { return }
            DispatchQueue.main {
                do {
                    let image = try APNGImage(fileURL: url)
                    image.numberOfPlays = 2
                    self.apngimv.image = image
                    self.apngimv.autoStartAnimationWhenSetImage = false
                    if emojiModel.isPlayed {
                    } else {
                        self.apngimv.startAnimating()
                        self.delegate?.dg_cellEmojiPlay(indexPath: indexPath)
                    }
                } catch {
                }
            }
        }
    }
}
private extension VoiceChatEmojiCell {
    func setViewSnp() {
        contentView.addSubview(usheaderView)
        contentView.addSubview(nicknamelb)
        contentView.addSubview(bubbydmageView)
        bubbydmageView.addSubview(apngimv)
        usheaderView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(0)
            make.width.height.equalTo(36.0)
        }
        nicknamelb.snp.makeConstraints { make in
            make.left.equalTo(usheaderView.snp.right).offset(4.0)
            make.right.equalToSuperview().offset(0)
            make.top.equalToSuperview()
        }
        bubbydmageView.snp.makeConstraints { make in
            make.left.equalTo(nicknamelb)
            make.top.equalTo(nicknamelb.snp.bottom).offset(2.0)
            make.width.equalTo(72.0)
            make.height.equalTo(36.0)
        }
        apngimv.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 7.0, left: 12.0, bottom: 7.0, right: 12.0))
        }
    }
    @objc func clickUserAction() {
        guard let user = self.dataSoure?.user else { return }
        self.delegate?.dg_cellUserAction(userId: user.userId)
    }
}
