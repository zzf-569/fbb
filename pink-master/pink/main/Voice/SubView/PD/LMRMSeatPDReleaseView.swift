import UIKit
extension LMRMSeatPDReleaseView {
    func setDataSoure(_ model: DispatchItem) {
        skilllb.text = model.bizName
        sexlb.text = model.genderText
        pricelb.text = model.demandPrice
        remarklb.text = model.remark
    }
}
class LMRMSeatPDReleaseView: UIView {
    private lazy var skilltitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFFA3"))
            .lmtext("类型：")
        return lb
    }()
    private lazy var skilllb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        return lb
    }()
    private lazy var sextitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFFA3"))
            .lmtext("性别：")
        return lb
    }()
    private lazy var sexlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        return lb
    }()
    private lazy var pricetitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFFA3"))
            .lmtext("单价：")
        return lb
    }()
    private lazy var pricelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        return lb
    }()
    private lazy var remarktitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFFA3"))
            .lmtext("备注：")
        return lb
    }()
    private lazy var remarklb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .numberOfLines(2)
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMSeatPDReleaseView {
    private func set_Subviews() {
        addSubview(skilltitleLab)
        addSubview(skilllb)
        addSubview(sextitleLab)
        addSubview(sexlb)
        addSubview(pricetitleLab)
        addSubview(pricelb)
        addSubview(remarktitleLab)
        addSubview(remarklb)
        skilltitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.top.equalToSuperview().offset(10.0)
            make.height.equalTo(20.0)
        }
        skilllb.snp.makeConstraints { make in
            make.left.equalTo(skilltitleLab.snp.right).offset(0.0)
            make.top.equalToSuperview().offset(10.0)
            make.height.equalTo(20.0)
            make.right.lessThanOrEqualToSuperview().offset(-12.0)
        }
        sextitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.top.equalTo(skilltitleLab.snp.bottom).offset(4.0)
            make.height.equalTo(20.0)
        }
        sexlb.snp.makeConstraints { make in
            make.left.equalTo(sextitleLab.snp.right).offset(0.0)
            make.top.equalTo(skilllb.snp.bottom).offset(4.0)
            make.height.equalTo(20.0)
            make.right.lessThanOrEqualToSuperview().offset(-12.0)
        }
        pricetitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.top.equalTo(sextitleLab.snp.bottom).offset(4.0)
            make.height.equalTo(20.0)
        }
        pricelb.snp.makeConstraints { make in
            make.left.equalTo(pricetitleLab.snp.right).offset(0.0)
            make.top.equalTo(sexlb.snp.bottom).offset(4.0)
            make.height.equalTo(20.0)
            make.right.lessThanOrEqualToSuperview().offset(-12.0)
        }
        remarktitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.top.equalTo(pricetitleLab.snp.bottom).offset(4.0)
            make.height.equalTo(20.0)
        }
        remarklb.snp.makeConstraints { make in
            make.left.equalTo(remarktitleLab.snp.right).offset(0.0)
            make.top.equalTo(pricelb.snp.bottom).offset(4.0)
            make.right.lessThanOrEqualToSuperview().offset(-12.0)
            make.bottom.lessThanOrEqualToSuperview().offset(0)
        }
    }
}
