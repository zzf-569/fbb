import UIKit
enum WebPopScreenStyle {
    case full
    case falf
}
extension WebPopViewController {
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
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.clear()
        }
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
class WebPopViewController: BasePopViewController {
    private lazy var bgView: UIView = {
        let view = UIView()
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var bdView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var bodyimv: UIImageView = {
        let imv = UIImageView()
        let effec = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effec)
        imv.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imv.addGestureTap { [weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
            }
        return imv
    }()
    private lazy var titleV: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(18), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .textAlignment(.center)
            .lmtext(title ?? "")
        return lb
    }()
    private lazy var closebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_popclose"), target: self, action: #selector(closehbtnAction))
        return btn
    }()
    private lazy var webView: BaseWebView = {
        let webView = BaseWebView(frame: .zero, loadUrl: loadUrl, delegate: self)
            .backgroundColor(.clear)
        return webView
    }()
    private let screenStyle: WebPopScreenStyle
    private let loadUrl: String
    init(loadUrl: String, title: String = "", screenStyle: WebPopScreenStyle = .falf) {
        self.loadUrl = loadUrl
        self.screenStyle = screenStyle
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
}
private extension WebPopViewController {
    func setViewSnp() {
        if screenStyle == .falf {
            view.addSubview(bgView)
            view.addSubview(bdView)
            bdView.addSubview(bodyimv)
            bdView.addSubview(titleV)
            bdView.addSubview(webView)
            titleV.addSubview(titleLab)
            titleV.addSubview(closebtn)
            bgView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            bdView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(view.snp.bottom).offset(0)
                make.height.equalTo(400.0 + kTabBarSafeHeight)
            }
            bodyimv.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            titleV.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(56.0)
            }
            titleLab.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            closebtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(10.0)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(36.0)
            }
            webView.snp.makeConstraints { make in
                make.top.equalTo(titleV.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
            view.layoutIfNeeded()
            bdView.set_Border(radius: 16.0, conrners: [.topLeft, .topRight])
        } else {
            view.addSubview(bgView)
            view.addSubview(bdView)
            bdView.addSubview(bodyimv)
            bdView.addSubview(closebtn)
            bdView.addSubview(webView)
            bgView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            bdView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(view.snp.bottom).offset(0)
                make.height.equalTo(kScreenHeight)
            }
            bodyimv.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            closebtn.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-20.0)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(36.0)
            }
            webView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            view.layoutIfNeeded()
        }
    }
    @objc func closehbtnAction() {
        self.hide()
    }
}
extension WebPopViewController: BaseWebViewDelegate {
    func webViewStartLoad(_ webView: BaseWebView) {
    }
    func webViewLoadComplete(_ webView: BaseWebView) {
    }
    func webViewLoadFailure(_ webView: BaseWebView, error: Error) {
    }
    func webViewTitle(_ webView: BaseWebView, title: String) {
        if self.title?.isEmpty == true {
            self.titleLab.text = title
        }
    }
    func webViewClose() {
        closehbtnAction()
    }
}
