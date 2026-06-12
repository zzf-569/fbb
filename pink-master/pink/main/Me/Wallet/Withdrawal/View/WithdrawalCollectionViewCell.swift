import UIKit
class WithdrawalCollectionViewCell: UICollectionViewCell {
    var dataSoure: WithdrawConfigItem = WithdrawConfigItem() {
        didSet {
            coinlb.text = dataSoure.requireValue.toString()
            pricelb.text = dataSoure.requireName
        }
    }
    lazy var coinlb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(18), textColor: .textDefaulColor)
        lb.textAlignment(.center)
        return lb
    }()
    lazy var pricelb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(10), textColor: .white)
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
        contentView.addSubview(coinlb)
        contentView.addSubview(pricelb)
        coinlb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(9))
            make.height.equalTo(kScaleWidth(26))
        }
        pricelb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(32))
            make.height.equalTo(kScaleWidth(14))
        }
        contentView.layoutIfNeeded()
    }
    func setDataSoure() {
    }
    var isSelectedItem: Bool? {
        didSet {
            if isSelectedItem == true {
                coinlb.textColor(.white)
                pricelb.textColor(.white)
                contentView.backgroundColor = lmColorHex("#FF4F7D")
                contentView.cornerRadius(12)
            } else {
                coinlb.textColor(lmColorHex("#FF4F7DFF"))
                pricelb.textColor(lmColorHex("#FF4F7DFF"))
                contentView.backgroundColor = lmColorHex("#FF4F7D14")
                contentView.cornerRadius(12)
            }
        }
    }
}
