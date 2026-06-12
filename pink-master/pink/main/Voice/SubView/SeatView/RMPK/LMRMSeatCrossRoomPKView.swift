import UIKit
extension LMRMSeatCrossRoomPKView {
    func set_PkStatus(_ viewModel:VoiceVM, roomPkModel:LMinvitePkViewModel) {
        confCrossRoomInfo(viewModel)
        let invitePkInfo = roomPkModel.dataSoure
        dataSoure = invitePkInfo
        switch invitePkInfo.status {
        case .normal, .close, .refuse:
            initNormalUI(viewModel)
        case .start:
            initPKUI(viewModel, roomPkModel: roomPkModel)
        case .end:
            initEndUI(viewModel, roomPkModel: roomPkModel)
        }
    }
    func confCrossRoomInfo(_ viewModel:VoiceVM) {
        for (index, item) in self.items.enumerated() {
            if index == 0 {
                if let item = item as?LMRMCrossPkSeatItemView {
                    item.confCrossRoomInfo(viewModel)
                }
            }
        }
    }
    func set_PkView(_ viewModel:VoiceVM, roomPkModel: LMinvitePkViewModel) {
        pkview?.set_upPkSubviews(viewModel, roomPkModel: roomPkModel)
    }
    func set_PKValue(_ roomItem:RoomItem) {
        if let pkview = self.pkview {
            pkview.set_PKValue(roomItem)
        }
    }
    func set_PKCountDown(_ time: String) {
        if time == "00:03" {
            endAnimation()
        }
        pkview?.progressView.set_Title(title: time)
    }
}
class LMRMSeatCrossRoomPKView:LMSeatBaseView {
    private var pkview:LMRMCrossRoomPKSeatPKView?
    private var resultimv: UIImageView?
    var dataSoure: invitePkInfo = invitePkInfo()
    override func set_TypeAndSeats(_ seats: [RoomSeatItem]) {
        super.set_TypeAndSeats(seats)
        for (index, seat) in seats.enumerated() {
            if index == 1 {
            } else if index == 0 {
            } else {
                let item = LMRMPkNomoreItemView(LMRMSeatItemView.seatItems.gmSeatIndexView())
                item.tag = index
                item.userNamelb.isHidden = true
                self.addSubview(item)
                item.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(0 + (index - 2) * 40)
                    make.bottom.equalToSuperview().offset(-22)
                    make.width.equalTo(40.0)
                    make.height.equalTo(40.0)
                }
                item.setDataSoure(seat)
                item.addGestureTap { [weak self] tap in
                    guard let self = self else { return }
                    if let view = tap.view {
                        Mediator.shared.dispatch(event: LMRMViewMethon.seatClickAction, data: ["seatIndex": view.tag, "seatView": view])
                    }
                }
                items.append(item)
            }
        }
    }
}
private extension LMRMSeatCrossRoomPKView {
    func initNormalUI(_ viewModel:VoiceVM) {
        pkview?.removeFromSuperview()
        pkview = nil
        resultimv?.removeFromSuperview()
    }
    func initPKUI(_ viewModel:VoiceVM, roomPkModel: LMinvitePkViewModel) {
        resultimv?.removeFromSuperview()
        if pkview == nil {
            let pkview = LMRMCrossRoomPKSeatPKView()
            insertSubview(pkview, at: 0)
            pkview.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            pkview.set_upPkSubviews(viewModel, roomPkModel: roomPkModel)
            self.pkview = pkview
        }
        startAnimation()
        guard viewModel.roomItem.role != .audience else {
            return
        }
    }
    func initEndUI(_ viewModel:VoiceVM, roomPkModel:LMinvitePkViewModel) {
        resultimv?.removeFromSuperview()
        if pkview == nil {
            let pkview = LMRMCrossRoomPKSeatPKView()
            insertSubview(pkview, at: 0)
            pkview.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.pkview = pkview
        }
        pkview?.set_upPkSubviews(viewModel, roomPkModel: roomPkModel)
        pkview?.progressView.set_Title(title: "惩罚时间")
        let resultimv = UIImageView()
        addSubview(resultimv)
        resultimv.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 116, height: 116))
        }
        self.resultimv = resultimv
        switch roomPkModel.dataSoure.result {
        case .dogfall:
            resultimv.image(UIImage(named: "rm_pk_pingcent"))
        case .blue:
            resultimv.image(UIImage(named: "rm_pk_win"))
        case .red:
            resultimv.image(UIImage(named: "rm_pk_loss"))
        case nil:
            lmPrint("")
        }
        guard viewModel.roomItem.role != .audience else {
            return
        }
    }
    @objc func pkbtnAction() {
        Mediator.shared.dispatch(event: LMRMViewMethon.pkDidClickStartOrEndAction, data: "")
    }
    func startAnimation() {
    }
    func endAnimation() {
    }
}
extension LMRMSeatCrossRoomPKView: LMAnimationPlayerDelegate {
    func playerDidFinish(_ player: LMAnimationPlayer) {
    }
}
