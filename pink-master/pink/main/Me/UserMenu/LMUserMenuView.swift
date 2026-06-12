import UIKit
class LMUserMenuView: UIView {
    var dataList: [[LMUserMenuItemModel]] = [
        [LMUserMenuItemModel(type: .DressingCenter),
          LMUserMenuItemModel(type: .MyLevel)],
        ConfigService.shared.reviewStatus ? [LMUserMenuItemModel(type: .MyRoom),
                                             LMUserMenuItemModel(type: .skill)] :
        [LMUserMenuItemModel(type: .MyRoom),
         LMUserMenuItemModel(type: .skill),
         LMUserMenuItemModel(type: .MyGuild)],
        [LMUserMenuItemModel(type: .YouthMode),
          LMUserMenuItemModel(type: .Feedback),
          LMUserMenuItemModel(type: .AboutUs)]
     ]
    var cellClickblock: ((LMUserMenuItemModel) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        backgroundColor = .white
        tableView.tableHeaderView = headerView
        addSubview(tableView)
        addSubview(setbtn)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight + 16.0)
            make.bottom.equalTo(setbtn.snp.top).offset(-20.0)
        }
        setbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40.0)
            make.right.equalToSuperview().offset(-40.0)
            make.bottom.equalToSuperview().offset(-(kTabHeight + 20.0))
            make.height.equalTo(56.0)
        }
    }
    @objc private func setAction() {
        UIViewController.current?.navigationController?.pushViewController(MineSettingViewController(), animated: true)
    }
    lazy var headerView: LMUserMenuHeaderView = {
        let view = LMUserMenuHeaderView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: kScaleWidth(65) + 10.0))
        return view
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMUserMenuCell.self])
        tableView.sectionFooterHeight = 0.01
        tableView.sectionHeaderHeight = 16
        return tableView
    }()
    private lazy var setbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontS(16), titleColor: lmColorHex("#2B313D"), target: self, action: #selector(setAction))
        btn.setImage(UIImage(named: "user_menu_set"), for: .normal)
        btn.setTitle("系统设置", for: .normal)
        btn.backgroundColor = lmColorHex("#F3F3F5")
        btn.set_Border(radius: 12.0)
        if let image = btn.image(for: .normal) {
            let resizedImage = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20)).image { _ in
                image.draw(in: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
            }
            btn.setImage(resizedImage, for: .normal)
        }
        return btn
    }()
}
extension LMUserMenuView: UITableViewDataSource & UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        dataList.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataList[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: LMUserMenuCell.self, cellForRowAt: indexPath)
        cell.setData(model: dataList[indexPath.section][indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        48.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataList[indexPath.section][indexPath.row]
        self.cellClickblock?(model)
    }
}
