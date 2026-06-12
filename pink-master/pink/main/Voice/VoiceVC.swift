import UIKit
class VoiceVC: LMBaseVC {
    var viewModel:VoiceVM
    {
        didSet{
            roomView.viewModel = viewModel
        }
    }
    lazy var roomView: LMMainView = {
        let view = LMMainView(model:self.viewModel)
        view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        return view
    }()
   
    var roomId: String
    var pkViewModel:LMRMPKViewModel?
    var PDViewModel: LMRMPDViewModel?
    var roomPkModel:LMinvitePkViewModel = LMinvitePkViewModel()
    var daRenView: LMRMDaRanSortView?
    var giftTrackManager = LMRMGiftTrackManager()
    required init(model:RoomItem, delegate:VoiceServiceDelegate) {
        self.roomId = model.roomId
        self.viewModel = VoiceVM(roomItem: model)
        self.viewModel.Seversdelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        configMether()
        entryRoom()
        addNotification()
        RTCService.shared.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.giftTrackManager.set_SuperView(roomView)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    deinit {
        self.removeNotification()
    }
}
private extension VoiceVC {
    func addNotification() {
        IMService.shared.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(nt_receiveImNewMessage), name: NotificationName.imNewPrivateChatMessage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nt_imUnreadMessageCountChange), name: NotificationName.imUnreadMessageCountChange, object: nil)
    }
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
}
extension VoiceVC {
    func setViewSnp() {
        self.view.addSubview(self.roomView)
        
    }
    func createDaRenSequenceView() -> LMRMDaRanSortView {
        let view = LMRMDaRanSortView(frame: UIScreen.main.bounds,roomId: viewModel.roomId)
            .isHidden(true)
        view.setDataSoure(PDViewModel?.sequenceList ?? [])
        view.role = viewModel.roomItem.role
        view.isInSequence = PDViewModel?.isInSequence ?? false
        self.view.addSubview(view)
        return view
    }
}
extension VoiceVC: RTCServiceDelegate {
    func rtcOnAudioVolumeIndicationUpdate(_ soundLevels: [String: NSNumber]) {
        _ = soundLevels.map { (streamId, volume) in
            if let userId = streamId.separatedByString(with: "_").last {
                if let seat = self.viewModel.userSeatInfo(userId) {
                    self.roomView.seatView.playVolume(volume.intValue, seatIndex: seat.seatIndex)
                }
            }
        }
    }
}
extension VoiceVC {
    func startPKTimer() {
        if let pkViewModel = pkViewModel,
           pkViewModel.dataSoure.status == .start,
           let pkTime = pkViewModel.dataSoure.pkTime {
            pkViewModel.initTimer(time: pkTime) { [weak self] timeString in
                guard let self = self else { return }
                if let timeString = timeString {
                    roomView.set_PKCountDown(timeString)
                } else {
                    pkViewModel.set_upEndPK()
                    roomView.set_PkStatus(viewModel, pkViewModel: pkViewModel)
                }
            }
        }
    }
    func endPKTimer() {
        if let pkViewModel = pkViewModel {
            pkViewModel.clearTimer()
        }
    }
    func startCrossPKTimer() {
        let invitePkInfo = roomPkModel
        let pkTime = invitePkInfo.dataSoure.pkTime
        invitePkInfo.initTimer(time: pkTime) { [weak self] timeString in
            guard let self = self else { return }
            if let timeString = timeString {
                roomView.set_PKCountDown(timeString)
            } else {
                invitePkInfo.set_upEndPK()
                roomView.set_RoomPkStatus(viewModel, roomPkModel: roomPkModel)
            }
        }
    }
    
}
