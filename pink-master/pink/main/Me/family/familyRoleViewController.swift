import UIKit
class familyRoleViewController: LMBaseVC {
    var page: Int = 1
    var dataSoure: GuildItem
    var dataList: [GuildusInfoModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [familyUserPageCell.self])
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    required init(model: GuildItem) {
        self.dataSoure = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setData()
    }
    private func setViewSnp() {
        title = "通知"
        view.backgroundColor = .white
        titleColor = .textDefaulColor
        let btn = UIButton(image: UIImage(named: "cm_back"), target: self, action: #selector(back))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight + 12)
        }
    }
    func setData() {
        GuildNetWork.FamilyadminList(familyId: dataSoure.familyId, page: page).lmrequest {[weak self] responseModel in
            guard let model = [GuildusInfoModel].deserialize(from: responseModel.data as? [Any]) else { return }
            self?.dataList = model
        } failureBlock: { _ in
        }
    }
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension familyRoleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kScaleWidth(80)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: familyUserPageCell.self, cellForRowAt: indexPath)
        cell.delegate = self
        cell.dataSoure = dataList[indexPath.row]
        cell.hotlb.isHidden = true
        if dataSoure.admin == true || dataSoure.owner == true {
            cell.isAdmin = true
        } else {
            cell.isAdmin = false
        }
        return cell
    }
}
extension familyRoleViewController: GuildUserPageCellDelegate {
    func dg_userOperate(UsInfoItem: GuildusInfoModel) {
        let items: [LMSheetTabModel]
            items = [
                LMSheetTabModel(title: "取消管理员"),
                LMSheetTabModel(title: "踢出公会")
            ]
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
                self?.setData()
            } failureBlock: { _ in
            }
        }.show()
    }
}
