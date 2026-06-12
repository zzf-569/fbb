import UIKit
extension LMRMPkHistoryCell {
    func setDataSoure(_ data:VoiceCrossPkItem) {
        roomNamelb.lmtext("对方 \(data.roomName)")
        walllb.lmtext("我方\(data.pkValue) | 对方\(data.targetValue)")
        timelb.lmtext(data.createTime)
        switch data.result {
        case .victory:
            resultImage.image(UIImage(named: "rm_pk_win"))
        case .draw:
            resultImage.image(UIImage(named: "rm_pk_pingcent"))
        case .defeat:
            resultImage.image(UIImage(named: "rm_pk_loss"))
        }
    }
}
class LMRMPkHistoryCell: LMBaseTableViewCell {
    lazy var backView: UIView = {
        let view = UIView()
            .backgroundColor(.clear)
        return view
    }()
    lazy var roomNamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#FFFFFFF5"))
        return lb
    }()
    lazy var walllb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#FFFFFFA3"))
        return lb
    }()
    lazy var timelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(10), textColor: lmColorHex("#FFFFFF66"))
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
        backView.addSubview(roomNamelb)
        backView.addSubview(walllb)
        backView.addSubview(timelb)
        backView.addSubview(resultImage)
        backView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(0))
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(8))
        }
       roomNamelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(10))
            make.height.equalTo(kScaleWidth(24))
        }
        walllb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(34))
            make.height.equalTo(kScaleWidth(20))
        }
        timelb.snp.makeConstraints { make in
            make.left.equalTo(walllb.snp.left)
            make.bottom.equalToSuperview().offset(-kScaleWidth(10))
            make.height.equalTo(kScaleWidth(16))
        }
        resultImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(12))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(48), height: kScaleWidth(48)))
        }
    }
}
