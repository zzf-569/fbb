import UIKit
class ZodiacCard: UIView {
    var isFrontFacing = true 
    var rotationAngle: CGFloat = 0.0 
    var backView: UIView = UIView()
    var isnum: Bool = true
    lazy var cardView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "zodiacCard"))
        return view
    }()
    init(backView: UIView) {
        super.init(frame: .zero)
        self.backView = backView
        set_UI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func set_UI() {
        addSubview(cardView)
        addSubview(backView)
        backView.isHidden = true
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.addGestureTap { [weak self] _ in
            guard let self = self else {return}
            let flipAngle = 0.0
            UIView.transition(with: self.cardView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.cardView.transform = CGAffineTransform(rotationAngle: .pi * flipAngle / 180)
            }) { _ in
                self.cardView.isHidden = true
                self.backView.isHidden = false
                self.postData()
            }
        }
    }
    func postData() {
        if isnum {
            CommonNetWork.zodiacOpen(openLuckNumber: true).lmrequest { _ in
            } failureBlock: { _ in
            }
        } else {
            CommonNetWork.zodiacOpen(openMatchUser: true).lmrequest { _ in
            } failureBlock: { _ in
            }
        }
    }
    func setOpen(open: Bool) {
        self.cardView.isHidden = open
        self.backView.isHidden = !open
    }
}
