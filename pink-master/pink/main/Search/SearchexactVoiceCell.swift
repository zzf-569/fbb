import UIKit
import APNGKit
import AttributedString
extension SearchexactRoomCell {
    func setDataSoure(_ model: RoomItem) {
        self.dataSoure = model
        self.tagimv.set_Image(url: model.tagUrl)
        self.coverimv.set_Image(url: model.cover)
        self.idlb.text = "ID·" + model.showRoomId
        let text = model.roomName
        let string: ASAttributedString = .init(string: text, .font(lmFontM(14)), .foreground(lmColorHex("#FF4F7DFF")))
        titleLab.attributed.text = string
        openimv.isHidden(model.status != 1)
    }
}
class SearchexactRoomCell: BaseCollectionViewCell {
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
            .isUserInteractionEnabled(true)
        imv.addGestureTap { [weak self] _ in
            self?.selectedCellBack()
        }
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
    private lazy var arrowimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "fans_more"))
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
private extension SearchexactRoomCell {
    func setViewSnp() {
        contentView.addSubview(bgimv)
        bgimv.addSubview(coverimv)
        bgimv.addSubview(openimv)
        bgimv.addSubview(titleLab)
        bgimv.addSubview(idlb)
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
            make.top.equalTo(coverimv.snp.top).offset(11.0)
            make.right.equalToSuperview().offset(-100)
            make.height.equalTo(24.0)
        }
        idlb.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.left)
            make.top.equalTo(titleLab.snp.bottom).offset(4.0)
        }
        arrowimv.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 28, height: 28))
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
