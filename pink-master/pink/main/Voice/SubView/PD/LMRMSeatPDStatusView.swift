import UIKit
extension LMRMSeatPDStatusView {
    func reConfigUI() {
        self.danmuView?.removeFromSuperview()
        self.danmuView = nil
        self.consultView?.removeFromSuperview()
        self.consultView = nil
        self.releaseView?.removeFromSuperview()
        self.releaseView = nil
        self.auditionView?.removeFromSuperview()
        self.auditionView = nil
        self.actionbtn?.removeFromSuperview()
        self.actionbtn = nil
    }
    func set_DispatchStatus(_ viewModel:VoiceVM, PDViewModel: LMRMPDViewModel?) {
        reConfigUI()
        switch PDViewModel?.status {
        case .normal:
            initNormalStatusView(viewModel)
        case .consult:
            initConsultStatusView(viewModel)
        case .release:
            initReleaseStatusView(viewModel, PDViewModel: PDViewModel)
        case .audition:
            initAuditionStatusView(viewModel, PDViewModel: PDViewModel)
        case .dispatch:
            initNormalStatusView(viewModel)
        case .none:
            initNormalStatusView(viewModel)
        }
    }
    func updateAuditionSeatUser(_ seat:RoomSeatItem) {
        if let auditionView = auditionView {
            auditionView.updateAuditionSeatUser(seat)
        }
    }
    func auditionUserDownSeat(_ userId: String) {
        if let auditionView = auditionView {
            auditionView.auditionUserDownSeat(userId)
        }
    }
    func playVolume(_ volume: Int, seatIndex: Int) {
        if let auditionView = auditionView {
            auditionView.playVolume(volume, seatIndex: seatIndex)
        }
    }
}
class LMRMSeatPDStatusView: UIView {
    private var status: RoomPDStatus = .normal
    private lazy var statusimv: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    private lazy var bgimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_seat_dispatch_bg"))
        return imv
    }()
    private var danmuView: LMDanmuView?
    private var danmuDataSource: [LMRMPDusInfoModel] = []
    private var beginTime: TimeInterval = 0.0
    private var consultView:LMRMSeatPDConsultView?
    private var releaseView:LMRMSeatPDReleaseView?
    private var auditionView:LMRMSeatPDAuditionView?
    private var actionbtn: UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
