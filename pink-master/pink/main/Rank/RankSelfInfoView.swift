import UIKit
extension RankSelfInfoView {
    func setDataSoure(_ model: VoiceRankItem?) {
        if let model = model {
            self.rankNumlb.text = model.rank.toString()
            self.rankNumimv.image = nil
            self.userNamelb.text = model.nickname
            self.userusheaderView.set_Image(url: model.avatar)
            if model.rank == 1 {
                let text = "当前第一名"
                let attributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor: lmColorHex("#2B313D66")])
                self.valuelb.attributedText = attributedString
            } else {
                let text = model.rankType
                let valueText = model.amount.toString()
                let attributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor: lmColorHex("#2B313D66")])
                attributedString.append(NSAttributedString(string: valueText, attributes: [.foregroundColor: lmColorHex("#2B313D66")]))
                self.valuelb.attributedText = attributedString
            }
        } else {
            self.rankNumlb.text = "-"
            self.userNamelb.text = UserShared.user?.nickname
            self.userusheaderView.set_Image(url: UserShared.user?.avatar)
            let text = "暂未上榜"
            let attributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor: lmColorHex("#2B313D66")])
            self.valuelb.attributedText = attributedString
        }
    }
}
class RankSelfInfoView: UIView {
    private lazy var rankNumlb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(14), textColor: lmColorHex("#2B313D"))
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
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#2B313D"))
        return lb
    }()
    private lazy var valuelb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#2B313D66"))
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension RankSelfInfoView {
    private func setViewSnp() {
        addSubview(rankNumlb)
        addSubview(rankNumimv)
        addSubview(userusheaderView)
        addSubview(userNamelb)
        addSubview(valuelb)
        rankNumlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalTo(userusheaderView)
            make.width.equalTo(48.0)
        }
        rankNumimv.snp.makeConstraints { make in
            make.center.equalTo(rankNumlb)
            make.width.height.equalTo(24.0)
        }
        userusheaderView.snp.makeConstraints { make in
            make.left.equalTo(rankNumlb.snp.right)
            make.top.equalToSuperview().offset(12.0)
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
    }
}
