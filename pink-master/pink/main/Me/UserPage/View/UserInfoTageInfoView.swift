import UIKit
extension UserInfoTageInfoView {
    func setDataSoure(_ model: UsInfoItem) {
        var acctagList: [String] = []
        acctagList = model.userLabel.accomplishmentList.map {$0.labelName}
        var instagList: [String] = []
        instagList = model.userLabel.interestList.map {$0.labelName}
        var gameList: [String] = []
        gameList = model.userLabel.gameList.map {$0.labelName}
        tagView.setDataSoure(acctagList + instagList + gameList)
    }
}
class UserInfoTageInfoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var iconImg: UIImageView = {
        let image = UIImageView(image: UIImage(named: "user_dh_icon"))
        return image
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#2B313D"))
            .lmtext("TA的基因")
        return lb
    }()
    private lazy var tagView: UserCardExtendTagView = {
        let tagView = UserCardExtendTagView()
        tagView.viewHeightChange = { height in
            tagView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(20.0)
                make.top.equalTo(self.titleLab.snp.bottom).offset(20.0)
                make.right.equalToSuperview().offset(-16.0)
                make.height.equalTo(height)
                make.bottom.equalToSuperview().offset(-20)
            }
        }
        return tagView
    }()
}
private extension UserInfoTageInfoView {
    private func setViewSnp() {
        addSubview(iconImg)
        addSubview(titleLab)
        addSubview(tagView)
        iconImg.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview()
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(iconImg.snp.right).offset(kScaleWidth(4))
            make.top.equalToSuperview()
            make.height.equalTo(24.0)
        }
        tagView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.0)
            make.top.equalTo(titleLab.snp.bottom).offset(20.0)
            make.right.equalToSuperview().offset(-16.0)
            make.height.equalTo(32.0)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
