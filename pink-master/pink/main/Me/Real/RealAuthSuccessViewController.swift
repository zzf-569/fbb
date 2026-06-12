import UIKit
class RealAuthSuccessViewController: LMBaseVC {
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: .textDefaulColor)
            .lmtext("您已通过实名认证审核")
        return lb
    }()
    lazy var iconImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "auth_success"))
        return imageV
    }()
    lazy var subtitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#2B313D8F"))
            .lmtext("认证成功")
        return lb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
    private func setViewSnp() {
        view.backgroundColor = .white
        view.addSubview(titleLab)
        view.addSubview(iconImage)
        view.addSubview(subtitleLab)
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(40) + kNavigationHeight)
        }
        iconImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(152) + kNavigationHeight)
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
        subtitleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImage.snp.bottom)
        }
    }
    func setDataSoure() {
    }
}
