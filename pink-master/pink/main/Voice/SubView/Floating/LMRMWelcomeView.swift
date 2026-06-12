import Foundation
extension LMRMWelcomeView {
    func clear() {
        stopTimer()
    }
    func setDataSoure(_ model: UsInfoItem) {
        scrolllb.text = "\(model.nickname)来了"
        bgimv.set_Image(url: model.levelEntryEffect)
    }
    func showAnimation(_ superView: UIView) {
        superView.addSubview(self)
        self.frame = CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: 64.0)
        UIView.animate(withDuration: 0.3) {
            self.x = 0
        } completion: { _ in
            self.createTimer()
        }
    }
    func hideAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.x = -self.width
        } completion: { _ in
            self.scrollCompleteblock?()
        }
    }
    func createTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    @objc func timerAction() {
        currentSecond += 1
        if currentSecond >= minSeconds {
            stopTimer()
            hideAnimation()
        }
    }
}
class LMRMWelcomeView: UIView {
    public var scrollCompleteblock: (() -> Void)?
    private var timer: Timer?
    private let minSeconds: TimeInterval = 3
    private var currentSecond: TimeInterval = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var bgimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_floating_screen_bg"))
        return imv
    }()
    private lazy var scrolllb: UILabel = {
        let scrolllb = UILabel()
        scrolllb.font = lmFontM(14)
        scrolllb.textColor = lmColorHex("#FFFFFF")
        return scrolllb
    }()
}
private extension LMRMWelcomeView {
    private func setViewSnp() {
        addSubview(bgimv)
        bgimv.addSubview(scrolllb)
        bgimv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(kScreenWidth - 112 - 16)
        }
        scrolllb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(30.0)
        }
    }
}
