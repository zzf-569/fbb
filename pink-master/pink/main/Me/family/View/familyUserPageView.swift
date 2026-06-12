import UIKit
import JXSegmentedView
class familyUserPageView: UIView {
    var dataList: [GuildusInfoModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var page: Int = 0
    var type: Int = 0
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [familyUserPageCell.self])
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kTabBarSafeHeight, right: 0)
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    var dataSoure: GuildItem
    init(model: GuildItem, type: Int) {
        self.dataSoure = model
        self.type = type
        super.init(frame: .zero)
        setViewSnp()
        addRefresh()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func getViewData() {
        GuildNetWork.FamilyMemberCharm(familyId: dataSoure.familyId, page: page, type: type).lmrequest {[weak self] responseModel in
            guard let model = [GuildusInfoModel].deserialize(from: responseModel.data as? [Any]) else { return }
            self?.dataList = model
            self?.tableView.endRefreshing()
        } failureBlock: {[weak self] _ in
            self?.tableView.endRefreshing()
        }
    }
}
private extension familyUserPageView {
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
extension familyUserPageView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        kScaleWidth(80)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: familyUserPageCell.self, cellForRowAt: indexPath)
        cell.delegate = self
        if dataSoure.admin == true || dataSoure.owner == true {
            cell.isAdmin = true
        } else {
            cell.isAdmin = false
        }
        cell.dataSoure = dataList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        RouteService.pushUserMainPage(model.userId, vc: viewController)
    }
}
extension familyUserPageView: GuildUserPageCellDelegate {
    func dg_userOperate(UsInfoItem: GuildusInfoModel) {
        let items: [LMSheetTabModel]
        if UsInfoItem.role == 1 {
            items = [
                LMSheetTabModel(title: "取消管理员"),
                LMSheetTabModel(title: "踢出公会")
            ]
        } else {
            items = [
                LMSheetTabModel(title: "设为管理员"),
                LMSheetTabModel(title: "踢出公会")
            ]
        }
        LMSheetTableVC(title: UsInfoItem.nickname, dataSource: items, cancel: "取消") {[weak self] item in
            guard let item = item, let familyId = self?.dataSoure.familyId else { return }
            var operate = 0
            if item.title == "设为管理员" {
                operate = 1
            } else if item.title == "取消管理员" {
                operate = 2
            } else if item.title == "踢出公会" {
                operate = 0
            }
            GuildNetWork.FamilyOperate(familyId: familyId, memberUserId: UsInfoItem.userId, operate: operate).lmrequest {[weak self] responseModel in
                HUD.show(responseModel.message)
                self?.getViewData()
            } failureBlock: { _ in
            }
        }.show()
    }
}
extension familyUserPageView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
