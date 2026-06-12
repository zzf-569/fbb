import UIKit
import AttributedString
extension LMFloatingView {
    func clear() {
        stopTimer()
        scrolllb.stopScrolling()
    }
    func setDataSoure(_ model: LMFloatingModel) {
        scrolllb.attributedString = model.content
        switch model.style {
        case .gift:
            bgimv.image = UIImage(named: "rm_current_floating_screen_bg")
        case .allRoomGift:
            bgimv.image = UIImage(named: "rm_current_floating_screen_bg")
        default:
            lmPrint("其他样式")
        }
    }
    func showAnimation(_ superView: UIView) {
        superView.addSubview(self)
        self.frame = CGRect(x: superView.width, y: kNavigationHeight + 40.0, width: superView.width, height: 64.0)
        UIView.animate(withDuration: 0.3) {
            self.x = 0
        } completion: { _ in
            self.scrolllb.startScrolling()
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
        if currentSecond >= minSeconds, isComplete {
            stopTimer()
            scrolllb.stopScrolling()
            hideAnimation()
        }
    }
}
class LMFloatingView: UIView {
    public var scrollCompleteblock: (() -> Void)?
    private var timer: Timer?
    private let minSeconds: TimeInterval = 4
    private var currentSecond: TimeInterval = 0
    private var isComplete: Bool = false
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
    private lazy var scrolllb: LMScrollLabel = {
        let scrolllb = LMScrollLabel()
        scrolllb.font = lmFontM(14)
        scrolllb.textColor = lmColorHex("#FFFFFF")
        scrolllb.scrollSpeed = 0.5
        scrolllb.maxWidth = 360.0 - 32.0 * 2
        scrolllb.backgroundColor = .clear
        scrolllb.scrollOneRoundblock = { [weak self] in
            guard let self = self else { return }
            lmPrint("当前轮次已完成")
            self.isComplete = true
            if currentSecond >= minSeconds, isComplete {
                stopTimer()
                scrolllb.stopScrolling()
                hideAnimation()
            }
        }
        return scrolllb
    }()
}
private extension LMFloatingView {
    private func setViewSnp() {
        addSubview(bgimv)
        bgimv.addSubview(scrolllb)
        bgimv.snp.makeConstraints { make in
            make.center.height.equalToSuperview()
            make.width.equalTo(360.0)
        }
        scrolllb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32.0)
            make.right.equalToSuperview().offset(-32.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(30.0)
        }
    }
}
