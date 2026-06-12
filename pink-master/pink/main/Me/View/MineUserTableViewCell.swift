import UIKit
protocol MineUserTableViewCellDelegate: NSObjectProtocol {
    func dg_editbtnClick(UsInfoItem: UsInfoItem)
}
class MineUserTableViewCell: UITableViewCell {
    weak var delegate: MineUserTableViewCellDelegate?
    var dataSoure: UsInfoItem = UsInfoItem() {
        didSet {
            namelb.lmtext(dataSoure.nickname)
            headImage.set_usheader(url: dataSoure.avatar)
            ageView.setDataSoure(LMUserTagV(id: dataSoure.showUserId, idColor: .textTerColor), maxWidth: kScreenWidth - 200)
        }
    }
    func set_Edit(edit: Bool) {
        if edit == true {
            editbtn.isHidden = false
            backImage.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(kScaleWidth(64))
            }
        } else {
            editbtn.isHidden = true
            backImage.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(kScaleWidth(0))
            }
        }
    }
    lazy var backImage: UIImageView = {
        let imageV = UIImageView()
            .backgroundColor(.white)
        imageV.isUserInteractionEnabled = true
        return imageV
    }()
    lazy var headImage: UIImageView = {
        let imageV = UIImageView(image: kPlaceholder_avatar)
        imageV.cornerRadius(kScaleWidth(28))
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
        return lb
    }()
    lazy var ageView: UserTagView = {
        let view = UserTagView()
        return view
    }()
    lazy var editbtn: UIButton = {
        let imageV = UIButton(image: UIImage(named: "me_deleCell"), target: self, action: #selector(editbtnClick))
        imageV.isHidden = true
        return imageV
    }()
    lazy var morebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "fans_more"))
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
        contentView.addSubview(backImage)
        contentView.addSubview(editbtn)
        backImage.addSubview(headImage)
        backImage.addSubview(namelb)
        backImage.addSubview(ageView)
        backImage.addSubview(morebtn)
        editbtn.snp.makeConstraints { make in
            make.right.equalTo(backImage.snp.left).offset(-kScaleWidth(22))
            make.centerY.equalTo(backImage)
            make.size.equalTo(CGSize(width: kScaleWidth(24), height: kScaleWidth(24)))
        }
        backImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(kScaleWidth(0))
            make.top.equalToSuperview().offset(kScaleWidth(0))
            make.height.equalTo(kScaleWidth(80))
            make.width.equalTo(kScreenWidth)
        }
        headImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(12))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(56)))
        }
        namelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(78))
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(kScaleWidth(24))
        }
        ageView.snp.makeConstraints { make in
            make.left.equalTo(namelb.snp.left)
            make.bottom.equalToSuperview().offset(-kScaleWidth(16))
            make.size.equalTo(CGSize(width: kScaleWidth(32), height: kScaleWidth(20)))
        }
        morebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(28), height: kScaleWidth(28)))
        }
        let line = UIView().backgroundColor(lmColorHex("#2B313D14"))
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(1)
        }
    }
    @objc func editbtnClick() {
        delegate? .dg_editbtnClick(UsInfoItem: dataSoure)
    }
}
