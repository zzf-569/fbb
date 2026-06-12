import UIKit
extension LMAuthPopVC {
    func show(_ vc: UIViewController? = nil) {
        if let viewController = vc {
            viewController.addChild(self)
            viewController.view.addSubview(self.view)
        } else {
            UIViewController.current?.addChild(self)
            UIViewController.current?.view.addSubview(self.view)
        }
        self.view.frame = UIScreen.main.bounds
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
            self.contentView.y = kScreenHeight - self.contentView.height
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.contentView.y = kScreenHeight
        } completion: { _ in
            self.clear()
        }
    }
}
class LMAuthPopVC: UIViewController {
    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            .backgroundColor(theme == .dark ? lmColorHex("#0000007F") : lmColorHex("#0000007F"))
            .alpha(0)
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 100.0))
            .backgroundColor(.white)
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(16), textColor: theme == .dark ? lmColorHex("#FFFFFF") : lmColorHex("#2B313D"))
            .lmtext("温馨提示:")
        return lb
    }()
    private lazy var subtitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: theme == .dark ? lmColorHex("#FFFFFF") : lmColorHex("#2B313DA3"))
            .lmtext("·认证前请确认您已满18岁，未满18岁您将无法认证。\n·您提供的证件信息将受到严格保护，未经本人许可不会用做其他用途；")
            .numberOfLines(0)
        return lb
    }()
    lazy var headerImage: UIImageView = {
        let imageV = UIImageView().image(UIImage(named: "cm_noAuth"))
        return imageV
    }()
    lazy var cancelbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(18), titleColor: theme == .dark ? lmColorHex("#FFFFFFE0") : lmColorHex("#2B313D"), target: self, action: #selector(cancelbtnAction))
            .lmtitle(cancel ?? "")
            .cornerRadius(12.0)
            .backgroundColor(theme == .dark ? lmColorHex("#212130") : lmColorHex("#2B313D0A"))
        return btn
    }()
    lazy var confirmbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: theme == .dark ? lmColorHex("#FFFFFFE0") : lmColorHex("#FFFFFF"), target: self, action: #selector(confirmbtnAction))
            .lmtitle(confirm)
            .cornerRadius(12.0)
            .backgroundColor(theme == .dark ? lmColorHex("#212130") : lmColorHex("#618DF0FF"))
        return btn
    }()
    private let theme: UIUserInterfaceStyle
    private let cancel: String?
    private let confirm: String
    private let callbackblock: (String?) -> Void
    public init(theme: UIUserInterfaceStyle, cancel: String?, confirm: String, complete block: @escaping (String?) -> Void) {
        self.theme = theme
        self.cancel = cancel
        self.confirm = confirm
        self.callbackblock = block
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
    deinit {
        lmPrint("UIViewController deinit：----------------\(Self.className)已被销毁")
    }
}
private extension LMAuthPopVC {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(contentView)
        contentView.addSubview(titleLab)
        contentView.addSubview(headerImage)
        contentView.addSubview(subtitleLab)
        let contentHeight = getContentHeight()
        contentView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: contentHeight)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerImage.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(-kScaleWidth(40))
            make.height.equalTo(kScaleWidth(140))
        }
        titleLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(32))
            make.top.equalTo(headerImage.snp.bottom).offset(0)
            make.height.equalTo(24.0)
        }
        subtitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(32))
            make.top.equalTo(titleLab.snp.bottom).offset(8.0)
        }
        if self.cancel != nil {
            contentView.addSubview(cancelbtn)
            contentView.addSubview(confirmbtn)
            cancelbtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24.0)
                make.top.equalTo(subtitleLab.snp.bottom).offset(32.0)
                make.height.equalTo(56.0)
            }
            confirmbtn.snp.makeConstraints { make in
                make.left.equalTo(cancelbtn.snp.right).offset(16.0)
                make.right.equalToSuperview().offset(-24.0)
                make.top.equalTo(cancelbtn)
                make.height.equalTo(56.0)
                make.width.equalTo(cancelbtn)
            }
        } else {
            contentView.addSubview(confirmbtn)
            confirmbtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24.0)
                make.right.equalToSuperview().offset(-24.0)
                make.top.equalTo(subtitleLab.snp.bottom).offset(36.0)
                make.height.equalTo(56.0)
            }
        }
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @objc func cancelbtnAction() {
        callbackblock(self.cancel)
        hide()
    }
    @objc func confirmbtnAction() {
        callbackblock(self.confirm)
        hide()
    }
    func getContentHeight() -> Double {
        let allHeight = 244.0 + kScaleWidth(120) + kTabBarSafeHeight
        return allHeight
    }
}
