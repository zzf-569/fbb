import UIKit
import AttributedString
struct LMUserTagLB {
    let sex: Int?
    let age: Int?
    let city: String?
    let constellation: String?
    var textColor: String = ""
    var font: CGFloat = 10
    init(sex: Int? = nil, age: Int? = nil, city: String? = nil, constellation: String? = nil, textColor: String = "#FFFFFFB8", font: CGFloat = 10) {
        self.city = city
        self.sex = sex
        self.age = age
        self.font = font
        self.textColor = textColor
        self.constellation = constellation
    }
}
extension UserTaglb {
    func setDataSoure(_ set_: LMUserTagLB, maxWidth: Double) {
        self.set_ = set_
        var content: ASAttributedString = ASAttributedString("")
        if let age = set_.age {
            let sexAndAgeAttributedString: ASAttributedString = .init(string: "user.age_years_suffix_space".localized(age), .font(lmFontM(set_.font)), .foreground(lmColorHex(set_.textColor)))
            content += sexAndAgeAttributedString
        }
        if let sex = set_.sex {
            let line = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 8))
                .backgroundColor(lmColorHex(set_.textColor))
            let lineString: ASAttributedString = .init("\(.view(line, .original(.center))) ", .font(lmFontM(set_.font)))
            content += lineString
            let genderText = sex == 1 ? "user.young_man".localized : "user.young_woman".localized
            let AgeAttributedString: ASAttributedString = .init(string: " \(genderText) ", .font(lmFontM(set_.font)), .foreground(lmColorHex(set_.textColor)))
            content += AgeAttributedString
        }
        if let city = set_.city, city.isEmpty == false {
            let line = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 8))
                .backgroundColor(lmColorHex(set_.textColor))
            let lineString: ASAttributedString = .init("\(.view(line, .original(.center))) ", .font(lmFontM(set_.font)))
            content += lineString
            let cityAttributedString: ASAttributedString = .init(string: " \(city) ", .font(lmFontM(set_.font)), .foreground(lmColorHex(set_.textColor)))
            content += cityAttributedString
        }
        if let constellation = set_.constellation, constellation.isEmpty == false {
            let line = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 8))
                .backgroundColor(lmColorHex(set_.textColor))
            let lineString: ASAttributedString = .init("\(.view(line, .original(.center))) ", .font(lmFontM(set_.font)))
            content += lineString
            let cityAttributedString: ASAttributedString = .init(string: " \(constellation) ", .font(lmFontM(set_.font)), .foreground(lmColorHex(set_.textColor)))
            content += cityAttributedString
        }
        let localizedContent = content.localized
        self.textView.attributed.text = localizedContent
        let contentSize = localizedContent.value.textSize(width: maxWidth)
        self.snp.updateConstraints { make in
            make.size.equalTo(contentSize)
        }
    }
}
class UserTaglb: UIView {
    var set_: LMUserTagLB?
    private lazy var textView: UITextView = {
        let textView = UITextView(lmfont: lmFontF(10), textColor: lmColorHex("#FFFFFFA3"))
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        return textView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension UserTaglb {
    private func setViewSnp() {
        self.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
