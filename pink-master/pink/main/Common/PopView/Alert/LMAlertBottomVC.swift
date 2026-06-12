import UIKit
import AttributedString
extension LMAlertBottomVC {
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
class LMAlertBottomVC: UIViewController {
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
            .backgroundColor(theme == .dark ? lmColorHex("#2B313D") : lmColorHex("#F5F6FA"))
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: theme == .dark ? lmColorHex("#FFFFFF") : lmColorHex("#2B313D"))
            .lmtext(_title)
        return lb
    }()
    private lazy var messageTextView: UITextView = {
        let textView = UITextView(lmfont: lmFontF(14), textColor: theme == .dark ? lmColorHex("#FFFFFF") : lmColorHex("#2B313DA3"))
        textView.textAlignment = .center
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    lazy var cancelbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: theme == .dark ? lmColorHex("#FFFFFFE0") : lmColorHex("#2B313D"), target: self, action: #selector(cancelbtnAction))
            .lmtitle(cancel ?? "")
            .cornerRadius(12.0)
            .backgroundColor(theme == .dark ? lmColorHex("#212130") : lmColorHex("#FFFFFF"))
        return btn
    }()
    lazy var confirmbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: theme == .dark ? lmColorHex("#FFFFFFE0") : lmColorHex("#2B313D"), target: self, action: #selector(confirmbtnAction))
            .lmtitle(confirm ?? "")
            .cornerRadius(12.0)
            .backgroundColor(theme == .dark ? lmColorHex("#212130") : lmColorHex("#FFFFFF"))
        return btn
    }()
    private let theme: UIUserInterfaceStyle
    private let _title: String
    private let message: String?
    private let cancel: String?
    private let confirm: String?
    private let _messageAttributedString: ASAttributedString?
    private let callbackblock: (String?) -> Void
    public init(theme: UIUserInterfaceStyle, title: String, message: String, cancel: String?, confirm: String, complete block: @escaping (String?) -> Void) {
        self.theme = theme
        self._title = title
        self.message = message
        self.cancel = cancel
        self.confirm = confirm
        self.callbackblock = block
        self._messageAttributedString = nil
        super.init(nibName: nil, bundle: nil)
    }
    public init(title: String, messageAttributedString: ASAttributedString?, cancel: String?, confirm: String?, complete block: @escaping (String?) -> Void) {
        self.theme = .light
        self._title = title
        self.message = nil
        self._messageAttributedString = messageAttributedString
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
private extension LMAlertBottomVC {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(contentView)
        contentView.addSubview(titleLab)
        contentView.addSubview(messageTextView)
        let contentHeight = getContentHeight()
        contentView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: contentHeight)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.top.equalToSuperview().offset(24.0)
            make.height.equalTo(32.0)
        }
        if let _message = self.message {
            let maxHeight = kScreenHeight/3
            var messageHeight = _message.textHeight(width: self.contentView.width - 24.0 * 2, font: self.messageTextView.font!)
            if messageHeight > maxHeight {
                messageHeight = maxHeight
            }
            messageTextView.text = _message
            messageTextView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24.0)
                make.right.equalToSuperview().offset(-24.0)
                make.top.equalTo(titleLab.snp.bottom).offset(kScaleWidth(24))
                make.height.equalTo(messageHeight)
            }
        }
        if let _messageAttributedString = self._messageAttributedString {
            let messageAttributedString = _messageAttributedString.localized
            let maxHeight = kScreenHeight/3
            var messageHeight = messageAttributedString.value.textHeight(width: self.contentView.width - 24.0 * 2)
            messageTextView.attributed.text = messageAttributedString
            messageTextView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24.0)
                make.right.equalToSuperview().offset(-24.0)
                make.top.equalTo(titleLab.snp.bottom).offset(kScaleWidth(24))
                make.height.equalTo(messageHeight)
            }
        }
        if self.cancel == nil, self.confirm == nil {
        } else if self.cancel != nil {
            contentView.addSubview(cancelbtn)
            contentView.addSubview(confirmbtn)
            cancelbtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24.0)
                make.top.equalTo(messageTextView.snp.bottom).offset(32.0)
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
                make.top.equalTo(messageTextView.snp.bottom).offset(32.0)
                make.height.equalTo(56.0)
            }
        }
        contentView.set_Border(radius: 24.0, conrners: [.topLeft, .topRight])
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
        var allHeight = 24.0
        allHeight += 32.0
        allHeight += 8.0
        if let message = self.message {
            let messageHeight = message.textHeight(width: kScreenWidth - 24.0 - 24.0, font: lmFontF(16))
            allHeight += messageHeight
        }
        if let message = self._messageAttributedString {
            var messageHeight = message.value.textHeight(width: self.contentView.width - 24.0 * 2)
            allHeight += messageHeight
        }
        if self.cancel != nil || self.confirm != nil {
            allHeight += 32.0
            allHeight += 56.0
        }
        allHeight += 32.0
        allHeight += kTabBarSafeHeight
        return allHeight
    }
}
