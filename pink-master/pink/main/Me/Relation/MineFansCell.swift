import UIKit
protocol MineFansCellDelegate: NSObjectProtocol {
    func dg_userLiked(UsInfoItem: UsInfoItem)
    func dg_editbtnClick(UsInfoItem: UsInfoItem)
}
class MineFansCell: MineUserTableViewCell {
    weak var delegale: MineFansCellDelegate?
    override var dataSoure: UsInfoItem {
        didSet {
            namelb.lmtext(dataSoure.nickname)
            headImage.set_usheader(url: dataSoure.avatar)
            ageView.setDataSoure(LMUserTagV(id: dataSoure.showUserId, idColor: .textTerColor), maxWidth: kScreenWidth - 200)
            followbtn.isHidden = dataSoure.liked
            morebtn.isHidden = !dataSoure.liked
        }
    }
    lazy var followbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: .white, target: self, action: #selector(clickFollow))
            .lmtitle("关注")
            .titleColor(lmColorHex("#FFFFFF"))
            .backgroundColor(lmColorHex("#FF4F7D"))
            .cornerRadius(kScaleWidth(14))
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
        backImage.addSubview(followbtn)
        followbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(26))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(28)))
        }
    }
    @objc func clickFollow() {
        delegale? .dg_userLiked(UsInfoItem: dataSoure)
    }
    @objc override func editbtnClick() {
        delegale? .dg_editbtnClick(UsInfoItem: dataSoure)
    }
}
