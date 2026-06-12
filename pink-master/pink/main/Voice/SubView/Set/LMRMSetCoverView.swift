import UIKit
extension LMRMSetCoverView {
    func setDataSoure(_ model:RoomItem) {
        self.coverimv.set_Image(url: model.cover)
    }
}
class LMRMSetCoverView: UIView {
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .white)
            .lmtext("房间封面")
        return lb
    }()
    private lazy var coverimv: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
        imv.set_Border(radius: 12.0, borderWidth: 2.0, borderColor: .white)
        return imv
    }()
    private lazy var arrowimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_more_set_arrow"))
        return imv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMSetCoverView {
    private func setViewSnp() {
        self.addSubview(titleLab)
        self.addSubview(coverimv)
        self.addSubview(arrowimv)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
        }
        arrowimv.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12.0)
        }
        coverimv.snp.makeConstraints { make in
            make.right.equalTo(arrowimv.snp.left).offset(0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(56.0)
        }
    }
}
