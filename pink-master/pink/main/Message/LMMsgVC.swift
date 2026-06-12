import UIKit
import TUIChat
extension LMMsgVC {
}
class LMMsgVC: LMBaseVC {
    private let isRoom: Bool
    private let viewModel = LMMessageViewModel()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: .white)
            .lmtext("聊一聊")
        return lb
    }()
    lazy var likeMe: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "msg_ord"), for: .normal)
        btn.addTarget(self, action: #selector(turnLike), for: .touchUpInside)
        return btn
    }()
    lazy var meLike: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "msg_myord"), for: .normal)
        btn.addTarget(self, action: #selector(turnLikeMe), for: .touchUpInside)
        return btn
    }()
    private lazy var clearbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "msg_clear"), target: self, action: #selector(clearbtnAction))
        return btn
    }()
    lazy var centerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: kNavigationHeight, width: kScreenWidth, height: kScreenHeight - kNavigationHeight))
        view.backgroundColor(lmColorHex("#F3F3F5FF"))
        view.set_Border(radius: 12, conrners: [.topLeft, .topRight])
        return view
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMMessageListCell.self])
        tableView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavigationHeight)
        tableView.backgroundColor(lmColorHex("#F3F3F5FF"))
        return tableView
    }()
    init(isRoom: Bool) {
        self.isRoom = isRoom
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage = UIImage(named: "msg_bg")
        setViewSnp()
        getViewData()
        viewModel.block = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        viewModel.getCustomer()
    }
}
private extension LMMsgVC {
    func setViewSnp() {
        view.backgroundColor = lmColorHex("#F3F3F5FF")
        view.addSubview(centerView)
        view.addSubview(titleLab)
        view.addSubview(clearbtn)
        centerView.addSubview(likeMe)
        centerView.addSubview(meLike)
        centerView.addSubview(tableView)
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(isRoom ? 12 : kStatusBarHeight + 8)
            make.size.equalTo(CGSize(width: 72, height: 36))
        }
        clearbtn.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right).offset(8)
            make.centerY.equalTo(titleLab)
            make.width.height.equalTo(32.0)
        }
        centerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(isRoom ? 20 : kNavigationHeight)
            make.bottom.equalToSuperview().offset(isRoom ? -kTabBarSafeHeight : 0)
        }
        likeMe.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: kScaleWidth(168), height: kScaleWidth(72)))
        }
        meLike.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: kScaleWidth(168), height: kScaleWidth(72)))
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(108))
            make.bottom.equalToSuperview().offset(0)
        }
        if isRoom {
            backgroundImage = nil
            view.backgroundColor = lmColorHex("#F3F3F5FF")
            titleLab.isHidden = true
            clearbtn.isHidden = true
            tableView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(kScaleWidth(20))
                make.bottom.equalToSuperview().offset(0)
            }
            view.layoutIfNeeded()
            self.view.set_Border(radius: 16.0, conrners: [.topLeft, .topRight])
        }
    }
    func getViewData() {
    }
    func refreshSubviews() {
    }
    @objc func turnLike() {
        self.navigationController?.pushViewController(OrderPageViewController(), animated: true)
    }
    @objc func turnLikeMe() {
        self.navigationController?.pushViewController(LMRecOrdPageVC(), animated: true)
    }
    @objc func clearbtnAction() {
        let items = [
            LMSheetTabModel(title: "全部标记为已读"),
            LMSheetTabModel(title: "全部清空")
        ]
        let sheet = LMSheetTableVC(title: "消息设置", dataSource: items, cancel: "") { item in
            guard let item = item else { return }
            if item.title == "全部标记为已读" {
                IMService.shared.cleanUnreadCount { _, _ in
                    IMService.shared.upIMUnCount()
                    self.viewModel.getConversationList()
                }
            }
            if item.title == "全部清空" {
                let converIDList = self.viewModel.dataSource.map { $0.converID }
                IMService.shared.deleteConversationList(converIDList) { _, _ in
                    IMService.shared.upIMUnCount()
                    self.viewModel.getConversationList()
                }
            }
        }
        sheet.show(AppConfig.keyWindow.rootViewController)
    }
    func deletebtnAction(userId: String) {
        IMService.shared.deleteConversation(userId) { _, _ in
            IMService.shared.upIMUnCount()
            self.viewModel.getConversationList()
        }
    }
}
extension LMMsgVC: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: LMMessageListCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(viewModel.dataSource[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        12.0 + 56.0 + 12.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel.dataSource[indexPath.row]
        if model.converID == kConversationId(imUserId: AppConfig.IMConfig.officialIMID) || model.converID == kConversationId(imUserId: AppConfig.IMConfig.walletIMID) {
            let system = SystemViewController(model.converID, isRoom: isRoom) {[weak self] in
                self?.viewModel.getCustomer()
            }
            if isRoom {
                system.show(self)
            } else {
                self.navigationController?.pushViewController(system, animated: true)
            }
        } else if model.converID == kConversationId(imUserId: AppConfig.IMConfig.customUserId) {
            let view = CustomChatController(kImUserId(converID: model.converID), isRoom: isRoom)
            if isRoom {
                view.show(self)
            } else {
                self.navigationController?.pushViewController(view, animated: true)
            }
        } else {
            let chat = ChatViewController(kUserId(converID: model.converID), isRoom: isRoom) {[weak self] in
                self?.viewModel.getCustomer()
            }
            if isRoom {
                chat.show(self)
            } else {
                self.navigationController?.pushViewController(chat, animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let model = viewModel.dataSource[indexPath.row]
        if model.converID == kConversationId(imUserId: AppConfig.IMConfig.dispatchIMID) {
            return false
        }
        return true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let model = viewModel.dataSource[indexPath.row]
        let ex = UIContextualAction(style: .normal, title: "") {[weak self]
            (_, _, completionHandler) in
            self?.deletebtnAction(userId: model.converID)
            completionHandler(true)
        }
        ex.backgroundColor = .white.withAlphaComponent(0)
        ex.image = UIImage(named: "me_fans_dele")
        let config = UISwipeActionsConfiguration(actions: [ex])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}
