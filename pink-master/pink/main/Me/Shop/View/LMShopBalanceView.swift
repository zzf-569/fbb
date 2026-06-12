import UIKit
extension LMShopBalanceView {
    func set_Balance(_ balance: Int) {
        self.balancelb.text =  balance.toString()
    }
}
class LMShopBalanceView: UIView {
    private lazy var markimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_gift_balance"))
        return imv
    }()
    private lazy var balancelb: UILabel = {
        let lable = UILabel(lmfont: lmFontM(12), textColor: theme == .dark ? .white : .textDefaulColor)
        return lable
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontR(10), textColor: theme == .dark ? .whitePrimary : .textDefaulColor)
            .lmtext("充值")
        return lb
    }()
    private lazy var arrowimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: theme == .dark ? "shopbalance_arrow_dark" : "shopbalance_arrow"))
        return imv
    }()
    var theme: UIUserInterfaceStyle
    init(theme: UIUserInterfaceStyle) {
        self.theme = theme
        super.init(frame: .zero)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMShopBalanceView {
    private func setViewSnp() {
        self.addSubview(markimv)
        self.addSubview(balancelb)
        self.addSubview(titleLab)
        self.addSubview(arrowimv)
        markimv.snp.makeConstraints { make in
            make.right.equalTo(balancelb.snp.left).offset(-4.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14.0)
        }
        balancelb.snp.makeConstraints { make in
            make.right.equalTo(titleLab.snp.left).offset(-4.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(20.0)
        }
        titleLab.snp.makeConstraints { make in
            make.right.equalTo(arrowimv.snp.left)
            make.centerY.equalToSuperview()
            make.width.equalTo(20.0)
        }
        arrowimv.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(8.0)
        }
    }
}
