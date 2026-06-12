import UIKit
import AttributedString
extension LMPrivacyVC {
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
    func hide(_ title: String?) {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.callbackblock(title)
            self.clear()
        }
    }
}
class LMPrivacyVC: UIViewController {
    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            .backgroundColor(lmColorHex("#0000007F"))
            .alpha(0)
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            if self.bgIsCanClick {
                self.hide(nil)
            }
        }
        return view
    }()
    private lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 100.0))
            .backgroundColor(.white)
            .cornerRadius(24.0)
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: lmColorHex("#2B313D"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var messageTextView: UITextView = {
        let textView = UITextView(lmfont: lmFontF(12), textColor: lmColorHex("#2B313DAD"))
        textView.textAlignment = .center
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    private lazy var pricacyTextView: UITextView = {
        let textView = UITextView(lmfont: lmFontF(14), textColor: lmColorHex("#2B313DA3"))
        textView.textAlignment = .center
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    private lazy var cancelbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: .textDefaulColor, target: self, action: #selector(cancelbtnAction))
            .cornerRadius(12.0)
            .backgroundColor(lmColorHex("#2B313D0A"))
        return btn
    }()
    private lazy var confirmbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: .white, target: self, action: #selector(confirmbtnAction))
            .cornerRadius(12.0)
            .backgroundColor(lmColorHex("#FF4F7D"))
        return btn
    }()
    private var _title: String = ""
    private var _messageAttributedString: ASAttributedString
    private var _cancel: String = ""
    private var _confirm: String = ""
    private let callbackblock: (String?) -> Void
    public var bgIsCanClick: Bool = true
    public init(title: String, messageAttributedString: ASAttributedString, cancel: String, confirm: String, complete block: @escaping (String?) -> Void) {
        self._title = title
        self._messageAttributedString = messageAttributedString
        self._cancel = cancel
        self._confirm = confirm
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
private extension LMPrivacyVC {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(contentView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLab.text = _title
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalToSuperview().offset(24.0)
            make.height.equalTo(32.0)
        }
        let tipslb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#FF4F7DFF"))
            .lmtext("欢迎使用粉贝贝")
        contentView.addSubview(tipslb)
        tipslb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(72)
        }
        let tipslbs = UILabel(lmfont: lmFontM(14), textColor: .textDefaulColor)
            .lmtext("我们非常重视与您的个人隐私及其他相关权益，在你使用之前请仔细阅读《用户协议》和《隐私政策》")
            .numberOfLines(0)
        contentView.addSubview(tipslbs)
        tipslbs.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(102)
        }
        messageTextView.attributed.text = _messageAttributedString.localized
        contentView.addSubview(messageTextView)
        messageTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalToSuperview().offset(154)
            make.height.equalTo(126)
        }
        let content: ASAttributedString = "\("详情请查看", .font(lmFontF(14)), .foreground(lmColorHex("#2B313DA3")))\("《服务协议》", .font(lmFontF(12)), .foreground(lmColorHex("#328BF9")), .action(userAction(_:)))\("和", .font(lmFontF(12)), .foreground(lmColorHex("#2B313DA3")))\("《隐私政策》", .font(lmFontF(12)), .foreground(lmColorHex("#328BF9")), .action(privacyAction(_:)))"
        pricacyTextView.attributed.text = content.localized
        contentView.addSubview(pricacyTextView)
        pricacyTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalToSuperview().offset(288)
            make.height.equalTo(22)
        }
        cancelbtn.lmtitle(_cancel)
        confirmbtn.lmtitle(_confirm)
        contentView.addSubview(cancelbtn)
        contentView.addSubview(confirmbtn)
        confirmbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24.0)
            make.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + kScaleWidth(24)))
            make.width.equalTo(161.0)
            make.height.equalTo(48.0)
        }
        cancelbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + kScaleWidth(24)))
            make.width.equalTo(161.0)
            make.height.equalTo(48.0)
        }
        self.contentView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 398 + kTabBarSafeHeight)
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @objc func cancelbtnAction() {
        hide(_cancel)
    }
    @objc func confirmbtnAction() {
        hide(_confirm)
    }
    func userAction(_ result: ASAttributedString.Attribute.Result) {
        switch result.content {
            case .string(let value):
                print("文本: \(value) range: \(result.range)")
            self.navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.service), animated: true)
            case .attachment(let value):
                print("附件: \(value) range: \(result.range)")
            }
    }
    func privacyAction(_ result: ASAttributedString.Attribute.Result) {
        switch result.content {
            case .string(let value):
                print("文本: \(value) range: \(result.range)")
            self.navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.privacy), animated: true)
            case .attachment(let value):
                print("附件: \(value) range: \(result.range)")
            }
    }
}
