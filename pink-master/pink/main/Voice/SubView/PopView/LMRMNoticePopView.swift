import UIKit
class LMRMNoticePopView: UIView {
    private lazy var bgimv: UIImageView = {
        let imv = UIImageView()
            .backgroundColor(lmColorHex("#000000CC"))
            .cornerRadius(12)
        return imv
    }()
    private lazy var textlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFF", alpha: 0.88))
            .numberOfLines(0)
        return lb
    }()
    private lazy var contentView: UIView = {
        let view = UIView().backgroundColor(.clear)
        return view
    }()
    private lazy var arrowimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_notice_arrow"))
        return imv
    }()
    private let notice: String
    private init(notice: String) {
        self.notice = notice
        super.init(frame: UIScreen.main.bounds)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LMRMNoticePopView {
    static func show(_ notice: String, parentView: UIView) {
        let popView = LMRMNoticePopView(notice: notice)
        popView.isHidden = true
        parentView.addSubview(popView)
        popView.show()
    }
}
private extension LMRMNoticePopView {
    private func setViewSnp() {
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.arrowimv)
        self.contentView.addSubview(self.bgimv)
        self.contentView.addSubview(self.textlb)
        let contentSize = getNoticeSize(notice)
        self.contentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalToSuperview().offset(kStatusBarHeight + 72.0)
            make.size.equalTo(contentSize)
        }
        self.arrowimv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalToSuperview()
            make.width.equalTo(16.0)
            make.height.equalTo(8.0)
        }
        self.bgimv.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(arrowimv.snp.bottom).offset(0)
        }
        self.textlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.right.equalToSuperview().offset(-12.0)
            make.top.equalToSuperview().offset(20.0)
        }
        self.textlb.text = notice
        self.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
    }
    func show() {
        self.isHidden = false
    }
    func hide() {
        self.removeFromSuperview()
    }
    func getNoticeSize(_ text: String) -> CGSize {
        let width = 12.0 + width + 12.0
        let textheight = text.textHeight(width: width, font: lmFontM(14))
        let height = 20.0 + textheight + 12.0
        return CGSize(width: width, height: height)
    }
}
