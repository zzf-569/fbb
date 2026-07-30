import UIKit

final class LMMessageSettingsViewController: LMBaseVC {
    private let bannerSwitch = UISwitch()
    private let soundSwitch = UISwitch()
    private let vibrationSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Message Settings"
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#F5F6FA")
        buildView()
    }

    private func buildView() {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        view.addSubview(card)
        card.snp.makeConstraints { $0.left.right.equalToSuperview().inset(16); $0.top.equalToSuperview().offset(kNavigationHeight + 12); $0.height.equalTo(168) }
        makeRow(in: card, index: 0, title: "Top Message Banner", control: bannerSwitch)
        makeRow(in: card, index: 1, title: "Sounds", control: soundSwitch)
        makeRow(in: card, index: 2, title: "Vibration", control: vibrationSwitch)
        bannerSwitch.isOn = false
        soundSwitch.isOn = true
        vibrationSwitch.isOn = true
    }

    private func makeRow(in card: UIView, index: Int, title: String, control: UISwitch) {
        let label = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#172019"))
        label.text = title
        card.addSubview(label)
        label.snp.makeConstraints { $0.left.equalToSuperview().offset(12); $0.top.equalToSuperview().offset(CGFloat(index) * 56); $0.height.equalTo(56) }
        control.onTintColor = lmColorHex("#172019")
        control.transform = CGAffineTransform(scaleX: 0.72, y: 0.72)
        card.addSubview(control)
        control.snp.makeConstraints { $0.right.equalToSuperview().offset(-10); $0.centerY.equalTo(label) }
    }
}
