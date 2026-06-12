import UIKit
class GiftWallPageViewCell: BaseCollectionViewCell {
    var dataSoure: GiftWallListL = GiftWallListL() {
        didSet {
            giftIcon.set_Image(url: dataSoure.iconUrl)
            giftName.lmtext(dataSoure.name)
            pricelb.lmtext(dataSoure.price.toString())
            if dataSoure.count > 0 {
                bgimageV.image(UIImage(named: "gw_itembg"))
                giftName.textColor(lmColorHex("#F7D18D"))
            } else {
                bgimageV.image(UIImage(named: "gw_item"))
                giftName.textColor(lmColorHex("#FFFFFF8F"))
            }
        }
    }
    lazy var bgimageV: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "gw_item"))
        return imageV
    }()
    lazy var giftIcon: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var giftName: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .white)
        lb.textAlignment(.center)
        return lb
    }()
    lazy var coinImage: UIImageView = {
        let imageV = UIImageView()
        imageV.image(UIImage(named: "cm_coin"))
        return imageV
    }()
    lazy var pricelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(10), textColor: .white)
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
        contentView.addSubview(bgimageV)
        bgimageV.addSubview(giftIcon)
        bgimageV.addSubview(giftName)
        bgimageV.addSubview(pricelb)
        bgimageV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        giftIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(56)))
        }
        giftName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(70))
            make.height.equalTo(kScaleWidth(20))
        }
        let coinView = UIView()
        bgimageV.addSubview(coinView)
        coinView.addSubview(coinImage)
        coinView.addSubview(pricelb)
        coinImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(16), height: 16))
        }
        pricelb.snp.makeConstraints { make in
            make.left.equalTo(coinImage.snp.right).offset(kScaleWidth(3))
            make.right.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(16))
        }
        coinView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kScaleWidth(12))
            make.height.equalTo(kScaleWidth(16))
        }
    }
    func setDataSoure() {
    }
}
