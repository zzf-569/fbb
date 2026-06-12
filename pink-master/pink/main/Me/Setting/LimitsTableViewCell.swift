import UIKit
class LimitsTableViewCell: LMBaseTableViewCell {
    var dataSoure: LimitsItem = LimitsItem() {
        didSet {
            titleLab.lmtext(dataSoure.title)
            sublb.lmtext(dataSoure.subtitle)
            if dataSoure.status == true {
                statuslb.lmtext("已开启")
                statuslb.textColor(.textDefaulColor)
            } else {
                statuslb.lmtext("去开启")
                statuslb.textColor(.textSecondColor)
            }
        }
    }
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontR(16), textColor: .textDefaulColor)
        return lb
    }()
    lazy var sublb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textTerColor)
        return lb
    }()
    lazy var statuslb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textDefaulColor)
        return lb
    }()
    lazy var moreImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "me_more"))
        return imageV
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
        backView.addSubview(sublb)
        backView.addSubview(statuslb)
        backView.addSubview(moreImage)
        backView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(0))
            make.top.equalToSuperview().offset(kScaleWidth(0))
            make.height.equalTo(kScaleWidth(72))
            make.bottom.equalToSuperview()
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(24))
        }
        sublb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.bottom.equalToSuperview().offset(-kScaleWidth(16))
            make.height.equalTo(kScaleWidth(20))
        }
        moreImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(12), height: kScaleWidth(12)))
        }
        statuslb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(30))
            make.centerY.equalToSuperview()
        }
    }
}
