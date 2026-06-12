import UIKit
extension LMRMSendDressListCell {
    func setDataSoure(_ model: ShopListItem) {
        self.selectedimv.isHidden = !model.isSelected
        self.imv.set_Image(url: model.dressUpIcon)
        self.namelb.text = model.dressUpName
        self.pricelb.text = model.dailyPrice.toString()
        self.tagImagewView.isHidden = model.typeIcon.isEmpty == true
        if model.typeIcon.isEmpty == false {
            tagImagewView.set_Image(url: model.typeIcon, placeholder: nil) { result in
                switch result {
                case .success(let imageRestlt):
                    self.tagImagewView.snp.remakeConstraints { make in
                        make.top.right.equalToSuperview()
                        make.size.equalTo(CGSize(width: kScaleWidth(12)/imageRestlt.image.size.height * imageRestlt.image.size.width, height: kScaleWidth(12)))
                    }
                case .failure:
                    break
                }
            }
        }
    }
}
class LMRMSendDressListCell: BaseCollectionViewCell {
    private lazy var selectedimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_gift_item_selected"))
        imv.isHidden(true)
        return imv
    }()
    private lazy var imv: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
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
        imageVeiw.contentMode(.scaleToFill)
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
private extension LMRMSendDressListCell {
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
