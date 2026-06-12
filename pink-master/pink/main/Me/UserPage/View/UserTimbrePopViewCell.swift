import UIKit
class UserTimbrePopViewCell: UICollectionViewCell {
    var title: String = "" {
        didSet {
            titleLab.text = title
        }
    }
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: .textDefaulColor)
        lb.textAlignment(.center)
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
        setDataSoure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        contentView.layoutIfNeeded()
    }
    func setDataSoure() {
    }
    var isSelectedItem: Bool? {
        didSet {
            if isSelectedItem == true {
                contentView.set_Border(radius: 12, borderWidth: 2, borderColor: lmColorHex("#FF4F7D"))
                contentView.backgroundColor = lmColorHex("#FF4F7D1A")
            } else {
                contentView.backgroundColor = lmColorHex("#2B313D0F")
                contentView.set_Border(radius: 12, borderWidth: 0, borderColor: .clear)
            }
        }
    }
}
