import UIKit
class LMRMChatListJoinCell:LMRMChatListBaseCell {
    private lazy var contentlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#FFFFFFE0"))
            .numberOfLines(0)
        lb.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            guard let user = self.dataSoure?.user else { return }
            self.delegate?.dg_cellUserAction(userId: user.userId)
        }
        return lb
    }()
    lazy var welcomeBtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(10), titleColor: .white)
            .frame(CGRect(x: 0, y: 0, width: 32.0, height: 16.0))
            .backgroundColor(lmColorHex("#FF4F7DFF"))
            .cornerRadius(8)
            .lmtitle("欢迎")
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            guard let user = self.dataSoure?.user else { return }
            self.delegate?.dg_welcomeClick(userId: user.userId)
        }
        return btn
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
        if model.user?.userId != UserShared.user?.userId {
            welcomeBtn.isHidden = false
        } else {
            welcomeBtn.isHidden = true
        }
    }
}
private extension LMRMChatListJoinCell {
    func setViewSnp() {
        self.contentView.addSubview(contentlb)
        self.contentView.addSubview(welcomeBtn)
        contentlb.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-20)
        }
        welcomeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(contentlb)
            make.left.equalTo(contentlb.snp.right)
            make.size.equalTo(CGSize(width: 32, height: 16))
        }
    }
}
