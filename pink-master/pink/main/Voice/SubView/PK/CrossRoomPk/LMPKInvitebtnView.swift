import UIKit
class LMPKInvitebtnView: UIView {
    func setDataSoure(_ data: inviteInfo) {
        set_time(data)
    }
    lazy var backImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "pk_invite_receive"))
        return imageV
    }()
    lazy var timelb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(14), textColor: .white)
        return lb
    }()
    var timer: Timer?
    var countDown: Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(backImage)
        addSubview(timelb)
        backImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        timelb.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
        }
    }
    func set_time(_ data: inviteInfo) {
        timer = Timer(safeTimerWithTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            let timeString = getTimeString(data)
            if timeString == nil {
                hide(nil)
            } else {
                timelb.lmtext("\(timeString ?? "")s")
            }
        })
    }
    func getTimeString(_ data: inviteInfo) -> String? {
        let currentTime = data.inviteTime
        let endTime = (Double(Date().timeIntervalSince1970*1000))
        if endTime >= currentTime {
            let timeDifference = endTime / 1000 - currentTime / 1000
            if timeDifference < 60 {
                let seconds = Int(timeDifference) % 60
                return String(format: "%d", 60 - seconds)
            } else {
                return nil
            }
        }
        return nil
    }
    func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
    func clear() {
        clearTimer()
        self.removeFromSuperview()
    }
    func hide(_ title: String?) {
        UIView.animate(withDuration: 0.3) {
        } completion: { _ in
            self.clear()
        }
    }
}
