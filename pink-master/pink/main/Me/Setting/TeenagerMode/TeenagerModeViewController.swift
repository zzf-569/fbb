import UIKit
extension TeenagerModeViewController {
}
class TeenagerModeViewController: LMBaseVC {
    var isMain: Bool = false
    private lazy var actionbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .white, target: self, action: #selector(btnAction))
            .backgroundColor(lmColorHex("#26D477"))
            .cornerRadius(12)
        return btn
    }()
    lazy var agreementBoxbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "cm_box"), target: self, action: #selector(boxbtnAction))
            .image(UIImage(named: "cm_box_s"), .selected)
        btn.isSelected = true
        return btn
    }()
    lazy var agreementlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(16), textColor: .textSecondColor)
            .textAlignment(.center)
            .lmtext("查看阅读并同意")
        return lb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setViewSnp()
        getViewData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isOpen = TeenagerModeManager.shared.isOpen
        actionbtn.lmtitle(isOpen ? "关闭青少年模式" : "开启青少年模式")
    }
}
private extension TeenagerModeViewController {
    func setViewSnp() {
        let btn = UIButton(image: UIImage(named: "cm_back"), target: self, action: #selector(backItemDidiClick))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: kNavigationHeight, width: kScreenWidth, height: kScreenHeight - kNavigationHeight - 40.0 - 56.0 - 80.0 - kTabBarSafeHeight))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        let contentView = UIView(frame: scrollView.bounds)
        scrollView.addSubview(contentView)
        let logoimv = UIImageView(image: UIImage(named: "me_teenagerMode_logo"))
        view.addSubview(logoimv)
        view.addSubview(actionbtn)
        logoimv.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight + 12.0)
            make.width.equalTo(kScaleWidth(240))
            make.height.equalTo(kScaleWidth(160))
        }
        let titleLab = UILabel(lmfont: lmFontASHTB(24), textColor: .textDefaulColor)
        let isOpen = TeenagerModeManager.shared.isOpen
        titleLab.lmtext(isOpen ? "关闭青少年模式" : "开启青少年模式")
        scrollView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoimv.snp.bottom).offset(kScaleWidth(40))
        }
        let subtitleLab = UILabel(lmfont: lmFontM(12), textColor: .textDefaulColor)
            .lmtext("为呵护青少年健康成长，设置密码打开青少年模式后无法进行充值、购买等操作，无法进行音视频、打赏等功能无法使用推荐、发消息等功能")
            .numberOfLines(0)
        scrollView.addSubview(subtitleLab)
        subtitleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(kScaleWidth(40))
            make.top.equalTo(logoimv.snp.bottom).offset(kScaleWidth(104))
        }
        actionbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.bottom.equalToSuperview().offset(-(kScaleWidth(56) + kTabBarSafeHeight))
            make.height.equalTo(56.0)
        }
        let agreementView = UIView()
        view.addSubview(agreementView)
        agreementView.addSubview(agreementBoxbtn)
        agreementView.addSubview(agreementlb)
        agreementBoxbtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(4))
            make.size.equalTo(CGSize(width: kScaleWidth(16), height: kScaleWidth(16)))
        }
        agreementlb.snp.makeConstraints { make in
            make.left.equalTo(agreementBoxbtn.snp.right).offset(kScaleWidth(6))
            make.top.right.equalToSuperview()
            make.height.equalTo(kScaleWidth(24))
        }
        agreementView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(actionbtn.snp.top).offset(-40.0)
            make.height.equalTo(22.0)
        }
        view.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: kScreenWidth, height: kScreenHeight)
        set_upAgreement()
    }
    func set_upAgreement() {
        let text = "查看阅读并同意"
        let textAction1 = " 青少年保护协议"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: lmFontR(14), .foregroundColor: UIColor.textDefaulColor])
        attributedString.append(NSAttributedString(string: textAction1, attributes: [.font: lmFontR(14), .foregroundColor: UIColor.textLink]))
        self.agreementlb.attributedText = attributedString
        self.agreementlb.addGestureTap { [weak self] tap in
            (tap as? UITapGestureRecognizer)?.didTapLabelAttributedText([textAction1]) { _ in
                guard let self = self else { return }
                self.navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.minorsProtection), animated: true)
            }
            (tap as? UITapGestureRecognizer)?.didTapLabelAttributedText([text]) { _ in
                guard let self = self else { return }
                self.agreementBoxbtn.isSelected = !self.agreementBoxbtn.isSelected
            }
        }
    }
    func getViewData() {
    }
    func refreshSubviews() {
    }
    @objc func boxbtnAction(_ btn: UIButton) {
        btn.isSelected(!btn.isSelected)
    }
    @objc func btnAction() {
        guard agreementBoxbtn.isSelected else {
            HUD.showFailure("请选中青少年协议")
            return
        }
        if TeenagerModeManager.shared.isOpen {
            let vc = TeenagerModeCloseViewController()
            vc.isMain = isMain
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.navigationController?.pushViewController(TeenagerModeOpenViewController(), animated: true)
        }
    }
    @objc func agreementbtnAction() {
        self.navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.minorsProtection), animated: true)
    }
    @objc func backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension TeenagerModeItemView {
    func getHeight() -> Double {
        let titleHeight = title.textHeight(width: kScreenWidth - 16.0 * 4, font: lmFontM(16), minHeight: 24.0)
        let messageHeigh = message.textHeight(width: kScreenWidth - 16.0 * 4, font: lmFontF(14), minHeight: 22.0)
        return 16.0 + titleHeight + 8.0 + messageHeigh + 16.0
    }
}
class TeenagerModeItemView: UIView {
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
private extension TeenagerModeItemView {
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
