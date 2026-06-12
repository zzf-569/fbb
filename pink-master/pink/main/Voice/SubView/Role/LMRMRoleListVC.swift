import UIKit
extension LMRMRoleListVC {
}
class LMRMRoleListVC: LMBaseVC {
    private lazy var searchView: UIView = {
        let view = UIView()
            .backgroundColor(lmColorHex("#2B313D", alpha: 0.24))
            .cornerRadius(40/2)
        return view
    }()
    private lazy var searchimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_more_role_search"))
        return imv
    }()
    private lazy var searchTextField: UITextField = {
        let textField = UITextField(lmfont: lmFontM(16), textColor: .white, placeholder: "请输入用户 ID", placeholderColor: lmColorHex("#FFFFFF", alpha: 0.26))
            .keyboardType(.phonePad)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    private lazy var addbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: .white, target: self, action: #selector(addbtnAction))
            .backgroundColor(lmColorHex("#04BE96"))
            .cornerRadius(32/2)
            .lmtitle("添加")
        return btn
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMRMRoleListCell.self])
        return tableView
    }()
    private let roomId: String
    private let role:RMRoleType
    private let listType:RMUserListType
    private var dataSource: [UsInfoItem] = []
    init(roomId: String, role:RMRoleType, listType:RMUserListType) {
        self.roomId = roomId
        self.role = role
        self.listType = listType
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.backgroundImage = nil
        self.view.backgroundColor = .clear
        setViewSnp()
        getViewData()
    }
}
private extension LMRMRoleListVC {
    func setViewSnp() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func addRefresh() {
        self.tableView.addHeader { [weak self] in
            guard let self = self else { return }
            self.getViewData()
        }
    }
    func getViewData() {
       RoomNetWork.userList(roomId:roomId, type: listType.rawValue).lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            let userList = (responseModel.data as? [String: Any])?["userList"]
            guard let list = [UsInfoItem].deserialize(from: userList as? [Any]) else { return }
            self.dataSource = list
            self.refreshSubviews()
            self.tableView.confEmptyView(isEmpty: dataSource.count <= 0)
        } failureBlock: { [weak self] error in
            guard let self = self else { return }
            self.tableView.confEmptyView(isEmpty: dataSource.count <= 0, model: LMEmptyDataModel(title: error.message))
        }
    }
    func refreshSubviews() {
        self.tableView.reloadData()
    }
    @objc func addbtnAction() {
        guard let userId = self.searchTextField.text else {
            HUD.showFailure("请输入用户ID")
            return
        }
        self.searchTextField.resignFirstResponder()
        if listType == .admin {
            HUD.showLoading()
           RoomNetWork.operateUserSetting(roomId:roomId, toUserId: userId, admin: true).lmrequest { [weak self] _ in
                guard let self = self else { return }
                HUD.showSuccess("添加成功")
                self.searchTextField.text = ""
                self.getViewData()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        }
        if listType == .host {
            HUD.showLoading()
           RoomNetWork.operateUserChair(roomId:roomId, toUserId: userId, chair: true).lmrequest { [weak self] _ in
                guard let self = self else { return }
                HUD.showSuccess("添加成功")
                self.searchTextField.text = ""
                self.getViewData()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        }
        if listType == .disableMessage {
            HUD.showLoading()
           RoomNetWork.forbidUser(roomId:roomId, userIdList: [userId], muteTime: 0).lmrequest { [weak self] _ in
                guard let self = self else { return }
                HUD.showSuccess("添加成功")
                self.searchTextField.text = ""
                self.getViewData()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        }
    }
    @objc func removebtnAction(_ btn: UIButton) {
        self.searchTextField.resignFirstResponder()
        let model = self.dataSource[btn.tag]
        if listType == .admin {
            HUD.showLoading()
           RoomNetWork.operateUserSetting(roomId:roomId, toUserId: model.userId, admin: false).lmrequest { [weak self] _ in
                guard let self = self else { return }
                HUD.showSuccess("移除成功")
                self.getViewData()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        }
        if listType == .host {
            HUD.showLoading()
           RoomNetWork.operateUserChair(roomId:roomId, toUserId: model.userId, chair: false).lmrequest { [weak self] _ in
                guard let self = self else { return }
                HUD.showSuccess("移除成功")
                self.getViewData()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        }
        if listType == .disableMessage {
            HUD.showLoading()
           RoomNetWork.forbidUser(roomId:roomId, userIdList: [model.userId], muteTime: 0).lmrequest { [weak self] _ in
                guard let self = self else { return }
                HUD.showSuccess("解禁成功")
                self.getViewData()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        }
    }
}
extension LMRMRoleListVC: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType:LMRMRoleListCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(dataSource[indexPath.row])
        cell.indexPath = indexPath
        if (role == .owner) || (role == .host && listType == .disableMessage) || (role == .admin && listType == .disableMessage) {
            cell.removebtn.isHidden = false
            cell.removebtn.tag = indexPath.row
            cell.removebtn.addTarget(self, action: #selector(removebtnAction), for: .touchUpInside)
        } else {
            cell.removebtn.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56.0 + 24.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = self.dataSource[indexPath.row]
       VoiceShared.roomViewController?.showUserCard(user.userId)
    }
}
extension LMRMRoleListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        self.view
    }
}
