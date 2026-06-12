import UIKit
extension StstemOutcomeCell {
    func setDataSoure(_ model: SystemListModel) {
        self.titleLab.text = model.title
        self.amountlb.text = "\(model.coin)"
        self.cashlb.attributed.text = "\(.init(string: "支付金额 ".localized, .font(lmFontF(14))), .foreground(lmColorHex("#2B313DA3")))\(.init(string: "¥\(model.money)", .font(lmFontF(14))), .foreground(lmColorHex("#2B313D")))"
        self.timelb.attributed.text = "\(.init(string: "操作时间 ".localized, .font(lmFontF(14))), .foreground(lmColorHex("#2B313DA3")))\(.init(string: model.time, .font(lmFontF(14))), .foreground(lmColorHex("#2B313D")))"
    }
}
class StstemOutcomeCell: LMBaseTableViewCell {
    private lazy var bdView: UIView = {
        let view = UIView()
            .backgroundColor(.white)
            .cornerRadius(12.0)
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontF(14), textColor: lmColorHex("#2B313DA3"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var amountlb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(28), textColor: lmColorHex("#2B313D"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var walletbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontF(14), titleColor: lmColorHex("#2B313DA3"))
            .image(UIImage(named: "cm_arrow"))
            .lmtitle("钱包明细")
        btn.isUserInteractionEnabled = false
        btn.set_ImageTitleLayout(.imgRight, spacing: 2.0)
        return btn
    }()
    private lazy var cashlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(14), textColor: lmColorHex("#2B313DA3"))
        return lb
    }()
    private lazy var timelb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(14), textColor: lmColorHex("#2B313DA3"))
        return lb
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension StstemOutcomeCell {
    func setViewSnp() {
        contentView.addSubview(bdView)
        bdView.addSubview(titleLab)
        bdView.addSubview(amountlb)
        bdView.addSubview(walletbtn)
        bdView.addSubview(cashlb)
        bdView.addSubview(timelb)
        bdView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16.0, bottom: 20.0, right: 16.0))
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32.0)
            make.centerX.equalToSuperview()
        }
        amountlb.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(8.0)
            make.centerX.equalToSuperview()
        }
        walletbtn.snp.makeConstraints { make in
            make.top.equalTo(amountlb.snp.bottom).offset(8.0)
            make.centerX.equalToSuperview()
            make.width.equalTo(150.0)
            make.height.equalTo(22.0)
        }
        cashlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.bottom.equalTo(timelb.snp.top).offset(-8.0)
            make.height.equalTo(22.0)
        }
        timelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.bottom.equalToSuperview().offset(-12.0)
            make.height.equalTo(22.0)
        }
    }
}
