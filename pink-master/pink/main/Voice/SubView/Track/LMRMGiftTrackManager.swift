import Foundation
private let GIFT_ICON_TAG = 201
class LMRMGiftTrackManager: NSObject {
    override init() { super.init() }
    private var dataSource: [LMRMGiftTrackModel] = []
    private var isplay: Bool = false
    private var superView: UIView?
    private var aniComCount = 0
    func set_SuperView(_ view: UIView?) {
        superView = view
        if isplay {
            removeFloatingView()
        }
        isplay = false
        dataSource.removeAll()
        aniComCount = 0
    }
    func add(_ model:LMRMGiftTrackModel) {
        dataSource.append(model)
        if !isplay {
            startAnimation()
        }
    }
    func reConfigUI() {
        if isplay {
            removeFloatingView()
        }
        isplay = false
        dataSource.removeAll()
        aniComCount = 0
    }
}
private extension LMRMGiftTrackManager {
    func startAnimation() {
        if let model = dataSource.first,
            let superView = self.superView,
            let RoomVC = VoiceShared.roomViewController,
            let seatPoints = RoomVC.roomView.seatView.seatsCenters() {
            var micPositions: [CGPoint] = []
            for toUserId in model.toUserIds {
                if let seat = RoomVC.viewModel.userSeatInfo(toUserId), seat.seatIndex < seatPoints.count {
                    if let index = RoomVC.viewModel.roomItem.seatList.firstIndex(where: {$0.seatIndex == seat.seatIndex}), index > 0 {
                        micPositions.append(seatPoints[index - 1])
                    } else {
                    }
                }
            }
            guard micPositions.count > 0 else {
                return
            }
            aniComCount = micPositions.count
            isplay = true
            if let seat = RoomVC.viewModel.userSeatInfo(model.userId) {
                var startPoint = seatPoints[seat.seatIndex]
                if let index = RoomVC.viewModel.roomItem.seatList.firstIndex(where: {$0.seatIndex == seat.seatIndex}) {
                    startPoint = seatPoints[index]
                }
                for micPosition in micPositions {
                    let fadeAnimation = CAKeyframeAnimation(keyPath: "opacity")
                    fadeAnimation.values = [0.0, 1.0, 1.0] 
                    fadeAnimation.keyTimes = [0.0, 0.3, 1.0] 
                    fadeAnimation.duration = 0.3 + 0.7
                    fadeAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
                    let dispersePath = UIBezierPath()
                    dispersePath.move(to: startPoint)
                    let controlPoint = CGPoint(
                        x: (superView.bounds.midX + micPosition.x) / 2,
                        y: 300 - 100 
                    )
                    dispersePath.addQuadCurve(to: micPosition, controlPoint: controlPoint)
                    let disAni = CAKeyframeAnimation(keyPath: "position")
                    disAni.path = dispersePath.cgPath
                    disAni.duration = 0.7
                    disAni.beginTime = 0.3 
                    let giftIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
                    giftIcon.tag = GIFT_ICON_TAG
                    giftIcon.alpha = 0
                    giftIcon.set_Image(url: model.giftIcon)
                    giftIcon.center = startPoint
                    superView.addSubview(giftIcon)
                    let animationGroup = CAAnimationGroup()
                    animationGroup.animations = [fadeAnimation, disAni]
                    animationGroup.duration = 0.3 + 0.7
                    animationGroup.delegate = self 
                    animationGroup.isRemovedOnCompletion = false
                    animationGroup.fillMode = .forwards
                    giftIcon.layer.add(animationGroup, forKey: "giftAnimation")
                }
            } else {
                let centerPoint = CGPoint(x: kScreenWidth / 2, y: kScreenHeight / 2)
                let giftIcon = UIImageView(frame: CGRect(x: (kScreenWidth - 50.0) / 2, y: -50.0, width: 50.0, height: 50.0))
                giftIcon.tag = GIFT_ICON_TAG
                giftIcon.set_Image(url: model.giftIcon)
                superView.addSubview(giftIcon)
                let fadeAnimation = CAKeyframeAnimation(keyPath: "opacity")
                fadeAnimation.values = [0.0, 1.0, 1.0] 
                fadeAnimation.keyTimes = [0.0, 0.5, 1.0] 
                fadeAnimation.duration = 1.5
                fadeAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
                let fallPath = UIBezierPath()
                fallPath.move(to: giftIcon.center)
                fallPath.addLine(to: centerPoint) 
                let fallAnimation = CAKeyframeAnimation(keyPath: "position")
                fallAnimation.path = fallPath.cgPath
                fallAnimation.duration = 1.0
                fallAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
                for micPosition in micPositions {
                    let dispersePath = UIBezierPath()
                    dispersePath.move(to: centerPoint)
                    let controlPoint = CGPoint(
                        x: (superView.bounds.midX + micPosition.x) / 2,
                        y: 300 - 100 
                    )
                    dispersePath.addQuadCurve(to: micPosition, controlPoint: controlPoint)
                    let disAni = CAKeyframeAnimation(keyPath: "position")
                    disAni.path = dispersePath.cgPath
                    disAni.duration = 0.5
                    disAni.beginTime = 1.0 
                    let giftCopy = UIImageView(image: giftIcon.image)
                    giftCopy.tag = GIFT_ICON_TAG
                    giftCopy.tintColor = giftIcon.tintColor
                    giftCopy.frame = giftIcon.frame
                    superView.addSubview(giftCopy)
                    let animationGroup = CAAnimationGroup()
                    animationGroup.animations = [fadeAnimation, fallAnimation, disAni]
                    animationGroup.duration = 1.5
                    animationGroup.delegate = self 
                    animationGroup.isRemovedOnCompletion = false
                    animationGroup.fillMode = .forwards
                    giftCopy.layer.add(animationGroup, forKey: "giftAnimation")
                }
                giftIcon.removeFromSuperview()
            }
        }
    }
    func removeFloatingView() {
        if let superView = self.superView {
            for view in superView.subviews {
                if view.tag == GIFT_ICON_TAG {
                    view.removeFromSuperview()
                }
            }
        }
    }
}
extension LMRMGiftTrackManager: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            aniComCount -= 1
            if aniComCount == 0 {
                removeFloatingView()
                if dataSource.first != nil {
                    dataSource.removeFirst()
                }
                isplay = false
                startAnimation()
            }
        }
    }
}
struct LMRMGiftTrackModel {
    let userId: String
    let toUserIds: [String]
    let giftIcon: String
}
