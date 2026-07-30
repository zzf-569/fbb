import UIKit

final class LMHostCenterViewController: LMBaseVC {
    private let whatsappNumber = "61682072"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        buildView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    private func buildView() {

        backgroundImage = UIImage(named: "host_bg")

       

        let titleLabel = UILabel(lmfont: lmFontM(24), textColor: lmColorHex("#172019"))
        titleLabel.text = "Become a host"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(32)
            $0.top.equalToSuperview().offset(kNavigationBarHeight + 65)
        }

        let benefitsLabel = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#192218", alpha: 0.64))
        benefitsLabel.numberOfLines = 0
        benefitsLabel.text = "▪ Daily Hoster Bonus: 1,000 Points.\n▪ Daily Engagement Bonus: Up to 5,000 Extra\n  Points.\n▪ Go live and bring your energy to earn more!"
        benefitsLabel.setLineSpacing(7)
        view.addSubview(benefitsLabel)
        benefitsLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.right.equalToSuperview().offset(-28) 
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }

        let applyRow = actionRow(
            icon: "host",
            title: "Apply to Become a Host",
            subtitle: nil,
            buttonTitle: "Apply",
            action: #selector(applyAction)
        )
        let agentRow = actionRow(
            icon: "agency",
            title: "Join Agent Program",
            subtitle: "Get agent support and guidance.",
            buttonTitle: "Join",
            action: #selector(joinAction)
        )
        let supportRow = actionRow(
            icon: "support",
            title: "Customer Support",
            subtitle: "WhatsApp : \(whatsappNumber)",
            buttonTitle: "Copy",
            action: #selector(copyAction)
        )

        let stack = UIStackView(arrangedSubviews: [applyRow, agentRow, supportRow])
        stack.axis = .vertical
        stack.spacing = 14
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.top.equalTo(benefitsLabel.snp.bottom).offset(34)
            $0.height.equalTo(240)
        }
    }

    private func actionRow(
        icon: String,
        title: String,
        subtitle: String?,
        buttonTitle: String,
        action: Selector
    ) -> UIView {
        let row = UIView()
        row.backgroundColor = UIColor.white.withAlphaComponent(0.78)
        row.layer.cornerRadius = 16
        row.layer.borderWidth = 1
        row.layer.borderColor = lmColorHex("#172019").cgColor

        let iconContainer = UIView()
        iconContainer.backgroundColor = lmColorHex("#152019")
        iconContainer.layer.cornerRadius = 22
        row.addSubview(iconContainer)
        iconContainer.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
        }

        let iconView = UIImageView(image: UIImage(named: icon))
        iconView.contentMode = .scaleAspectFit
        iconContainer.addSubview(iconView)
        iconView.snp.makeConstraints { $0.edges.equalToSuperview().inset(7) }

        let titleLabel = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#172019"))
        titleLabel.text = title
        row.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconContainer.snp.right).offset(10)
            $0.right.lessThanOrEqualToSuperview().offset(-72)
            $0.centerY.equalToSuperview().offset(subtitle == nil ? 0 : -9)
        }

        if let subtitle {
            let subtitleLabel = UILabel(lmfont: lmFontR(11), textColor: lmColorHex("#A0A6A1"))
            subtitleLabel.text = subtitle
            row.addSubview(subtitleLabel)
            subtitleLabel.snp.makeConstraints {
                $0.left.equalTo(titleLabel)
                $0.right.lessThanOrEqualToSuperview().offset(-66)
                $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            }
        }

        let button = UIButton(type: .custom)
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(lmColorHex("#172019"), for: .normal)
        button.titleLabel?.font = lmFontM(14)
        button.backgroundColor = lmColorHex("#8CFF15")
        button.layer.cornerRadius = 4
        button.addTarget(self, action: action, for: .touchUpInside)
        row.addSubview(button)
        button.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(58)
            $0.height.equalTo(32)
        }

        return row
    }

    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func applyAction() {
        navigationController?.pushViewController(LMHostCenterDashboardViewController(hasRoom: false), animated: true)
    }

    @objc private func joinAction() {
        let joinAgentVC = LMJoinAgentViewController()
        joinAgentVC.show(in: self)
    }

    @objc private func copyAction() {
        UIPasteboard.general.string = whatsappNumber
        HUD.showSuccess("Copied")
    }
}

