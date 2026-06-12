import UIKit
class SearchHeaderView: UICollectionReusableView {
    var selectedClosure: (() -> Void)?
    lazy var centerView: UIView = {
        let view = UIView().act_backgroundColor(.white)
        return view
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel(lmfont: lmFontM(15), textColor: .textPrimary)
        return label
    }()
    lazy var moreBtn: UIButton = {
        let button = UIButton(lmfont: lmFontM(12), titleColor: .textSecondary)
            .act_lmtitle("更多")
            .act_image(UIImage(named: "search_more"))
            .act_isHidden(true)
        button.addTarget(self, action: #selector(dg_moreClock), for: .touchUpInside)
        button.act_setImageTitleLayout(.imgRight)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        act_setUISubViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func act_setUISubViews() {
        addSubview(centerView)
        centerView.addSubview(titleLabel)
        centerView.addSubview(moreBtn)
        centerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(46))
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.height.equalTo(24)
        }
        moreBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        layoutSubviews()
        centerView.roundedRect([.topLeft, .topRight], withCornerRatio: 8)
    }
    @objc func dg_moreClock() {
        self.selectedClosure?()
    }
}
