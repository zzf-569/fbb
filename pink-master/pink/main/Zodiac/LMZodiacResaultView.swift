import UIKit
class LMZodiacResaultView: UIView {
    lazy var item1: ZodiacItemView = {
        let view = ZodiacItemView()
        return view
    }()
    lazy var item2: ZodiacItemView = {
        let view = ZodiacItemView()
        return view
    }()
    lazy var item3: ZodiacItemView = {
        let view = ZodiacItemView()
        return view
    }()
    lazy var item4: ZodiacItemView = {
        let view = ZodiacItemView()
        return view
    }()
    lazy var item5: ZodiacItemView = {
        let view = ZodiacItemView()
        return view
    }()
    lazy var nextbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: lmColorHex("#FFFFFF"))
        btn.backgroundColor = lmColorHex("#FFD6BF")
        btn.cornerRadius(kScaleWidth(24))
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        btn.setTitle("关闭", for: .normal)
        return btn
    }()
    @objc func close() {
        self.isHidden = true
    }
    lazy var titleLab: UILabel = {
        let lb = UILabel()
        lb.font = lmFontR(16)
        lb.textColor = lmColorHex("#F1E1BBFF")
        lb.textAlignment = .center
        lb.text = "推荐大神陪玩,快来下单吧"
        return lb
    }()
    lazy var tipslb: UILabel = {
        let lb = UILabel()
        lb.font = lmFontR(12)
        lb.textColor = lmColorHex("#F1E1BBFF")
        lb.cornerRadius(6)
        lb.textAlignment = .center
        lb.text = "剩余3/4次"
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func set_Subviews() {
        backgroundColor(lmColorHex("#000000", alpha: 0.8))
        addSubview(titleLab)
        addSubview(item1)
        addSubview(item2)
        addSubview(item3)
        addSubview(item4)
        addSubview(item5)
        addSubview(nextbtn)
        addSubview(tipslb)
        titleLab.snp.makeConstraints { make in
            make.bottom.equalTo(item1.snp.top).offset(-30)
            make.centerX.equalToSuperview()
        }
        item1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(30))
            make.top.equalToSuperview().offset(kScaleWidth(238))
            make.size.equalTo(CGSize(width: kScaleWidth(102), height: kScaleWidth(118)))
        }
        item2.snp.makeConstraints { make in
            make.left.equalTo(item1.snp.right).offset(kScaleWidth(12))
            make.top.equalToSuperview().offset(kScaleWidth(238))
            make.size.equalTo(CGSize(width: kScaleWidth(102), height: kScaleWidth(118)))
        }
        item3.snp.makeConstraints { make in
            make.left.equalTo(item2.snp.right).offset(kScaleWidth(12))
            make.top.equalToSuperview().offset(kScaleWidth(238))
            make.size.equalTo(CGSize(width: kScaleWidth(102), height: kScaleWidth(118)))
        }
        item4.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(87))
            make.top.equalToSuperview().offset(kScaleWidth(368))
            make.size.equalTo(CGSize(width: kScaleWidth(102), height: kScaleWidth(118)))
        }
        item5.snp.makeConstraints { make in
            make.left.equalTo(item4.snp.right).offset(kScaleWidth(12))
            make.top.equalToSuperview().offset(kScaleWidth(368))
            make.size.equalTo(CGSize(width: kScaleWidth(102), height: kScaleWidth(118)))
        }
        nextbtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(item5.snp.bottom).offset(kScaleWidth(40))
            make.size.equalTo(CGSize(width: kScaleWidth(200), height: kScaleWidth(48)))
        }
        tipslb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nextbtn.snp.bottom).offset(kScaleWidth(12))
        }
    }
}
class ZodiacItemView: UIView {
    lazy var bgimage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "zodiac_itembg"))
        return imageV
    }()
    lazy var Avarar: UIImageView = {
        let imageV = UIImageView()
        imageV.cornerRadius(36)
        imageV.contentMode = .scaleAspectFill
        imageV.isUserInteractionEnabled = true
        return imageV
    }()
    lazy var headimage: UIImageView = {
        let imageV = UIImageView()
        imageV.isUserInteractionEnabled = true
        return imageV
    }()
    lazy var likebtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "zodiac_like"), for: .normal)
        btn.setImage(UIImage(named: "zodiac_liked"), for: .selected)
        return btn
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(10), textColor: lmColorHex("#FFE7AEFF"))
        lb.textAlignment = .center
        return lb
    }()
    var dataSoure: UsInfoItem = UsInfoItem() {
        didSet {
            Avarar.set_Image(url: dataSoure.avatar)
            namelb.text = dataSoure.nickname
            likebtn.isSelected = dataSoure.hostLiked
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func set_Subviews() {
        addSubview(Avarar)
        addSubview(bgimage)
        addSubview(headimage)
        addSubview(likebtn)
        addSubview(namelb)
        Avarar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(15))
            make.size.equalTo(CGSize(width: kScaleWidth(72), height: kScaleWidth(72)))
        }
        bgimage.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(102))
        }
        headimage.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(102))
        }
        likebtn.snp.makeConstraints { make in
            make.bottom.equalTo(bgimage.snp.bottom).offset(-kScaleWidth(6))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(20), height: kScaleWidth(20)))
        }
        namelb.snp.makeConstraints { make in
            make.top.equalTo(likebtn.snp.bottom).offset(0)
            make.left.right.bottom.equalToSuperview()
        }
        self.addGestureTap { _ in
            self.superview?.isHidden = true
            RouteService.pushUserMainPage(self.dataSoure.userId, vc: UIViewController.current)
        }
    }
}
