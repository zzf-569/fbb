import Foundation
import UIKit
extension LMRMWaterListCell {
    func setDataSoure(_ model:LMRMWaterModel) {
        titleLab.text = model.dateTime
        incomelb.text = model.statement
    }
}
class LMRMWaterListCell: LMBaseTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var bdView: UIView = {
        let view = UIView()
            .backgroundColor(lmColorHex("#000000", alpha: 0.2))
            .cornerRadius(9)
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        return lb
    }()
    private lazy var incomelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        return lb
    }()
    private lazy var incomeimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "cm_coin"))
        return imv
    }()
}
private extension LMRMWaterListCell {
    func setViewSnp() {
        contentView.addSubview(bdView)
        bdView.addSubview(titleLab)
        bdView.addSubview(incomelb)
        bdView.addSubview(incomeimv)
        bdView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16.0, bottom: 12.0, right: 16.0))
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
        }
        incomelb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
        }
        incomeimv.snp.makeConstraints { make in
            make.right.equalTo(incomelb.snp.left).offset(-2.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16.0)
        }
    }
}
