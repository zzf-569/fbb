import UIKit
extension LMRMSendGiftBalanceView {
    func set_Balance(_ balance: Int) {
        self.balancelb.text =  balance.toString()
    }
}
class LMRMSendGiftBalanceView: UIView {
    private lazy var markimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_gift_balance"))
        return imv
    }()
    private lazy var balancelb: UILabel = {
        let lable = UILabel(lmfont: lmFontM(14), textColor: .white)
        return lable
    }()
    private lazy var arrowimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_gift_balance_arrow"))
        return imv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMSendGiftBalanceView {
    private func setViewSnp() {
        self.addSubview(markimv)
        self.addSubview(balancelb)
        self.addSubview(arrowimv)
        markimv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14.0)
        }
        balancelb.snp.makeConstraints { make in
            make.left.equalTo(markimv.snp.right).offset(4.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(22.0)
        }
        arrowimv.snp.makeConstraints { make in
            make.left.equalTo(balancelb.snp.right).offset(2.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12.0)
            make.right.equalToSuperview().offset(-8.0)
        }
    }
}
