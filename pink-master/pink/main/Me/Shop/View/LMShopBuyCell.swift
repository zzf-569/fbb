import UIKit
class LMShopBuyCell: BaseCollectionViewCell {
    var dataSoure: ShopPriceList = ShopPriceList() {
        didSet {
            daylb.lmtext("\(dataSoure.days.toString())天")
            coinlb.text = dataSoure.totalPrice.toString()
            discountImage.isHidden = dataSoure.discount == 100
            discountlb.isHidden = dataSoure.discount == 100
            discountlb.lmtext("\(dataSoure.discount/10)折")
        }
    }
    var theme: UIUserInterfaceStyle = .light {
        didSet {
            centerView.backgroundColor(theme == .dark ? lmColorHex("#00000033") : lmColorHex("#2B313D0A"))
            daylb.textColor(theme == .dark ? .white : .textDefaulColor)
            coinlb.textColor(theme == .dark ? lmColorHex("#FFFFFF66") : .textDefaulColor)
        }
    }
    var select: Bool = false {
        didSet {
            if select == true {
                centerView.set_Border(radius: 9, borderWidth: 1, borderColor: lmColorHex("#FF4F7DFF"))
            } else {
                centerView.set_Border(radius: 9, borderWidth: 1, borderColor: .clear)
            }
        }
    }
    lazy var discountImage: UIImageView = {
        let imageV = UIImageView()
            .backgroundColor(lmColorHex("#F5455CFF"))
        return imageV
    }()
    lazy var discountlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(10), textColor: .white)
            .textAlignment(.center)
        return lb
    }()
    lazy var centerView: UIView = {
        let view = UIView().backgroundColor(lmColorHex("#2B313D0A"))
            .cornerRadius(12)
        return view
    }()
    lazy var daylb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(16), textColor: .textDefaulColor)
            .textAlignment(.center)
        return lb
    }()
    lazy var coinImage: UIImageView = {
        let imageV = UIImageView()
        imageV.image(UIImage(named: "cm_coin"))
        return imageV
    }()
    lazy var coinlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#2B313D8F"))
        lb.textAlignment(.center)
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
        setDataSoure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        contentView.addSubview(centerView)
        contentView.addSubview(discountImage)
        discountImage.addSubview(discountlb)
        centerView.addSubview(daylb)
        let coinView = UIView()
        centerView.addSubview(coinView)
        coinView.addSubview(coinImage)
        coinView.addSubview(coinlb)
        discountImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(26), height: kScaleWidth(14)))
        }
        discountlb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(0))
            make.height.equalTo(kScaleWidth(16))
        }
        centerView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        daylb.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kScaleWidth(9))
            make.centerX.equalToSuperview()
        }
        coinImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(12), height: kScaleWidth(12)))
        }
        coinlb.snp.makeConstraints { make in
            make.left.equalTo(coinImage.snp.right).offset(kScaleWidth(3))
            make.right.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(20))
        }
        coinView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kScaleWidth(11))
            make.centerX.equalToSuperview()
            make.height.equalTo(kScaleWidth(20))
        }
        layoutIfNeeded()
        discountImage.set_Border(radius: 12, conrners: [.topRight, .bottomLeft])
    }
    func setDataSoure() {
    }
}
