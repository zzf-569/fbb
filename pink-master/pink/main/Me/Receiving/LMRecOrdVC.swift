import UIKit
class LMRecOrdVC: LMBaseVC {
    var dataList: [OrderItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var page: Int = 1
    var status: Int = 0
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMRecOrdersCell.self])
        tableView.estimatedRowHeight = 44
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        tableView.headerBeginRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configSubviews()
        addRefresh()
    }
    private func configSubviews() {
        backgroundImage = nil
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
        }
    }
    func configData() {
        OrderApi.orderReceiveList(page: page, status: status).lmrequest {[weak self] responseModel in
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
}
private extension LMRecOrdVC {
    func addRefresh() {
        tableView.addHeader { [weak self] in
            guard let self = self else { return }
            self.page = 1
            self.configData()
        }
        tableView.addFooter { [weak self] in
            guard let self = self else { return }
            self.page += 1
            self.configData()
        }
        self.tableView.footerHidden(true)
        tableView.headerBeginRefreshing()
    }
}
extension LMRecOrdVC: UITableViewDelegate, UITableViewDataSource, LMRecOrdersCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        kScaleWidth(136)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: LMRecOrdersCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataList[indexPath.row]
        cell.delegate = self
        return cell
    }
    func d_nextClick(model: OrderItem) {
        if model.status == -1 {
            let alert = LMAlertBottomVC(theme: .light, title: "温馨提示", message: "已准备好开始接单吗？", cancel: "拒绝", confirm: "接单") {[weak self] string in
                if string == "接单" {
                    self?.a_orderReceiv(model: model)
                } else {
                    self?.a_orderCancle(model: model)
                }
            }
            alert.cancelbtn.setTitleColor(lmColorHex("#F5455CFF"), for: .normal)
            alert.cancelbtn.backgroundColor = lmColorHex("#2B313D", alpha: 0.04)
            alert.confirmbtn.setTitleColor(lmColorHex("#00DBA9"), for: .normal)
            alert.confirmbtn.backgroundColor = lmColorHex("#DEFCF1")
            alert.show()
        } else if model.status == 0 {
            let alert = LMAlertBottomVC(theme: .light, title: "温馨提示", message: "确定开始订单吗？", cancel: "取消", confirm: "确定") {[weak self] string in
                if string == "确定" {
                    self?.a_orderStar(model: model)
                }
            }
            alert.cancelbtn.setTitleColor(.textDefaulColor, for: .normal)
            alert.cancelbtn.backgroundColor = lmColorHex("#2B313D", alpha: 0.04)
            alert.confirmbtn.setTitleColor(lmColorHex("#00DBA9"), for: .normal)
            alert.confirmbtn.backgroundColor = lmColorHex("#DEFCF1")
            alert.show()
        } else if model.status == 1 {
            let alert = LMAlertBottomVC(theme: .light, title: "温馨提示", message: "请确保已履约订单", cancel: "取消", confirm: "确定") {[weak self] string in
                if string == "确定" {
                    self?.a_orderOver(model: model)
                }
            }
            alert.cancelbtn.setTitleColor(.textDefaulColor, for: .normal)
            alert.cancelbtn.backgroundColor = lmColorHex("#2B313D", alpha: 0.04)
            alert.confirmbtn.setTitleColor(lmColorHex("#00DBA9"), for: .normal)
            alert.confirmbtn.backgroundColor = lmColorHex("#DEFCF1")
            alert.show()
        }
    }
    func d_chatClick(userId: String) {
        RouteService.pushChat(userId, vc: self)
    }
}
private extension LMRecOrdVC {
    func a_orderStar(model: OrderItem) {
        OrderApi.submit(orderNo: model.orderNo, status: 1).lmrequest {[weak self] _ in
            self?.configData()
        } failureBlock: { _ in
        }
    }
    func a_orderReceiv(model: OrderItem) {
        OrderApi.submit(orderNo: model.orderNo, status: 0).lmrequest {[weak self] _ in
            self?.configData()
        } failureBlock: { _ in
        }
    }
    func a_orderCancle(model: OrderItem) {
        OrderApi.submit(orderNo: model.orderNo, status: 4).lmrequest {[weak self] _ in
            self?.configData()
        } failureBlock: { _ in
        }
    }
    func a_orderOver(model: OrderItem) {
        OrderApi.submit(orderNo: model.orderNo, status: 3).lmrequest {[weak self] _ in
            self?.configData()
        } failureBlock: { _ in
        }
    }
}
extension LMRecOrdVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
