import UIKit
class BlackLiskViewController: LMBaseVC {
    private var page: Int = 1
    private var isEdit: Bool = false
    var dataList: [UsInfoItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [MineUserTableViewCell.self])
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    lazy var editbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "black_edit"), target: self, action: #selector(editbtnClick))
            .titleColor(lmColorHex("#2B313D"))
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        addRefresh()
    }
    private func setViewSnp() {
        title = "黑名单"
        backgroundImage = nil
        view.backgroundColor = .white
        let BarbtnItem = UIBarButtonItem(customView: editbtn)
        self.navigationItem.rightBarButtonItem = BarbtnItem
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kScaleWidth(16) + kNavigationHeight)
            make.left.right.bottom.equalToSuperview()
        }
    }
    func getViewData() {
        UserNetWork.blockList(page: page).lmrequest {[weak self] responseModel in
            guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]), let self = self else { return }
            guard let list = [UsInfoItem].deserialize(from: model.records) else { return }
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
    @objc func editbtnClick() {
        isEdit = !isEdit
        if isEdit == true {
            editbtn.setImage(nil, for: .normal)
            editbtn.setTitle("保存", for: .normal)
        } else {
            editbtn.setImage(UIImage(named: "black_edit"), for: .normal)
            editbtn.setTitle("", for: .normal)
        }
        let BarbtnItem = UIBarButtonItem(customView: editbtn)
        self.navigationItem.rightBarButtonItem = BarbtnItem
        self.page = 1
        self.getViewData()
    }
}
private extension BlackLiskViewController {
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
extension BlackLiskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: MineUserTableViewCell.self, cellForRowAt: indexPath)
        cell.delegate = self
        cell.dataSoure = dataList[indexPath.row]
        cell.set_Edit(edit: isEdit)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        self.navigationController?.pushViewController(LMUserViewController(user: model), animated: true)
    }
}
extension BlackLiskViewController: MineUserTableViewCellDelegate {
    func dg_editbtnClick(UsInfoItem: UsInfoItem) {
        UserNetWork.block(toUserId: UsInfoItem.userId, block: false).lmrequest {[weak self] _ in
            self?.getViewData()
        } failureBlock: { _ in
        }
    }
}
