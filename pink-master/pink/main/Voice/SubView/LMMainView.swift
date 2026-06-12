import UIKit
class LMMainView: UIView {
    private var roomType: RMCORType = .normal
    var viewModel:VoiceVM
    
    private lazy var bgimv: SuiteBackGroundView = {
        let imv = SuiteBackGroundView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        return imv
    }()
    
    lazy var sequenceView:LMRMSeatSortView = {
        let view = LMRMSeatSortView(frame: UIScreen.main.bounds)
            .isHidden(true)
        return view
    }()
    lazy var giftView:LMRMSendGiftPopController = {
        let vc = LMRMSendGiftPopController(roomId: viewModel.roomItem.roomId)
        return vc
    }()
    lazy var moreView:LMRMMoreView = {
        let view = LMRMMoreView(frame: UIScreen.main.bounds)
            .isHidden(true)
        return view
    }()
    
    lazy var topView:LMRMTopView = {
        let view = LMRMTopView()
        return view
    }()
    lazy var seatView:LMRMSeatView = {
        let view = LMRMSeatView()
        return view
    }()
    lazy var bannerView: SuiteBannerView = {
        let view = SuiteBannerView()
        return view
    }()
    lazy var chatListView:LMRMChatListView = {
        let view = LMRMChatListView()
        return view
    }()
    lazy var bottomView: SuiteBottomView = {
        let view = SuiteBottomView()
        return view
    }()
    lazy var giftAniView: SuiteAnimationView = {
        let giftAniView = SuiteAnimationView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            .backgroundColor(.clear)
            .isUserInteractionEnabled(false)
        return giftAniView
    }()
    lazy var inviteView:LMPKInvitebtnView = {
        let btn = LMPKInvitebtnView()
            .isHidden(true)
        return btn
    }()
    required init(model:VoiceVM) {
        self.viewModel = model
        super.init(frame: .zero)
        self.setViewSnp()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LMMainView {
    func reConfigUI() {
        self.topView.reConfigUI()
        self.seatView.reConfigUI()
        self.giftAniView.reConfigUI()
        self.chatListView.reConfigUI()
        self.bannerView.reConfigUI()
    }
    func clear() {
    }
    func resatSubView(_ viewModel:VoiceVM) {
        self.viewModel = viewModel
        
        if self.roomType == viewModel.roomItem.roomType && viewModel.roomItem.gameStatus == .isGame {
            return
        }
        switch viewModel.roomItem.roomType {
        case .person:
            setPersonView(viewModel)
            
        default:
            setNomorView(viewModel)
        }
        
        self.roomType = viewModel.roomItem.roomType
    }
    func setPersonView(_ viewModel:VoiceVM) {
        self.viewModel = viewModel
        self.seatView.snp.remakeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(4.0)
            make.right.equalToSuperview().offset(-6)
            make.width.equalTo(100.0)
            make.height.equalTo(222.0)
        }
        self.chatListView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalTo(self.topView.snp.bottom).offset(12.0)
            make.right.equalToSuperview().offset(-112.0)
            make.bottom.equalToSuperview().offset(-kTabHeight)
        }
        self.bannerView.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(self.seatView.snp.bottom).offset(90)
            make.width.equalTo(64.0)
            make.height.equalTo(70.0)
        }
        self.inviteView.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.bannerView.snp.top).offset(-32)
            make.height.equalTo(48)
        }
    }
    func setNomorView(_ viewModel:VoiceVM) {
        self.viewModel = viewModel
        
        self.bottomView.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60.0 + kTabBarSafeHeight)
        }
        self.topView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight)
            make.height.equalTo(68.0)
        }
        if viewModel.roomItem.roomType == .dispatch {
            self.seatView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(topView.snp.bottom).offset(16)
                make.height.equalTo(304.0)
            }
        } else {
            self.seatView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(topView.snp.bottom).offset(16)
                make.height.equalTo(220.0)
            }
        }
        self.chatListView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalTo(self.seatView.snp.bottom).offset(16.0)
            make.right.equalToSuperview().offset(-112.0)
            make.bottom.equalToSuperview().offset(-kTabHeight)
        }
        self.bannerView.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(self.chatListView)
            make.width.equalTo(64.0)
            make.height.equalTo(70.0)
        }
    }
    func set_UIinfo(_ viewModel:VoiceVM, pkViewModel: LMRMPKViewModel?, roomPkModel:LMinvitePkViewModel) {
        self.viewModel = viewModel
        
        self.resatSubView(viewModel)
        self.bottomView.setDataSoure(viewModel)
        self.topView.setDataSoure(viewModel.roomItem)
        self.topView.set_Seats(viewModel.seats)
        self.seatView.set_TypeAndSeats(viewModel.roomItem.seatList,roomItem: viewModel.roomItem)
        self.set_BackGround(viewModel)
        if viewModel.roomItem.roomPkInfo != nil {
            set_RoomPkStatus(viewModel,roomPkModel:roomPkModel)
        } else {
            if let pkViewModel = pkViewModel {
                set_PkStatus(viewModel, pkViewModel: pkViewModel)
                updatePKValue(pkViewModel)
            }
        }
    }
    func set_BackGround(_ viewModel:VoiceVM) {
        if viewModel.roomItem.roomType == .dispatch {
            bgimv.setDataSoure(url: viewModel.roomItem.background, placeholder: "rm_dispatch_bg")
        } else if viewModel.roomItem.roomType == .normal {
            bgimv.setDataSoure(url: viewModel.roomItem.background, placeholder: "rm_normal_bg")
        } else if viewModel.roomItem.roomType == .person {
            bgimv.setDataSoure(url: viewModel.roomItem.background, placeholder: "rm_person_bg")
        } else {
            bgimv.setDataSoure(url: viewModel.roomItem.background, placeholder: "rm_normal_bg")
        }
    }
    func set_CollectStatus(_ status: Bool) {
        self.topView.set_CollectStatus(status)
    }
    func set_MessageCount(_ count: Int) {
        self.bottomView.set_MessageCount(count)
    }
    func set_PkStatus(_ viewModel:VoiceVM, pkViewModel: LMRMPKViewModel?) {
        self.viewModel = viewModel
        
        if viewModel.roomItem.gameStatus == .isGame {
            return
        }

        if viewModel.roomItem.roomType == .normal || viewModel.roomItem.roomType == .party {
            
            if  pkViewModel?.dataSoure.status == .normal || pkViewModel?.dataSoure.status == .close || pkViewModel == nil  {
                    UIView.animate(withDuration: 0.3) {
                        self.seatView.snp.updateConstraints { make in
                            make.height.equalTo(220.0)
                        }
                        self.chatListView.snp.remakeConstraints { make in
                            make.left.equalToSuperview().offset(16.0)
                            make.top.equalTo(self.seatView.snp.bottom).offset(16.0)
                            make.right.equalToSuperview().offset(-112.0)
                            make.bottom.equalToSuperview().offset(-kTabHeight)
                        }
                        self.seatView.superview?.layoutIfNeeded()
                    } completion: { _ in
                    }
                    set_BackGround(viewModel)
                
            }else {
                UIView.animate(withDuration: 0.3) {
                    self.seatView.snp.updateConstraints { make in
                        make.height.equalTo(228.0 + 8 + 62)
                    }
                    self.chatListView.snp.remakeConstraints { make in
                        make.left.equalToSuperview().offset(16.0)
                        make.top.equalTo(self.seatView.snp.bottom).offset(16.0)
                        make.right.equalToSuperview().offset(-112.0)
                        make.bottom.equalToSuperview().offset(-kTabHeight)
                    }
                    self.seatView.superview?.layoutIfNeeded()
                } completion: { _ in
                }
                bgimv.setDataSoure(url: "", placeholder: "rm_pk_bg")
            }
            seatView.set_PkStatus(viewModel, pkViewModel: pkViewModel)
        }
    }
    
    func set_RoomPkStatus(_ viewModel:VoiceVM, roomPkModel:LMinvitePkViewModel) {
        self.viewModel = viewModel
        
        if viewModel.roomItem.gameStatus == .isGame || viewModel.roomItem.roomPkInfo == nil {
            set_BackGround(viewModel)
            return
        }
        
        switch viewModel.roomItem.roomType {
        case .normal, .party:
            UIView.animate(withDuration: 0.3) {
                self.seatView.snp.updateConstraints { make in
                    make.top.equalTo(self.topView.snp.bottom).offset(-kScaleWidth(0))
                    make.height.equalTo(272.0)
                }
                self.chatListView.snp.remakeConstraints { make in
                    make.left.equalToSuperview().offset(16.0)
                    make.top.equalTo(self.seatView.snp.bottom).offset(16.0)
                    make.right.equalToSuperview().offset(-112.0)
                    make.bottom.equalToSuperview().offset(-kTabHeight)
                }
                self.seatView.superview?.layoutIfNeeded()
            } completion: { _ in
            }
            bgimv.setDataSoure(url: "", placeholder: "rm_pk_bg")
        default:
            UIView.animate(withDuration: 0.3) {
                self.seatView.snp.updateConstraints { make in
                    make.top.equalTo(self.topView.snp.bottom).offset(-kScaleWidth(0))
                    make.width.equalTo(kScreenWidth)
                    make.height.equalTo(kScaleWidth(144) + 94)
                }
                self.chatListView.snp.remakeConstraints { make in
                    make.left.equalToSuperview().offset(16.0)
                    make.top.equalTo(self.seatView.snp.bottom).offset(-94)
                    make.right.equalToSuperview().offset(-112.0)
                    make.bottom.equalToSuperview().offset(-kTabHeight)
                }
                self.seatView.superview?.layoutIfNeeded()
                self.seatView.sendSubviewToBack(self.chatListView)
            } completion: { _ in
            }
            bgimv.setDataSoure(url: "", placeholder: "rm_pk_bg")
        }
 
    }
    func updatePKValue(_ pkViewModel:LMRMPKViewModel) {
        seatView.set_PKValue(pkViewModel)
    }
    func set_PKCountDown(_ time: String) {
        seatView.set_PKCountDown(time)
    }
    func changeBackGround(url: String) {
        bgimv.setDataSoure(url: url, placeholder: "rm_party_bg")
    }
    func showPkInviteinfo(_ inviteInfo: inviteInfo?) {
        guard let inviteInfo = inviteInfo else {
            inviteView.isHidden = true
            if let views = UIViewController.current?.children {
                for view in views {
                    if view.className == LMRMPkInviteCenView.className {
                        (view as!LMRMPkInviteCenView).hide(nil)
                    }
                }
            }
            return
        }
        inviteView.setDataSoure(inviteInfo)
        inviteView.isHidden = false
        Mediator.shared.dispatch(event: LMRMViewMethon.invitebtnShow, data: "")
    }
    
}
extension LMMainView {
    private func setViewSnp() {
        
        self.addSubview(self.bgimv)
        self.addSubview(self.bottomView)
        self.addSubview(self.giftAniView)
        self.addSubview(self.seatView)
        self.addSubview(self.topView)
        self.addSubview(self.chatListView)
        self.addSubview(self.bannerView)
        self.addSubview(self.inviteView)
        self.addSubview(self.sequenceView)
        self.addSubview(self.moreView)
        self.bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60.0 + kTabBarSafeHeight)
        }
        self.topView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight)
            make.height.equalTo(72.0)
        }
        self.seatView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(4.0)
            make.height.equalTo(220.0)
        }
        self.chatListView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalTo(self.seatView.snp.bottom).offset(16.0)
            make.right.equalToSuperview().offset(-112.0)
            make.bottom.equalToSuperview().offset(-kTabHeight)
        }
        self.bannerView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(self.chatListView)
            make.width.equalTo(64.0)
            make.height.equalTo(70.0)
        }
        self.inviteView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(self.bannerView.snp.bottom).offset(24)
            make.width.height.equalTo(64)
        }
        
    }
}
