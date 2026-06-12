import UIKit
class LMRMSeatView: UIView {
    private var seatView:LMSeatBaseView?
    private var roomItem: RoomItem = RoomItem()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LMRMSeatView {
    func reConfigUI() {
        self.seatView?.reConfigUI()
        self.seatView?.removeFromSuperview()
        self.seatView = nil
    }
    func set_TypeAndSeats(_ seats: [RoomSeatItem],roomItem:RoomItem) {
        reConfigUI()
        switch roomItem.roomType {
        case .normal, .party:
            let seatView = LMRMSeatNormalView(frame: self.bounds)
            self.addSubview(seatView)
            seatView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.seatView = seatView
        case .dispatch:
            let seatView = LMRMSeatPDView(frame: self.bounds)
            self.addSubview(seatView)
            seatView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.seatView = seatView
        case .person:
            break
        default:
           break
        }
        self.seatView?.set_TypeAndSeats(seats)
        if roomItem.roomPkInfo != nil {
            set_RoomPKSeats(seats,roomItem:roomItem)
        }
    }
    func set_RoomPKSeats(_ seats: [RoomSeatItem],roomItem:RoomItem) {
        reConfigUI()
        switch roomItem.roomType {
        case .person:
            break
        default:
            let seatView = LMRMSeatCrossRoomPKView(frame: self.bounds)
            self.addSubview(seatView)
            seatView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.seatView = seatView
            self.seatView?.set_TypeAndSeats(seats)
        }
    }
    func set_Seats(_ seats: [RoomSeatItem]) {
        self.seatView?.set_Seats(seats)
    }
    func playEmoji(_ model: LMEmojiListModel, seatIndex: Int) {
        self.seatView?.playEmoji(model, seatIndex: seatIndex)
    }
    func playVolume(_ volume: Int, seatIndex: Int) {
        self.seatView?.playVolume(volume, seatIndex: seatIndex)
    }
  
    func seatsCenters() -> [CGPoint]? {
        if let seatView = self.seatView {
            return seatView.seatsCenters()
        }
        return nil
    }
}
extension LMRMSeatView {
    func set_PkStatus(_ viewModel:VoiceVM, pkViewModel: LMRMPKViewModel?) {
        if let seatView = seatView as?LMRMSeatBasePKView {
            seatView.set_PkStatus(viewModel, pkViewModel: pkViewModel)
        }
    }
    func set_RMPkStatus(_ viewModel:VoiceVM, roomPkModel:LMinvitePkViewModel) {
        if let seatView = seatView as?LMRMSeatCrossRoomPKView {
            seatView.set_PkStatus(viewModel, roomPkModel: roomPkModel)
        }
    }
    func set_PKValue(_ pkViewModel:LMRMPKViewModel) {
        if let seatView = seatView as?LMRMSeatBasePKView {
            seatView.set_PKValue(pkViewModel)
        }
    }
    func set_RoomPKValue(_ roomItem:RoomItem) {
        if let seatView = seatView as? LMRMSeatCrossRoomPKView {
            seatView.set_PKValue(roomItem)
        }
    }
    func set_PKCountDown(_ time: String) {
        if let seatView = seatView as? LMRMSeatBasePKView {
            seatView.set_PKCountDown(time)
        }
    }
    func set_PkView(_ viewModel:VoiceVM) {
    }
    func set_DispatchStatus(_ viewModel:VoiceVM, PDViewModel: LMRMPDViewModel?) {
        if let seatView = seatView as?LMRMSeatPDView {
            seatView.set_DispatchStatus(viewModel, PDViewModel: PDViewModel)
        }
    }
    func set_DaRenCount(_ count: Int) {
        if let seatView = seatView as?LMRMSeatPDView {
            seatView.set_DaRenCount(count)
        }
    }
    func updateAuditionSeatUser(_ seat:RoomSeatItem) {
        if let seatView = seatView as?LMRMSeatPDView {
            seatView.updateAuditionSeatUser(seat)
        }
    }
    func auditionUserDownSeat(_ userId: String) {
        if let seatView = seatView as?LMRMSeatPDView {
            seatView.auditionUserDownSeat(userId)
        }
    }
    func newUserJoinAuditionSequence(_ viewModel:VoiceVM, PDViewModel: LMRMPDViewModel?) {
        if let seatView = seatView as?LMRMSeatPDView {
            seatView.newUserJoinAuditionSequence(viewModel, PDViewModel: PDViewModel)
        }
    }
}
