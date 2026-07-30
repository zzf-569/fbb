import UIKit

final class LanguageSettingViewController: LMBaseVC {
    private var itemViews: [AppLanguage: UIView] = [:]
    private let saveButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Language Settings"
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#F5F6FA")
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(lmColorHex("#8CFF15"), for: .normal)
        saveButton.titleLabel?.font = lmFontM(11)
        saveButton.backgroundColor = lmColorHex("#172019")
        saveButton.layer.cornerRadius = 5
        saveButton.frame = CGRect(x: 0, y: 0, width: 56, height: 28)
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        buildView()
        reloadLanguageState()
    }

    private func buildView() {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        view.addSubview(card)
        card.snp.makeConstraints { $0.left.right.equalToSuperview().inset(16); $0.top.equalToSuperview().offset(kNavigationHeight + 12); $0.height.equalTo(CGFloat(AppLanguage.allCases.count) * 56) }

        for (index, language) in AppLanguage.allCases.enumerated() {
            let row = UIControl()
            row.addTarget(self, action: #selector(languageTapped(_:)), for: .touchUpInside)
            row.tag = index
            card.addSubview(row)
            row.snp.makeConstraints { $0.left.right.equalToSuperview(); $0.top.equalToSuperview().offset(CGFloat(index) * 56); $0.height.equalTo(56) }
            let label = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#172019"))
            label.text = language.displayName
            row.addSubview(label)
            label.snp.makeConstraints { $0.left.equalToSuperview().offset(12); $0.centerY.equalToSuperview() }
            let check = UILabel(lmfont: lmFontM(18), textColor: lmColorHex("#8CFF15"))
            check.text = "✓"
            check.tag = 900
            row.addSubview(check)
            check.snp.makeConstraints { $0.right.equalToSuperview().offset(-14); $0.centerY.equalToSuperview() }
            itemViews[language] = row
        }
    }

    @objc private func languageTapped(_ sender: UIControl) {
        guard AppLanguage.allCases.indices.contains(sender.tag) else { return }
        AppLanguageManager.shared.setLanguage(AppLanguage.allCases[sender.tag])
        reloadLanguageState()
    }

    private func reloadLanguageState() {
        let current = AppLanguageManager.shared.currentLanguage
        for language in AppLanguage.allCases {
            itemViews[language]?.viewWithTag(900)?.isHidden = language != current
        }
    }

    @objc private func saveAction() {
        HUD.showSuccess("Saved")
    }
}
