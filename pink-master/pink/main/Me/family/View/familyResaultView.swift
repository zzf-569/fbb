import UIKit
class familyResaultView: UIView {
    var dataList: [GuildItem] = [] {
        didSet {
            self.isHidden = dataList.count == 0 ? true : false
            tableView.reloadData()
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMFamilyListCell.self])
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        backgroundColor = lmColorHex("#2B313D")
        self.isHidden = true
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}
extension familyResaultView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kScaleWidth(96)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: LMFamilyListCell.self, cellForRowAt: indexPath)
        cell.setData(dataList[indexPath.row], index: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        UIViewController.current?.navigationController?.pushViewController(familyEntertainViewController(model: model), animated: true)
    }
}
