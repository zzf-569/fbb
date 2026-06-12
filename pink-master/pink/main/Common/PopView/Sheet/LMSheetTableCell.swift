import UIKit
extension LMSheetTableCell {
    func setDataSoure(_ model: LMSheetTabModel) {
        self.titleLab.text = model.title
        self.titleLab.textColor(lmColorHex(model.titleColor))
    }
}
class LMSheetTableCell: LMBaseTableViewCell {
    private lazy var bdView: UIView = {
        let view = UIView()
            .backgroundColor(.white)
            .cornerRadius(12.0)
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(18), textColor: lmColorHex("#2B313D"))
            .textAlignment(.center)
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
private extension LMSheetTableCell {
    func setViewSnp() {
        contentView.addSubview(bdView)
        bdView.addSubview(titleLab)
        bdView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24.0)
        }
        titleLab.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
