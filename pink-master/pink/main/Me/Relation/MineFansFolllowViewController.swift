import UIKit
import JXSegmentedView
class MineFansFolllowViewController: LMBaseVC {
    private var page: Int = 1
    private var isEdit: Bool = false
    var dataList: [UsInfoItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [MineFansCell.self])
        tableView.contentInset = UIEdgeInsets(top: kScaleWidth(12), left: 0, bottom: kTabBarSafeHeight, right: 0)
        return tableView
    }()
    lazy var editbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "black_edit"), target: self, action: #selector(editbtnClick))
            .titleColor(lmColorHex("#2B313D"))
        return btn
    }()
    var userId: String
    var type: Int
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == 1 {
            title = "关注"
        } else {
            title = "粉丝"
        }
        setViewSnp()
        addRefresh()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    required init(userId: String, type: Int) {
        self.userId = userId
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        view.backgroundColor = .white

        if type == 1 {
            let BarbtnItem = UIBarButtonItem(customView: editbtn)
            self.navigationItem.rightBarButtonItem = BarbtnItem
        }
        view.addSubview(tableView)
         tableView.snp.makeConstraints { make in
             make.top.equalToSuperview().offset(kNavigationHeight)
             make.left.right.equalToSuperview()
             make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
         }
    }
    func getViewData() {
        UserNetWork.friendList(type: type, page: page).lmrequest {[weak self] responseModel in
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
private extension MineFansFolllowViewController {
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
extension MineFansFolllowViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        kScaleWidth(80)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: MineFansCell.self, cellForRowAt: indexPath)
        cell.delegale = self
        cell.dataSoure = dataList[indexPath.row]
        cell.set_Edit(edit: isEdit)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        self.navigationController?.pushViewController(LMUserViewController(user: model), animated: true)
    }
    func userUnlike(userId: String) {
        HUD.showLoading()
        UserNetWork.like(toUserId: userId, liked: false).lmrequest { [weak self] _ in
            guard let self = self else { return }
            HUD.hide()
            self.getViewData()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
extension MineFansFolllowViewController: MineFansCellDelegate {
    func dg_userLiked(UsInfoItem: UsInfoItem) {
        HUD.showLoading()
        UserNetWork.like(toUserId: UsInfoItem.userId, liked: true).lmrequest { [weak self] _ in
            guard let self = self else { return }
            HUD.hide()
            self.getViewData()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    func dg_editbtnClick(UsInfoItem: UsInfoItem) {
        HUD.showLoading()
        UserNetWork.like(toUserId: UsInfoItem.userId, liked: false).lmrequest { [weak self] _ in
            guard let self = self else { return }
            HUD.hide()
            self.getViewData()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
extension MineFansFolllowViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
