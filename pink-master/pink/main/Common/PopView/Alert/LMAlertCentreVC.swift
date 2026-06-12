import UIKit
import AttributedString
extension LMAlertCentreVC {
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
            self.contentView.alpha = 1
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
class LMAlertCentreVC: UIViewController {
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
        let view = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth - kScaleWidth(40.0) * 2, height: 100.0))
            .backgroundColor(.white)
            .cornerRadius(24.0)
            .alpha(0)
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: lmColorHex("#2B313D"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var messageTextView: UITextView = {
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
            .backgroundColor(.clear)
        return btn
    }()
    private lazy var confirmbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: .white, target: self, action: #selector(confirmbtnAction))
            .cornerRadius(12.0)
            .backgroundColor(lmColorHex("#FF4F7D"))
        return btn
    }()
    private let _title: String?
    private let _message: String?
    private let _messageAttributedString: ASAttributedString?
    private let _cancel: String?
    private var _confirm: String?
    private var _type: Int = 0
    private let callbackblock: (String?) -> Void
    public var bgIsCanClick: Bool = true
    public init(title: String?, message: String?, cancel: String?, confirm: String?, type: Int? = 0, complete block: @escaping (String?) -> Void) {
        self._title = title
        self._message = message
        self._messageAttributedString = nil
        self._cancel = cancel
        self._confirm = confirm
        self._type = type ?? 0
        self.callbackblock = block
        super.init(nibName: nil, bundle: nil)
    }
    public init(title: String?, messageAttributedString: ASAttributedString?, cancel: String?, confirm: String?, complete block: @escaping (String?) -> Void) {
        self._title = title
        self._message = nil
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
private extension LMAlertCentreVC {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(contentView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        var allHeight = 0.0
        if let _title = self._title {
            allHeight += 24.0
            titleLab.text = _title
            contentView.addSubview(titleLab)
            titleLab.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24.0)
                make.right.equalToSuperview().offset(-24.0)
                make.top.equalToSuperview().offset(allHeight)
                make.height.equalTo(32.0)
            }
            allHeight += 32.0
        }
        if let _message = self._message {
            let maxHeight = kScreenHeight/3
            allHeight += 24.0
            var messageHeight = _message.textHeight(width: self.contentView.width - 24.0 * 2, font: self.messageTextView.font!)
            if messageHeight > maxHeight {
                messageHeight = maxHeight
            }
            messageTextView.text = _message
            contentView.addSubview(messageTextView)
            messageTextView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24.0)
                make.right.equalToSuperview().offset(-24.0)
                make.top.equalToSuperview().offset(allHeight)
                make.height.equalTo(messageHeight)
            }
            allHeight += messageHeight
        }
        if let _messageAttributedString = self._messageAttributedString {
            let messageAttributedString = _messageAttributedString.localized
            let maxHeight = kScreenHeight/3
            allHeight += 24.0
            var messageHeight = messageAttributedString.value.textHeight(width: self.contentView.width - 24.0 * 2)
            if messageHeight > maxHeight {
                messageHeight = maxHeight
            }
            messageTextView.attributed.text = messageAttributedString
            contentView.addSubview(messageTextView)
            messageTextView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24.0)
                make.right.equalToSuperview().offset(-24.0)
                make.top.equalToSuperview().offset(allHeight)
                make.height.equalTo(messageHeight)
            }
            allHeight += messageHeight
        }
        if let _cancel = self._cancel, let _confirm = self._confirm {
            allHeight += 24.0
            cancelbtn.lmtitle(_cancel)
            confirmbtn.lmtitle(_confirm)
            contentView.addSubview(cancelbtn)
            contentView.addSubview(confirmbtn)
            if _type == 1 {
                confirmbtn.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(24.0)
                    make.right.equalToSuperview().offset(-24.0)
                    make.top.equalToSuperview().offset(allHeight)
                    make.height.equalTo(44.0)
                }
                cancelbtn.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(24.0)
                    make.right.equalToSuperview().offset(-24.0)
                    make.top.equalTo(confirmbtn.snp.bottom).offset(4)
                    make.height.equalTo(44.0)
                    make.width.equalTo(cancelbtn)
                }
                allHeight += 92.0
            } else {
                cancelbtn.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(24.0)
                    make.top.equalToSuperview().offset(allHeight)
                    make.height.equalTo(48.0)
                }
                confirmbtn.snp.makeConstraints { make in
                    make.left.equalTo(cancelbtn.snp.right).offset(16.0)
                    make.right.equalToSuperview().offset(-24.0)
                    make.top.equalToSuperview().offset(allHeight)
                    make.height.equalTo(48.0)
                    make.width.equalTo(cancelbtn)
                }
                allHeight += 48.0
            }
        } else if let _cancel = self._cancel, self._confirm == nil {
            allHeight += 24.0
            cancelbtn.lmtitle(_cancel)
            contentView.addSubview(cancelbtn)
            cancelbtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24.0)
                make.right.equalToSuperview().offset(-24.0)
                make.top.equalToSuperview().offset(allHeight)
                make.height.equalTo(44.0)
            }
            allHeight += 44.0
        } else if self._cancel == nil, let _confirm = self._confirm {
            allHeight += 24.0
            confirmbtn.lmtitle(_confirm)
            contentView.addSubview(confirmbtn)
            confirmbtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24.0)
                make.right.equalToSuperview().offset(-24.0)
                make.top.equalToSuperview().offset(allHeight)
                make.height.equalTo(44.0)
            }
            allHeight += 44.0
        } else {
        }
        allHeight += 24.0
        self.contentView.frame = CGRect(x: 0, y: 0, width: self.contentView.width, height: allHeight)
        self.contentView.center = self.view.center
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
}
