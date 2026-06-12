import UIKit
class familyRoomPageCell: BaseCollectionViewCell {
    var dataSoure: GuildRoomModel = GuildRoomModel() {
        didSet {
            self.titleLab.text = dataSoure.roomName
            self.coverimv.set_Image(url: dataSoure.cover)
            idView.setDataSoure(LMUserTagV(id: dataSoure.showRoomId, idColor: lmColorHex("#2B313D8F")), maxWidth: kScreenWidth)
            hotlb.text = "流水 \(dataSoure.roomCharmValue.StringToHotVaule())"
        }
    }
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
        lb.numberOfLines = 1
        return lb
    }()
    private lazy var coverimv: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
            .cornerRadius(kScaleWidth(8))
        return imv
    }()
    lazy var idView: UserTagView = {
        let view = UserTagView()
        return view
    }()
    lazy var hotlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#2B313D8F"))
        lb.textAlignment = .left
        return lb
    }()
    lazy var morebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "fans_more"))
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        contentView.addSubview(titleLab)
        contentView.addSubview(coverimv)
        contentView.addSubview(idView)
        contentView.addSubview(hotlb)
        contentView.addSubview(morebtn)
        coverimv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(56)))
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(coverimv.snp.right).offset(kScaleWidth(12))
            make.top.equalToSuperview().offset(kScaleWidth(17))
            make.height.equalTo(22)
        }
        idView.snp.makeConstraints { make in
            make.left.equalTo(coverimv.snp.right).offset(kScaleWidth(12))
            make.bottom.equalToSuperview().offset(-kScaleWidth(16))
            make.size.equalTo(CGSize(width: kScaleWidth(60), height: 20))
        }
        hotlb.snp.makeConstraints { make in
            make.left.equalTo(idView.snp.right).offset(kScaleWidth(8))
            make.centerY.equalTo(idView.snp.centerY)
            make.height.equalTo(20)
        }
        morebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(34))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(28), height: kScaleWidth(28)))
        }
    }
}
