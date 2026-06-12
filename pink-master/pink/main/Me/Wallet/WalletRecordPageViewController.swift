import UIKit
import JXPagingView
class WalletRecordPageViewController: LMBaseVC {
    private var page: Int = 1
    var dataList: [WalletRecordsItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [WalletRecordCell.self])
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kTabBarSafeHeight, right: 0)
        return tableView
    }()
    var type: Int = 0
    init(type: Int) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        addRefresh()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    private func setViewSnp() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func getViewData() {
        if type == 0 {
            WalletNetWork.WalletCoinList(page: 1).lmrequest {[weak self] responseModel in
                guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]), let self = self else { return }
                guard let list = [WalletRecordsItem].deserialize(from: model.records) else { return }
                self.dataList = list
                self.tableView.endRefreshing()
                self.tableView.footerHidden(model.pages <= self.page)
                tableView.confEmptyView(isEmpty: dataList.count <= 0, model: LMEmptyDataModel(titleColor: lmColorHex("#2B313DA3")))
            } failureBlock: {[weak self] error in
                guard let self = self else { return }
                self.tableView.endRefreshing()
                tableView.confEmptyView(isEmpty: dataList.count <= 0, model: LMEmptyDataModel(title: error.message, titleColor: lmColorHex("#2B313DA3")))
            }
        } else {
            WalletNetWork.WalletCashList(page: 1).lmrequest {[weak self] responseModel in
                guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]), let self = self else { return }
                guard let list = [WalletRecordsItem].deserialize(from: model.records) else { return }
                self.dataList = list
                self.tableView.endRefreshing()
                self.tableView.footerHidden(model.pages <= self.page)
                tableView.confEmptyView(isEmpty: dataList.count <= 0, model: LMEmptyDataModel(titleColor: lmColorHex("#2B313DA3")))
            } failureBlock: {[weak self] error in
                guard let self = self else { return }
                self.tableView.endRefreshing()
                tableView.confEmptyView(isEmpty: dataList.count <= 0, model: LMEmptyDataModel(title: error.message, titleColor: lmColorHex("#2B313DA3")))
            }
        }
    }
}
private extension WalletRecordPageViewController {
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
        self.tableView.footerHidden(true)
        tableView.headerBeginRefreshing()
    }
}
extension WalletRecordPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        kScaleWidth(88)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: WalletRecordCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataList[indexPath.row]
        return cell
    }
}
extension WalletRecordPageViewController: JXPagingViewListViewDelegate {
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        listViewDidScrollCallback = callback
    }
    func listView() -> UIView {
        return view
    }
    func listScrollView() -> UIScrollView { tableView }
}
