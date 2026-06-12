import UIKit
class ViolationRecordViewController: LMBaseVC {
    var dataList: [ViolationRecordItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [ViolationRecordCell.self])
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        titleColor = .whitePrimary
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setDataSoure()
    }
    private func setViewSnp() {
        title = "违规记录"
        self.backgroundImage = nil
        view.backgroundColor = lmColorHex("#2B313D")
        let btn = UIButton(image: UIImage(named: "cm_back_white"), target: self, action: #selector(backItemDidiClick))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight)
        }
    }
    func setDataSoure() {
        let model = ViolationRecordItem(title: "房间违规通知", time: "7月26日", content: "您好！根据我们的社区准则和相关法律法规，您的房间【房间 ID】存在违规行为。经过初步审查，我们发现您的房间存在“违规内容文字”行为。")
        dataList = [model, model, model]
    }
    @objc func backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ViolationRecordViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: ViolationRecordCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataList[indexPath.row]
        return cell
    }
}
