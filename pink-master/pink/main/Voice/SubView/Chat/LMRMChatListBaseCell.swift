import UIKit
protocol LMRMChatListCellDelegate: NSObjectProtocol {
    func dg_cellUserAction(userId: String)
    func dg_cellEmojiPlay(indexPath: IndexPath)
    func dg_welcomeClick(userId: String)
}
class LMRMChatListBaseCell: LMBaseTableViewCell {
    lazy var backView: UIView = {
        let view = UIView().backgroundColor(lmColorHex("#FFFFFF", alpha: 0.08))
        view.set_Border(radius: 8)
        return view
    }()
    weak var delegate:LMRMChatListCellDelegate?
    var dataSoure:VoiceChatListModel?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setDataSoure(_ model:VoiceChatListModel) {
        self.dataSoure = model
        self.dataSoure?.clickUserblock = { [weak self] userId in
            guard let self = self else { return }
            self.delegate?.dg_cellUserAction(userId: userId)
        }
    }
}
