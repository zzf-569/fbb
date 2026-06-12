import UIKit
extension LMRMDaRanSortView {
    func setDataSoure(_ list: [UsInfoItem]) {
        self.dataSource = list
        self.tableView.reloadData()
        tableView.confEmptyView(isEmpty: dataSource.count <= 0)
    }
    func show() {
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        }completion: { _ in
            self.isHidden = true
        }
    }
}
class LMRMDaRanSortView: UIView {
    private var roomId: String
    private var dataSource: [UsInfoItem] = []
    var isInSequence: Bool = false {
        didSet {
            applyOnSeatbtn.isSelected = isInSequence
        }
    }
    var isOnSeat: Bool = false {
        didSet {
            updateStatus()
        }
    }
    var role:RMRoleType = .audience {
        didSet {
            updateStatus()
        }
    }
    private func updateStatus() {
        if role == .audience {
            self.clearSequencebtn.isHidden = true
            self.clearSeatsbtn.isHidden = true
            self.allOnSeatbtn.isHidden = true
            self.clearSeatsbtn.snp.updateConstraints { make in
                make.height.equalTo(0.0)
            }
            self.allOnSeatbtn.snp.updateConstraints { make in
                make.height.equalTo(0.0)
            }
            if isOnSeat {
                self.applyOnSeatbtn.isHidden = true
                self.tableView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-(8.0 + kTabBarSafeHeight))
                }
                self.applyOnSeatbtn.snp.updateConstraints { make in
                    make.height.equalTo(0.0)
                }
            } else {
                self.applyOnSeatbtn.isHidden = false
                self.tableView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-(8.0 + 48.0 + 8.0 + kTabBarSafeHeight))
                }
                self.applyOnSeatbtn.snp.updateConstraints { make in
                    make.height.equalTo(48.0)
                }
            }
        } else {
            self.clearSequencebtn.isHidden = false
            self.clearSeatsbtn.isHidden = false
            self.allOnSeatbtn.isHidden = false
            self.applyOnSeatbtn.isHidden = true
            self.tableView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-(8.0 + 48.0 + 8.0 + kTabBarSafeHeight))
            }
            self.clearSeatsbtn.snp.updateConstraints { make in
                make.height.equalTo(48.0)
            }
            self.allOnSeatbtn.snp.updateConstraints { make in
                make.height.equalTo(48.0)
            }
            self.applyOnSeatbtn.snp.updateConstraints { make in
                make.height.equalTo(0.0)
            }
        }
        tableView.reloadData()
    }
    init(frame: CGRect = .zero, roomId: String) {
        self.roomId = roomId
        super.init(frame: frame)
        self.set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var bgView: UIView = {
        let view = UIView(frame: self.bounds)
            .alpha(0)
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var bdView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.height, width: self.width, height: self.height/3*2))
        view.set_Border(radius: 24.0, conrners: [.topLeft, .topRight])
        return view
    }()
    private lazy var bodyimv: UIImageView = {
        let imv = UIImageView()
            .backgroundColor(.clear)
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
        let lb = UILabel(lmfont: lmFontM(18), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .textAlignment(.center)
            .lmtext("麦下达人")
        return lb
    }()
    private lazy var closebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_pop_close"), target: self, action: #selector(a_closehbtnAction))
        return btn
    }()
    private lazy var clearSequencebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: lmColorHex("#FFFFFF", alpha: 0.96), target: self, action: #selector(a_clearSequencebtnAction))
            .lmtitle("清空排挡")
        return btn
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMRMDaRanSortCell.self])
        return tableView
    }()
    private lazy var clearSeatsbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_dispatch_sequence_clear_seat"), target: self, action: #selector(a_clearSeatbtnAction))
        return btn
    }()
    private lazy var allOnSeatbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_dispatch_sequence_all_on_seat"), target: self, action: #selector(a_allOnSeatbtnAction))
        return btn
    }()
    private lazy var applyOnSeatbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_dispatch_sequence_apply_on_seat"), target: self, action: #selector(a_applyOnSeatbtnAction))
            .image(UIImage(named: "rm_dispatch_sequence_cancel_on_seat"), .selected)
        return btn
    }()
}
private extension LMRMDaRanSortView {
    private func set_Subviews() {
        addSubview(bgView)
        addSubview(bdView)
        bdView.addSubview(bodyimv)
        bdView.addSubview(titleV)
        bdView.addSubview(tableView)
        bdView.addSubview(clearSeatsbtn)
        bdView.addSubview(allOnSeatbtn)
        bdView.addSubview(applyOnSeatbtn)
        titleV.addSubview(closebtn)
        titleV.addSubview(titleLab)
        titleV.addSubview(clearSequencebtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.snp.bottom).offset(0)
            make.height.equalTo(kScreenHeight/3*2)
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
        clearSequencebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(68.0)
            make.height.equalTo(28.0)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleV.snp.bottom).offset(8.0)
            make.bottom.equalToSuperview().offset(-(8.0 + 48.0 + 8.0 + kTabBarSafeHeight))
        }
        clearSeatsbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 8.0))
            make.width.equalTo(142.0)
            make.height.equalTo(0.0)
        }
        allOnSeatbtn.snp.makeConstraints { make in
            make.left.equalTo(clearSeatsbtn.snp.right).offset(16.0)
            make.bottom.equalTo(clearSeatsbtn)
            make.right.equalToSuperview().offset(-16.0)
            make.height.equalTo(0.0)
        }
        applyOnSeatbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 8.0))
            make.height.equalTo(0.0)
        }
        self.layoutIfNeeded()
    }
    @objc func a_closehbtnAction() {
        self.hide()
    }
    @objc func a_clearSequencebtnAction() {
        HUD.showLoading()
        RoomPDApi.clearDaRenList(roomId:roomId, toUserId: nil).lmrequest { _ in
            HUD.showSuccess("已清空排挡")
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func a_clearSeatbtnAction() {
        HUD.showLoading()
        RoomPDApi.clearSeat(roomId:roomId).lmrequest { _ in
            HUD.showSuccess("已清空试音")
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func a_allOnSeatbtnAction() {
        HUD.showLoading()
        RoomPDApi.autoUpSeat(roomId:roomId).lmrequest { _ in
            HUD.showSuccess("一键上麦成功")
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func a_onSeatbtnAction(_ btn: UIButton) {
        guard let seats = VoiceShared.roomViewController?.viewModel.seats else { return }
        let user = dataSource[btn.tag]
        var items = [LMSheetItemModel]()
        for seat in seats where seat.seatIndex > 0 && seat.seatIndex < 8 {
            if let _ = seat.userInfo {
                items.append(LMSheetItemModel(title: "号麦", imageName: "rm_sheet_seat_\(seat.seatIndex)_n", isEnable: false, index: seat.seatIndex))
            } else {
                items.append(LMSheetItemModel(title: "号麦", imageName: "rm_sheet_seat_\(seat.seatIndex)", isEnable: true, index: seat.seatIndex))
            }
        }
        LMSheetCollectionVC.show(title: user.nickname, items: items, cancel: "取消") { [weak self] item in
            guard let self = self else { return }
            guard let item = item, item.isEnable else { return }
            HUD.showLoading()
            RoomPDApi.operateDaRenSeat(roomId:roomId, toUserId: user.userId, upSeat: true, seatIndex: item.index).lmrequest { _ in
                HUD.hide()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        }
    }
    @objc func a_removebtnAction(_ btn: UIButton) {
        let user = dataSource[btn.tag]
        LMAlertBottomVC(theme: .dark, title: "删除提示", message: "确定删除该达人上麦申请吗？", cancel: "取消", confirm: "确定") { [weak self] actionTitle in
            if let title = actionTitle, title == "确定" {
                guard let self = self else { return }
                HUD.showLoading()
                RoomPDApi.clearDaRenList(roomId: self.roomId, toUserId: user.userId).lmrequest { _ in
                    HUD.hide()
                } failureBlock: { error in
                    HUD.showFailure(error.message)
                }
            }
        }.show()
    }
    @objc func a_userbtnAction(_ btn: UIButton) {
        RouteService.pushUserMainPage(dataSource[btn.tag].userId, vc: viewController)
    }
    @objc func a_applyOnSeatbtnAction(_ btn: UIButton) {
        if isInSequence {
            HUD.showLoading()
            RoomPDApi.cancelApplyDaRenlist(roomId:roomId).lmrequest { _ in
                HUD.showSuccess("已取消排挡")
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        } else {
            HUD.showLoading()
            RoomPDApi.applyDaRenlist(roomId:roomId, seatIndex: nil).lmrequest { _ in
                HUD.showSuccess("已排挡")
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        }
    }
}
extension LMRMDaRanSortView: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: LMRMDaRanSortCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(dataSource[indexPath.row])
        cell.indexPath = indexPath
        cell.onSeatbtn.isHidden = role == .audience
        cell.onSeatbtn.tag = indexPath.row
        cell.onSeatbtn.addTarget(self, action: #selector(a_onSeatbtnAction), for: .touchUpInside)
        cell.removebtn.isHidden = role == .audience
        cell.removebtn.tag = indexPath.row
        cell.removebtn.addTarget(self, action: #selector(a_removebtnAction), for: .touchUpInside)
        cell.userbtn.isHidden = role != .audience
        cell.userbtn.tag = indexPath.row
        cell.userbtn.addTarget(self, action: #selector(a_userbtnAction), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56.0 + 24.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        RouteService.pushUserMainPage(dataSource[indexPath.row].userId, vc: viewController)
    }
}
