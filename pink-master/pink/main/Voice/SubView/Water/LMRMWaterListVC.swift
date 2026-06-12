import UIKit
extension LMRMWaterListVC {
    func refreshList() {
        tableView.headerBeginRefreshing()
    }
}
class LMRMWaterListVC: LMBaseVC {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMRMWaterListCell.self])
        return tableView
    }()
    private let roomId: String
    private let listType:LMRMWaterType
    private var dataSource: [LMRMWaterModel] = []
    private var page: Int = 1
    init(roomId: String, listType:LMRMWaterType) {
        self.roomId = roomId
        self.listType = listType
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.backgroundImage = nil
        self.view.backgroundColor = .clear
        setViewSnp()
        getViewData()
        addRefresh()
        self.navigationController?.navigationBar.isHidden = true
    }
}
private extension LMRMWaterListVC {
    func setViewSnp() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func addRefresh() {
        tableView.addHeader { [weak self] in
            guard let self = self else { return }
            self.page = 1
            self.getViewData()
        }
        tableView.addFooter { [weak self] in
            guard let self = self else { return }
            self.page += 1
            self.getViewData()
        }
        tableView.footerHidden(true)
        tableView.headerBeginRefreshing()
    }
    func getViewData() {
       RoomNetWork.roomWaterFlow(roomId:roomId, page: page, pageSize: AppConfig.pageSize, type: listType.rawValue).lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            if self.page == 1 {
                self.dataSource.removeAll()
            }
            guard let list = [LMRMWaterModel].deserialize(from: (responseModel.data as? [String: Any])?["stateMent"] as? [Any]) else {
                self.refreshList(0)
                return
            }
            self.dataSource.append(contentsOf: list)
            self.refreshList(list.count)
            tableView.confEmptyView(isEmpty: dataSource.count <= 0, model: LMEmptyDataModel(titleColor: lmColorHex("#2B313DA3")))
        } failureBlock: { [weak self] error in
            guard let self = self else { return }
            if self.page > 1 {
                self.page -= 1
            }
            self.refreshList(0)
            tableView.confEmptyView(isEmpty: dataSource.count <= 0, model: LMEmptyDataModel(title: error.message, titleColor: lmColorHex("#2B313DA3")))
        }
    }
    private func refreshList(_ count: Int) {
        self.tableView.endRefreshing()
        if count == AppConfig.pageSize {
            self.tableView.footerHidden(false)
        } else {
            self.tableView.footerHidden(true)
        }
        self.tableView.reloadData()
    }
    func refreshSubviews() {
    }
}
extension LMRMWaterListVC: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType:LMRMWaterListCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(dataSource[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56.0 + 12.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension LMRMWaterListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        self.view
    }
}
