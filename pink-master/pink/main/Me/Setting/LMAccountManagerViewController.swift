import UIKit

final class LMAccountManagerViewController: LMBaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account Manager"
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#F5F6FA")
        buildView()
    }

    private func buildView() {
        let radarView = LMAccountSecurityRadarView()
        view.addSubview(radarView)
        radarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(kNavigationHeight + 26)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(136)
        }

        let securityLabel = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#192218", alpha: 0.42))
        securityLabel.text = "Account passed security check."
        securityLabel.textAlignment = .center
        view.addSubview(securityLabel)
        securityLabel.snp.makeConstraints {
            $0.top.equalTo(radarView.snp.bottom).offset(9)
            $0.centerX.equalToSuperview()
        }

        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        view.addSubview(card)
        card.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(securityLabel.snp.bottom).offset(22)
            $0.height.equalTo(224)
        }

        let rows: [(String, Selector)] = [
            ("Change Email", #selector(changeEmailAction)),
            ("Account Password", #selector(accountPasswordAction)),
            ("Security Password", #selector(securityPasswordAction)),
            ("Link Account", #selector(linkAccountAction))
        ]
        for (index, item) in rows.enumerated() {
            let row = makeRow(title: item.0, action: item.1)
            card.addSubview(row)
            row.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalToSuperview().offset(CGFloat(index) * 56)
                $0.height.equalTo(56)
            }
        }

        let deleteRow = makeRow(title: "Delete Account", color: lmColorHex("#FF4960"), action: #selector(deleteAccountAction))
        view.addSubview(deleteRow)
        deleteRow.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(card.snp.bottom).offset(12)
            $0.height.equalTo(56)
        }
    }

    private func makeRow(title: String, color: UIColor = lmColorHex("#172019"), action: Selector) -> UIView {
        let row = UIControl()
        row.addTarget(self, action: action, for: .touchUpInside)
        let titleLabel = UILabel(lmfont: lmFontM(14), textColor: color)
        titleLabel.text = title
        row.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
        let arrow = UIImageView(image: UIImage(named: "me_more"))
        arrow.contentMode = .scaleAspectFit
        row.addSubview(arrow)
        arrow.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(12)
        }
        return row
    }

    @objc private func changeEmailAction() {
        navigationController?.pushViewController(LMSecurityVerificationViewController(destination: .changeEmail), animated: true)
    }

    @objc private func accountPasswordAction() {
        navigationController?.pushViewController(LMSecurityVerificationViewController(destination: .password), animated: true)
    }

    @objc private func securityPasswordAction() {
        navigationController?.pushViewController(LMSecurityVerificationViewController(destination: .password), animated: true)
    }

    @objc private func linkAccountAction() {
        navigationController?.pushViewController(LMLinkAccountViewController(), animated: true)
    }

    @objc private func deleteAccountAction() {
        navigationController?.pushViewController(CancelAccountViewController(), animated: true)
    }
}

enum LMAccountManagerDestination {
    case changeEmail
    case password
}

final class LMSecurityVerificationViewController: LMBaseVC {
    private let destination: LMAccountManagerDestination
    private let codeField = UITextField()
    private let getButton = UIButton(type: .custom)
    private let confirmButton = UIButton(type: .custom)

    init(destination: LMAccountManagerDestination) {
        self.destination = destination
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Security Verification"
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#F5F6FA")
        buildView()
    }

    private func buildView() {
        let safeImage = UIImageView(image: UIImage(named: "setting_safe") ?? UIImage(systemName: "lock.shield.fill"))
        safeImage.contentMode = .scaleAspectFit
        safeImage.tintColor = lmColorHex("#19D99A")
        view.addSubview(safeImage)
        safeImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(kNavigationHeight + 30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(110)
        }

        let message = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#192218", alpha: 0.55))
        message.text = "For the security of your account, your device\nneeds to be verified"
        message.numberOfLines = 0
        message.textAlignment = .center
        view.addSubview(message)
        message.snp.makeConstraints {
            $0.top.equalTo(safeImage.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }

        let email = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#172019"))
        email.text = "wuwk13930@gmail.com"
        email.textAlignment = .center
        view.addSubview(email)
        email.snp.makeConstraints {
            $0.top.equalTo(message.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }

        let fieldContainer = UIView()
        fieldContainer.backgroundColor = .white
        fieldContainer.layer.cornerRadius = 10
        view.addSubview(fieldContainer)
        fieldContainer.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(email.snp.bottom).offset(16)
            $0.height.equalTo(46)
        }

        codeField.font = lmFontR(14)
        codeField.textColor = lmColorHex("#172019")
        codeField.attributedPlaceholder = NSAttributedString(string: "Enter code", attributes: [.foregroundColor: lmColorHex("#A0A6A1")])
        codeField.keyboardType = .numberPad
        fieldContainer.addSubview(codeField)
        codeField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-70)
        }

