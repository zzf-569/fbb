import UIKit
extension LMRMPDPopView {
    func show(_ view: UIView) {
        view.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.y = kStatusBarHeight
        } completion: { _ in
            self.createTimer()
        }
    }
    func hide(_ isReceive: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.y = -(kStatusBarHeight + self.height)
        } completion: { _ in
            self.receiveOrderblock(isReceive ? self.model : nil)
            self.timer?.invalidate()
            self.timer = nil
            self.removeFromSuperview()
        }
    }
}
class LMRMPDPopView: UIView {
    private let model: DispatchItem
    private let receiveOrderblock: (DispatchItem?) -> Void
    private var timer: Timer?
    private var countdown: Int = 4
    init(frame: CGRect, model: DispatchItem, receiveOrder block: @escaping (DispatchItem?) -> Void) {
        self.model = model
        self.receiveOrderblock = block
        super.init(frame: frame)
        self.set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var countdownlb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(18), textColor: lmColorHex("#2B313D"))
        return lb
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(18), textColor: lmColorHex("#2B313D"))
        return lb
    }()
    private lazy var contentlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#2B313D", alpha: 0.64))
        return lb
    }()
    private lazy var remarklb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#2B313D", alpha: 0.64))
        return lb
    }()
    private lazy var actionbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: ""), target: self, action: #selector(a_actionbtnAction))
        btn.lmtitle("接单")
        btn.backgroundColor(lmColorHex("#FFEC3BFF"))
        btn.titleColor(.textDefaulColor)
        btn.cornerRadius(16)
        return btn
    }()
}
private extension LMRMPDPopView {
    private func set_Subviews() {
        addSubview(countdownlb)
        addSubview(titleLab)
        addSubview(contentlb)
        addSubview(remarklb)
        addSubview(actionbtn)
        countdownlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalToSuperview().offset(16.0)
            make.height.equalTo(26.0)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(countdownlb.snp.right).offset(4.0)
            make.centerY.equalTo(countdownlb)
            make.right.lessThanOrEqualToSuperview().offset(-16.0)
            make.height.equalTo(26.0)
        }
        contentlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalTo(countdownlb.snp.bottom).offset(8.0)
            make.height.equalTo(20.0)
            make.right.equalTo(actionbtn.snp.left).offset(-10.0)
        }
        remarklb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalTo(contentlb.snp.bottom).offset(2.0)
            make.height.equalTo(20.0)
            make.right.equalTo(actionbtn.snp.left).offset(-10.0)
        }
        actionbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.bottom.equalToSuperview().offset(-20.0)
            make.width.equalTo(64)
            make.height.equalTo(32.0)
        }
        func setDataSoure() {
            titleLab.text = "邀请你接单啦"
            contentlb.text = "需求：\(model.bizName) \(model.genderText) \(model.demandPrice)"
            remarklb.text = "备注：\(model.remark)"
        }
        setDataSoure()
    }
    func createTimer() {
        countdownlb.text = "\(countdown)s"
        timer = Timer(safeTimerWithTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            countdown -= 1
            countdownlb.text = "\(countdown)s"
            if countdown == 0 {
                hide(false)
                timer?.invalidate()
                timer = nil
            }
        })
    }
    @objc func a_actionbtnAction() {
        hide(true)
    }
}
