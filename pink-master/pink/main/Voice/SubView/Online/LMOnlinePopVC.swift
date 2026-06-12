import UIKit
extension LMOnlinePopVC {
    @discardableResult
    static func show(roomId: String, role:RMRoleType, userblock: @escaping (UsInfoItem) -> Void, onSeatblock: @escaping (UsInfoItem) -> Void) ->LMOnlinePopVC {
        let pop = LMOnlinePopVC(roomId:roomId, role: role, userblock: userblock, onSeatblock: onSeatblock)
        UIViewController.current?.addChild(pop)
        UIViewController.current?.view.addSubview(pop.view)
        pop.view.frame = UIScreen.main.bounds
        return pop
    }
}
class LMOnlinePopVC: UIViewController {
    private lazy var bgView: UIView = {
        let view = UIView()
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var bdView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var bodyimv: UIImageView = {
        let imv = UIImageView()
        let effec = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effec)
        imv.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return imv
    }()
    private lazy var titleV: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .white)
            .lmtext("在线用户")
        return lb
    }()
    private lazy var countlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFF", alpha: 0.4))
            .lmtext("(0)")
        return lb
    }()
    private lazy var refreshbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_list_refresh"), target: self, action: #selector(refreshbtnAction))
        return btn
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMRMOnlineCell.self])
        return tableView
    }()
    private var dataSource: [UsInfoItem] = []
    private let roomId: String
    private let role:RMRoleType
    private let userblock: (UsInfoItem) -> Void
    private let onSeatblock: (UsInfoItem) -> Void
    init(roomId: String, role:RMRoleType, userblock: @escaping (UsInfoItem) -> Void, onSeatblock: @escaping (UsInfoItem) -> Void) {
        self.roomId = roomId
        self.role = role
        self.userblock = userblock
        self.onSeatblock = onSeatblock
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        addRefresh()
        setViewSnp()
        getViewData()
        show()
    }
}
private extension LMOnlinePopVC {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(bodyimv)
        bdView.addSubview(titleV)
        bdView.addSubview(tableView)
        titleV.addSubview(titleLab)
        titleV.addSubview(countlb)
        titleV.addSubview(refreshbtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(0)
            make.height.equalTo(kScaleWidth(640))
        }
        bodyimv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(92.0)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleV.snp.bottom)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.0)
            make.top.equalToSuperview().offset(44)
        }
        countlb.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right).offset(4.0)
            make.top.equalToSuperview().offset(44)
        }
        refreshbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20.0)
            make.top.equalToSuperview().offset(44)
            make.width.height.equalTo(20.0)
        }
        view.layoutIfNeeded()
        bdView.set_Border(radius: 16.0, conrners: [.topLeft, .topRight])
        let lineView = UIView().backgroundColor(lmColorHex("#FFFFFF3D"))
            .cornerRadius(2)
        bdView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(8))
            make.size.equalTo(CGSize(width: 48, height: 4))
        }
    }
    func addRefresh() {
        tableView.addHeader { [weak self] in
            self?.getViewData()
        }
    }
    func getViewData() {
       RoomNetWork.userList(roomId:roomId).lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            let userList = (responseModel.data as? [String: Any])?["userList"]
            guard let list = [UsInfoItem].deserialize(from: userList as? [Any]) else { return }
            self.dataSource = list
            self.refreshSubviews()
            tableView.confEmptyView(isEmpty: dataSource.count <= 0)
        } failureBlock: { [weak self] error in
            guard let self = self else { return }
            tableView.confEmptyView(isEmpty: dataSource.count <= 0, model: LMEmptyDataModel(title: error.message))
        }
    }
    func refreshSubviews() {
        self.countlb.text = "(\(self.dataSource.count))"
        self.tableView.reloadData()
        self.tableView.endRefreshing()
    }
    @objc func refreshbtnAction() {
        tableView.headerBeginRefreshing()
    }
    @objc func onSeatbtnAction(btn: UIButton) {
        let model = dataSource[btn.tag]
        self.onSeatblock(model)
        self.hide()
    }
    func show() {
        UIView.animate(withDuration: 0.3) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}
extension LMOnlinePopVC: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType:LMRMOnlineCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(dataSource[indexPath.row])
        cell.indexPath = indexPath
        cell.arrowimv.isHidden = role != .audience
        cell.onSeatbtn.isHidden = role == .audience
        if dataSource[indexPath.row].userId == UserShared.user?.userId {
            cell.onSeatbtn.isHidden = true
        }
        if let _ = VoiceShared.roomViewController?.viewModel.userSeatInfo(dataSource[indexPath.row].userId) {
            cell.onSeatbtn.isHidden = true
        }
        cell.onSeatbtn.tag = indexPath.row
        cell.onSeatbtn.addTarget(self, action: #selector(onSeatbtnAction), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56.0 + 24.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.userblock(dataSource[indexPath.row])
        self.hide()
    }
}
