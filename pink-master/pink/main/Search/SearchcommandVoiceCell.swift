import UIKit
import APNGKit
import AttributedString
extension SearchcommandRoomCell {
    func setDataSoure(_ model: RoomItem, keyString: String? = "") {
        self.dataSoure = model
        self.tagimv.set_Image(url: model.tagUrl)
        self.coverimv.set_Image(url: model.cover)
        self.idlb.text = "ID·" + model.showRoomId
        let text = model.roomName
        let string: ASAttributedString = .init(string: text, .font(lmFontM(14)), .foreground(lmColorHex("#2B313D")))
        titleLab.attributed.text = string
        let keytext = "\("邀请码: ".localized)\(keyString ?? "")"
        var key: ASAttributedString = .init(string: keytext, .font(lmFontR(12)), .foreground(lmColorHex("#2B313DA3")))
        key.add(attributes: [.foreground(lmColorHex("#FF4F7DFF"))], checkings: [.regex(keyString ?? "")])
        commandlb.attributed.text = key.localized
        switch model.scene {
        case .pk:
            sceneimv.isHidden = false
            do {
                let image = try APNGImage(named: "pk-icon")
                self.sceneimv.image = image
                self.sceneimv.autoStartAnimationWhenSetImage = false
                self.sceneimv.startAnimating()
            } catch {
            }
        default:
            self.sceneimv.stopAnimating()
            sceneimv.isHidden = true
        }
        openimv.isHidden(model.status != 1)
        if model.status == 1 {
            arrowimv.image = UIImage(named: "search_exactgoroom")
        } else {
            arrowimv.isHidden = model.like == true
            arrowimv.image = UIImage(named: "search_exfellow")
        }
    }
}
class SearchcommandRoomCell: BaseCollectionViewCell {
    var selectedblock: ((String, RoomItem) -> Void)?
    var dataSoure: RoomItem = RoomItem()
    private lazy var bgimv: UIImageView = {
        let imv = UIImageView()
            .backgroundColor(.white)
            .cornerRadius(12)
            .isUserInteractionEnabled(true)
        return imv
    }()
    private lazy var coverimv: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
            .cornerRadius(kScaleWidth(8))
        return imv
    }()
    private lazy var openimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "search_rm_open"))
            .contentMode(.scaleAspectFill)
        return imv
    }()
    private lazy var titleLab: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        return textView
    }()
    private lazy var tagimv: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
        return imv
    }()
    private lazy var idlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#2B313DA3"))
        return lb
    }()
    private lazy var commandlb: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        return textView
    }()
    private lazy var sceneimv: APNGImageView = {
        let apngView = APNGImageView()
        apngView.isHidden = true
        return apngView
    }()
    private lazy var arrowimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "search_exactgoroom"))
            .isUserInteractionEnabled(true)
        imv.addGestureTap { [weak self] _ in
            self?.selectedCellBack()
        }
        return imv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension SearchcommandRoomCell {
    func setViewSnp() {
        contentView.addSubview(bgimv)
        bgimv.addSubview(coverimv)
        bgimv.addSubview(openimv)
        bgimv.addSubview(titleLab)
        bgimv.addSubview(tagimv)
        bgimv.addSubview(idlb)
        bgimv.addSubview(commandlb)
        bgimv.addSubview(sceneimv)
        bgimv.addSubview(arrowimv)
        bgimv.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(94))
        }
        coverimv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 68.0, height: 68.0))
        }
        openimv.snp.makeConstraints { make in
            make.center.equalTo(coverimv)
            make.size.equalTo(CGSize(width: 70.0, height: 70.0))
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(coverimv.snp.right).offset(12)
            make.top.equalTo(coverimv.snp.top).offset(1.0)
            make.height.equalTo(24.0)
        }
        tagimv.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.left)
            make.top.equalTo(titleLab.snp.bottom).offset(4.0)
            make.size.equalTo(CGSize(width: 44.0, height: 20.0))
        }
        idlb.snp.makeConstraints { make in
            make.left.equalTo(tagimv.snp.right).offset(4)
            make.centerY.equalTo(tagimv.snp.centerY)
        }
        sceneimv.snp.makeConstraints { make in
            make.left.equalTo(idlb.snp.right).offset(kScaleWidth(4))
            make.centerY.equalTo(tagimv)
            make.size.equalTo(CGSize(width: kScaleWidth(24), height: kScaleWidth(24)))
        }
        commandlb.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.left)
            make.top.equalTo(tagimv.snp.bottom).offset(1.0)
        }
        arrowimv.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 36))
        }
    }
    func selectedCellBack() {
        if dataSoure.status == 1 {
            self.selectedblock?("去房间", dataSoure)
        } else {
            self.selectedblock?("关注", dataSoure)
        }
    }
}
