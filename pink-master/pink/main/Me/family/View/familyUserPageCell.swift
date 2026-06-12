import UIKit
protocol GuildUserPageCellDelegate: NSObjectProtocol {
    func dg_userOperate(UsInfoItem: GuildusInfoModel)
}
class familyUserPageCell: UITableViewCell {
    weak var delegate: GuildUserPageCellDelegate?
    var dataSoure: GuildusInfoModel = GuildusInfoModel() {
        didSet {
            namelb.text = dataSoure.nickname
            headImage.set_usheader(url: dataSoure.avatar)
            if dataSoure.role == 0 {
                rolelb.text = "公会长"
            }else if dataSoure.role == 1 {
                rolelb.text = "管理员"
            }
            else if dataSoure.role == 2 {
                rolelb.text = "成员"
            }
            idView.setDataSoure(LMUserTagV(id: dataSoure.showUserId, idColor: lmColorHex("#2B313D8F")), maxWidth: kScreenWidth)
            hotlb.text = "流水: \(dataSoure.userCharmValue.StringToHotVaule())"
            if dataSoure.userId == UserShared.user?.userId {
                morebtn.isHidden = true
            } else {
                morebtn.isHidden = false
            }
        }
    }
    var isAdmin: Bool? 
    lazy var headImage: UIImageView = {
        let imageV = UIImageView(image: kPlaceholder_avatar)
        imageV.cornerRadius(kScaleWidth(28))
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: .textDefaulColor)
        return lb
    }()
    lazy var rolelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .whitePrimary).textAlignment(.center)
        lb.backgroundColor(lmColorHex("#FFFFFF0F"))
        lb.cornerRadius(3)
        return lb
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
        let btn = UIButton(image: UIImage(named: "fans_more"), target: self, action: #selector(morebtnClick))
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
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(headImage)
        contentView.addSubview(namelb)
        contentView.addSubview(idView)
        contentView.addSubview(morebtn)
        contentView.addSubview(hotlb)
        headImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(56)))
        }
        namelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(88))
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(22)
        }
        idView.snp.makeConstraints { make in
            make.left.equalTo(namelb.snp.left)
            make.bottom.equalToSuperview().offset(-kScaleWidth(16))
            make.size.equalTo(CGSize(width: kScreenWidth, height: 20))
        }
        hotlb.snp.makeConstraints { make in
            make.left.equalTo(idView.snp.right).offset(kScaleWidth(8))
            make.centerY.equalTo(idView.snp.centerY)
            make.height.equalTo(20)
        }
        morebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(20))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(28), height: kScaleWidth(28)))
        }
    }
    @objc func morebtnClick() {
        if isAdmin == true {
            self.delegate? .dg_userOperate(UsInfoItem: dataSoure)
        }
    }
}
