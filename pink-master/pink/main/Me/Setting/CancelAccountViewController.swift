import UIKit
extension CancelAccountViewController {
}
class CancelAccountViewController: LMBaseVC {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注销账号"
        self.backgroundImage = UIImage.gradient(["#F5455C", "#D43F54"], size: view.size, direction: .vertical)
        let btn = UIButton(image: UIImage(named: "cm_back_white"), target: self, action: #selector(backItemDidiClick))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        setViewSnp()
        getViewData()
    }
}
private extension CancelAccountViewController {
    func setViewSnp() {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: kNavigationHeight, width: kScreenWidth, height: kScreenHeight - kNavigationHeight - 20.0 - 56.0 - 32.0 - kTabBarSafeHeight))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        let contentView = UIView(frame: scrollView.bounds)
        scrollView.addSubview(contentView)
        let titleLab = UILabel(lmfont: lmFontF(16), textColor: lmColorHex("#FFFFFFA3"))
            .numberOfLines(0)
            .lmtext("为保障你的账号安全，在申请注销前，需同时满足以下条件：")
        contentView.addSubview(titleLab)
        let item1 = CancelAccountItemView("非风险类账号", "在最近两周内，手机换绑定等敏感操作")
        contentView.addSubview(item1)
        let item2 = CancelAccountItemView("账号出于安全状态", "最近 6 个月内，您的账号未曾被封号或处于封号中。且与平台、其它用户不存在未结的争议纠纷，包括但不限于被投诉、举报或违反法律法规")
        contentView.addSubview(item2)
        let item3 = CancelAccountItemView("收益已结清或得到妥善处理", "收益已结清或得到妥善处理，包括但不善于虚拟货币、道具、会员等权益等收益。请你妥善处理，若为处理则视为您自愿放弃该等权益")
        contentView.addSubview(item3)
        let item4 = CancelAccountItemView("永久注销，无法登录及数据无法找回", "账号一旦注销无法登录，注销后所有产品数据在「粉贝贝」无法找回")
        contentView.addSubview(item4)
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: lmColorHex("#D43F54"), target: self, action: #selector(btnAction))
            .backgroundColor(lmColorHex("#FFFFFF"))
            .cornerRadius(56/2)
            .lmtitle("已确定风险，确定注销")
        view.addSubview(btn)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalToSuperview().offset(12.0)
        }
        item1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(titleLab.snp.bottom).offset(16.0)
        }
        item2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(item1.snp.bottom).offset(16.0)
        }
        item3.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(item2.snp.bottom).offset(16.0)
        }
        item4.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(item3.snp.bottom).offset(16.0)
        }
        btn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(scrollView.snp.bottom).offset(20.0)
            make.height.equalTo(56.0)
        }
        view.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: 0, height: item4.bottom + 20.0)
    }
    func getViewData() {
    }
    func refreshSubviews() {
    }
    @objc func btnAction() {
        let alert = LMAlertBottomVC(theme: .light, title: "注销账号", message: "永久注销，无法登录及数据无法找回", cancel: "取消", confirm: "注销") { text in
            if text == "注销" {
                HUD.showLoading()
                UserNetWork.logoff().lmrequest { _ in
                    HUD.showSuccess("注销成功")
                    UserShared.logout {
                        let login = LoginViewController()
                        RootRouter().setRootViewController(controller: BaseNavigationController(rootViewController: login), animatedWithOptions: nil)
                    }
                } failureBlock: { error in
                    HUD.showFailure(error.message)
                }
            }
        }
        alert.confirmbtn.setTitleColor(lmColorHex("#F5455C"), for: .normal)
        alert.show(self)
    }
    @objc func backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension CancelAccountItemView {
    func getHeight() -> Double {
        let titleHeight = title.textHeight(width: kScreenWidth - 16.0 * 4, font: lmFontM(16), minHeight: 24.0)
        let messageHeigh = message.textHeight(width: kScreenWidth - 16.0 * 4, font: lmFontF(14), minHeight: 22.0)
        return 16.0 + titleHeight + 8.0 + messageHeigh + 16.0
    }
}
class CancelAccountItemView: UIView {
    private let title: String
    private let message: String
    lazy var meessagelb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(14), textColor: lmColorHex("#FFFFFFA3"))
            .numberOfLines(0)
            .lmtext(message)
        return lb
    }()
    init(_ title: String, _ message: String) {
        self.title = title
        self.message = message
        super.init(frame: CGRect.zero)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension CancelAccountItemView {
    private func setViewSnp() {
        let bgimv = UIImageView()
            .backgroundColor(lmColorHex("#FFFFFF1E"))
        bgimv.set_Border(radius: 12.0, borderWidth: 1.0, borderColor: lmColorHex("#FFFFFF1E"))
        let markimv = UIImageView()
            .backgroundColor(lmColorHex("#FFFFFFE0"))
        let titleLab = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#FFFFFFE0"))
            .numberOfLines(0)
            .lmtext(title)
        addSubview(bgimv)
        addSubview(markimv)
        addSubview(titleLab)
        addSubview(meessagelb)
        bgimv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        markimv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalToSuperview().offset(22.0)
            make.width.equalTo(2.0)
            make.height.equalTo(12.0)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(markimv.snp.right).offset(6.0)
            make.top.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
        }
        meessagelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(titleLab.snp.bottom).offset(8.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
    }
}
