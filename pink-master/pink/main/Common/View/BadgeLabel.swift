import UIKit
extension Badgelb {
    func set_Badge(_ num: Int) {
        let height = 16.0
        if num <= 0 {
            self.isHidden = true
        } else if num <= 99 {
            self.isHidden = false
            let content = num.toString()
            var contentWidth = content.textWidth(height: height, font: self.contentlb.font)
            contentWidth += 10.0
            if contentWidth < height {
                contentWidth = height
            }
            self.snp.updateConstraints { make in
                make.width.equalTo(contentWidth)
            }
            self.contentlb.text = content
        } else {
            self.isHidden = false
            let content = "99+"
            let contentWidth = content.textWidth(height: height, font: self.contentlb.font)
            self.snp.updateConstraints { make in
                make.width.equalTo(5.0 + contentWidth + 5.0)
            }
            self.contentlb.text = content
        }
    }
}
class Badgelb: UIView {
    private lazy var contentlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(10), textColor: .white)
            .textAlignment(.center)
            .backgroundColor(lmColorHex("#F5455C"))
            .cornerRadius(16/2)
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
private extension Badgelb {
    private func setViewSnp() {
        self.isHidden = true
        self.addSubview(contentlb)
        contentlb.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
