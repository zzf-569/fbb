import UIKit
class familyListViewController: LMBaseVC, UITextFieldDelegate {
    var dataList: [GuildItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    lazy var textField: UITextField = {
        let textField = UITextField(lmfont: lmFontR(14), textColor: .whitePrimary)
        textField.backgroundColor(lmColorHex("#212130"))
        textField.delegate = self
        textField.attributedPlaceholder(NSAttributedString(string: "搜索公会ID或公会名称", attributes: [.foregroundColor: UIColor.whiteTertiary]))
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        let searchIcon = UIImageView(image: UIImage(named: "cm_search_w"))
        searchIcon.frame = CGRect(x: 12, y: 10, width: 16, height: 16)
        leftView.addSubview(searchIcon)
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.cornerRadius(20)
        textField.returnKeyType = .search
        return textField
    }()
    lazy var tipslb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(16), textColor: .textDefaulColor)
        lb.text = "公会势力榜"
        return lb
    }()
    lazy var canclebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(15), titleColor: .whiteTertiary)
        btn.lmtitle("取消")
        return btn
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMFamilyListCell.self])
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    lazy var resaultView: familyResaultView = {
        let view = familyResaultView()
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    private func setViewSnp() {
        title = "我的公会"
        view.backgroundColor = .white
        view.addSubview(tipslb)
        view.addSubview(tableView)
        view.addSubview(resaultView)
        tipslb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(12) + kNavigationHeight)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(52) + kNavigationHeight)
        }
        resaultView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight + 12)
        }
        canclebtn.addGestureTap { [weak self] _ in
            if self?.resaultView.isHidden == false {
                self?.resaultView.isHidden = true
                self?.textField.resignFirstResponder()
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    func setData() {
        GuildNetWork.RecommendFamile().lmrequest {[weak self] responseModel in
            guard let model = [GuildItem].deserialize(from: responseModel.data as? [Any]) else { return }
            self?.dataList = model
        } failureBlock: { _ in
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keywords = textField.text, keywords.isEmpty == false else {
            HUD.show("请输入ID或昵称")
            return false
        }
        search()
        return true
    }
    func search() {
        guard let keywords = textField.text, keywords.isEmpty == false else {
            return
        }
        GuildNetWork.FamilySearch(content: keywords).lmrequest {[weak self] responseModel in
            guard let list = [GuildItem].deserialize(from: responseModel.data as? [Any]) else { return }
            self?.resaultView.dataList = list
        } failureBlock: { _ in
        }
    }
}
extension familyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        kScaleWidth(80)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: LMFamilyListCell.self, cellForRowAt: indexPath)
        cell.setData(dataList[indexPath.row], index: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        self.navigationController?.pushViewController(MyfamilyViewController(model: model), animated: true)
    }
}
