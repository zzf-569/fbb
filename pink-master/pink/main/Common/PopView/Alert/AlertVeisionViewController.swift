import UIKit
import AttributedString
extension LMVeisionVC {
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
    func hide(isturn: Bool) {
        if dataSoure.code == 2 {
            self.callbackblock(true)
            return
        }
        if isturn {
            self.callbackblock(isturn)
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.callbackblock(isturn)
            self.clear()
        }
    }
}
class LMVeisionVC: UIViewController {
    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            .backgroundColor(lmColorHex("#0000007F"))
            .alpha(0)
        return view
    }()
    private lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth - kScaleWidth(40.0) * 2, height: 370.0))
            .backgroundColor(.white)
            .cornerRadius(24.0)
            .alpha(0)
        let topImageV = UIImageView(image: UIImage(named: "version_top"))
        topImageV.frame = CGRect(x: 0, y: 0, width: view.width, height: 112)
        view.addSubview(topImageV)
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(18), textColor: lmColorHex("#2B313D"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var messageTextView: UITextView = {
        let textView = UITextView(lmfont: lmFontF(12), textColor: lmColorHex("#2B313DAD"))
        textView.backgroundColor(.clear)
        textView.textAlignment = .left
        textView.textContainer.lineFragmentPadding = 5
        textView.isEditable = false
        textView.isSelectable = false
        textView.cornerRadius(6)
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return textView
    }()
    private lazy var cancelbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: .white, target: self, action: #selector(cancelbtnAction))
        btn.image(UIImage(named: "version_close"))
        return btn
    }()
    private lazy var confirmbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(18), titleColor: .white, target: self, action: #selector(confirmbtnAction))
            .cornerRadius(12.0)
            .backgroundColor(lmColorHex("#FF4F7DFF"))
            .lmtitle("立即更新")
        return btn
    }()
    private var dataSoure: VersionModel = VersionModel()
    private let callbackblock: (Bool) -> Void
    public var bgIsCanClick: Bool = false
    public init(model: VersionModel, complete block: @escaping (Bool) -> Void) {
        self.dataSoure = model
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
private extension LMVeisionVC {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(contentView)
        contentView.addSubview(titleLab)
        contentView.addSubview(messageTextView)
        contentView.addSubview(confirmbtn)
        view.addSubview(cancelbtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(112)
        }
        messageTextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(146)
            make.bottom.equalToSuperview().offset(-96)
        }
        confirmbtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 262, height: 48))
        }
        cancelbtn.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        cancelbtn.isHidden = dataSoure.code == 2
        titleLab.text = dataSoure.version + "更新内容:"
        messageTextView.text = dataSoure.content
        self.contentView.center = self.view.center
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @objc func cancelbtnAction() {
        self.hide(isturn: false)
    }
    @objc func confirmbtnAction() {
        self.hide(isturn: true)
    }
}
