import UIKit
class LMBageRecordVC: LMBaseVC {
    var page = 1
    var dataSource: [DressRecordModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMBageRecordCell.self])
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        lmrequestData()
        addRefresh()
    }
    func addRefresh() {
        tableView.addHeader { [weak self] in
            self?.page = 1
            self?.lmrequestData()
        }
        tableView.addFooter { [weak self] in
            self?.page += 1
            self?.lmrequestData()
        }
    }
    private func setViewSnp() {
        title = "记录"
        backgroundImage = nil
        view.backgroundColor = (lmColorHex("#F5F6FAFF"))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight)
            make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
        }
    }
    func lmrequestData() {
        ShopNetWork.getPackageRecord(page: page).lmrequest {[weak self] responseModel in
            self?.tableView.endRefreshing()
            guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]),
                  let list = [DressRecordModel].deserialize(from: model.records), let self = self else {
                return
            }
            self.page == 1 ? self.dataSource = list : self.dataSource.append(contentsOf: list)
            self.tableView.confEmptyView(isEmpty: self.dataSource.count <= 0, model: LMEmptyDataModel(titleColor: .textTerColor))
            self.tableView.footerHidden(model.total <= self.dataSource.count)
        } failureBlock: { _ in
        }
    }
}
extension LMBageRecordVC: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        kScaleWidth(88)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: LMBageRecordCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataSource[indexPath.row]
        return cell
    }
}
