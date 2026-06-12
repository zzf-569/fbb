import UIKit
import WebKit
class BaseWebViewController: LMBaseVC {
    private let loadUrl: String
    private lazy var webView: BaseWebView = {
        let webView = BaseWebView(frame: .zero, loadUrl: loadUrl, delegate: self)
            .backgroundColor(.clear)
        return webView
    }()
    init(loadUrl: String, title: String = "") {
        self.loadUrl = loadUrl
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setViewSnp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
private extension BaseWebViewController {
    func setViewSnp() {
        self.view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight)
        }
    }
    func refreshSubviews() {
    }
}
extension BaseWebViewController: BaseWebViewDelegate {
    func webViewStartLoad(_ webView: BaseWebView) {
    }
    func webViewLoadComplete(_ webView: BaseWebView) {
    }
    func webViewLoadFailure(_ webView: BaseWebView, error: Error) {
    }
    func webViewTitle(_ webView: BaseWebView, title: String) {
        if self.title?.isEmpty == true {
            self.title = title
        }
    }
    func webViewClose() {
    }
}
