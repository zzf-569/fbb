import UIKit
@preconcurrency import WebKit
protocol BaseWebViewDelegate: NSObjectProtocol {
    func webViewStartLoad(_ webView: BaseWebView)
    func webViewLoadComplete(_ webView: BaseWebView)
    func webViewLoadFailure(_ webView: BaseWebView, error: Error)
    func webViewTitle(_ webView: BaseWebView, title: String)
    func webViewClose()
}
class BaseWebView: UIView {
    private let loadUrl: String
    private weak var delegate: BaseWebViewDelegate?
    private var observation: NSKeyValueObservation?
    init(frame: CGRect, loadUrl: String, delegate: BaseWebViewDelegate) {
        self.loadUrl = loadUrl
        self.delegate = delegate
        super.init(frame: frame)
        setViewSnp()
        startLoad()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.0
        progressView.tintColor = .textBrand
        return progressView
    }()
    private lazy var contentController: WKUserContentController = {
        let contentController = WKUserContentController()
        contentController.add(self, name: "nativeApp")
        return contentController
    }()
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        config.userContentController = self.contentController
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.showsVerticalScrollIndicator = false
        return webView
    }()
}
private extension BaseWebView {
    func setViewSnp() {
        addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        webView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(3.0)
        }
    }
    func startLoad() {
        guard let url = URL(string: self.loadUrl) else { return }
        addCookie()
        observation = webView.observe(\.estimatedProgress, options: [.old, .new]) { [weak self] webView, _ in
            guard let self = self else { return }
            progressView.alpha = 1.0
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut) {
                    self.progressView.alpha = 0.0
                } completion: { _ in
                    self.progressView.progress = 0
                }
            }
        }
        let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
        webView.load(request)
    }
    func addCookie() {
        var token = ""
        if let login = UserShared.loginToken {
            token = login.accessToken
        }
        let host = URL(string: self.loadUrl)?.host ?? ""
        let path = URL(string: self.loadUrl)?.path ?? ""
        set_Cookie(domain: host, path: path, name: "_token", value: token)
        set_Cookie(domain: host, path: path, name: "_dev", value: kdev ? "1" : "0")
    }
    func set_Cookie(domain: String, path: String, name: String, value: Any) {
        if let cookie = HTTPCookie(properties: [
            .domain: domain,
            .path: path,
            .name: name,
            .value: value
        ]) {
            WKWebsiteDataStore.default().httpCookieStore.setCookie(cookie) {
                lmPrint("cookie 设置成功：\(cookie)")
            }
        }
    }
}
extension BaseWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        delegate?.webViewStartLoad(self)
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        delegate?.webViewLoadFailure(self, error: error)
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let title = webView.title {
            delegate?.webViewTitle(self, title: title)
        }
        webView.evaluateJavaScript("document.title", completionHandler: { (
        result, _) in
            if let title = result as? String {
                self.delegate?.webViewTitle(self, title: title)
            }
        })
        delegate?.webViewLoadComplete(self)
    }
}
extension BaseWebView: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frameInfo = navigationAction.targetFrame, frameInfo.isMainFrame {
            webView.load(navigationAction.request)
        }
        return nil
    }
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        completionHandler(defaultText)
    }
}
extension BaseWebView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        lmPrint("JS ---->>> Call ---->>> Native\n message.name:\(message.name)\n message.body:\(message.body)")
        if message.name != "nativeApp" {
            return
        }
        let bodyString = message.body as? String
        if let jsonData = bodyString?.data(using: .utf8) {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if let jsonDictionary = jsonObject as? [String: Any] {
                    let functionName = jsonDictionary["functionName"] as? String
                    let params = jsonDictionary["params"] as? [String: Any]
                    if functionName == "close" {
                        self.delegate?.webViewClose()
                    }
                } else {
                    print("解析结果不是字典")
                }
            } catch {
                print("JSON解析失败: \(error)")
            }
        } else {
            lmPrint("JSON数据转换失败")
        }
    }
}
