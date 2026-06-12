import UIKit
protocol LMFamApplyTableViewCellDelegate: NSObjectProtocol {
    func dg_userApply(UsInfoItem: GuildApplyModel)
}
class LMFamApplyTableViewCell: UITableViewCell {
    weak var delegate: LMFamApplyTableViewCellDelegate?
    var dataSoure: GuildApplyModel = GuildApplyModel() {
        didSet {
            namelb.text = dataSoure.nickname
            headImage.set_usheader(url: dataSoure.avatar)
            applytypeType.text = "\(dataSoure.createTime) \(dataSoure.desc)"
        }
    }
    var isAdmin: Bool? {
        didSet {
            if isAdmin == true {
                morebtn.image(UIImage(named: "rm_online_user_more"))
            } else {
                morebtn.image(UIImage(named: "fam_more_w"))
            }
        }
    }
    lazy var headImage: UIImageView = {
        let imageV = UIImageView(image: kPlaceholder_avatar)
        imageV.cornerRadius(kScaleWidth(28))
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
        return lb
    }()
    lazy var applytypeType: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#2B313D8F"))
        return lb
    }()
    lazy var morebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: lmColorHex("#2B313D"), target: self, action: #selector(morebtnClick))
            .backgroundColor(lmColorHex("#2B313D0A"))
            .lmtitle("审核")
            .cornerRadius(kScaleWidth(16))
        return btn
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        backgroundColor = .white
        selectionStyle = .none
        contentView.addSubview(headImage)
        contentView.addSubview(namelb)
        contentView.addSubview(morebtn)
        contentView.addSubview(applytypeType)
        headImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(56)))
        }
        namelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(88))
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(kScaleWidth(16))
        }
        applytypeType.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(88))
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(kScaleWidth(16))
        }
        morebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(24))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(32)))
        }
    }
    @objc func morebtnClick() {
        self.delegate? .dg_userApply(UsInfoItem: dataSoure)
    }
}
