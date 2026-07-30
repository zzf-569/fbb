import UIKit
class LMRMSeatNormalView:LMRMSeatBasePKView {
        
    override func set_TypeAndSeats(_ seats: [RoomSeatItem]) {
        super.set_TypeAndSeats(seats)
        for (index, seat) in seats.enumerated() {
            if index > 0 {
                let itemWidth = kScreenWidth / 4
                let itemHeight = 100.0
                let item = LMRMSeatItemNormalView(LMRMSeatItemView.seatItems.nomalIndexView())
                item.tag = index
                self.addSubview(item)
                let x = Double((index - 1) % 4) * itemWidth
                let y = Double((index - 1) / 4) * itemHeight + 76
                item.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(x)
                    make.top.equalToSuperview().offset(y)
                    make.width.equalTo(itemWidth)
                    make.height.equalTo(itemHeight)
                }
                item.setDataSoure(seat)
                item.addGestureTap { tap in
                    if let view = tap.view {
                        Mediator.shared.dispatch(event: LMRMViewMethon.seatClickAction, data: ["seatIndex": view.tag, "seatView": view])
                    }
                }
                items.append(item)
            }else {
                let itemWidth = kScreenWidth / 4
                let itemHeight = 100.0
                let item = LMRMSeatItemNormalView(LMRMSeatItemView.seatItems.nomalIndexView())
                item.tag = index
                self.addSubview(item)
                item.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalToSuperview().offset(-24)
                    make.width.equalTo(itemWidth)
                    make.height.equalTo(itemHeight)
                }
                item.setDataSoure(seat)
                item.addGestureTap { tap in
                    if let view = tap.view {
                        Mediator.shared.dispatch(event: LMRMViewMethon.seatClickAction, data: ["seatIndex": view.tag, "seatView": view])
                    }
                }
                items.append(item)
            }
        }
    }
}
