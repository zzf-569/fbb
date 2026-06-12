import UIKit
class MyfamilyApplyViewController: LMBaseVC {
    var page: Int = 1
    var familyId: Int = 0
    var dataList: [GuildApplyModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMFamApplyTableViewCell.self])
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
    required init(familyId: Int) {
        self.familyId = familyId
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
        GuildNetWork.FamilyApplyList(familyId: familyId, page: page).lmrequest {[weak self] responseModel in
            let PageItem = responseModel.data as! [String: Any]
            guard let list = [GuildApplyModel].deserialize(from: PageItem["list"] as? [Any]) else { return }
            self?.dataList = list
        } failureBlock: { _ in
        }
    }
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension MyfamilyApplyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kScaleWidth(80)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: LMFamApplyTableViewCell.self, cellForRowAt: indexPath)
        cell.delegate = self
        cell.dataSoure = dataList[indexPath.row]
        return cell
    }
}
extension MyfamilyApplyViewController: LMFamApplyTableViewCellDelegate {
    func dg_userApply(UsInfoItem: GuildApplyModel) {
        let items = [
            LMSheetTabModel(title: "同意"),
            LMSheetTabModel(title: "拒绝", titleColor: "#D43F54")
        ]
        if UsInfoItem.applyType == 0 {
            let sheet = LMSheetTableVC(title: "\(UsInfoItem.nickname)申请加入公会", dataSource: items, cancel: "") { item in
                var optype = 0
                if item?.title == "同意" {
                    optype = 1
                    GuildNetWork.FamilyApplyDeal(applyId: UsInfoItem.applyId, opType: optype).lmrequest {[weak self] _ in
                        self?.setData()
                    } failureBlock: { _ in
                    }
                } else if item?.title == "拒绝" {
                    optype = 0
                    GuildNetWork.FamilyApplyDeal(applyId: UsInfoItem.applyId, opType: optype).lmrequest {[weak self] _ in
                        self?.setData()
                    } failureBlock: { _ in
                    }
                }
            }
            sheet.show()
            self.navigationController?.navigationBar.isHidden = false
        } else {
            let sheet = LMSheetTableVC(title: "\(UsInfoItem.nickname)申请退出公会", dataSource: items, cancel: "") { item in
                var optype = 0
                if item?.title == "同意" {
                    optype = 1
                    GuildNetWork.FamilyApplyDeal(applyId: UsInfoItem.applyId, opType: optype).lmrequest {[weak self] _ in
                        self?.setData()
                    } failureBlock: { _ in
                    }
                } else if item?.title == "拒绝" {
                    optype = 0
                    GuildNetWork.FamilyApplyDeal(applyId: UsInfoItem.applyId, opType: optype).lmrequest {[weak self] _ in
                        self?.setData()
                    } failureBlock: { _ in
                    }
                }
            }
            sheet.show()
            self.navigationController?.navigationBar.isHidden = false
        }
    }
}
