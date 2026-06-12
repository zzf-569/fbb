import UIKit
class findOrderViewController: LMBaseVC {
    var dataList: [findOrderItem] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    var page: Int = 1
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [findOrderCell.self])
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: .textDefaulColor)
            .lmtext("派单大厅")
        return lb
    }()
    lazy var sendbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "order_send"), target: self, action: #selector(sendOrder))
        btn.lmtitle("发布")
        btn.backgroundColor(lmColorHex("#FFEC3B"))
        btn.font(lmFontR(16))
        btn.cornerRadius(20)
        btn.titleColor(.textDefaulColor)
        return btn
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataSoure()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        set_Subviews()
    }
    private func set_Subviews() {
        backgroundImage = UIImage(named: "order_bg")
        view.addSubview(titleLab)
        view.addSubview(sendbtn)
        view.addSubview(tableView)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(68))
        }
        sendbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(20))
            make.centerY.equalTo(titleLab)
            make.size.equalTo(CGSize(width: 88, height: 40))
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(0)
            make.top.equalToSuperview().offset(kScaleWidth(122))
            make.bottom.equalToSuperview().offset(-(kTabBarHeight + kTabBarSafeHeight))
        }
    }
    func setDataSoure(){
        findOrderApi.findOrderList(page: 1).lmrequest {[weak self] responseModel in
            guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]),
                  let list = [findOrderItem].deserialize(from: model.records), let self = self else {
                return
            }
            self.dataList = list
        } failureBlock: { error in
        }
    }
    @objc func sendOrder() {
        let vc = OrderSendView()
        vc.show(AppConfig.keyWindow.rootViewController)
    }
}
extension findOrderViewController: UITableViewDelegate, UITableViewDataSource, findOrderCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        184
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: findOrderCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataList[indexPath.row]
        cell.delegate = self
        return cell
    }
    func findOrderCellNext(orderNo: String) {
        if UserShared.user?.realAuth == false {
            let view = LMAuthPopVC(theme: .light, cancel: nil, confirm: "立即认证") { title in
                if title == "立即认证" {
                    UIViewController.current?.navigationController?.pushViewController(RealAuthViewController(routetype: .toRoom), animated: true)
                }
            }
            view.show()
            return
        }
        
        LMAlertBottomVC(theme: .light, title: "温馨提示", message: "确定抢到此单吗？弃单将会有违规处理", cancel: "取消", confirm: "确定") { [weak self] actionTitle in
            if let title = actionTitle, title == "确定" {
                guard let self = self else { return }
                HUD.showLoading()
                findOrderApi.findOrderSub(orderNo: orderNo).lmrequest { responseModel in
                    HUD.show("接单成功")
                    self.setDataSoure()
                } failureBlock: { error in
                    HUD.hide()
                }
            }
        }.show()
        
    }
}
