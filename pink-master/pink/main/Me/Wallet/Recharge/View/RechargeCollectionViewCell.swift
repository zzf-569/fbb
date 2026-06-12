import UIKit
import AttributedString
class RechargeCollectionViewCell: UICollectionViewCell {
    var dataSoure: RechargeItem = RechargeItem() {
        didSet {
            coinlb.text = "\(dataSoure.productAmount.toString())钻石"
            pricelb.text = "¥\(dataSoure.price.toString())"
        }
    }
    lazy var coinlb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(10), textColor: .white)
        lb.textAlignment(.center)
        return lb
    }()
    lazy var pricelb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(18), textColor: lmColorHex("#FF4F7D"))
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
        contentView.addSubview(pricelb)
        contentView.addSubview(coinlb)
        coinlb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(32)
            make.height.equalTo(kScaleWidth(14))
        }
        pricelb.snp.makeConstraints { make in
            make.centerX.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kScaleWidth(24))
            make.height.equalTo(kScaleWidth(24))
        }
        contentView.layoutIfNeeded()
    }
    func setDataSoure() {
    }
    var isSelectedItem: Bool? {
        didSet {
            if isSelectedItem == true {
                pricelb.textColor(.white)
                coinlb.textColor(.white)
                contentView.backgroundColor = lmColorHex("#FF4F7D")
                contentView.cornerRadius(12)
            } else {
                pricelb.textColor(lmColorHex("#FF4F7DFF"))
                coinlb.textColor(lmColorHex("#FF4F7DFF"))
                contentView.backgroundColor = lmColorHex("#FF4F7D14")
                contentView.cornerRadius(12)
            }
        }
    }
}
