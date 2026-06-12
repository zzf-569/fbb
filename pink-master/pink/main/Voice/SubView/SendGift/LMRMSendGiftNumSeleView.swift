import UIKit
extension LMRMSendGiftNumSeleView {
    static func show(parentView: UIView, block: @escaping (Int) -> Void) {
        let pop = LMRMSendGiftNumSeleView(frame: UIScreen.main.bounds, block: block)
        pop.isHidden = true
        parentView.addSubview(pop)
        pop.show()
    }
}
class LMRMSendGiftNumSeleView: UIView {
    private lazy var bgView: UIView = {
        let view = UIView().backgroundColor(.clear)
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var bdView: UIView = {
        let view = UIView().backgroundColor(lmColorHex("#303041"))
            .cornerRadius(12.0)
        return view
    }()
    private let dataSource: [String] = ["1 一心一意", "5 五福临门", "10 十全十美", "66 一切顺利", "99 天长地久", "188 要抱抱", "520 我爱你", "1314 一生一世"]
    private let centerPoint: CGPoint = CGPoint(x: kScreenWidth - 76.0, y: kScreenHeight - 48.0 - kTabBarSafeHeight)
    private let block: (Int) -> Void
    private init(frame: CGRect, block: @escaping (Int) -> Void) {
        self.block = block
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMSendGiftNumSeleView {
    private func setViewSnp() {
        self.addSubview(bgView)
        self.addSubview(bdView)
        let contentSize = getContentSize(dataSource)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(centerPoint.x - contentSize.width/2)
            make.bottom.equalToSuperview().offset(-(kScreenHeight - centerPoint.y))
            make.size.equalTo(contentSize)
        }
        for (index, item) in dataSource.enumerated() {
            let btn = UIButton(lmfont: lmFontM(12), titleColor: .white, target: self, action: #selector(btnAction))
                .tag(index).lmtitle(item)
                .backgroundColor(lmColorHex("#454558"))
                .cornerRadius(28.0/2)
            bdView.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(8.0)
                make.right.equalToSuperview().offset(-8.0)
                make.top.equalTo(8.0 + 28.0 * index.toDouble() + index.toDouble() * 8.0)
                make.height.equalTo(28.0)
            }
        }
    }
    @objc func btnAction(_ btn: UIButton) {
        var count = 0
        switch btn.tag {
        case 0:
            count = 1
        case 1:
            count = 5
        case 2:
            count = 10
        case 3:
            count = 66
        case 4:
            count = 99
        case 5:
            count = 188
        case 6:
            count = 520
        case 7:
            count = 1314
        default:
            count = 1
        }
        self.block(count)
        self.hide()
    }
    func show() {
        self.isHidden = false
    }
    func hide() {
        self.removeFromSuperview()
    }
    func getContentSize(_ List: [String]) -> CGSize {
        let width = 112.0
        return CGSize(width: width, height: List.count.toDouble() * 28.0 + (List.count.toDouble() + 1.0) * 8.0)
    }
}
