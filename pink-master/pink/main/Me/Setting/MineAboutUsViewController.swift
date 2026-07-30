import UIKit

final class MineAboutUsViewController: LMBaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About Us"
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#F5F6FA")
        buildView()
    }

    private func buildView() {
        let logo = UIImageView(image: UIImage(named: "ICON"))
        logo.contentMode = .scaleAspectFit
        logo.layer.cornerRadius = 22
        logo.clipsToBounds = true
        view.addSubview(logo)
        logo.snp.makeConstraints { $0.top.equalToSuperview().offset(kNavigationHeight + 34); $0.centerX.equalToSuperview(); $0.size.equalTo(104) }

        let version = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#A0A6A1"))
        version.text = "Voiro \(kAppShortVersion)"
        view.addSubview(version)
        version.snp.makeConstraints { $0.top.equalTo(logo.snp.bottom).offset(8); $0.centerX.equalToSuperview() }

        let update = makeButton(title: "Check For Updates", action: #selector(checkUpdatesAction))
        let privacy = makeButton(title: "Privacy Policy", action: #selector(privacyAction))
        let service = makeButton(title: "Terms Of Service", action: #selector(serviceAction))
        let live = makeButton(title: "Live Agreement", action: #selector(liveAgreementAction))
        let stack = UIStackView(arrangedSubviews: [update, privacy, service, live])
        stack.axis = .vertical
        stack.spacing = 14
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.snp.makeConstraints { $0.left.right.equalToSuperview().inset(72); $0.top.equalTo(version.snp.bottom).offset(70); $0.height.equalTo(224) }
    }

    private func makeButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(lmColorHex("#172019"), for: .normal)
        button.titleLabel?.font = lmFontM(14)
        button.backgroundColor = .white
        button.layer.cornerRadius = 2
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc private func checkUpdatesAction() { HUD.show("Already the latest version") }
    @objc private func privacyAction() { navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.privacy), animated: true) }
    @objc private func serviceAction() { navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.service), animated: true) }
    @objc private func liveAgreementAction() { navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.service), animated: true) }
}
