import UIKit
extension UserPageVoiceView {
    func setDataSoure(title: String) {
        titleLab.lmtext(title)
    }
}
class UserPageVoiceView: UIView {
    lazy var bgView: UIImageView = {
        let imageV = UIImageView()
            .backgroundColor(lmColorHex("#FF4F7D14"))
            .cornerRadius(14)
        return imageV
    }()
    lazy var playView: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "me_user_voicePlay"))
        return imageV
    }()
    lazy var voiceView: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "me_user_voice"))
        return imageV
    }()
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#FF4F7DFF"))
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
private extension UserPageVoiceView {
    private func setViewSnp() {
        addSubview(bgView)
        addSubview(titleLab)
        addSubview(playView)
        addSubview(voiceView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(4))
            make.centerY.equalToSuperview()
            make.height.equalTo(kScaleWidth(20))
        }
        voiceView.snp.makeConstraints { make in
            make.left.equalTo(playView.snp.right)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(37), height: kScaleWidth(12)))
        }
        playView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(4))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(12), height: kScaleWidth(12)))
        }
    }
}
