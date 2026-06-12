import UIKit
extension RankListCell {
    func setDataSoure(_ model: VoiceRankItem) {
        self.rankNumlb.text = model.rank.toString()
        self.userNamelb.text = model.nickname
        self.userusheaderView.set_Image(url: model.avatar)
        if model.showType == 0 {
            let text = model.rankType
            let valueText = model.amount.toString()
            let attributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor: lmColorHex("#FFFFFF8F")])
            attributedString.append(NSAttributedString(string: valueText, attributes: [.foregroundColor: lmColorHex("#FFFFFF8F")]))
            self.valuelb.attributedText = attributedString
        } else {
            if model.rank == 1 {
                let text = "当前第一名"
                let attributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor: lmColorHex("#2B313D66")])
                self.valuelb.attributedText = attributedString
            } else {
                let text = "距离前一名 "
                let valueText = model.amount.toString()
                let attributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor: lmColorHex("#2B313D66")])
                attributedString.append(NSAttributedString(string: valueText, attributes: [.foregroundColor: lmColorHex("#F531B4")]))
                self.valuelb.attributedText = attributedString
            }
        }
    }
}
class RankListCell: LMBaseTableViewCell {
    private lazy var rankNumlb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(14), textColor: lmColorHex("#FFFFFF"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var rankNumimv: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    private lazy var userusheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
            .cornerRadius(56/2)
        return imv
    }()
    private lazy var userNamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFF"))
        return lb
    }()
    private lazy var valuelb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#FFFFFF8F"))
        return lb
    }()
    private lazy var arrowimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "cm_arrow_w"))
        return imv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension RankListCell {
    func setViewSnp() {
        contentView.addSubview(rankNumlb)
        contentView.addSubview(rankNumimv)
        contentView.addSubview(userusheaderView)
        contentView.addSubview(userNamelb)
        contentView.addSubview(valuelb)
        contentView.addSubview(arrowimv)
        rankNumlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(48.0)
        }
        rankNumimv.snp.makeConstraints { make in
            make.center.equalTo(rankNumlb)
            make.width.height.equalTo(24.0)
        }
        userusheaderView.snp.makeConstraints { make in
            make.left.equalTo(rankNumlb.snp.right)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(56.0)
        }
        userNamelb.snp.makeConstraints { make in
            make.left.equalTo(userusheaderView.snp.right).offset(12.0)
            make.top.equalTo(userusheaderView.snp.top).offset(5.0)
            make.height.equalTo(22.0)
        }
        valuelb.snp.makeConstraints { make in
            make.left.equalTo(userNamelb)
            make.top.equalTo(userNamelb.snp.bottom).offset(4.0)
            make.height.equalTo(20.0)
        }
        arrowimv.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12.0)
        }
    }
}
