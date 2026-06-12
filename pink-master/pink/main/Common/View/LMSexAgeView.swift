import UIKit
extension LMSexAgeView {
    func setDataSoure(gender: Int, age: Int) {
        if gender == 1 {
            self.seximv.image = UIImage(named: "cm_tag_sex_boy")
        } else {
            self.seximv.image = UIImage(named: "cm_tag_sex_girl")
        }
        self.agelb.text = age.toString()
    }
}
class LMSexAgeView: UIView {
    private lazy var seximv: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    private lazy var agelb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(10), textColor: .white)
            .textAlignment(.center)
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
private extension LMSexAgeView {
    private func setViewSnp() {
        self.addSubview(seximv)
        self.addSubview(agelb)
        seximv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        agelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13.0)
            make.right.equalToSuperview().offset(-2.0)
            make.centerY.equalToSuperview()
        }
    }
}
