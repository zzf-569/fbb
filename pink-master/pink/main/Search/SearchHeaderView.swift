import UIKit
class SearchHeaderView: UICollectionReusableView {
    var selectedblock: (() -> Void)?
    lazy var centerView: UIView = {
        let view = UIView().backgroundColor(.white)
        return view
    }()
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(15), textColor: .textDefaulColor)
        return lb
    }()
    lazy var morebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: .textSecondColor)
            .lmtitle("更多")
            .image(UIImage(named: "search_more"))
            .isHidden(true)
        btn.addTarget(self, action: #selector(dg_moreClock), for: .touchUpInside)
        btn.set_ImageTitleLayout(.imgRight)
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(centerView)
        centerView.addSubview(titleLab)
        centerView.addSubview(morebtn)
        centerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(46))
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.height.equalTo(24)
        }
        morebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.centerY.equalTo(titleLab.snp.centerY)
        }
        layoutSubviews()
        centerView.roundedRect([.topLeft, .topRight], withCornerRatio: 8)
    }
    @objc func dg_moreClock() {
        self.selectedblock?()
    }
}
