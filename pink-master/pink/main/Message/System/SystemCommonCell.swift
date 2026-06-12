import UIKit
extension SystemCommonCell {
    func setDataSoure(_ model: SystemListModel) {
        self.titleLab.text = model.title
        self.timelb.text = model.time
        self.contentlb.text = model.content
    }
}
class SystemCommonCell: LMBaseTableViewCell {
    private lazy var bdView: UIView = {
        let view = UIView()
            .backgroundColor(.white)
            .cornerRadius(12.0)
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(18), textColor: lmColorHex("#2B313D"))
            .numberOfLines(0)
            .textAlignment(.center)
        return lb
    }()
    private lazy var timelb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#2B313D66"))
        return lb
    }()
    private lazy var contentlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(16), textColor: lmColorHex("#2B313D"))
            .numberOfLines(0)
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
private extension SystemCommonCell {
    func setViewSnp() {
        contentView.addSubview(bdView)
        bdView.addSubview(titleLab)
        bdView.addSubview(timelb)
        bdView.addSubview(contentlb)
        bdView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.0)
        }
        titleLab.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(12.0)
            make.right.equalToSuperview().offset(-12.0)
        }
        timelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.right.equalToSuperview().offset(-12.0)
            make.top.equalTo(titleLab.snp.bottom).offset(2.0)
            make.height.equalTo(20.0)
        }
        contentlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.right.equalToSuperview().offset(-12.0)
            make.top.equalTo(timelb.snp.bottom).offset(16.0)
            make.bottom.equalToSuperview().offset(-12.0)
        }
    }
}
