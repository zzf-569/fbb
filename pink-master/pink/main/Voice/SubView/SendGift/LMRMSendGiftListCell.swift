import UIKit
extension LMRMSendGiftListCell {
    func setDataSoure(_ model: GiftItem) {
        self.selectedimv.isHidden = !model.isSelected
        self.imv.set_Image(url: model.iconUrl)
        self.namelb.text = model.name
        self.pricelb.text = model.price.toString()
        self.tagImagewView.isHidden = model.tagUrl.isEmpty == true
        if model.tagUrl.isEmpty == false {
            tagImagewView.set_Image(url: model.tagUrl, placeholder: nil) { result in
                switch result {
                case .success(let imageRestlt):
                    self.tagImagewView.snp.remakeConstraints { make in
                        make.top.right.equalToSuperview()
                        make.size.equalTo(CGSize(width: kScaleWidth(12) / imageRestlt.image.size.height * imageRestlt.image.size.width, height: kScaleWidth(12)))
                    }
                case .failure:
                    break
                }
            }
        }
    }
}
class LMRMSendGiftListCell: BaseCollectionViewCell {
    private lazy var selectedimv: UIImageView = {
        let imv = UIImageView()
            .backgroundColor(lmColorHex("#FFFFFF14"))
        imv.isHidden(true)
        return imv
    }()
    private lazy var imv: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
        imv.clipsToBounds = true
        return imv
    }()
    private lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(12), textColor: .white)
            .textAlignment(.center)
        return lb
    }()
    private lazy var priceView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var priceImagewView: UIImageView = {
        let imageVeiw = UIImageView(image: UIImage(named: "rm_gift_price"))
        return imageVeiw
    }()
    private lazy var pricelb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(10), textColor: lmColorHex("#FFFFFF", alpha: 0.4))
        return lb
    }()
    private lazy var tagImagewView: UIImageView = {
        let imageVeiw = UIImageView()
        imageVeiw.contentMode(.scaleAspectFill)
        imv.clipsToBounds = true
        return imageVeiw
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMSendGiftListCell {
    func setViewSnp() {
        contentView.addSubview(selectedimv)
        contentView.addSubview(imv)
        contentView.addSubview(namelb)
        contentView.addSubview(priceView)
        contentView.addSubview(tagImagewView)
        priceView.addSubview(priceImagewView)
        priceView.addSubview(pricelb)
        selectedimv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imv.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(4.0)
            make.height.width.equalTo(48.0)
        }
        namelb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imv.snp.bottom).offset(4.0)
            make.height.equalTo(20.0)
        }
        priceView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(namelb.snp.bottom)
            make.height.equalTo(16.0)
        }
        priceImagewView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(10.0)
        }
        pricelb.snp.makeConstraints { make in
            make.left.equalTo(priceImagewView.snp.right).offset(2.0)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        tagImagewView.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
        }
    }
}
