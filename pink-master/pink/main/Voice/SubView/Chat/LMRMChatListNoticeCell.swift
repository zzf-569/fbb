import UIKit
class LMRMChatListNoticeCell:LMRMChatListBaseCell {
    
    lazy var notiTitle: UIButton = {
        let button = UIButton(image: UIImage(named: "room_msg_noti"))
        button .setTitle("System", for: .normal)
        button.setTitleColor(lmColorHex("#FCFF2C"), for: .normal)
        return button
    }()
    
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
        
        backView.addSubview(notiTitle)
        
        backView.addSubview(contentlb)
        
        notiTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            
        }
        
        contentlb.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 34, left: 10, bottom: 10.0, right: 10))
        }
    }
}
