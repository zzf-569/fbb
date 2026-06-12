import UIKit
import JXSegmentedView
class PartnerOrderViewController: LMBaseVC {
    var dataList: [OrderItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var page: Int = 1
    var status: Int = 0
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [PartnerOrderTableViewCell.self])
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.headerBeginRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        set_Subviews()
        addRefresh()
    }
    private func set_Subviews() {
        backgroundImage = nil
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
        }
    }
    func setDataSoure() {
        OrderApi.orderList(page: page, status: status).lmrequest {[weak self] responseModel in
            self?.tableView.endRefreshing()
            guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]), let self = self else { return }
            guard let list = [OrderItem].deserialize(from: model.records) else { return }
            self.dataList = list
            if self.page >= model.pages {
                self.tableView.footerHidden(true)
            } else {
                self.tableView.footerHidden(false)
            }
            tableView.confEmptyView(isEmpty: dataList.count <= 0, model: LMEmptyDataModel(titleColor: lmColorHex("#2B313DA3")))
        } failureBlock: {[weak self] error in
            guard let self = self else { return }
            self.tableView.endRefreshing()
            tableView.confEmptyView(isEmpty: dataList.count <= 0, model: LMEmptyDataModel(title: error.message, titleColor: lmColorHex("#2B313DA3")))
        }
    }
    @objc func a_backItemDidiClick() {
        self.navigationController?.popToViewControllerAtIndex(index: 1)
    }
}
private extension PartnerOrderViewController {
    func addRefresh() {
        tableView.addHeader { [weak self] in
            guard let self = self else { return }
            self.page = 1
            self.setDataSoure()
        }
        tableView.addFooter { [weak self] in
            guard let self = self else { return }
            self.page += 1
            self.setDataSoure()
        }
        self.tableView.footerHidden(true)
        tableView.headerBeginRefreshing()
    }
}
extension PartnerOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        kScaleWidth(136)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: PartnerOrderTableViewCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataList[indexPath.row]
        cell.delegale = self
        return cell
    }
}
extension PartnerOrderViewController: PartnerOrderTableViewCellDelegate {
    func d_chatClick(userId: String) {
        RouteService.pushChat(userId, vc: self)
    }
}
extension PartnerOrderViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
