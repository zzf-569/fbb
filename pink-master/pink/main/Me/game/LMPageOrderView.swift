import UIKit
class LMPageOrderView: UIView {
    lazy var lineView: UIView = {
        let view = UIView().backgroundColor(lmColorHex("#303041")).cornerRadius(kScaleWidth(3))
        view.isHidden = true
        return view
    }()
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor).lmtext("开黑陪玩")
        lb.isHidden = true
        return lb
    }()
    var dataSoure: UsInfoItem = UsInfoItem() {
        didSet {
            setDataSoure()
        }
    }
    var dataList: [SkillItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [UserPageSkillCell.self])
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        set_Subviews()
        setDataSoure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func set_Subviews() {
        backgroundColor(lmColorHex("#F5F6FA"))
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(8.5))
            make.size.equalTo(CGSize(width: kScaleWidth(40), height: kScaleWidth(6)))
        }
        addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(26))
            make.height.equalTo(kScaleWidth(20))
        }
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(20))
            make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
        }
        tableView.reloadData()
    }
    func setDataSoure() {
        dataList = dataSoure.userSkills
    }
}
extension LMPageOrderView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        kScaleWidth(112)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: UserPageSkillCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataList[indexPath.row]
        cell.userId = self.dataSoure.userId
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = PlaOrViewController()
        view.usInfoItem = dataSoure
        view.skillItem = dataList[indexPath.row]
        UIViewController.current?.navigationController?.pushViewController(view, animated: true)
    }
}
extension LMPageOrderView: JXPagingViewListViewDelegate, UIScrollViewDelegate {
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        listViewDidScrollCallback = callback
    }
    func listView() -> UIView { self }
    func listScrollView() -> UIScrollView {         UIScrollView()
 }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
}
