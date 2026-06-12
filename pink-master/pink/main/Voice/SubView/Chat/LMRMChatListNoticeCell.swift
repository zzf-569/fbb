import UIKit
class LMRMChatListNoticeCell:LMRMChatListBaseCell {
    private lazy var contentlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(14), textColor: lmColorHex("#FF4F7D"))
            .numberOfLines(0)
        return lb
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
        self.contentlb.attributed.text = model.content
    }
}
private extension LMRMChatListNoticeCell {
    func setViewSnp() {
        self.contentView.addSubview(contentlb)
        contentlb.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 20.0, right: 0))
        }
    }
}
