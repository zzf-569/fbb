import UIKit
class LMRMSeatPDConsultView: UIView {
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFFF5"))
            .textAlignment(.center)
            .lmtext("主持正在与嘉宾沟通")
        return lb
    }()
    private lazy var imv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_dispatch_seat_consult"))
        return imv
    }()
    private lazy var subtitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFFA3"))
            .textAlignment(.center)
            .lmtext("沟通中，请等待..")
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMSeatPDConsultView {
    private func set_Subviews() {
        addSubview(titleLab)
        addSubview(imv)
        addSubview(subtitleLab)
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(14.0)
        }
        imv.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(8.0)
            make.width.equalTo(120.0)
            make.height.equalTo(64.0)
        }
        subtitleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imv.snp.bottom).offset(8.0)
        }
    }
}
