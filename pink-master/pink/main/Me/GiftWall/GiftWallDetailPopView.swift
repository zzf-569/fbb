import UIKit
import AttributedString
extension GiftWallDetailPopView {
    func setDataSoure(_ model: GiftWallListL) {
        iconImage.set_Image(url: model.iconUrl)
        giftNamelb.lmtext(model.name)
        let price: ASAttributedString = .init(string: "礼物价值：".localized, .font(lmFontR(12)), .foreground(lmColorHex("#FFFFFFA3")))
        let iconI = ASAttributedString.ImageAttachment.image(UIImage(named: "cm_coin")!, .custom(size: CGSize(width: 12, height: 12)))
        let priceL: ASAttributedString = .init(string: model.price.toString(), .font(lmFontR(12)), .foreground(lmColorHex("#FFFFFFF5")))
        priceTextView.attributed.text = "\(price)\(iconI)\(priceL)"
        if model.unLocked {
            var upuser: ASAttributedString = .init(string: "\("最近点亮粉丝：".localized)\(model.latestLightingUpUser)", .font(lmFontR(12)), .foreground(lmColorHex("#FFFFFFA3")))
            upuser.set(attributes: [.foreground(lmColorHex("#FFFFFFF5"))], checkings: [.regex((model.latestLightingUpUser))])
            fansTextView.attributed.text = upuser
            var time: ASAttributedString = .init(string: "\("点亮时间：".localized)\(model.lightingUpTime)", .font(lmFontR(12)), .foreground(lmColorHex("#FFFFFFA3")))
            time.set(attributes: [.foreground(lmColorHex("#FFFFFFF5"))], checkings: [.regex((model.lightingUpTime))])
            timeTextView.attributed.text = time
            var count: ASAttributedString = .init(string: "\("点亮次数：".localized)\(model.lightingUpCount)", .font(lmFontR(12)), .foreground(lmColorHex("#FFFFFFA3")))
            count.set(attributes: [.foreground(lmColorHex("#FFFFFFF5"))], checkings: [.regex((model.lightingUpCount))])
            numTextView.attributed.text = count
        } else {
            fansTextView.attributed.text = .init(string: "最近点亮粉丝：虚位以待".localized, .font(lmFontR(12)), .foreground(lmColorHex("#FFFFFFA3")))
            timeTextView.attributed.text = .init(string: "点亮时间：未点亮".localized, .font(lmFontR(12)), .foreground(lmColorHex("#FFFFFFA3")))
            numTextView.attributed.text = .init(string: "点亮次数：未点亮".localized, .font(lmFontR(12)), .foreground(lmColorHex("#FFFFFFA3")))
        }
    }
    func show(_ vc: UIViewController? = nil) {
        if let viewController = vc {
            viewController.addChild(self)
            viewController.view.addSubview(self.view)
        } else {
            UIViewController.current?.addChild(self)
            UIViewController.current?.view.addSubview(self.view)
        }
        self.view.frame = UIScreen.main.bounds
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
            self.contentView.alpha = 1
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.clear()
        }
    }
}
class GiftWallDetailPopView: UIViewController {
    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            .backgroundColor(lmColorHex("#0000007F"))
            .alpha(0)
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
            .alpha(0)
        return view
    }()
    lazy var bgimv: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "gw_dtbg"))
        imageV.isUserInteractionEnabled = true
        return imageV
    }()
    lazy var iconImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var giftNamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#F3FF9BFF"))
            .isHidden(true)
        return lb
    }()
    lazy var fansTextView: UITextView = {
        let textView = UITextView(lmfont: lmFontR(12), textColor: lmColorHex("#FFFFFFA3"))
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        textView.backgroundColor(.clear)
        return textView
    }()
    lazy var priceTextView: UITextView = {
        let textView = UITextView(lmfont: lmFontR(12), textColor: lmColorHex("#FFFFFFA3"))
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        textView.backgroundColor(.clear)
        return textView
    }()
    lazy var timeTextView: UITextView = {
        let textView = UITextView(lmfont: lmFontR(12), textColor: lmColorHex("#FFFFFFA3"))
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        textView.backgroundColor(.clear)
        return textView
    }()
    lazy var numTextView: UITextView = {
        let textView = UITextView(lmfont: lmFontR(12), textColor: lmColorHex("#FFFFFFA3"))
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        textView.backgroundColor(.clear)
        return textView
    }()
    lazy var closebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "gw_colse"), target: self, action: #selector(closebtnAction))
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        setViewSnp()
    }
    deinit {
        lmPrint("UIViewController deinit：----------------\(Self.className)已被销毁")
    }
}
private extension GiftWallDetailPopView {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(contentView)
        contentView.addSubview(bgimv)
        bgimv.addSubview(iconImage)
        bgimv.addSubview(giftNamelb)
        bgimv.addSubview(fansTextView)
        bgimv.addSubview(priceTextView)
        bgimv.addSubview(timeTextView)
        bgimv.addSubview(numTextView)
        bgimv.addSubview(closebtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgimv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(222), height: kScaleWidth(236)))
        }
        closebtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-kScaleWidth(20))
            make.right.equalToSuperview().offset(kScaleWidth(20))
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        iconImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(20))
            make.size.equalTo(CGSize(width: kScaleWidth(72), height: kScaleWidth(72)))
        }
        giftNamelb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(124))
            make.height.equalTo(kScaleWidth(24))
        }
        fansTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(42))
            make.top.equalToSuperview().offset(kScaleWidth(124))
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(kScaleWidth(22))
        }
        priceTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(42))
            make.top.equalToSuperview().offset(kScaleWidth(148))
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(kScaleWidth(22))
        }
        timeTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(42))
            make.top.equalToSuperview().offset(kScaleWidth(172))
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(kScaleWidth(22))
        }
        numTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(42))
            make.top.equalToSuperview().offset(kScaleWidth(196))
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(kScaleWidth(22))
        }
        self.contentView.center = self.view.center
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @objc func closebtnAction() {
        hide()
    }
}
