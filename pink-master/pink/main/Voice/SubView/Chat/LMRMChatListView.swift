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
    enum ChatFilter: Int {
        case all
        case room
        case chat
    }

    /// Called after one of the left-side filters is selected. The list itself
    /// keeps its current data source so the room owner can decide how to filter it.
    var onFilterSelected: ((ChatFilter) -> Void)?
    private var selectedFilter: ChatFilter = .all

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
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(51))
            make.right.equalToSuperview().offset(0)
            make.top.bottom.equalToSuperview()
        }

        let filterStack = UIStackView()
        filterStack.axis = .vertical
        filterStack.spacing = 16
        addSubview(filterStack)

        let titles = ["All", "Room", "Chat"]
        for (index, title) in titles.enumerated() {
            let button = LMRMChatFilterButton(title: title)
            button.tag = index
            button.layer.cornerRadius = 11.5
            button.addTarget(self, action: #selector(filterAction(_:)), for: .touchUpInside)
            filterStack.addArrangedSubview(button)
            let heights: [CGFloat] = [51, 72, 63]
            button.snp.makeConstraints { make in
                make.height.equalTo(heights[index])
            }
        }
        filterStack.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(23)
            make.height.equalTo(218)
        }

        // Keep the selector above the table while using the existing left gutter.
        bringSubviewToFront(filterStack)
        updateFilterButtons()
    }

    @objc func filterAction(_ sender: UIButton) {
        guard let filter = ChatFilter(rawValue: sender.tag) else { return }
        selectedFilter = filter
        updateFilterButtons()
        onFilterSelected?(filter)
    }

    func updateFilterButtons() {
        guard let stack = subviews.first(where: { $0 is UIStackView }) as? UIStackView else { return }
        for (index, view) in stack.arrangedSubviews.enumerated() {
            guard let button = view as? LMRMChatFilterButton else { continue }
            let isSelected = index == selectedFilter.rawValue
            button.setSelectedStyle(isSelected)
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

private final class LMRMChatFilterButton: UIButton {
    private let verticalTitleLabel = UILabel()

    init(title: String) {
        super.init(frame: .zero)
        verticalTitleLabel.text = title
        verticalTitleLabel.font = lmFontR(14)
        verticalTitleLabel.textAlignment = .center
        verticalTitleLabel.isUserInteractionEnabled = false
        addSubview(verticalTitleLabel)
        verticalTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
        }
        verticalTitleLabel.transform = CGAffineTransform(rotationAngle: .pi / 2)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSelectedStyle(_ selected: Bool) {
        backgroundColor = selected ? lmColorHex("#8CFF15") : lmColorHex("#40503F")
        verticalTitleLabel.textColor = selected ? lmColorHex("#172019") : .white
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
