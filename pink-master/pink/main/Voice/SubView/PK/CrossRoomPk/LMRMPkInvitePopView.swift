import UIKit
extension LMRMPkInvitePopView {
    func show(_ vc: UIViewController? = nil) {
        if let viewController = vc {
            viewController.addChild(self)
            viewController.view.addSubview(self.view)
        } else {
            UIViewController.current?.addChild(self)
            UIViewController.current?.view.addSubview(self.view)
        }
        self.view.frame = UIScreen.main.bounds
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
    func hide(_ roomItem:RoomItem? = nil) {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            if let model = roomItem {
                self.selectedPKRoomblock?(model)
            }
            self.clear()
        }
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
class LMRMPkInvitePopView: UIViewController {
    private let roomId: String
    var page = 1
    var dataSource: [RoomItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedPKRoomblock: ((RoomItem) -> Void)?
    public init(roomId: String) {
        self.roomId = roomId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setViewSnp()
        lmrequestData()
        addRefresh()
        Mediator.shared.register(event: LMRMViewMethon.invitebtnClick) { (model: RoomItem) in
            self.hide(model)
        }
    }
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
        imv.addGestureTap { [weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
            }
        return imv
    }()
    private lazy var titleV: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var closebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_popclose"), target: self, action: #selector(closehbtnAction))
        return btn
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(18), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .textAlignment(.center)
            .lmtext("PK邀请")
        return lb
    }()
    private lazy var refreshbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_rank_refresh"), target: self, action: #selector(refershbtnAction))
        return btn
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMRMCrossPkInviteCell.self])
        return tableView
    }()
}
private extension LMRMPkInvitePopView {
    private func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(bodyimv)
        bdView.addSubview(titleV)
        bdView.addSubview(tableView)
        titleV.addSubview(titleLab)
        titleV.addSubview(closebtn)
        titleV.addSubview(refreshbtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(0)
            make.height.equalTo(530.0 + kTabBarSafeHeight)
        }
        bodyimv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(56.0)
        }
        titleLab.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        closebtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36.0)
        }
        refreshbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36.0)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleV.snp.bottom)
            make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
        }
        view.layoutIfNeeded()
        bdView.set_Border(radius: 16.0, conrners: [.topLeft, .topRight])
    }
    func addRefresh() {
        tableView.addHeader { [weak self] in
            self?.page = 1
            self?.lmrequestData()
        }
        tableView.addFooter { [weak self] in
            self?.page += 1
            self?.lmrequestData()
        }
    }
    func lmrequestData() {
       RoomPKNetWork.roompklist(roomId:roomId, page: 1).lmrequest {[weak self] responseModel in
            self?.tableView.endRefreshing()
            guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]),
            let list = [RoomItem].deserialize(from: model.records), let self = self else {
                return
            }
            self.page == 1 ? self.dataSource = list : self.dataSource.append(contentsOf: list)
            self.tableView.confEmptyView(isEmpty: self.dataSource.count <= 0, model: LMEmptyDataModel(titleColor: .textTerColor))
            self.tableView.footerHidden(model.total <= self.dataSource.count)
        } failureBlock: { _ in
        }
    }
    @objc func closehbtnAction() {
        self.hide()
    }
    @objc func refershbtnAction() {
        tableView.headerBeginRefreshing()
    }
}
extension LMRMPkInvitePopView: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType:LMRMCrossPkInviteCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        kScaleWidth(80)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
