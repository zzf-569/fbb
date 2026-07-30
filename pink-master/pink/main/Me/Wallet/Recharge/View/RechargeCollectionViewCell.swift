import UIKit

final class RechargeCollectionViewCell: UICollectionViewCell {
    private let coinImageView = UIImageView()

    var dataSoure: RechargeItem = RechargeItem() {
        didSet {
            coinlb.text = dataSoure.productAmount.formattedWithSeparator
            pricelb.text = formattedPrice(dataSoure.price)
        }
    }

    lazy var coinlb: UILabel = {
        let label = UILabel(lmfont: lmFontM(15), textColor: lmColorHex("#202620"))
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()

    lazy var pricelb: UILabel = {
        let label = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#777D78"))
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
        applySelectionStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setViewSnp() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 14
        contentView.clipsToBounds = true

        coinImageView.image = UIImage(named: "cm_coin") ?? UIImage(named: "icon_coins")
        coinImageView.contentMode = .scaleAspectFit
        contentView.addSubview(coinImageView)
        contentView.addSubview(coinlb)
        contentView.addSubview(pricelb)

        coinImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(13)
            $0.size.equalTo(17)
        }
        coinlb.snp.makeConstraints {
            $0.left.equalTo(coinImageView.snp.right).offset(4)
            $0.right.equalToSuperview().offset(-7)
            $0.centerY.equalTo(coinImageView)
        }
        pricelb.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(6)
            $0.top.equalTo(coinImageView.snp.bottom).offset(7)
            $0.height.equalTo(17)
        }
    }

    private func formattedPrice(_ price: Int) -> String {
        guard price > 0 else { return "$0.99" }
        if price >= 100 {
            return String(format: "$%.2f", Double(price) / 100)
        }
        return String(format: "$%.2f", max(Double(price) - 0.01, 0.99))
    }

    var isSelectedItem: Bool? {
        didSet {
            applySelectionStyle()
        }
    }

    private func applySelectionStyle() {
        let selected = isSelectedItem == true
        contentView.backgroundColor = selected ? lmColorHex("#142018") : .white
        coinlb.textColor = selected ? lmColorHex("#B9FF47") : lmColorHex("#202620")
        pricelb.textColor = selected ? lmColorHex("#AEB5AF") : lmColorHex("#777D78")
    }
}

private extension Int {
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? toString()
    }
}
