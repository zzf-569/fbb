import UIKit
extension LMSeatBaseView {
    func set_Seats(_ seats: [RoomSeatItem]) {
        for item in items {
            for seat in seats {
                if item.seatIndex == seat.seatIndex {
                    item.setDataSoure(seat)
                }
            }
        }
    }
    func playEmoji(_ model: LMEmojiListModel, seatIndex: Int) {
        if let item = items.first(where: { $0.seatIndex == seatIndex }) {
            item.playEmoji(model)
        }
    }
    func playVolume(_ volume: Int, seatIndex: Int) {
        if let item = items.first(where: { $0.seatIndex == seatIndex }) {
            item.playVolume(volume)
        }
    }
    func seatsCenters() -> [CGPoint] {
        var tempPoints: [CGPoint] = []
        for item in items {
            let itemCenter = item.userusheaderView.center
            lmPrint("初始 麦位 中心点：\(itemCenter)")
            let seatView = superview!
            let seatCenter = item.convert(itemCenter, to: superview)
            lmPrint("麦位区 麦位 中心点：\(seatCenter)")
            let roomView = seatView.superview
            let roomCenter = seatView.convert(seatCenter, to:roomView)
            tempPoints.append(roomCenter)
            lmPrint("屏幕 麦位 中心点：\(roomCenter)")
        }
        return tempPoints
    }
}
class LMSeatBaseView: UIView {
    var items: [LMRMSeatItemView] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setViewSnp() {
    }
    func reConfigUI() {
        self.removeAllSubViews()
        self.items.removeAll()
    }
    func set_TypeAndSeats(_ seats: [RoomSeatItem]) {
    }
}
