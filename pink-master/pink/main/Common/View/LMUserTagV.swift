import UIKit
import AttributedString
struct LMUserTagV {
    let roomRole: RMRoleType?
    let sex: Int?
    let age: Int?
    let id: String?
    let richLeve: Int?
    let charmLevel: Int?
    let idColor: UIColor?
    let isCopy: Bool
    let medal: String?
    init(roomRole: RMRoleType? = nil, sex: Int? = nil, age: Int? = nil, id: String? = nil, richLeve: Int? = nil, charmLevel: Int? = nil, idColor: UIColor? = lmColorHex("#FFFFFFA3"), medal: String? = nil, isCopy: Bool = false) {
        self.roomRole = roomRole
        self.sex = sex
        self.age = age
        self.id = id
        self.richLeve = richLeve
        self.charmLevel = charmLevel
        self.idColor = idColor
        self.isCopy = isCopy
        self.medal = medal
    }
}
extension UserTagView {
    func setDataSoure(_ set_: LMUserTagV, maxWidth: Double) {
        self.set_ = set_
        var content: ASAttributedString = ASAttributedString("")
        if let roomRole = set_.roomRole, roomRole != .audience {
            let imv = UIImageView(image: kPlaceholder_image)
                .contentMode(.scaleAspectFill)
                .frame(CGRect(x: 0, y: 0, width: 20.0, height: 20.0))
            imv.clipsToBounds = true
            var url = ""
            switch roomRole {
            case .admin:
                url = "https://assets.cyanmo.com/icon_img/room-admin.png"
            case .owner:
                url = "https://assets.cyanmo.com/icon_img/homeowner.png"
            case .host:
                url = "https://assets.cyanmo.com/icon_img/room-host.png"
            default:
                break
            }
            imv.set_Image(url: url)
            let richLeveAttributedString: ASAttributedString = .init("\(.view(imv, .original(.center))) ", .font(lmFontF(10)))
            content += richLeveAttributedString
        }
        content += configSex(set_, maxWidth: maxWidth)
        content += configRichLeve(set_, maxWidth: maxWidth)
        content += configCharmLevel(set_, maxWidth: maxWidth)
        if let id = set_.id, let idColor = set_.idColor {
            let idAttributedString: ASAttributedString = .init("ID: \(id) ", .font(lmFontF(10)), .foreground(idColor))
            content += idAttributedString
        }
        if set_.isCopy {
            let btn = UIButton(lmfont: lmFontF(10), titleColor: lmColorHex("#FFFFFF", alpha: 0.96), target: self, action: #selector(copyAction), frame: CGRect(x: 0, y: 0, width: 28.0, height: 16.0))
                .backgroundColor(lmColorHex("#FFFFFF", alpha: 0.08))
                .cornerRadius(3)
                .lmtitle("复制")
            let attributedString: ASAttributedString = .init("\(.view(btn, .original(.center))) ", .font(lmFontF(10)))
            content += attributedString
        }
        let localizedContent = content.localized
        self.textView.attributed.text = localizedContent
        let contentSize = localizedContent.value.textSize(width: maxWidth)
        self.snp.updateConstraints { make in
            make.size.equalTo(contentSize)
        }
    }
    func configSex(_ set_: LMUserTagV, maxWidth: Double) -> ASAttributedString {
        if let sex = set_.sex, let age = set_.age {
            let sexAndAgeview = LMSexAgeView(frame: CGRect(x: 0, y: 0, width: 32.0, height: 20.0))
            sexAndAgeview.setDataSoure(gender: sex, age: age)
            let sexAndAgeAttributedString: ASAttributedString = .init("\(.view(sexAndAgeview, .original(.center))) ", .font(lmFontF(10)))
            return sexAndAgeAttributedString
        }
        return ASAttributedString("")
    }
    func configRichLeve(_ set_: LMUserTagV, maxWidth: Double) -> ASAttributedString {
        if let richLeve = set_.richLeve, let medal = set_.medal, richLeve > 0 {
            let imv = UIImageView(image: kPlaceholder_image)
                .contentMode(.scaleAspectFill)
                .frame(CGRect(x: 0, y: 0, width: 45.0, height: 20.0))
            imv.clipsToBounds = true
            imv.set_Image(url: medal)
            let rich = UILabel(lmfont: lmFontASHTB(12), textColor: .white)
                .textAlignment(.right)
                .lmtext(richLeve.toString())
            imv.addSubview(rich)
            rich.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-6)
                make.centerY.equalToSuperview()
            }
            let richLeveAttributedString: ASAttributedString = .init("\(.view(imv, .original(.center))) ", .font(lmFontF(10)))
            return richLeveAttributedString
        }
        return ASAttributedString("")
    }
    func configCharmLevel(_ set_: LMUserTagV, maxWidth: Double) -> ASAttributedString {
        if let charmLevel = set_.charmLevel {
            let imv = UIImageView(image: kPlaceholder_image)
                .contentMode(.scaleAspectFill)
                .frame(CGRect(x: 0, y: 0, width: 54.0, height: 20.0))
            imv.clipsToBounds = true
            imv.set_Image(url: "\(AppConfig.URL.resource)level/charm/lv\(charmLevel).png")
            let charmLevelAttributedString: ASAttributedString = .init("\(.view(imv, .original(.center))) ", .font(lmFontF(10)))
            return charmLevelAttributedString
        }
        return ASAttributedString("")
    }
    @objc func copyAction() {
        guard let set_ = self.set_ else { return }
        if let id = set_.id {
            UIPasteboard.general.string = id
            HUD.showSuccess("复制成功")
        }
    }
}
class UserTagView: UIView {
    var set_: LMUserTagV?
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
private extension UserTagView {
    private func setViewSnp() {
        self.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
