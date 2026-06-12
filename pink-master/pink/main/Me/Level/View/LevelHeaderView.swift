import UIKit
import AttributedString
class LevelHeaderView: UIView {
    var dataSoure: LevelItem = LevelItem() {
        didSet {
            var content: ASAttributedString = ASAttributedString(string: "level.wealth_level".localized(dataSoure.richLevel), .foreground(lmColorHex("#FFFFFF")), .font(lmFontASHTB(24)))
            content.add(attributes: [.foreground(lmColorHex("#48FFF6FF"))], checkings: [.regex("Lv.\(dataSoure.richLevel.toString())")])
            if  case 1...11 = dataSoure.richLevel {
                iconImage.image = UIImage(named: "le_1_10")
            }
            if  case 11...21 = dataSoure.richLevel {
                iconImage.image = UIImage(named: "le_11_20")
            }
            if  case 21...31 = dataSoure.richLevel {
                iconImage.image = UIImage(named: "le_21_30")
            }
            if  case 31...41 = dataSoure.richLevel {
                iconImage.image = UIImage(named: "le_31_40")
            }
            if  case 41... = dataSoure.richLevel {
                iconImage.image = UIImage(named: "le_41_50")
            }
            levelText.attributed.text = content
            tipslb.text = "level.next_growth_tip".localized(dataSoure.currentRichLevelValue.toString(), dataSoure.nextRichLevelValue.toString())
            levellb.text = "Lv.\(dataSoure.richLevel.toString())"
            nextlevellb.text = "Lv.\((dataSoure.richLevel + 1).toString())"
        }
    }
    lazy var backImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "le_headerbg"))
        return imageV
    }()
    lazy var iconImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var levelText: UITextView = {
        let textView = UITextView(lmfont: lmFontASHTB(24), textColor: lmColorHex("#FFFFFF"))
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        return textView
    }()
    lazy var progressView: UIView = {
        let view = UIView().backgroundColor(lmColorHex("#FFFFFF29"))
        return view
    }()
    lazy var tipslb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(10), textColor: lmColorHex("#FFFFFF8F"))
        return lb
    }()
    lazy var lineImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "le_line"))
        return imageV
    }()
    lazy var pointImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "le_point"))
        return imageV
    }()
    lazy var nextView: UIView = {
        let imageV = UIView().backgroundColor(lmColorHex("#CFFFFFFF"))
            .cornerRadius(kScaleWidth(3))
        return imageV
    }()
    lazy var levellb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFF"))
            .backgroundColor(lmColorHex("#FFFFFF3D"))
            .textAlignment(.center)
        return lb
    }()
    lazy var nextlevellb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(10), textColor: lmColorHex("#FFFFFF8F"))
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(backImage)
        addSubview(iconImage)
        addSubview(levelText)
        addSubview(tipslb)
        addSubview(progressView)
        addSubview(lineImage)
        addSubview(pointImage)
        addSubview(levellb)
        addSubview(nextView)
        addSubview(nextlevellb)
        backImage.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(32))
            make.height.equalTo(kScaleWidth(120))
        }
        iconImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(20))
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(144), height: kScaleWidth(136)))
        }
        levelText.snp.makeConstraints { make in
            make.top.left.equalTo(backImage).offset(32)
            make.size.equalTo(CGSize(width: kScreenWidth, height: kScaleWidth(32)))
        }
//        progressView.snp.makeConstraints { make in
//            make.left.equalTo(backImage.snp.left).offset(16)
//            make.top.equalTo(backImage.snp.top).offset(78)
//            make.width.equalTo(kScaleWidth(200))
//            make.height.equalTo(kScaleWidth(6))
//        }
        tipslb.snp.makeConstraints { make in
            make.left.equalTo(backImage.snp.left).offset(16)
            make.top.equalTo(levelText.snp.bottom).offset(4)
            make.height.equalTo(kScaleWidth(16))
        }
        lineImage.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(backImage.snp.bottom).offset(kScaleWidth(32))
            make.height.equalTo(kScaleWidth(26))
        }
        pointImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backImage.snp.bottom).offset(kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(40), height: kScaleWidth(40)))
        }
        levellb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backImage.snp.bottom).offset(kScaleWidth(42))
            make.size.equalTo(CGSize(width: kScaleWidth(40), height: kScaleWidth(20)))
        }
        nextView.snp.makeConstraints { make in
            make.right.equalTo(lineImage.snp.right).offset(-kScaleWidth(72))
            make.top.equalTo(lineImage.snp.top).offset(kScaleWidth(4))
            make.size.equalTo(CGSize(width: kScaleWidth(6), height: kScaleWidth(6)))
        }
        nextlevellb.snp.makeConstraints { make in
            make.centerX.equalTo(nextView.snp.centerX)
            make.bottom.equalTo(lineImage.snp.bottom)
        }
    }
}
