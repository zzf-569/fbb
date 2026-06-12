import UIKit
import AttributedString
class LMBageRecordCell: LMBaseTableViewCell {
    var dataSoure: DressRecordModel = DressRecordModel() {
        didSet {
            timelb.lmtext(dataSoure.createTime)
            switch dataSoure.source {
            case 0:
                let text: ASAttributedString = .init(string: "购买".localized, .font(lmFontM(16)), .foreground(.textDefaulColor))
                let name: ASAttributedString = .init("\(dataSoure.resourceName)", .font(lmFontM(16)), .foreground(lmColorHex("#DD33FFFF")))
                let daytext: ASAttributedString = .init(string: "badge.duration_days".localized(dataSoure.duration), .font(lmFontM(16)), .foreground(.textDefaulColor))
                titleV.attributed.text = text + name + daytext
            case 3:
                let text: ASAttributedString = .init(string: "图鉴奖励".localized, .font(lmFontM(16)), .foreground(.textDefaulColor))
                let name: ASAttributedString = .init("\(dataSoure.resourceName)", .font(lmFontM(16)), .foreground(lmColorHex("#DD33FFFF")))
                var daytext: ASAttributedString = .init(string: "badge.duration_days".localized(dataSoure.duration), .font(lmFontM(16)), .foreground(.textDefaulColor))
                if dataSoure.duration == -1 {
                    daytext = .init(string: "永久".localized, .font(lmFontM(16)), .foreground(.textDefaulColor))
                }
                titleV.attributed.text = text + name + daytext
            default:
                let text: ASAttributedString = .init(string: "badge.gifted_to_you".localized(dataSoure.giftGiverName), .font(lmFontM(16)), .foreground(.textDefaulColor))
                let name: ASAttributedString = .init("\(dataSoure.resourceName)", .font(lmFontM(16)), .foreground(lmColorHex("#DD33FFFF")))
                let daytext: ASAttributedString = .init(string: "badge.duration_days".localized(dataSoure.duration), .font(lmFontM(16)), .foreground(.textDefaulColor))
                titleV.attributed.text = text + name + daytext
            }
        }
    }
    lazy var backView: UIView = {
        let view = UIView()
        view.cornerRadius(kScaleWidth(12))
        view.backgroundColor = .white
        return view
    }()
    lazy var titleV: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        textView.backgroundColor(.white)
        return textView
    }()
    lazy var timelb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(14), textColor: .textTerColor)
            .lmtext("2025/09/02 12:23:11")
        return lb
    }()
    lazy var iconImage: UIImageView = {
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
        backView.addSubview(titleV)
        backView.addSubview(timelb)
        backView.addSubview(iconImage)
        backView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.height.equalTo(kScaleWidth(82))
        }
        titleV.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(24))
            make.right.equalToSuperview().offset(-kScaleWidth(88))
        }
        timelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.bottom.equalToSuperview().offset(-kScaleWidth(16))
            make.height.equalTo(kScaleWidth(22))
            make.right.equalToSuperview().offset(-kScaleWidth(88))
        }
        iconImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(20))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(50), height: kScaleWidth(50)))
        }
    }
}