        getButton.setTitle("Get", for: .normal)
        getButton.setTitleColor(lmColorHex("#79E600"), for: .normal)
        getButton.titleLabel?.font = lmFontR(13)
        getButton.addTarget(self, action: #selector(getCodeAction), for: .touchUpInside)
        fieldContainer.addSubview(getButton)
        getButton.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.width.equalTo(62)
        }
        let divider = UIView()
        divider.backgroundColor = lmColorHex("#B7BBB8")
        getButton.addSubview(divider)
        divider.snp.makeConstraints { $0.left.equalToSuperview(); $0.centerY.equalToSuperview(); $0.width.equalTo(1); $0.height.equalTo(16) }

        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(lmColorHex("#8CFF15"), for: .normal)
        confirmButton.titleLabel?.font = lmFontM(18)
        confirmButton.backgroundColor = lmColorHex("#172019")
        confirmButton.layer.cornerRadius = 8
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 70))
            $0.height.equalTo(56)
        }
    }

    @objc private func getCodeAction() {
        HUD.show("Verification code sent")
    }

    @objc private func confirmAction() {
        guard codeField.text?.isEmpty == false else {
            HUD.show("Enter the verification code")
            return
        }
        let next: UIViewController = destination == .changeEmail ? LMChangeEmailViewController() : LMSettingPasswordViewController()
        navigationController?.pushViewController(next, animated: true)
    }
}

final class LMChangeEmailViewController: LMBaseVC {
    private let emailField = LMAccountField(placeholder: "Enter email", keyboard: .emailAddress)
    private let codeField = LMAccountField(placeholder: "Enter code", keyboard: .numberPad)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Change Email"
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#F5F6FA")
        buildView()
    }

    private func buildView() {
        view.addSubview(emailField)
        view.addSubview(codeField)
        emailField.snp.makeConstraints { $0.left.right.equalToSuperview().inset(16); $0.top.equalToSuperview().offset(kNavigationHeight + 32); $0.height.equalTo(46) }
        codeField.snp.makeConstraints { $0.left.right.equalTo(emailField); $0.top.equalTo(emailField.snp.bottom).offset(12); $0.height.equalTo(46) }

        let get = UIButton(type: .custom)
        get.setTitle("Get", for: .normal)
        get.setTitleColor(lmColorHex("#79E600"), for: .normal)
        get.titleLabel?.font = lmFontR(13)
        get.addTarget(self, action: #selector(getCodeAction), for: .touchUpInside)
        codeField.addSubview(get)
        get.snp.makeConstraints { $0.right.top.bottom.equalToSuperview(); $0.width.equalTo(62) }
        let divider = UIView()
        divider.backgroundColor = lmColorHex("#B7BBB8")
        get.addSubview(divider)
        divider.snp.makeConstraints { $0.left.equalToSuperview(); $0.centerY.equalToSuperview(); $0.width.equalTo(1); $0.height.equalTo(16) }

        let confirm = accountConfirmButton(title: "Confirm", target: self, action: #selector(confirmAction))
        view.addSubview(confirm)
        confirm.snp.makeConstraints { $0.left.right.equalTo(emailField); $0.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 70)); $0.height.equalTo(56) }
    }

    @objc private func getCodeAction() { HUD.show("Verification code sent") }
    @objc private func confirmAction() {
        guard emailField.text?.isEmpty == false, codeField.text?.isEmpty == false else { HUD.show("Please complete the fields"); return }
        HUD.showSuccess("Email changed")
    }
}

final class LMSettingPasswordViewController: LMBaseVC {
    private let passwordField = LMAccountField(placeholder: "Enter password", keyboard: .default, secure: true)
    private let repeatField = LMAccountField(placeholder: "Re-enter password", keyboard: .default, secure: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Setting Password"
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#F5F6FA")
        buildView()
    }

    private func buildView() {
        view.addSubview(passwordField)
        view.addSubview(repeatField)
        passwordField.snp.makeConstraints { $0.left.right.equalToSuperview().inset(16); $0.top.equalToSuperview().offset(kNavigationHeight + 32); $0.height.equalTo(46) }
        repeatField.snp.makeConstraints { $0.left.right.equalTo(passwordField); $0.top.equalTo(passwordField.snp.bottom).offset(12); $0.height.equalTo(46) }

        let hint = UILabel(lmfont: lmFontR(11), textColor: lmColorHex("#A0A6A1"))
        hint.text = "Required. Must be 8 to 16 characters in length."
        hint.textAlignment = .center
        view.addSubview(hint)
        hint.snp.makeConstraints { $0.top.equalTo(repeatField.snp.bottom).offset(12); $0.centerX.equalToSuperview() }

        let confirm = accountConfirmButton(title: "Confirm", target: self, action: #selector(confirmAction))
        view.addSubview(confirm)
        confirm.snp.makeConstraints { $0.left.right.equalTo(passwordField); $0.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 70)); $0.height.equalTo(56) }
    }

    @objc private func confirmAction() {
        guard let password = passwordField.text, password.count >= 8, password.count <= 16, password == repeatField.text else {
            HUD.show("Password must match and be 8 to 16 characters")
            return
        }
        HUD.showSuccess("Password saved")
    }
}

