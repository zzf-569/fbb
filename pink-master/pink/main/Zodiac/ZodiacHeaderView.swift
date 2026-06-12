import UIKit
class ZodiacHeaderView: UIView {
    var dataSoure: zodiacModel = zodiacModel()
    lazy var zodiacImage: UIImageView = {
        let iamgeV = UIImageView()
        return iamgeV
    }()
    lazy var numText: UILabel = {
        let lb = UILabel()
        lb.font = lmFontASHTB(48)
        lb.textColor = lmColorHex("#F1E1BB")
        lb.textAlignment = .center
        return lb
    }()
    lazy var lbText: UILabel = {
        let lb = UILabel()
        lb.font = lmFontR(12)
        lb.textColor = .white
        lb.textAlignment = .right
        lb.text = "今日上分指数"
        return lb
    }()
    lazy var letfBack: UIImageView = {
        let view = UIImageView(image: UIImage(named: "Zodiac_left"))
        return view
    }()
    lazy var luckNum: UILabel = {
        let lb = UILabel()
        lb.font = lmFontASHTB(64)
        lb.textAlignment = .center
        lb.textColor = lmColorHex("#F1E1BB")
        return lb
    }()
    lazy var leftCard: ZodiacCard = {
        let view = ZodiacCard(backView: letfBack)
        view.isnum = true
        return view
    }()
    lazy var rightBack: UIImageView = {
        let view = UIImageView(image: UIImage(named: "Zodiac_right"))
        view.addGestureTap { [weak self] _ in
            guard let self = self else {return}
            RouteService.pushUserMainPage(self.dataSoure.matchUser.userId, vc: UIViewController.current)
        }
        return view
    }()
    lazy var rightCard: ZodiacCard = {
        let view = ZodiacCard(backView: rightBack)
        view.isnum = false
        return view
    }()
    lazy var userHaeder: UIImageView = {
        let image = UIImageView()
        image.set_Border(radius: kScaleWidth(32), borderWidth: 2, borderColor: lmColorHex("#FFD6BFFF"))
        image.contentMode = .scaleAspectFill
        return image
    }()
    lazy var username: UILabel = {
        let lb = UILabel()
        lb.font = lmFontM(14)
        lb.textColor = lmColorHex("#FFD6BFFF")
        lb.textAlignment = .center
        return lb
    }()
    lazy var tips: UILabel = {
        let lb = UILabel()
        lb.font = lmFontR(10)
        lb.textColor = lmColorHex("#FFD6BF")
        lb.backgroundColor = lmColorHex("#FFD6BF1A")
        lb.cornerRadius(6)
        lb.textAlignment = .center
        lb.text = "温馨提示：生肖仅用于娱乐，不具有科学依据。"
        return lb
    }()
    lazy var headtitle: UIImageView = {
        let view = UIImageView(image: UIImage(named: "zodiac_tit"))
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        set_UI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func set_UI() {
        addSubview(zodiacImage)
        addSubview(numText)
        addSubview(lbText)
        zodiacImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(35))
            make.top.equalToSuperview().offset(kScaleWidth(15))
            make.size.equalTo(CGSize(width: kScaleWidth(116), height: kScaleWidth(72)))
        }
        lbText.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(35))
            make.top.equalToSuperview().offset(kScaleWidth(74))
        }
        numText.snp.makeConstraints { make in
            make.centerX.equalTo(lbText)
            make.top.equalToSuperview().offset(kScaleWidth(12))
        }
    }
    func confData(model: zodiacModel) {
        self.dataSoure = model
        zodiacImage.image = UIImage(named: model.zodiacName)
        luckNum.text = model.luckyNumber
        numText.text = model.overallScore
        userHaeder.set_Image(url: model.matchUser.avatar)
        username.text = model.matchUser.nickname
        leftCard.setOpen(open: model.openLuckNumber)
        rightCard.setOpen(open: model.openLuckNumber)
    }
}
