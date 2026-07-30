import UIKit
import AVFoundation
import Photos
import CoreLocation
import CoreBluetooth
import UserNotifications

final class LimitsViewController: LMBaseVC {
    private var statusLabels: [UILabel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Privacy"
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#F5F6FA")
        buildView()
        refreshStatuses()
    }

    private func buildView() {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        view.addSubview(scroll)
        scroll.snp.makeConstraints { $0.top.equalToSuperview().offset(kNavigationHeight); $0.left.right.bottom.equalToSuperview() }

        let content = UIView()
        scroll.addSubview(content)
        content.snp.makeConstraints { $0.edges.equalToSuperview(); $0.width.equalToSuperview() }
        let rows: [(String, String, String)] = [
            ("Allow Voiro to send you notifications.", "For unread message alerts.", "notifications"),
            ("Allow Voiro to access your camera.", "For creating pictures and recording videos.", "camera"),
            ("Allow Voiro to access your photo album", "For uploading, sending pictures, etc.", "photos"),
            ("Allow Voiro to access your microphone.", "For recording video and sending voice messages.", "microphone"),
            ("Allow Voiro to use Bluetooth.", "To connect and use Bluetooth headphones.", "bluetooth"),
            ("Allow Voiro to access your location.", "To find nearby users.", "location")
        ]
        var previous: UIView?
        for item in rows {
            let row = makeRow(title: item.0, subtitle: item.1)
            content.addSubview(row)
            row.snp.makeConstraints {
                $0.left.right.equalToSuperview().inset(16)
                $0.height.equalTo(80)
                if let previous { $0.top.equalTo(previous.snp.bottom).offset(12) } else { $0.top.equalToSuperview().offset(12) }
            }
            row.accessibilityIdentifier = item.2
            previous = row
        }
        previous?.snp.makeConstraints { $0.bottom.equalToSuperview().offset(-20) }
    }

    private func makeRow(title: String, subtitle: String) -> UIView {
        let row = UIControl()
        row.backgroundColor = .white
        row.layer.cornerRadius = 12
        row.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        let titleLabel = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#172019"))
        titleLabel.text = title
        titleLabel.numberOfLines = 2
        row.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.left.equalToSuperview().offset(12); $0.top.equalToSuperview().offset(14); $0.right.equalToSuperview().offset(-70) }
        let subtitleLabel = UILabel(lmfont: lmFontR(11), textColor: lmColorHex("#A0A6A1"))
        subtitleLabel.text = subtitle
        row.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { $0.left.equalTo(titleLabel); $0.top.equalTo(titleLabel.snp.bottom).offset(3); $0.right.lessThanOrEqualToSuperview().offset(-12) }
        let status = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#7F8580"))
        status.textAlignment = .right
        statusLabels.append(status)
        row.addSubview(status)
        status.snp.makeConstraints { $0.right.equalToSuperview().offset(-12); $0.centerY.equalToSuperview(); $0.width.equalTo(52) }
        let arrow = UIImageView(image: UIImage(named: "me_more"))
        row.addSubview(arrow)
        arrow.snp.makeConstraints { $0.right.equalToSuperview().offset(-5); $0.centerY.equalToSuperview(); $0.size.equalTo(10) }
        return row
    }

    private func refreshStatuses() {
        let statuses = ["On 〉", cameraStatus() ? "On 〉" : "Off 〉", photoStatus() ? "On 〉" : "Off 〉", microphoneStatus() ? "On 〉" : "Off 〉", bluetoothStatus(), locationStatus()]
        for (label, status) in zip(statusLabels, statuses) { label.text = status }
    }

    private func cameraStatus() -> Bool { AVCaptureDevice.authorizationStatus(for: .video) == .authorized }
    private func photoStatus() -> Bool { PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized }
    private func microphoneStatus() -> Bool { AVCaptureDevice.authorizationStatus(for: .audio) == .authorized }
    private func bluetoothStatus() -> String {
        if #available(iOS 13.1, *) { return CBCentralManager.authorization == .allowedAlways ? "On 〉" : "Off 〉" }
        return "On 〉"
    }
    private func locationStatus() -> String {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse ? "On 〉" : "Off 〉"
    }

    @objc private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