final class LMLinkAccountViewController: LMBaseVC {
    private var googleLinked = true
    private var appleLinked = false
    private let googleActionLabel = UILabel()
    private let appleActionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Link Account"
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#F5F6FA")
        buildView()
    }

    private func buildView() {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        view.addSubview(card)
        card.snp.makeConstraints { $0.left.right.equalToSuperview().inset(16); $0.top.equalToSuperview().offset(kNavigationHeight + 12); $0.height.equalTo(112) }
        makeAccountRow(in: card, index: 0, title: "Google", image: "login_google", linked: googleLinked, actionLabel: googleActionLabel, action: #selector(googleAction))
        makeAccountRow(in: card, index: 1, title: "Apple Id", image: "login_apple", linked: appleLinked, actionLabel: appleActionLabel, action: #selector(appleAction))
    }

    private func makeAccountRow(in card: UIView, index: Int, title: String, image: String, linked: Bool, actionLabel: UILabel, action: Selector) {
        let row = UIControl()
        row.addTarget(self, action: action, for: .touchUpInside)
        card.addSubview(row)
        row.snp.makeConstraints { $0.left.right.equalToSuperview(); $0.top.equalToSuperview().offset(CGFloat(index) * 56); $0.height.equalTo(56) }
        let icon = UIImageView(image: UIImage(named: image) ?? UIImage(systemName: "globe"))
        icon.contentMode = .scaleAspectFit
        row.addSubview(icon)
        icon.snp.makeConstraints { $0.left.equalToSuperview().offset(12); $0.centerY.equalToSuperview(); $0.size.equalTo(24) }
        let label = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#172019"))
        label.text = title
        row.addSubview(label)
        label.snp.makeConstraints { $0.left.equalTo(icon.snp.right).offset(8); $0.centerY.equalToSuperview() }
        actionLabel.font = lmFontR(12)
        actionLabel.textColor = lmColorHex("#7F8580")
        actionLabel.text = linked ? "Unlink 〉" : "Link 〉"
        actionLabel.tag = 700 + index
        row.addSubview(actionLabel)
        actionLabel.snp.makeConstraints { $0.right.equalToSuperview().offset(-12); $0.centerY.equalToSuperview() }
    }

    @objc private func googleAction() {
        if googleLinked {
            showUnlinkAlert(account: "Google")
        } else {
            googleLinked = true
            googleActionLabel.text = "Unlink 〉"
            HUD.showSuccess("Linked")
        }
    }

    @objc private func appleAction() {
        if appleLinked {
            showUnlinkAlert(account: "Apple")
        } else {
            appleLinked = true
            appleActionLabel.text = "Unlink 〉"
            HUD.showSuccess("Linked")
        }
    }

    private func showUnlinkAlert(account: String) {
        let alert = LMUnlinkThirdPartyAlertViewController(account: account) { [weak self] in
            if account == "Google" {
                self?.googleLinked = false
                self?.googleActionLabel.text = "Link 〉"
            } else {
                self?.appleLinked = false
                self?.appleActionLabel.text = "Link 〉"
            }
        }
        alert.show(in: self)
    }
}

private final class LMAccountField: UIView {
    let textField: UITextField

    var text: String? { textField.text }

    init(placeholder: String, keyboard: UIKeyboardType, secure: Bool = false) {
        textField = UITextField()
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 10
        textField.font = lmFontR(14)
        textField.textColor = lmColorHex("#172019")
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: lmColorHex("#A0A6A1")])
        textField.keyboardType = keyboard
        textField.isSecureTextEntry = secure
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        textField.leftViewMode = .always
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(secure ? -44 : 0)
        }
        if secure {
            let eyeButton = UIButton(type: .custom)
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            eyeButton.setImage(UIImage(systemName: "eye"), for: .selected)
            eyeButton.tintColor = lmColorHex("#7F8580")
            eyeButton.addTarget(self, action: #selector(toggleSecureText(_:)), for: .touchUpInside)
            addSubview(eyeButton)
            eyeButton.snp.makeConstraints {
                $0.right.top.bottom.equalToSuperview()
                $0.width.equalTo(44)
            }
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    @objc private func toggleSecureText(_ sender: UIButton) {
        sender.isSelected.toggle()
        textField.isSecureTextEntry = !sender.isSelected
    }
}

private final class LMAccountSecurityRadarView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let cyan = lmColorHex("#20DDF2")

        context.setFillColor(lmColorHex("#20DDF2", alpha: 0.12).cgColor)
        context.fillEllipse(in: rect.insetBy(dx: 8, dy: 8))
        context.setStrokeColor(cyan.cgColor)
        context.setLineWidth(2)
        context.strokeEllipse(in: rect.insetBy(dx: 8, dy: 8))

        for radius in stride(from: CGFloat(20), through: CGFloat(52), by: 16) {
            context.setStrokeColor(lmColorHex("#20DDF2", alpha: 0.45).cgColor)
            context.setLineWidth(1)
            context.strokeEllipse(in: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
        }

        context.setStrokeColor(lmColorHex("#20DDF2", alpha: 0.35).cgColor)
        context.move(to: CGPoint(x: center.x, y: 14))
        context.addLine(to: CGPoint(x: center.x, y: rect.height - 14))
        context.move(to: CGPoint(x: 14, y: center.y))
        context.addLine(to: CGPoint(x: rect.width - 14, y: center.y))
        context.strokePath()

        context.setFillColor(cyan.cgColor)
        context.fillEllipse(in: CGRect(x: center.x - 5, y: center.y - 5, width: 10, height: 10))
        context.setFillColor(lmColorHex("#8CFF15").cgColor)
        context.fillEllipse(in: CGRect(x: center.x + 34, y: center.y - 27, width: 5, height: 5))
        context.fillEllipse(in: CGRect(x: center.x - 45, y: center.y + 31, width: 4, height: 4))
    }
}

