import UIKit
class ViolationRecordCell: LMBaseTableViewCell {
    var dataSoure: ViolationRecordItem = ViolationRecordItem() {
        didSet {
            titleLab.lmtext(dataSoure.title)
            timelb.lmtext(dataSoure.time)
            contentlb.lmtext(dataSoure.content)
        }
    }
    lazy var backView: UIView = {
        let view = UIView()
        view.cornerRadius(kScaleWidth(12))
        view.backgroundColor(lmColorHex("#212130"))
        return view
    }()
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(18), textColor: .whitePrimary)
        lb.numberOfLines(0)
        return lb
    }()
    lazy var timelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .whiteTertiary)
        return lb
    }()
    lazy var contentlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(16), textColor: .whitePrimary)
        lb.numberOfLines(0)
        return lb
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        contentView.addSubview(backView)
        backView.addSubview(titleLab)
        backView.addSubview(timelb)
        backView.addSubview(contentlb)
        backView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kScaleWidth(16))
        }
        titleLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(12))
            make.top.equalToSuperview().offset(kScaleWidth(12))
        }
        timelb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(12))
            make.top.equalTo(titleLab.snp.bottom).offset(kScaleWidth(2))
            make.height.equalTo(kScaleWidth(20))
        }
        contentlb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(12))
            make.top.equalTo(timelb.snp.bottom).offset(kScaleWidth(16))
            make.bottom.equalToSuperview().offset(-kScaleWidth(12))
        }
    }
}
