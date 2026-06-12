import UIKit
extension SearchexactUserCell {
    func setDataSoure(_ model: UsInfoItem, keyString: String? = "") {
        self.dataSoure = model
        self.usheaderView.set_usheader(url: model.avatar)
        self.nicknamelb.text = model.nickname
        self.idlb.text = "ID·" + model.showUserId
        self.arrowimv.isHidden = model.userId == UserShared.user?.userId
        if keyString == model.nickname {
            nicknamelb.textColor(lmColorHex("#FF4F7DFF"))
        } else {
            nicknamelb.textColor(lmColorHex("#2B313D"))
        }
    }
}
class SearchexactUserCell: BaseCollectionViewCell {
    var dataSoure: UsInfoItem = UsInfoItem()
    var selectedblock: ((UsInfoItem) -> Void)?
    private lazy var bgimv: UIImageView = {
        let imv = UIImageView().backgroundColor(.white).cornerRadius(12)
        return imv
    }()
    private lazy var usheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_avatar)
            .contentMode(.scaleAspectFill)
            .cornerRadius(56/2)
            .isUserInteractionEnabled(true)
        return imv
    }()
    private lazy var nicknamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#FF4F7DFF"))
        return lb
    }()
    private lazy var idlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#2B313DA3"))
        return lb
    }()
    private lazy var arrowimv: UIButton = {
        let imv = UIButton(lmfont: lmFontM(12), titleColor: .white)
            .backgroundColor(lmColorHex("#FF4F7DFF"))
            .cornerRadius(kScaleWidth(14))
            .lmtitle("打招呼")
        imv.addGestureTap { [weak self] _ in
            guard let model = self?.dataSoure else {
                return
            }
            self?.selectedblock?(model)
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
private extension SearchexactUserCell {
    func setViewSnp() {
        contentView.addSubview(bgimv)
        bgimv.addSubview(usheaderView)
        bgimv.addSubview(nicknamelb)
        bgimv.addSubview(idlb)
        bgimv.addSubview(arrowimv)
        bgimv.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(94))
        }
        usheaderView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(56.0)
        }
        nicknamelb.snp.makeConstraints { make in
            make.left.equalTo(usheaderView.snp.right).offset(12.0)
            make.top.equalTo(usheaderView.snp.top).offset(11.0)
            make.height.equalTo(24.0)
            make.right.equalToSuperview().offset(-24.0)
        }
        idlb.snp.makeConstraints { make in
            make.left.equalTo(nicknamelb)
            make.top.equalTo(nicknamelb.snp.bottom).offset(4.0)
        }
        arrowimv.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 56, height: 28))
        }
    }
}
