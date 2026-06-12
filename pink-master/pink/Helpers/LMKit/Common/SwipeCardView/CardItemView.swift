import UIKit
extension CardItemView {
}
class CardItemView: UIView, SwipeCardItemViewDelegate {
    func setDataSoure(_ model: Any?) {
        guard let model = model as? CardItemModel else { return }
        self.titleLab.text = model.title
        self.subtitleLab.text = model.subtitle
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var titleLab: UILabel = {
        let label = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
        return label
    }()
    private lazy var subtitleLab: UILabel = {
        let label = UILabel(lmfont: lmFontM(14), textColor: .textSecondColor)
        return label
    }()
}
private extension CardItemView {
    private func setViewSnp() {
        addSubview(titleLab)
        addSubview(subtitleLab)
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(12.0)
            make.right.equalTo(-12.0)
            make.top.equalTo(12.0)
        }
        subtitleLab.snp.makeConstraints { make in
            make.left.equalTo(12.0)
            make.right.equalTo(-12.0)
            make.bottom.equalTo(-12.0)
        }
    }
}
