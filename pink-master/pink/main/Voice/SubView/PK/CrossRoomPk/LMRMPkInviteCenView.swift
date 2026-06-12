import UIKit
extension LMRMPkInviteCenView {
    func setDataSoure(_ data: inviteInfo,roomItem:RoomItem) {
        timelb.lmtext("时长: \(data.pkTime / 60)分")
        blueroomAvatar.set_Image(url: data.cover)
        redroomAvatar.set_Image(url:roomItem.cover)
        redName.lmtext(roomItem.roomName)
        if isSender == false {
            let timeString = getTimeString(data)
            confirmbtn.lmtitle("\(timeString ?? "60")s 同意")
            set_time(data)
        }
    }
    func show(_ vc: UIViewController? = nil) {
        if let viewController = vc {
            viewController.addChild(self)
            viewController.view.addSubview(self.view)
        } else {
            UIViewController.current?.addChild(self)
            UIViewController.current?.view.addSubview(self.view)
        }
        self.view.frame = UIScreen.main.bounds
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
            self.contentView.alpha = 1
        } completion: { _ in
        }
    }
    func hide(_ title: String?) {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.backBlock(title)
            self.clear()
        }
    }
}
class LMRMPkInviteCenView: UIViewController {
    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            .backgroundColor(lmColorHex("#0000007F"))
            .alpha(0)
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            if self.bgIsCanClick {
                self.hide(nil)
            }
        }
        return view
    }()
    private lazy var contentView: UIImageView = {
        let view = UIImageView()
            .alpha(0)
            .isUserInteractionEnabled(true)
            .backgroundColor(.white)
            .cornerRadius(20)
        return view
    }()
    private lazy var cancelbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: .textDefaulColor, target: self, action: #selector(cancelbtnAction))
            .backgroundColor(lmColorHex("#2B313D0A"))
            .cornerRadius(12)
            .lmtitle("取消邀请")
        return btn
    }()
    private lazy var confirmbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: .white, target: self, action: #selector(confirmbtnAction))
            .cornerRadius(12)
            .backgroundColor(lmColorHex("#FF4F7DFF"))
        return btn
    }()
    lazy var iconImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "pk_invite_c"))
        return imageV
    }()
    lazy var timelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#2B313DAD")).textAlignment(.center)
        return lb
    }()
    private lazy var blueroomAvatar: UIImageView = {
        let view = UIImageView().cornerRadius(6)
        return view
    }()
    private lazy var redroomAvatar: UIImageView = {
        let view = UIImageView().cornerRadius(6)
        return view
    }()
    lazy var redName: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: .textDefaulColor).textAlignment(.right)
        return lb
    }()
    var timer: Timer?
    var countDown: Int = 0
    private let backBlock: (String?) -> Void
    private let isSender: Bool?
    public var bgIsCanClick: Bool = true
    public init(isSender: Bool, complete block: @escaping (String?) -> Void) {
        self.isSender = isSender
        self.backBlock = block
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setViewSnp()
    }
    deinit {
        lmPrint("UIViewController deinit：----------------\(Self.className)已被销毁")
    }
}
private extension LMRMPkInviteCenView {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(contentView)
        contentView.addSubview(timelb)
        contentView.addSubview(redroomAvatar)
        contentView.addSubview(blueroomAvatar)
        contentView.addSubview(redName)
        contentView.addSubview(iconImage)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavigationHeight)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(310), height: kScaleWidth(220)))
        }
        timelb.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView.snp.top).offset(130)
            make.height.equalTo(22)
        }
        blueroomAvatar.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(91))
            make.top.equalToSuperview().offset(kScaleWidth(16))
            make.size.equalTo(CGSize(width: kScaleWidth(72), height: kScaleWidth(72)))
        }
        redroomAvatar.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(91))
            make.top.equalToSuperview().offset(kScaleWidth(16))
            make.size.equalTo(CGSize(width: kScaleWidth(72), height: kScaleWidth(72)))
        }
        redName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(100))
        }
        iconImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(48))
            make.size.equalTo(CGSize(width: kScaleWidth(40), height: kScaleWidth(40)))
        }
        if isSender == true {
            contentView.addSubview(cancelbtn)
            cancelbtn.lmtitle("取消邀请")
            cancelbtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(kScaleWidth(164))
                make.size.equalTo(CGSize(width: kScaleWidth(96), height: kScaleWidth(40)))
            }
        } else {
            contentView.addSubview(cancelbtn)
            contentView.addSubview(confirmbtn)
            cancelbtn.lmtitle("取消")
            cancelbtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(kScaleWidth(55))
                make.top.equalToSuperview().offset(kScaleWidth(164))
                make.size.equalTo(CGSize(width: kScaleWidth(96), height: kScaleWidth(40)))
            }
            confirmbtn.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-kScaleWidth(55))
                make.top.equalToSuperview().offset(kScaleWidth(164))
                make.size.equalTo(CGSize(width: kScaleWidth(96), height: kScaleWidth(40)))
            }
        }
        self.contentView.center = self.view.center
    }
    func set_time(_ data: inviteInfo) {
        timer = Timer(safeTimerWithTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            let timeString = getTimeString(data)
            if timeString == nil {
                lmPrint("PK 倒计时结束")
                hide(nil)
            } else {
                confirmbtn.lmtitle("\(timeString ?? "")s 同意")
            }
        })
    }
    func getTimeString(_ data: inviteInfo) -> String? {
        let currentTime = data.inviteTime
        let endTime = (Double(Date().timeIntervalSince1970*1000))
        if endTime >= currentTime {
            let timeDifference = endTime / 1000 - currentTime / 1000
            if timeDifference < 60 {
                let seconds = Int(timeDifference) % 60
                return String(format: "%d", 60 - seconds)
            } else {
                return nil
            }
        }
        return nil
    }
    func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
    func clear() {
        clearTimer()
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @objc func cancelbtnAction() {
        hide("取消")
    }
    @objc func confirmbtnAction() {
        hide("同意")
    }
    @objc func closebtnAction() {
        hide("")
    }
}
