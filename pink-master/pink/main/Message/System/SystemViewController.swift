import UIKit
import ImSDK_Plus
extension SystemViewController {
    func show(_ vc: UIViewController) {
        vc.addChild(self)
        vc.view.addSubview(self.view)
        self.view.frame = CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: vc.view.height)
        UIView.animate(withDuration: 0.3) {
            self.view.x = 0
        } completion: { _ in
        }
    }
    func hide() {
        self.callbackblock()
        UIView.animate(withDuration: 0.3) {
            self.view.x = kScreenWidth
        } completion: { _ in
            self.clear()
        }
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
class SystemViewController: LMBaseVC {
    private let isRoom: Bool
    private let converID: String
    private let imUserId: String
    private var dataSource: [SystemListModel] = []
    private var lastMsg: V2TIMMessage?
    private var pageCount: Int = AppConfig.pageSize
    private let callbackblock: () -> Void
    private lazy var customNavigationView: UIView = {
        let view = UIView().backgroundColor(.clear)
        return view
    }()
    private lazy var backbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "cm_back"), target: self, action: #selector(backbtnAction))
        return btn
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(18.0), textColor: lmColorHex("#2B313D"))
        return lb
    }()
    override var title: String? {
        didSet {
            self.titleLab.text = title
        }
    }
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [SystemCommonCell.self, SystemIncomeCell.self, StstemOutcomeCell.self, UITableViewCell.self])
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    init(_ converID: String, isRoom: Bool, complete block: @escaping () -> Void) {
        self.isRoom = isRoom
        self.converID = converID
        self.imUserId = kImUserId(converID: converID)
        self.callbackblock = block
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage = nil
        view.backgroundColor = .white
        switch self.imUserId {
        case AppConfig.IMConfig.officialIMID:
            self.title =  "官方"
        case AppConfig.IMConfig.walletIMID:
            self.title = "钱包"
        default:
            self.title = ""
        }
        setViewSnp()
        addRefresh()
        IMService.shared.cleanUnreadCount(self.converID) { _, _ in
            IMService.shared.upIMUnCount()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}
private extension SystemViewController {
    func setViewSnp() {
        view.addSubview(customNavigationView)
        customNavigationView.addSubview(backbtn)
        customNavigationView.addSubview(titleLab)
        customNavigationView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(isRoom ? 12 : kStatusBarHeight)
            make.height.equalTo(kNavigationBarHeight)
        }
        backbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32.0)
        }
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(customNavigationView.snp.bottom).offset(12.0)
        }
    }
    func addRefresh() {
        tableView.addHeader { [weak self] in
            guard let self = self else { return }
            self.lastMsg = nil
            self.getViewData()
        }
        tableView.addFooter { [weak self] in
            guard let self = self else { return }
            if let lastMsg = self.dataSource.last?.msg {
                self.lastMsg = lastMsg
            }
            self.getViewData()
        }
        self.tableView.footerHidden(true)
        tableView.headerBeginRefreshing()
    }
    func getViewData() {
        IMService.shared.getC2CHistoryMessageList(imUserId, count: pageCount, lastMsg: self.lastMsg) { [weak self] list, msg in
            guard let self = self else { return }
            if let msg = msg {
                HUD.showFailure(msg)
                self.refreshList(0)
                tableView.confEmptyView(isEmpty: dataSource.count <= 0, model: LMEmptyDataModel(title: msg, titleColor: lmColorHex("#2B313DA3")))
            } else {
                if self.lastMsg == nil {
                    self.dataSource.removeAll()
                }
                let models = list.map { msg -> SystemListModel in
                    SystemListModel(msg: msg)
                }
                self.dataSource.append(contentsOf: models)
                self.refreshList(models.count)
                tableView.confEmptyView(isEmpty: dataSource.count <= 0, model: LMEmptyDataModel(titleColor: lmColorHex("#2B313DA3")))
            }
        }
    }
    private func refreshList(_ count: Int) {
        self.tableView.endRefreshing()
        if count == pageCount {
            self.tableView.footerHidden(false)
        } else {
            self.tableView.footerHidden(true)
        }
        self.tableView.reloadData()
    }
    @objc func backbtnAction() {
        if isRoom {
            self.hide()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension SystemViewController: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        switch model.style {
        case IMSystemMessageStyle.common.rawValue, IMSystemMessageStyle.familyApply.rawValue, IMSystemMessageStyle.reward.rawValue, IMSystemMessageStyle.rule.rawValue:
            let cell = tableView.dequeueReusableCell(cellType: SystemCommonCell.self, cellForRowAt: indexPath)
            cell.setDataSoure(model)
            return cell
        case IMSystemMessageStyle.income.rawValue:
            let cell = tableView.dequeueReusableCell(cellType: SystemIncomeCell.self, cellForRowAt: indexPath)
            cell.setDataSoure(model)
            return cell
        case IMSystemMessageStyle.outcome.rawValue:
            let cell = tableView.dequeueReusableCell(cellType: StstemOutcomeCell.self, cellForRowAt: indexPath)
            cell.setDataSoure(model)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(cellType: UITableViewCell.self, cellForRowAt: indexPath)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row]
        if model.style == IMSystemMessageStyle.common.rawValue || model.style == IMSystemMessageStyle.familyApply.rawValue || model.style == IMSystemMessageStyle.reward.rawValue || model.style == IMSystemMessageStyle.rule.rawValue {
            return UITableView.automaticDimension
        }
        return dataSource[indexPath.row].cellHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataSource[indexPath.row]
        switch model.style {
        case IMSystemMessageStyle.common.rawValue:
            break
        case IMSystemMessageStyle.reward.rawValue:
            break
        case IMSystemMessageStyle.familyApply.rawValue:
            GuildNetWork.MyFamile().lmrequest { [weak self] _ in
            } failureBlock: { _ in
            }
        case IMSystemMessageStyle.income.rawValue:
            self.navigationController?.pushViewController(WalletViewController(), animated: true)
        case IMSystemMessageStyle.outcome.rawValue:
            self.navigationController?.pushViewController(WalletViewController(), animated: true)
        default:
            break
        }
    }
}