private extension LMRMSeatPDStatusView {
    func set_Subviews() {
        addSubview(statusimv)
        addSubview(bgimv)
        statusimv.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(4.0)
            make.height.equalTo(36.0)
        }
        bgimv.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(statusimv.snp.bottom).offset(4.0)
            make.height.equalTo(128)
        }
        requestData()
    }
    func requestData() {
        UserNetWork.randomList().lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            let userList = responseModel.data as? [[String: Any]]
            guard let list = [LMRMPDusInfoModel].deserialize(from: userList) else { return }
            self.danmuDataSource = list
            if danmuView != nil {
                self.playDanmu()
            }
        } failureBlock: { _ in
        }
    }
    func playDanmu() {
        if let danmuView = self.danmuView {
            for (index, _) in self.danmuDataSource.enumerated() {
                self.danmuDataSource[index].beginTime = self.beginTime + Double(arc4random_uniform(6))
                self.danmuDataSource[index].liveTime = 8.0
            }
            danmuView.dataSource.append(contentsOf: self.danmuDataSource)
        }
    }
    func initNormalStatusView(_ viewModel:VoiceVM) {
        statusimv.image = UIImage(named: "rm_dispatch_status_1")
        let danmuView = LMDanmuView()
        danmuView.delegate = self
        danmuView.lineCount = 3
        addSubview(danmuView)
        danmuView.snp.makeConstraints { make in
            make.top.equalTo(bgimv).offset(16.0)
            make.left.right.equalTo(bgimv)
            make.height.equalTo(120.0)
        }
        self.danmuView = danmuView
        if viewModel.isHostSeat(UserShared.user?.userId) {
            let actionbtn = UIButton(lmfont: lmFontM(14), titleColor: lmColorHex("#2B313D"), target: self, action: #selector(releaseDispatchAction))
                .backgroundImage(UIImage(named: "rm_seat_dispatch_action"))
                .lmtitle("发布需求")
            self.addSubview(actionbtn)
            actionbtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(0)
                make.width.equalTo(80.0)
                make.height.equalTo(32.0)
            }
            self.actionbtn = actionbtn
        } else if viewModel.isOnSeat() {
        } else {
            let actionbtn = UIButton(lmfont: lmFontM(14), titleColor: lmColorHex("#2B313D"), target: self, action: #selector(onGuestSeatAction))
                .backgroundImage(UIImage(named: "rm_seat_dispatch_action"))
                .lmtitle("寻找陪玩")
            self.addSubview(actionbtn)
            actionbtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(0)
                make.width.equalTo(80.0)
                make.height.equalTo(32.0)
            }
            self.actionbtn = actionbtn
        }
        playDanmu()
    }
    func initConsultStatusView(_ viewModel:VoiceVM) {
        statusimv.image = UIImage(named: "rm_dispatch_status_2")
        let consultView = LMRMSeatPDConsultView()
        addSubview(consultView)
        consultView.snp.makeConstraints { make in
            make.left.right.top.equalTo(bgimv)
            make.bottom.equalToSuperview()
        }
        self.consultView = consultView
        if viewModel.isHostSeat(UserShared.user?.userId) {
            let actionbtn = UIButton(lmfont: lmFontM(14), titleColor: .white, target: self, action: #selector(releaseDispatchAction))
                .backgroundImage(UIImage(named: "rm_seat_dispatch_action"))
                .lmtitle("发布需求")
            self.addSubview(actionbtn)
            actionbtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(0)
                make.width.equalTo(80.0)
                make.height.equalTo(32.0)
            }
            self.actionbtn = actionbtn
        } else if viewModel.isOnSeat() {
        } else {
        }
    }
    func initReleaseStatusView(_ viewModel:VoiceVM, PDViewModel: LMRMPDViewModel?) {
        statusimv.image = UIImage(named: "rm_dispatch_status_3")
        let releaseView = LMRMSeatPDReleaseView()
        addSubview(releaseView)
        releaseView.snp.makeConstraints { make in
            make.left.right.top.equalTo(bgimv)
            make.bottom.equalToSuperview()
        }
        releaseView.setDataSoure((PDViewModel?.DispatchItem)!)
        self.releaseView = releaseView
        if viewModel.isHostSeat(UserShared.user?.userId) {
            let actionbtn = UIButton(lmfont: lmFontM(14), titleColor: lmColorHex("#2B313D"), target: self, action: #selector(viewDispatchAction))
                .backgroundImage(UIImage(named: "rm_seat_dispatch_action"))
                .lmtitle("查看需求")
            self.addSubview(actionbtn)
            actionbtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(0)
                make.width.equalTo(80.0)
                make.height.equalTo(32.0)
            }
            self.actionbtn = actionbtn
        } else if viewModel.isOnSeat() {
        } else {
        }
    }
    func initAuditionStatusView(_ viewModel:VoiceVM, PDViewModel: LMRMPDViewModel?) {
        statusimv.image = UIImage(named: "rm_dispatch_status_4")
        let auditionView = LMRMSeatPDAuditionView()
        addSubview(auditionView)
        auditionView.snp.makeConstraints { make in
            make.left.right.top.equalTo(bgimv)
            make.bottom.equalToSuperview()
        }
        auditionView.setDataSoure(viewModel, PDViewModel: PDViewModel)
        self.auditionView = auditionView
        if viewModel.isHostSeat(UserShared.user?.userId) {
            let actionbtn = UIButton(lmfont: lmFontM(14), titleColor: lmColorHex("#2B313D"), target: self, action: #selector(viewDispatchAction))
                .backgroundImage(UIImage(named: "rm_seat_dispatch_action"))
                .lmtitle("查看需求")
            self.addSubview(actionbtn)
            actionbtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(0)
                make.width.equalTo(80.0)
                make.height.equalTo(32.0)
            }
            self.actionbtn = actionbtn
            auditionView.userNamelb.isHidden = true
        } else if viewModel.isOnSeat() {
            auditionView.userNamelb.isHidden = false
        } else {
            auditionView.userNamelb.isHidden = false
        }
    }
    @objc func onGuestSeatAction() {
        Mediator.shared.dispatch(event: LMRMViewMethon.onGuestSeatAction, data: "")
    }
    @objc func releaseDispatchAction() {
        Mediator.shared.dispatch(event: LMRMViewMethon.releaseDispatchAction, data: "")
    }
    @objc func viewDispatchAction() {
        Mediator.shared.dispatch(event: LMRMViewMethon.clickViewDispatchAction, data: "")
    }
}
extension LMRMSeatPDStatusView: LMDanmuViewProtocol {
    var currentTime: TimeInterval {
        self.beginTime += 0.1
        return self.beginTime
    }
    func dMViewForItem(model: LMDanmuModelProtocol) -> UIView {
        let item = LMRMSeatPDDanmuItemView(frame: CGRect(x: 0, y: 0, width:LMRMSeatPDDanmuItemView.getWidth(model as! LMRMPDusInfoModel), height: 24.0))
            .backgroundColor(lmColorHex("#FFFFFF", alpha: 0.08))
            .cornerRadius(24/2)
        item.setDataSoure(model as! LMRMPDusInfoModel)
        return item
    }
    func dMViewDidClick(item: UIView, at point: CGPoint) {
        lmPrint("弹幕被点击：\(item)")
    }
    func dMViewDataSourceDidEmpty() {
        self.playDanmu()
    }
}
