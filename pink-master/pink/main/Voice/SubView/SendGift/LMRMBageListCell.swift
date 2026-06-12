import UIKit
extension LMRMBageListCell {
    func setDataSoure(_ model: UserDressModel) {
        self.selectedimv.isHidden = !model.isSelected
        self.activeImagew.isHidden = !model.isActive
        self.imv.set_Image(url: model.dressUpIcon)
        self.namelb.text = model.resourceName
        self.timelb.text = model.remainTime
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
class LMRMBageListCell: BaseCollectionViewCell {
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
    private lazy var timelb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(10), textColor: lmColorHex("#FFFFFF", alpha: 0.4))
        return lb
    }()
    private lazy var tagImagewView: UIImageView = {
        let imageVeiw = UIImageView()
        imageVeiw.contentMode(.scaleToFill)
        return imageVeiw
    }()
    private lazy var activeImagew: UIImageView = {
        let imageVeiw = UIImageView(image: UIImage(named: "rm_packAge_isuse"))
        imageVeiw.contentMode(.scaleToFill)
        imageVeiw.isHidden = true
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
private extension LMRMBageListCell {
    func setViewSnp() {
        contentView.addSubview(selectedimv)
        contentView.addSubview(imv)
        contentView.addSubview(namelb)
        contentView.addSubview(tagImagewView)
        contentView.addSubview(activeImagew)
        contentView.addSubview(timelb)
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
        timelb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(namelb.snp.bottom)
            make.height.equalTo(16.0)
        }
        tagImagewView.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
        }
        activeImagew.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(32), height: kScaleWidth(12)))
        }
    }
}
