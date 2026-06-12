import UIKit
class LMZodiacYDView: UIView {
    lazy var LM1: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "LM_1"))
        return imageV
    }()
    lazy var Avatat: UIImageView = {
        let imageV = UIImageView()
        imageV.cornerRadius(28)
        imageV.contentMode = .scaleAspectFill
        return imageV
    }()
    lazy var LM2: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "LM_2"))
        imageV.isHidden = true
        return imageV
    }()
    var point: Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        set_Subviews()
        setDataSoure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func set_Subviews() {
        backgroundColor(lmColorHex("#000000", alpha: 0.8))
        UserDefaults().setValue(true, forKey: "firstyd")
    }
    func setDataSoure() {
        Avatat.set_Image(url: UserShared.user?.avatar)
        addSubview(LM1)
        LM1.addSubview(Avatat)
        addSubview(LM2)
        LM1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(180))
            make.size.equalTo(CGSize(width: kScaleWidth(144), height: kScaleWidth(254)))
        }
        Avatat.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kScaleWidth(24))
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(56)))
        }
        LM2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kScaleWidth(109))
            make.size.equalTo(CGSize(width: kScaleWidth(318), height: kScaleWidth(219)))
        }
        self.addGestureTap { _ in
            if self.point == 0 {
                self.LM1.isHidden = true
                self.LM2.isHidden = false
                self.point = 1
            } else {
                self.isHidden = true
                self.removeFromSuperview()
            }
        }
    }
}
