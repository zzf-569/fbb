import UIKit
extension SuiteBottomView {
    func clear() {
    }
    func setDataSoure(_ viewModel:VoiceVM) {
//        if let seat = viewModel.userSeatInfo(UserShared.user?.userId) {
//            //self.onSeatbtn.isSelected = true
//            self.micMutebtn.isHidden = false
//            self.micMutebtn.isSelected = seat.mute
//        } else {
//            // self.onSeatbtn.isSelected = false
//            self.micMutebtn.isHidden = true
//        }
        set_MessageCount(IMService.shared.unreadCount)
    }
    func set_MessageCount(_ count: Int) {
        self.messageRedPoint.isHidden(!(count > 0))
    }
    func newJoinSort(_ viewModel:VoiceVM) {
//        if viewModel.roomItem.role != .audience {
//            if viewModel.seatSequenceList.count > 0 {
//                self.sortRedPoint.isHidden = false
//            } else {
//                self.sortRedPoint.isHidden = true
//            }
//        } else {
//            self.sortRedPoint.isHidden = true
//        }
    }
}
class SuiteBottomView: UIView {
//    private lazy var bacimg: UIImageView = {
//        let imv = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60.0 + kTabBarSafeHeight))
//            .backgroundColor(lmColorHex("#7758FF1F", alpha: 0.8))
//        imv.set_Border(radius: 24.0, conrners: [.topLeft, .topRight])
//        return imv
//    }()
//    private lazy var onSeatbtn: UIButton = {
//        let btn = UIButton(lmfont: lmFontM(14), titleColor: lmColorHex("#FFFFFF", alpha: 0.88))
//        btn.image(UIImage(named: "rm_bottom_onseat_bg"), .normal)
//        btn.image(UIImage(named: "rm_bottom_onseat_s"), .selected)
//        btn.addGestureTap { [weak self] _ in
//            guard let self = self else { return }
//            Mediator.shared.dispatch(event: LMRMViewMethon.bottomSeatAction, data: "")
//        }
//        return btn
//    }()
    private lazy var inputbtn: UILabel = {
        let btn = UILabel().backgroundColor(lmColorHex("#FFFFFF", alpha: 0.12))
        btn.set_Border(radius: 18, borderWidth: 1, borderColor: lmColorHex("#FFFFFF", alpha: 0.35))
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.clickMegViewAction, data: "")
        }
        return btn
    }()
    
    private lazy var emgbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_bottom_emg"))
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.clickGiftAction, data: "")
        }
        return btn
    }()
    
//    private lazy var seatSortbtn: UIButton = {
//        let btn = UIButton(image: UIImage(named: "rm_bottom_more"))
//        btn.addGestureTap { [weak self] _ in
//            guard let self = self else { return }
//            self.sortRedPoint.isHidden = true
//            Mediator.shared.dispatch(event: LMRMViewMethon.showSortViewAction, data: "")
//        }
//        return btn
//    }()
    private lazy var giftbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_bottom_gift"))
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.clickGiftAction, data: "")
        }
        return btn
    }()
    
    private lazy var gamebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_bottom_game"))
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.clickGiftAction, data: "")
        }
        return btn
    }()
    
    private lazy var messagebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_bottom_message"))
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.clickMsgListAction, data: "")
        }
        return btn
    }()
    
    private lazy var memubtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_bottom_mute"))
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.clickMoreAction, data: "")
        }
        return btn
    }()
    
    private lazy var micMutebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_seat_sequence_mic_n"), target: self, action: #selector(micMutebtnAction))
            .image(UIImage(named: "rm_seat_sequence_mic_s"), .selected)
            .image(UIImage(named: "rm_seat_sequence_mic_d"), .disabled)
        return btn
    }()
    private lazy var messageRedPoint: UIView = {
        let view = UIView()
            .backgroundColor(lmColorHex("#F5455C"))
            .cornerRadius(10/2)
            .isHidden(true)
        return view
    }()
//    private lazy var sortRedPoint: UIView = {
//        let view = UIView()
//            .backgroundColor(lmColorHex("#F5455C"))
//            .cornerRadius(10/2)
//            .isHidden(true)
//        return view
//    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension SuiteBottomView {
    private func setViewSnp() {
        //self.addSubview(self.bacimg)
        //self.addSubview(self.onSeatbtn)
        self.addSubview(self.inputbtn)
        //self.addSubview(self.seatSortbtn)
        self.addSubview(self.giftbtn)
        self.addSubview(self.messagebtn)
        self.addSubview(self.gamebtn)
        self.addSubview(self.memubtn)
        self.addSubview(self.emgbtn)

        self.addSubview(self.micMutebtn)
        self.messagebtn.addSubview(self.messageRedPoint)
        //self.seatSortbtn.addSubview(self.sortRedPoint)
        self.inputbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalToSuperview().offset(10.0)
            make.width.equalTo(138.0)
            make.height.equalTo(36.0)
        }
        
        self.emgbtn.snp.makeConstraints { make in
            make.right.equalTo(self.inputbtn.snp.right).offset(-8.0)
            make.centerY.equalTo(self.inputbtn)
            make.width.height.equalTo(20.0)
        }
        
        
        self.messagebtn.snp.makeConstraints { make in
            make.right.equalTo(self.gamebtn.snp.left).offset(-8.0)
            make.top.equalTo(self.inputbtn)
            make.width.height.equalTo(36.0)
        }
//        self.seatSortbtn.snp.makeConstraints { make in
//            make.left.equalTo(self.messagebtn.snp.right).offset(8.0)
//            make.top.equalTo(self.inputbtn)
//            make.width.height.equalTo(36.0)
//        }
        self.memubtn.snp.makeConstraints { make in
            make.right.equalTo(self.messagebtn.snp.left).offset(-8.0)
            make.top.equalTo(self.inputbtn)
            make.width.height.equalTo(36.0)
        }
        
        self.micMutebtn.snp.makeConstraints { make in
            make.right.equalTo(self.memubtn.snp.left).offset(-8.0)
            make.top.equalTo(self.inputbtn)
            make.width.height.equalTo(36.0)
        }
        
        self.messagebtn.snp.makeConstraints { make in
            make.right.equalTo(self.gamebtn.snp.left).offset(-8.0)
            make.top.equalTo(self.inputbtn)
            make.width.height.equalTo(36.0)
        }
        
        self.giftbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(self.inputbtn)
            make.width.height.equalTo(36.0)
        }
        
        self.gamebtn.snp.makeConstraints { make in
            make.right.equalTo(self.giftbtn.snp.left).offset(-8.0)
            make.top.equalTo(self.inputbtn)
            make.width.height.equalTo(36.0)
        }
        
//        self.onSeatbtn.snp.makeConstraints { make in
//            make.right.equalTo(self.giftbtn.snp.left).offset(-8.0)
//            make.top.equalTo(self.inputbtn)
//            make.size.equalTo(CGSize(width: 64, height: 36))
//        }
        self.messageRedPoint.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.width.height.equalTo(10.0)
        }
//        self.sortRedPoint.snp.makeConstraints { make in
//            make.top.right.equalToSuperview()
//            make.width.height.equalTo(10.0)
//        }
    }
    @objc func micMutebtnAction() {
        Mediator.shared.dispatch(event: LMRMViewMethon.clickmicMuteAction, data: "")
    }
}