private final class LMJoinAgentViewController: UIViewController, UITextFieldDelegate {
    private let dimView = UIView()
    private let contentView = UIView()
    private let agentIDField = UITextField()
    private let resultView = UIView()
    private let resultIDLabel = UILabel()
    private let resultNameLabel = UILabel()
    private let confirmButton = UIButton(type: .custom)

    private var contentBottomConstraint: Constraint?
    private var selectedAgentID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        registerKeyboardNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func show(in parent: UIViewController) {
        parent.addChild(self)
        parent.view.addSubview(view)
        view.snp.makeConstraints { $0.edges.equalToSuperview() }
        didMove(toParent: parent)

        view.layoutIfNeeded()
        dimView.alpha = 0
        contentView.transform = CGAffineTransform(translationX: 0, y: contentView.bounds.height)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            self.dimView.alpha = 1
            self.contentView.transform = .identity
        }
    }

    private func buildView() {
        view.backgroundColor = .clear

        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.48)
        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimViewTapped)))
        view.addSubview(dimView)
        dimView.snp.makeConstraints { $0.edges.equalToSuperview() }

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.clipsToBounds = true
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            contentBottomConstraint = $0.bottom.equalToSuperview().constraint
            $0.height.equalTo(351)
        }

        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = lmColorHex("#172019")
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.size.equalTo(36)
        }

        let titleLabel = UILabel(lmfont: lmFontM(18), textColor: lmColorHex("#172019"))
        titleLabel.text = "Join Agent"
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(closeButton)
        }

        let sectionTitleLabel = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#172019"))
        sectionTitleLabel.text = "Join an Agent Team"
        contentView.addSubview(sectionTitleLabel)
        sectionTitleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(67)
        }

        let sectionSubtitleLabel = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#A0A6A1"))
        sectionSubtitleLabel.text = "Get the ID from your agent."
        contentView.addSubview(sectionSubtitleLabel)
        sectionSubtitleLabel.snp.makeConstraints {
            $0.left.equalTo(sectionTitleLabel)
            $0.top.equalTo(sectionTitleLabel.snp.bottom).offset(7)
        }

        let inputView = makeFieldContainer()
        contentView.addSubview(inputView)
        inputView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(sectionSubtitleLabel.snp.bottom).offset(13)
            $0.height.equalTo(44)
        }

        agentIDField.font = lmFontR(13)
        agentIDField.textColor = lmColorHex("#172019")
        agentIDField.attributedPlaceholder = NSAttributedString(
            string: "Enter the agent ID",
            attributes: [.foregroundColor: lmColorHex("#A0A6A1")]
        )
        agentIDField.keyboardType = .numberPad
        agentIDField.returnKeyType = .done
        agentIDField.clearButtonMode = .whileEditing
        agentIDField.delegate = self
        agentIDField.addTarget(self, action: #selector(agentIDDidChange), for: .editingChanged)
        inputView.addSubview(agentIDField)
        agentIDField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-78)
        }

        let checkButton = makeCheckButton(action: #selector(checkAgentAction))
        inputView.addSubview(checkButton)
        checkButton.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.width.equalTo(66)
        }

        resultView.backgroundColor = lmColorHex("#F5F5F5")
        resultView.layer.cornerRadius = 12
        resultView.isHidden = true
        contentView.addSubview(resultView)
        resultView.snp.makeConstraints {
            $0.left.right.equalTo(inputView)
            $0.top.equalTo(inputView.snp.bottom).offset(12)
            $0.height.equalTo(44)
        }

        resultIDLabel.font = lmFontR(13)
        resultIDLabel.textColor = lmColorHex("#172019")
        resultView.addSubview(resultIDLabel)
        resultIDLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.width.lessThanOrEqualTo(135)
        }

        let avatarView = UIImageView(image: kPlaceholder_avatar)
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 10
        resultView.addSubview(avatarView)
        avatarView.snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(resultIDLabel.snp.right).offset(8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }

        resultNameLabel.font = lmFontR(11)
        resultNameLabel.textColor = lmColorHex("#172019")
        resultNameLabel.text = "Nickname"
        resultView.addSubview(resultNameLabel)
        resultNameLabel.snp.makeConstraints {
            $0.left.equalTo(avatarView.snp.right).offset(5)
            $0.centerY.equalToSuperview()
            $0.right.lessThanOrEqualToSuperview().offset(-97)
        }

        let removeButton = UIButton(type: .custom)
        removeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        removeButton.tintColor = lmColorHex("#7F8580")
        removeButton.addTarget(self, action: #selector(removeResultAction), for: .touchUpInside)
        resultView.addSubview(removeButton)
        removeButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-72)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        let resultCheckButton = makeCheckButton(action: #selector(checkAgentAction))
        resultView.addSubview(resultCheckButton)
        resultCheckButton.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.width.equalTo(66)
        }

        confirmButton.setTitle("Confirm to Join", for: .normal)
        confirmButton.setTitleColor(lmColorHex("#8CFF15"), for: .normal)
        confirmButton.setTitleColor(lmColorHex("#8CFF15", alpha: 0.45), for: .disabled)
        confirmButton.titleLabel?.font = lmFontM(18)
        confirmButton.backgroundColor = lmColorHex("#172019")
        confirmButton.layer.cornerRadius = 8
        confirmButton.isEnabled = false
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        contentView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(resultView.snp.bottom).offset(31)
            $0.height.equalTo(56)
        }
    }

    private func makeFieldContainer() -> UIView {
        let fieldView = UIView()
        fieldView.backgroundColor = lmColorHex("#F5F5F5")
        fieldView.layer.cornerRadius = 12
        return fieldView
    }

    private func makeCheckButton(action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("Check", for: .normal)
        button.setTitleColor(lmColorHex("#79E600"), for: .normal)
        button.titleLabel?.font = lmFontR(14)
        button.addTarget(self, action: action, for: .touchUpInside)

        let divider = UIView()
        divider.backgroundColor = lmColorHex("#B7BBB8")
        button.addSubview(divider)
        divider.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(1)
            $0.height.equalTo(16)
        }
        return button
    }

    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func agentIDDidChange() {
        if selectedAgentID != agentIDField.text {
            selectedAgentID = nil
            resultView.isHidden = true
            confirmButton.isEnabled = false
        }
    }

    @objc private func checkAgentAction() {
        view.endEditing(true)
        let agentID = agentIDField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !agentID.isEmpty else {
            HUD.show("Please enter the agent ID")
            return
        }

        // Replace this local result with the agent-query API response when the endpoint is available.
        selectedAgentID = agentID
        resultIDLabel.text = agentID
        resultView.isHidden = false
        confirmButton.isEnabled = true
    }

    @objc private func removeResultAction() {
        selectedAgentID = nil
        agentIDField.text = nil
        resultView.isHidden = true
        confirmButton.isEnabled = false
        agentIDField.becomeFirstResponder()
    }

    @objc private func confirmAction() {
        guard selectedAgentID != nil else { return }
        HUD.show("Coming soon")
    }

    @objc private func dimViewTapped() {
        if agentIDField.isFirstResponder {
            view.endEditing(true)
        } else {
            hide()
        }
    }

    @objc private func closeAction() {
        hide()
    }

    private func hide() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn]) {
            self.dimView.alpha = 0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.bounds.height)
        } completion: { _ in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }

        let keyboardHeight = max(0, view.bounds.maxY - keyboardFrame.minY)
        contentBottomConstraint?.update(offset: -keyboardHeight)
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval) ?? 0.25
        contentBottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


private extension UILabel {
    func setLineSpacing(_ spacing: CGFloat) {
        guard let text else { return }
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = spacing
        attributedText = NSAttributedString(
            string: text,
            attributes: [.font: font as Any, .foregroundColor: textColor as Any, .paragraphStyle: paragraph]
        )
    }
}
