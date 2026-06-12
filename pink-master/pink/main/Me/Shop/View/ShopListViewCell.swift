import UIKit
class LMShopListViewCell: UICollectionViewCell {
    var dataSoure: ShopListItem = ShopListItem() {
        didSet {
            iconImage.set_Image(url: dataSoure.dressUpIcon)
            namelb.lmtext(dataSoure.dressUpName)
            coinlb.lmtext(dataSoure.dailyPrice.toString())
        }
    }
    lazy var selectView: UIView = {
        let view = UIView().backgroundColor(lmColorHex("#2B313D0A"))
        view.set_Border(radius: 9)
        return view
    }()
    lazy var iconImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textDefaulColor)
        return lb
    }()
    lazy var coinImage: UIImageView = {
        let imageV = UIImageView()
        imageV.image(UIImage(named: "cm_coin"))
        return imageV
    }()
    lazy var coinlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textTerColor)
        lb.textAlignment(.center)
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        contentView.addSubview(selectView)
        contentView.addSubview(iconImage)
        contentView.addSubview(namelb)
        let coinView = UIView()
        contentView.addSubview(coinView)
        coinView.addSubview(coinImage)
        coinView.addSubview(coinlb)
        selectView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(106), height: kScaleWidth(80)))
        }
        iconImage.snp.makeConstraints { make in
            make.center.equalTo(selectView)
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(56)))
        }
        namelb.snp.makeConstraints { make in
            make.top.equalTo(selectView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(kScaleWidth(20))
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
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(kScaleWidth(20))
        }
    }
}
