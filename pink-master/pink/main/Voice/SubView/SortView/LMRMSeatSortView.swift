import UIKit

extension LMRMSeatSortView {
    func setDataSoure(_ list: [UsInfoItem]) {
        self.dataSource = list
        self.tableView.reloadData()
        tableView.confEmptyView(isEmpty: dataSource.count <= 0)
        cancelbtn.isHidden = true
        for user in list {
            if user.userId == UserShared.user?.userId {
                cancelbtn.isHidden = false
            }
        }
    }
    func show() {
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.bdView.y = self.height - self.bdView.height
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bdView.y = self.height
        }completion: { _ in
            self.isHidden = true
        }
    }
}
class LMRMSeatSortView: UIView {
    private lazy var bgView: UIView = {
        let view = UIView(frame: self.bounds)
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
        let imv = UIImageView(frame: self.bdView.bounds)
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
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .textAlignment(.center)
            .lmtext("麦序")
        return lb
    }()
    private lazy var closebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_popclose"), target: self, action: #selector(closehbtnAction))
        return btn
    }()
    private lazy var cancelbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontF(14), titleColor: lmColorHex("#FFFFFF"), target: self, action: #selector(removebtnAction))
            .backgroundColor(lmColorHex("#FFFFFF", alpha: 0.06))
            .cornerRadius(32/2)
            .lmtitle("取消申请")
            .isHidden(true)
        return btn
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMRMSeatSortCell.self])
        return tableView
    }()
    private var dataSource: [UsInfoItem] = []
    var role:RMRoleType = .audience {
        didSet {
            tableView.reloadData()
            tableView.confEmptyView(isEmpty: dataSource.count <= 0)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.fb_updateEmptyViewLayout()
    }
}
private extension LMRMSeatSortView {
    private func setViewSnp() {
        addSubview(bgView)
        addSubview(bdView)
        bdView.addSubview(bodyimv)
        bdView.addSubview(titleV)
        bdView.addSubview(tableView)
        titleV.addSubview(closebtn)
        titleV.addSubview(titleLab)
        titleV.addSubview(cancelbtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.snp.bottom).offset(0)
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
        layoutIfNeeded()
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
}
extension LMRMSeatSortView: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(cellType:LMRMSeatSortCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(user)
        cell.indexPath = indexPath
        cell.onSeatbtn.isHidden = role == .audience
        cell.onSeatbtn.tag = indexPath.row
        cell.onSeatbtn.addTarget(self, action: #selector(onSeatbtnAction), for: .touchUpInside)
        cell.removebtn.isHidden = (role == .audience && user.userId != UserShared.user?.userId)
        cell.removebtn.tag = indexPath.row
        cell.removebtn.addTarget(self, action: #selector(removebtnAction), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56.0 + 24.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension LMRMSeatSortView {
    @objc func closehbtnAction() {
        self.hide()
    }
    @objc func onSeatbtnAction(_ btn: UIButton) {
        Mediator.shared.dispatch(event: LMRMViewMethon.holdUserOnSeat, data: dataSource[btn.tag])

    }
    @objc func removebtnAction(_ btn: UIButton) {

        Mediator.shared.dispatch(event: LMRMViewMethon.removeUserSeatSort, data: dataSource[btn.tag])
    }
    
   
}
