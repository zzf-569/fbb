import UIKit
struct LMRMPKSetupModel {
    var title: String = ""
    var imageName: String = ""
    var selected: Bool = false
    var time: Int = 5
}
extension LMRMPKSetupCell {
    func setDataSoure(_ model:LMRMPKSetupModel) {
        self.dataSoure = model
        titleLab.text = model.title
        if model.selected {
            titleLab.textColor = lmColorHex("#FF4F7DFF")
            contentView.backgroundColor = lmColorHex("#FF4F7D14")
            contentView.set_Border(radius: 6.0, borderWidth: 1.0, borderColor: lmColorHex("#FF4F7DFF"))
        } else {
            titleLab.textColor = lmColorHex("#FFFFFF", alpha: 0.96)
            contentView.backgroundColor = lmColorHex("#FFFFFF", alpha: 0.06)
            contentView.set_Border(radius: 6.0, borderWidth: 1.0, borderColor: .clear)
        }
    }
    func set_Nomor(_ isNomor: Bool) {
        if isNomor == true {
            if self.dataSoure?.selected == true {
                titleLab.textColor = lmColorHex("#FF4F7DFF")
                contentView.backgroundColor = lmColorHex("#FF4F7D14")
                contentView.set_Border(radius: 6.0, borderWidth: 1.0, borderColor: lmColorHex("#FF4F7DFF"))
            } else {
                titleLab.textColor = lmColorHex("#FFFFFF3D")
                contentView.backgroundColor = lmColorHex("#FFFFFF0F")
                contentView.set_Border(radius: 6.0, borderWidth: 1.0, borderColor: .clear)
            }
        }
    }
}
class LMRMPKSetupCell: BaseCollectionViewCell {
    var dataSoure:LMRMPKSetupModel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#FF4F7D"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var markimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_dispatch_release_sex"))
            .isHidden(true)
        return imv
    }()
}
private extension LMRMPKSetupCell {
    func setViewSnp() {
        contentView.addSubview(titleLab)
        contentView.addSubview(markimv)
        titleLab.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        markimv.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.width.equalTo(20.0)
            make.height.equalTo(10.0)
        }
    }
}
