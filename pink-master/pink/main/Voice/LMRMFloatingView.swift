import UIKit
import APNGKit
class LMRMFloatingView: UIView {
    private weak var delegate:VoiceServiceDelegate?
    private lazy var roomCover: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
            .isUserInteractionEnabled(true)
        imv.set_Border(radius: (self.width)/2, borderWidth: 4, borderColor: lmColorHex("#FF4F7D"))
        return imv
    }()
    lazy var deleteView: UILabel = {
        let lable = UILabel(lmfont: lmFontM(16), textColor: .white)
            .textAlignment(.center)
            .backgroundColor(.red)
            .frame(CGRect(x: 0, y: kScreenHeight - kTabHeight, width: kScreenWidth, height: kTabHeight))
            .isHidden(true)
            .alpha(0)
            .lmtext("移动到此区域关闭房间")
        if let superview = self.superview {
            superview.addSubview(lable)
            superview.bringSubviewToFront(self)
        }
        return lable
    }()
    private lazy var bgimv: APNGImageView = {
        let apngView = APNGImageView()
        do {
            let image = try APNGImage(named: "float_living")
            apngView.image = image
            apngView.autoStartAnimationWhenSetImage = false
        } catch {
        }
        return apngView
    }()
    init(frame: CGRect, delegate:VoiceServiceDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        setViewSnp()
        addPanGesture()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        self.addSubview(self.roomCover)
        self.roomCover.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.showRM()
        }
    }
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
    }
}
extension LMRMFloatingView {
    func setDataSoure(_ Room:RoomItem) {
        self.roomCover.set_Image(url:Room.cover)
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = 5.0
        rotationAnimation.repeatCount = Float.infinity
        self.roomCover.layer.add(rotationAnimation, forKey: nil)
    }
}
private extension LMRMFloatingView {
    @objc func closebtnAction() {
        self.delegate?.quiteRM()
    }
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let btn = gesture.view else { return }
        let btnWidth = btn.frame.width
        let btnHeight = btn.frame.height
        let screenWidth = kScreenWidth
        let screenHeight = kScreenHeight
        let minX: CGFloat = 10
        let maxX: CGFloat = screenWidth - btnWidth - 10
        let minY: CGFloat = kNavigationHeight
        let maxY: CGFloat = screenHeight
        let translation = gesture.translation(in: btn.superview)
        var newX = btn.center.x + translation.x
        var newY = btn.center.y + translation.y
        newX = max(minX + btnWidth / 2, min(newX, maxX + btnWidth / 2))
        newY = max(minY + btnHeight / 2, min(newY, maxY + btnHeight / 2))
        btn.center = CGPoint(x: newX, y: newY)
        gesture.setTranslation(.zero, in: btn.superview)
        if gesture.state == .changed {
            if translation.x > 5.0 || translation.y > 5.0 || translation.x < -5.0 || translation.y < -5.0 {
                if deleteView.isHidden {
                    deleteView.isHidden = false
                    UIView.animate(withDuration: 0.3) {
                        self.deleteView.alpha = 1
                    }
                }
            }
        }
        if gesture.state == .ended {
            UIView.animate(withDuration: 0.3) {
                self.deleteView.alpha = 0
            } completion: { _ in
                self.deleteView.isHidden = true
            }
            if newY >= screenHeight - kTabHeight {
                closebtnAction() 
            } else {
                autoAlignToEdge()
            }
        }
    }
    func autoAlignToEdge() {
        let screenWidth = kScreenWidth
        let btnCenterX = center.x
        UIView.animate(withDuration: 0.3) {
            if btnCenterX < screenWidth / 2 {
                self.frame.origin.x = 10
            } else {
                self.frame.origin.x = screenWidth - self.frame.width - 10
            }
        }
    }
}
