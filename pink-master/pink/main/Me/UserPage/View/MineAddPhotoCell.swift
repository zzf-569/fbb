import UIKit
protocol MineAddPhotoCellDelegate: NSObjectProtocol {
    func dg_cellClickDele(image: photoWallModel)
}
class MineAddPhotoCell: UICollectionViewCell {
    weak var delegate: MineAddPhotoCellDelegate?
    private let dashedBorder = CAShapeLayer()
    lazy var imv: UIButton = {
        let iamgeV = UIButton()
        iamgeV.setImage(UIImage(systemName: "plus"), for: .normal)
        iamgeV.tintColor = lmColorHex("#252B26")
        iamgeV.imageView?.contentMode = .scaleAspectFill
        iamgeV.backgroundColor(.white)
        iamgeV.cornerRadius(8)
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
                imv.setImage(UIImage(systemName: "plus"), for: .normal)
                imv.tintColor = lmColorHex("#252B26")
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

    override func layoutSubviews() {
        super.layoutSubviews()
        dashedBorder.frame = bounds
        dashedBorder.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), cornerRadius: 8).cgPath
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        dashedBorder.strokeColor = lmColorHex("#B7BBB8").cgColor
        dashedBorder.fillColor = UIColor.clear.cgColor
        dashedBorder.lineDashPattern = [7, 5]
        dashedBorder.lineWidth = 1
        addSubview(imv)
        addSubview(close)
        layer.addSublayer(dashedBorder)
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
