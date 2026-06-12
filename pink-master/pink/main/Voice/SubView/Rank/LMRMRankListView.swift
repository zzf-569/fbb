import UIKit
class LMRMRankListView: UIView {
    private let rankType:RMRANKType
    private let timeType:RMRTimeType
    private var dataSource: [VoiceRankItem] = []
    private var page: Int = 1
    private var pageSize: Int = AppConfig.pageSize
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMRMRankListCell.self])
        return tableView
    }()
    init(rankType:RMRANKType, timeType:RMRTimeType, frame: CGRect) {
        self.rankType = rankType
        self.timeType = timeType
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LMRMRankListView {
    func reConfigUI() {
        self.page = 1
        self.dataSource.removeAll()
        self.tableView.reloadData()
        tableView.confEmptyView(isEmpty: dataSource.count <= 0)
    }
    func refreshList() {
        tableView.headerBeginRefreshing()
    }
}
private extension LMRMRankListView {
    private func setViewSnp() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addRefresh()
    }
    func addRefresh() {
        tableView.addHeader { [weak self] in
            self?.page = 1
            self?.lmrequestData()
        }
        tableView.headerBeginRefreshing()
    }
    func lmrequestData() {
        guard let roomId = VoiceShared.roomViewController?.viewModel.roomItem.roomId else { self.tableView.endRefreshing(); return }
        GiftNetWork.rankList(roomId:roomId, type: rankType.rawValue, scene: timeType).lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            self.tableView.endRefreshing()
            if self.page == 1 {
                self.dataSource.removeAll()
            }
            guard let rankList = [VoiceRankItem].deserialize(from: (responseModel.data as? [String: Any])?["rankList"] as? [Any]) else { return }
            self.dataSource.append(contentsOf: rankList)
            self.tableView.reloadData()
            self.tableView.confEmptyView(isEmpty: self.dataSource.count <= 0)
        } failureBlock: { [weak self] error in
            guard let self = self else { return }
            self.tableView.confEmptyView(isEmpty: self.dataSource.count <= 0, model: LMEmptyDataModel(title: error.message))
            self.tableView.endRefreshing()
        }
    }
}
extension LMRMRankListView: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56.0 + 24.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType:LMRMRankListCell.self, cellForRowAt: indexPath)
        var dataSoure = dataSource[indexPath.row]
        dataSoure.rankType = self.rankType == .RY ? "荣誉值" : "人气值"
        cell.setDataSoure(dataSoure)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Mediator.shared.dispatch(event: LMRMViewMethon.rankViewUserAction, data: self.dataSource[indexPath.row])
    }
}
extension LMRMRankListView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