private func accountConfirmButton(title: String, target: Any, action: Selector) -> UIButton {
    let button = UIButton(type: .custom)
    button.setTitle(title, for: .normal)
    button.setTitleColor(lmColorHex("#8CFF15"), for: .normal)
    button.titleLabel?.font = lmFontM(18)
    button.backgroundColor = lmColorHex("#172019")
    button.layer.cornerRadius = 8
    button.addTarget(target, action: action, for: .touchUpInside)
    return button
}

private final class LMUnlinkThirdPartyAlertViewController: UIViewController {
    private let account: String
    private let completion: () -> Void
    private let dimView = UIView()
    private let card = UIView()

    init(account: String, completion: @escaping () -> Void) {
        self.account = account
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func show(in parent: UIViewController) {
        parent.addChild(self)
        parent.view.addSubview(view)
        view.snp.makeConstraints { $0.edges.equalToSuperview() }
        didMove(toParent: parent)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.48)
        view.addSubview(dimView)
        dimView.snp.makeConstraints { $0.edges.equalToSuperview() }
        card.backgroundColor = .white
        card.layer.cornerRadius = 22
        view.addSubview(card)
        card.snp.makeConstraints { $0.center.equalToSuperview(); $0.left.right.equalToSuperview().inset(34); $0.height.equalTo(214) }

        let title = UILabel(lmfont: lmFontM(18), textColor: lmColorHex("#172019"))
        title.text = "Unlink Third-Party\nAccount?"
        title.numberOfLines = 0
        title.textAlignment = .center
        card.addSubview(title)
        title.snp.makeConstraints { $0.top.equalToSuperview().offset(22); $0.centerX.equalToSuperview() }
        let message = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#59615A"))
        message.text = "This will remove the connection to your\n[\(account)] account. You may need to\nlog in or use certain features."
        message.numberOfLines = 0
        message.textAlignment = .center
        card.addSubview(message)
        message.snp.makeConstraints { $0.top.equalTo(title.snp.bottom).offset(16); $0.centerX.equalToSuperview() }

        let cancel = alertButton(title: "Cancel", color: lmColorHex("#F0F1F1"), titleColor: lmColorHex("#172019"), action: #selector(cancelAction))
        let unlink = alertButton(title: "Unlink", color: lmColorHex("#FF4960"), titleColor: .white, action: #selector(unlinkAction))
        card.addSubview(cancel); card.addSubview(unlink)
        cancel.snp.makeConstraints { $0.left.equalToSuperview().offset(20); $0.bottom.equalToSuperview().offset(-20); $0.width.equalTo(103); $0.height.equalTo(40) }
        unlink.snp.makeConstraints { $0.right.equalToSuperview().offset(-20); $0.bottom.equalTo(cancel); $0.width.equalTo(103); $0.height.equalTo(40) }
    }

    private func alertButton(title: String, color: UIColor, titleColor: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = lmFontM(14)
        button.backgroundColor = color
        button.layer.cornerRadius = 8
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc private func cancelAction() { dismissAlert() }
    @objc private func unlinkAction() { completion(); dismissAlert() }
    private func dismissAlert() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
