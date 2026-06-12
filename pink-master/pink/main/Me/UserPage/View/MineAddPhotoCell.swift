import UIKit
protocol MineAddPhotoCellDelegate: NSObjectProtocol {
    func dg_cellClickDele(image: photoWallModel)
}
class MineAddPhotoCell: UICollectionViewCell {
    weak var delegate: MineAddPhotoCellDelegate?
    lazy var imv: UIButton = {
        let iamgeV = UIButton()
        iamgeV.image(UIImage(named: "cm_whiteAddImage"))
        iamgeV.imageView?.contentMode = .scaleAspectFill
        iamgeV.backgroundColor(lmColorHex("#2B313D0A"))
        iamgeV.cornerRadius(8, borderColor: lmColorHex("#2B313D29"), borderWidth: 0.5)
        iamgeV.isUserInteractionEnabled = false
        return iamgeV
    }()
    lazy var close: UIButton = {
        let buttton = UIButton(image: UIImage(named: "cm_textfild_close"), target: self, action: #selector(closeAction))
        buttton.isHidden = true
        return buttton
    }()
    var image: photoWallModel? {
        didSet {
            guard let url = image?.url else {
                imv.image(UIImage(named: "cm_whiteAddImage"))
                close.isHidden = true
                return
            }
            imv.kf.setImage(with: URL(string: url), for: .normal)
            close.isHidden = false
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
        setDataSoure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(imv)
        addSubview(close)
        imv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        close.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(16), height: kScaleWidth(16)))
        }
    }
    func setDataSoure() {
    }
    @objc func closeAction() {
        guard let image = image else {return}
        delegate? .dg_cellClickDele(image: image)
    }
}
