import UIKit
extension RankListVC {
    func headerRefreshData() {
        tableView.headerBeginRefreshing()
    }
}
class RankListVC: LMBaseVC {
    private let rankType: RMRANKType
    private let timeType: RMRTimeType
    private var dataSource: [VoiceRankItem] = []
    private var page: Int = 1
    private var pageSize: Int = AppConfig.pageSize
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [RankListCell.self])
        return tableView
    }()
    private lazy var selfInfoView: RankSelfInfoView = {
        let view = RankSelfInfoView()
            .backgroundColor(.white)
            .cornerRadius(12)
        return view
    }()
    init(rankType: RMRANKType, timeType: RMRTimeType) {
        self.rankType = rankType
        self.timeType = timeType
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .clear
        setViewSnp()
    }
}
private extension RankListVC {
    func setViewSnp() {
        view.addSubview(tableView)
        view.addSubview(selfInfoView)
        tableView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 56.0 + 24.0))
        }
        selfInfoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 8))
            make.height.equalTo(kScaleWidth(80))
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
        GiftNetWork.rankList(type: rankType.rawValue, scene: timeType).lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            self.tableView.endRefreshing()
            if self.page == 1 {
                self.dataSource.removeAll()
            }
            guard let rankList = [VoiceRankItem].deserialize(from: (responseModel.data as? [String: Any])?["rankList"] as? [Any]) else { return }
            self.dataSource.append(contentsOf: rankList)
            self.tableView.reloadData()
            self.view.layoutIfNeeded()
            let selfModel = self.dataSource.first(where: { $0.userId == UserShared.user?.userId })
            self.selfInfoView.setDataSoure(selfModel)
            tableView.confEmptyView(isEmpty: dataSource.count <= 0, model: LMEmptyDataModel(titleColor: lmColorHex("#2B313DA3")))
        } failureBlock: { [weak self] error in
            guard let self = self else { return }
            self.tableView.endRefreshing()
            tableView.confEmptyView(isEmpty: dataSource.count <= 0, model: LMEmptyDataModel(title: error.message, titleColor: lmColorHex("#2B313DA3")))
        }
    }
    func refreshSubviews() {
    }
}
extension RankListVC: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56.0 + 24.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: RankListCell.self, cellForRowAt: indexPath)
        var dataSoure = dataSource[indexPath.row]
        dataSoure.rankType = self.rankType == .RY ? "荣誉值" : "人气值"
        cell.setDataSoure(dataSoure)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataSource[indexPath.row]
        RouteService.pushUserMainPage(model.userId, vc: self)
    }
}
extension RankListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
