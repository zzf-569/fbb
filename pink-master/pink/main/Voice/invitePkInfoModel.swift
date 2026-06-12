import UIKit
class invitePkInfoModel: NSObject {
    var dataSoure: invitePkInfo = invitePkInfo()
    var timer: Timer?
    var countDown: Int = 0
    func initTimer(time: Int, action: @escaping (String?) -> Void) {
        clearTimer()
        let timeString = getTimeString()
        if timeString == nil {
            lmPrint("PK 时间已过期")
        } else {
            timer = Timer(safeTimerWithTimeInterval: 1, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                let timeString = getTimeString()
                if timeString == nil {
                    lmPrint("PK 倒计时结束")
                    clearTimer()
                }
                action(timeString)
            })
        }
        action(timeString)
    }
    func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
    func getTimeString() -> String? {
        var currentTime = dataSoure.currentTime
        let endTime = dataSoure.endTime
        if endTime >= currentTime {
            currentTime += 1000
            dataSoure.currentTime = currentTime
            let timeDifference = abs(endTime / 1000 - currentTime / 1000)
            if timeDifference > 0 {
                let minutes = Int(timeDifference) / 60
                let seconds = Int(timeDifference) % 60
                return String(format: "%02d:%02d", minutes, seconds)
            }
        }
        return nil
    }
    func set_upEndPK() {
        dataSoure.status = .end
        var redValue = 0
        var buleValue = 0
        let campValueMap = dataSoure.campValueMap
        let Allkeys = campValueMap?.map({ $0.key })
        if let keys = Allkeys {
            for string in keys {
                let model = campValueMap?[string]
                if string == VoiceService.shared.roomViewController?.viewModel.roomItem.roomId {
                    buleValue = model?.pkValue ?? 0
                } else {
                    redValue = model?.pkValue ?? 0
                }
            }
        }
        if buleValue == redValue {
            dataSoure.result = .dogfall
        } else if buleValue > redValue {
            dataSoure.result = .blue
        } else {
            dataSoure.result = .red
        }
    }
}
