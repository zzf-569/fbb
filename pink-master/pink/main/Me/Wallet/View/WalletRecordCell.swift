import UIKit
import AttributedString
class WalletRecordCell: LMBaseTableViewCell {
    var dataSoure: WalletRecordsItem = WalletRecordsItem() {
        didSet {
            timelb.text = dataSoure.createTime
            var text = dataSoure.text
            text = text.removeSomeStringUseSomeString(removeString: "%s", replacingString: dataSoure.markText)
            var string: ASAttributedString = .init(string: text, .font(lmFontM(16)), .foreground(lmColorHex("#2B313D")))
            switch dataSoure.type {
            case .gift:
                string.add(attributes: [.foreground(lmColorHex("#FF4F7DFF"))], checkings: [.regex(dataSoure.markText)])
            case .room:
                string.add(attributes: [.foreground(lmColorHex("#FF4F7DFF"))], checkings: [.regex(dataSoure.markText)])
            case .order:
                string.add(attributes: [.foreground(lmColorHex("#FF4F7DFF"))], checkings: [.regex(dataSoure.markText)])
            }
            titleV.attributed.text = string.localized
            if let floatVal = Float(dataSoure.amount) {
                if floatVal < 0 {
                    numlb.textColor(lmColorHex("#2B313D"))
                    numlb.lmtext(dataSoure.amount)
                } else {
                    numlb.textColor(lmColorHex("#2B313D"))
                    numlb.lmtext("+\(dataSoure.amount)")
                }
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
        let prefix: ASAttributedString = .init(string: "来自 ".localized, .font(lmFontM(16)), .foreground(lmColorHex("#2B313D")))
        let giftName: ASAttributedString = .init(string: "奶甜㊗️白白🎉 ", .font(lmFontM(16)), .foreground(lmColorHex("#F531B4")))
        let count: ASAttributedString = .init(string: "的礼物".localized, .font(lmFontM(16)), .foreground(lmColorHex("#2B313D")))
        textView.attributed.text = prefix + giftName + count
        return textView
    }()
    lazy var timelb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(14), textColor: .textTerColor)
            .lmtext("2025/09/02 12:23:11")
        return lb
    }()
    lazy var numlb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: lmColorHex("#00D96D"))
            .lmtext("+200")
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
        backView.addSubview(titleV)
        backView.addSubview(timelb)
        backView.addSubview(numlb)
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
        numlb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.centerY.equalToSuperview()
        }
    }
}
