import UIKit
extension LMRMChatListView {
    func addMessage(_ model:VoiceChatListModel) {
        self.dataSource.append(model)
        self.tableView.insertRows(at: [IndexPath(row: self.dataSource.count - 1, section: 0)], with: .none)
        self.scrollToBottom()
    }
    func reConfigUI() {
        self.dataSource.removeAll()
        self.tableView.reloadData()
        self.scrollToBottom()
    }
}
class LMRMChatListView: UIView {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMRMChatListNormalCell.self,LMRMChatListNoticeCell.self,LMRMChatListJoinCell.self,VoiceChatEmojiCell.self])
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    private var dataSource: [VoiceChatListModel] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMChatListView {
    private func setViewSnp() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func scrollToBottom() {
        DispatchQueue.main.async {
            if self.dataSource.count > 0 {
                let indexPath = IndexPath(row: self.dataSource.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}
extension LMRMChatListView: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        if model.cellStyle == .normal {
            let cell = tableView.dequeueReusableCell(cellType:LMRMChatListNormalCell.self, cellForRowAt: indexPath)
            cell.indexPath = indexPath
            cell.delegate = self
            cell.setDataSoure(model)
            return cell
        }
        if model.cellStyle == .notice {
            let cell = tableView.dequeueReusableCell(cellType:LMRMChatListNoticeCell.self, cellForRowAt: indexPath)
            cell.indexPath = indexPath
            cell.delegate = self
            cell.setDataSoure(model)
            return cell
        }
        if model.cellStyle == .join {
            let cell = tableView.dequeueReusableCell(cellType:LMRMChatListJoinCell.self, cellForRowAt: indexPath)
            cell.indexPath = indexPath
            cell.delegate = self
            cell.setDataSoure(model)
            return cell
        }
        if model.cellStyle == .emoji {
            let cell = tableView.dequeueReusableCell(cellType:VoiceChatEmojiCell.self, cellForRowAt: indexPath)
            cell.indexPath = indexPath
            cell.delegate = self
            cell.setDataSoure(model)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        dataSource[indexPath.row].cellHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension LMRMChatListView:LMRMChatListCellDelegate {
    func dg_welcomeClick(userId: String) {
        Mediator.shared.dispatch(event: LMRMViewMethon.chatListWelcomeUser, data: userId)
    }
    func dg_cellUserAction(userId: String) {
        Mediator.shared.dispatch(event: LMRMViewMethon.chatListClickUser, data: userId)
    }
    func dg_cellEmojiPlay(indexPath: IndexPath) {
        dataSource[indexPath.row].emojiModel?.isPlayed = true
    }
}
