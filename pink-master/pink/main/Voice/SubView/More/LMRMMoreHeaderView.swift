import UIKit
extension LMRMMoreHeaderView {
    func setDataSoure(_ title: String) {
        self.contentlb.text = title
    }
}
class LMRMMoreHeaderView: UICollectionReusableView {
    private lazy var contentlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFFE0"))
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
private extension LMRMMoreHeaderView {
    private func setViewSnp() {
        self.addSubview(contentlb)
        contentlb.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.height.equalTo(22.0)
        }
    }
}
