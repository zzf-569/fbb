import UIKit
private let kClockSec = 0.1
public extension LMDanmuView {
    func pause() {
        self.isPause = true
        self.subviews.forEach { item in
            item.layer.pauseAnimation()
        }
    }
    func resume() {
        self.isPause = false
        self.subviews.forEach { item in
            item.layer.resumeAnimation()
        }
        self.initTimer()
    }
}
public class LMDanmuView: UIView {
    weak var delegate: LMDanmuViewProtocol?
    var dataSource: [LMDanmuModelProtocol] = []
    var lineCount: Int = 5
    private var isPause: Bool = false
    private var timer: Timer?
    lazy private var waitTimeArray: [TimeInterval] = {
        var tempArray: [TimeInterval] = []
        for i in 0..<lineCount {
            tempArray.append(0.0)
        }
        return tempArray
    }()
    lazy private var leftTimeArray: [TimeInterval] = {
        var tempArray: [TimeInterval] = []
        for i in 0..<lineCount {
            tempArray.append(0.0)
        }
        return tempArray
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        self.addGestureRecognizer(tap)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.initTimer()
        self.layer.masksToBounds = true
    }
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
}
private extension LMDanmuView {
    func setViewSnp() {
    }
    func initTimer() {
        if timer == nil {
            timer = Timer(timeInterval: kClockSec, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                self.checkAndBiu()
            })
            RunLoop.current.add(timer!, forMode: .common)
        }
    }
    func checkAndBiu() {
        guard !isPause else {
            return
        }
        guard self.dataSource.count != 0 else {
            self.delegate?.dMViewDataSourceDidEmpty()
            return
        }
        for i in 0..<lineCount {
            var waitValue = self.waitTimeArray[i] - kClockSec
            if waitValue <= 0.0 {
                waitValue = 0.0
            }
            self.waitTimeArray[i] = waitValue
            var leftValue = self.leftTimeArray[i] - kClockSec
            if leftValue <= 0.0 {
                leftValue = 0.0
            }
            self.leftTimeArray[i] = leftValue
        }
        self.dataSource.sort { $0.beginTime < $1.beginTime }
        guard let delegate = self.delegate else { return }
        self.dataSource.removeAll { model in
            let beginTime = model.beginTime
            let currentTime = delegate.currentTime
            if beginTime > currentTime {
                return false
            }
            let result = self.checkBoomAndBiu(model)
            return result
        }
    }
    func checkBoomAndBiu(_ model: LMDanmuModelProtocol) -> Bool {
        guard let delegate = self.delegate else { return false }
        let danmuLineHeight = self.frame.size.height / Double(lineCount)
        for i in 0..<lineCount {
            let waitTime = self.waitTimeArray[i]
            if waitTime > 0 {
                continue
            }
            let item = delegate.dMViewForItem(model: model)
            let leftTime = self.leftTimeArray[i]
            let speed = (item.frame.size.width + self.frame.size.width) / model.liveTime
            let distance = leftTime + speed
            if distance > self.frame.size.width {
                continue
            }
            self.waitTimeArray[i] = item.frame.size.width / speed
            self.leftTimeArray[i] = model.liveTime
            var frame = item.frame
            frame.origin = CGPoint(x: self.frame.size.width, y: danmuLineHeight * Double(i))
            item.frame = frame
            self.addSubview(item)
            UIView.animate(withDuration: model.liveTime, delay: 0, options: .curveLinear) {
                var frame = item.frame
                frame.origin.x = -item.frame.size.width
                item.frame = frame
            } completion: { _ in
                item.removeFromSuperview()
            }
            return true
        }
        return false
    }
    @objc func tapClick(tap: UITapGestureRecognizer) {
        let point = tap.location(in: tap.view)
        for item in self.subviews {
            if let frame = item.layer.presentation()?.frame {
                let isContain = frame.contains(point)
                if isContain {
                    self.delegate?.dMViewDidClick(item: item, at: point)
                    break
                }
            }
        }
    }
}
fileprivate extension CALayer {
    func pauseAnimation() {
        let pausedTime = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0.0
        self.timeOffset = pausedTime
    }
    func resumeAnimation() {
        let pausedTime = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }
}
