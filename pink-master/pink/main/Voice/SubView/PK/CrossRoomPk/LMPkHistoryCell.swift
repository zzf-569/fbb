import UIKit
extension LMPkHistoryCell {
    func setDataSoure(_ data:VoiceCrossPkItem) {
        walllb.lmtext("\(data.pkValue + data.targetValue)")
        timelb.lmtext(data.createTime)
        switch data.result {
        case .victory:
            resultImage.image(UIImage(named: "rm_pk_red_win"))
        case .draw:
            resultImage.image(UIImage(named: "rm_pk_ping"))
        case .defeat:
            resultImage.image(UIImage(named: "rm_pk_blue_win"))
        }
    }
}
class LMPkHistoryCell: LMBaseTableViewCell {
    lazy var backView: UIView = {
        let view = UIView()
            .backgroundColor(.clear)
        return view
    }()
    lazy var coinImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "cm_coin"))
        return imageV
    }()
    lazy var walllb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFFF5"))
        return lb
    }()
    lazy var timelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#FFFFFF66"))
        return lb
    }()
    lazy var resultImage: UIImageView = {
        let imageV = UIImageView()
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
        backView.addSubview(walllb)
        backView.addSubview(timelb)
        backView.addSubview(resultImage)
        backView.addSubview(coinImage)
        backView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(0))
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(8))
        }
        coinImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(10))
            make.width.height.equalTo(kScaleWidth(12))
        }
        walllb.snp.makeConstraints { make in
            make.left.equalTo(coinImage.snp.right).offset(kScaleWidth(2))
            make.centerY.equalTo(coinImage.snp.centerY)
            make.height.equalTo(kScaleWidth(24))
        }
        timelb.snp.makeConstraints { make in
            make.left.equalTo(coinImage.snp.left)
            make.bottom.equalToSuperview().offset(-kScaleWidth(10))
            make.height.equalTo(kScaleWidth(20))
        }
        resultImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(12))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(40), height: kScaleWidth(40)))
        }
    }
}
