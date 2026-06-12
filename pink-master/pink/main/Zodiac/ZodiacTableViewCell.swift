import UIKit
protocol ZodiacTableViewCellDelegate: NSObjectProtocol {
    func dg_cellClick(model: UsInfoItem)
}
class ZodiacTableViewCell: UITableViewCell {
    func setData(model: UsInfoItem) {
        self.dataSoure = model
        headImaeg.set_Image(url: model.avatar)
        namelb.text = model.nickname
        lineView.isHidden = model.onlineStatus != "ONLINE"
        likebtn.isSelected = model.hostLiked
        var taglb = "\(model.age)岁 | "
        if model.gender == 1 {
            taglb += "小哥哥"
        } else {
            taglb += "小姐姐"
        }
        if model.city.isEmpty == false {
            taglb += "  |  \(model.city)"
        }
        if model.constellation.isEmpty == false {
            taglb += "  |  \(model.constellation)"
        }
        infolb.text = taglb
    }
    var degegate: ZodiacTableViewCellDelegate?
    var dataSoure: UsInfoItem = UsInfoItem()
    lazy var bgView: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "zidiac_cellbg"))
        imageV.isUserInteractionEnabled = true
        return imageV
    }()
    lazy var headImaeg: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.layer.masksToBounds = true
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel()
        lb.font = lmFontM(16)
        lb.textColor = .white
        return lb
    }()
    lazy var infolb: UILabel = {
        let lb = UILabel()
        lb.font = lmFontR(12)
        lb.textColor = lmColorHex("#FFFFFFB8")
        return lb
    }()
    lazy var likebtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "zodiac_like"), for: .normal)
        btn.setImage(UIImage(named: "zodiac_liked"), for: .selected)
        btn.addTarget(self, action: #selector(likebtnClick), for: .touchUpInside)
        return btn
    }()
    lazy var lineView: UILabel = {
        let lb = UILabel(lmfont: lmFontM(10), textColor: lmColorHex("#26D477FF"))
            .backgroundColor(lmColorHex("#26D47714"))
            .lmtext("• 在线")
            .cornerRadius(8)
        lb.textAlignment = .center
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
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.addSubview(headImaeg)
        bgView.addSubview(namelb)
        bgView.addSubview(lineView)
        bgView.addSubview(infolb)
        bgView.addSubview(likebtn)
        bgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(35))
            make.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(88))
        }
        headImaeg.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(64), height: kScaleWidth(64)))
        }
        namelb.snp.makeConstraints { make in
            make.left.equalTo(headImaeg.snp.right).offset(kScaleWidth(23))
            make.top.equalToSuperview().offset(kScaleWidth(18))
            make.height.equalTo(kScaleWidth(22))
        }
        lineView.snp.makeConstraints { make in
            make.left.equalTo(namelb.snp.right).offset(kScaleWidth(8))
            make.top.equalToSuperview().offset(kScaleWidth(18))
            make.size.equalTo(CGSize(width: kScaleWidth(45), height: kScaleWidth(20)))
        }
        infolb.snp.makeConstraints { make in
            make.left.equalTo(namelb)
            make.bottom.equalToSuperview().offset(-kScaleWidth(18))
        }
        likebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(12))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32, height: kScaleWidth(32)))
        }
    }
    @objc func likebtnClick() {
        likebtn.isSelected = true
        self.degegate?.dg_cellClick(model: dataSoure)
    }
}
