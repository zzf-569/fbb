import UIKit
extension ChatUserView {
    func setDataSoure(_ model: UsInfoItem) {
        self.usheaderView.set_Image(url: model.avatar)
        let set_ = LMUserTagV(richLeve: model.richLevel, charmLevel: model.charmLevel)
        self.userTagView.setDataSoure(set_, maxWidth: kScreenWidth - 16.0 * 2 - 72.0 - 12.0)
        self.subtitleLab.text = model.signature
    }
}
class ChatUserView: UIView {
    private lazy var usheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_avatar)
            .contentMode(.scaleAspectFill)
            .cornerRadius(48/2)
        return imv
    }()
    private lazy var userTagView: UserTagView = {
        let userTagView = UserTagView()
        return userTagView
    }()
    private lazy var subtitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontF(14), textColor: lmColorHex("#2B313DA3"))
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
private extension ChatUserView {
    private func setViewSnp() {
        self.addSubview(usheaderView)
        self.addSubview(userTagView)
        self.addSubview(subtitleLab)
        usheaderView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48.0)
        }
        userTagView.snp.makeConstraints { make in
            make.left.equalTo(usheaderView.snp.right).offset(12.0)
            make.top.equalTo(usheaderView.snp.top).offset(1)
            make.size.equalTo(CGSize(width: 100, height: 20.0))
        }
        subtitleLab.snp.makeConstraints { make in
            make.left.equalTo(usheaderView.snp.right).offset(12.0)
            make.right.equalToSuperview().offset(-12.0)
            make.top.equalTo(userTagView.snp.bottom).offset(4.0)
        }
    }
}
