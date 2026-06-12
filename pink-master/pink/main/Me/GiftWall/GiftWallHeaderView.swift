import UIKit
import AttributedString
class GiftWallHeaderView: UIView {
    lazy var avatarView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.set_Border(radius: kScaleWidth(36), borderWidth: 2, borderColor: .white)
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(16), textColor: .whitePrimary)
            .isHidden(true)
        lb.textAlignment(.center)
        return lb
    }()
    lazy var numlb: UITextView = {
        let lb = UITextView(lmfont: lmFontR(12), textColor: lmColorHex("#F7D18DFF"))
        lb.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        lb.isUserInteractionEnabled = false
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(avatarView)
        addSubview(namelb)
        addSubview(numlb)
        avatarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(0))
            make.size.equalTo(CGSize(width: kScaleWidth(72), height: kScaleWidth(72)))
        }
        namelb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom).offset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(24))
        }
        numlb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom).offset(12)
            make.height.equalTo(kScaleWidth(20))
            make.width.equalTo(kScreenWidth)
        }
    }
    func setDataSoure(model: UsInfoItem) {
        avatarView.set_Image(url: model.avatar)
        namelb.lmtext(model.nickname)
        var prefix: ASAttributedString = .init(string: "礼物图鉴点亮\(model.userGiftCount.toString())/\(model.giftCount.toString())   典藏图鉴已集齐\(model.userIhCount.toString())/\(model.ihCount.toString())", .font(lmFontR(12)), .foreground(lmColorHex("#FFFFFF8F")))
        prefix.set(attributes: [.foreground(lmColorHex("#FFEB34FF"))], checkings: [.regex("/\(model.userGiftCount.toString())")])
        prefix.set(attributes: [.foreground(lmColorHex("#897E81FF"))], checkings: [.regex("/\(model.userIhCount.toString())")])
        numlb.attributed.text = prefix
        numlb.textAlignment = .center
    }
}
