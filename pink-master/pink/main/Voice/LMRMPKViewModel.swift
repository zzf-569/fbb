import Foundation
class LMRMPKViewModel: NSObject {
    var dataSoure:RoomPKModel = RoomPKModel()
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
        if  var currentTime = dataSoure.currentTime, let endTime = dataSoure.endTime, endTime >= currentTime {
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
        if let campValueMap = dataSoure.campValueMap {
            if campValueMap.blue.pkValue == campValueMap.red.pkValue {
                dataSoure.result = .dogfall
            } else if campValueMap.blue.pkValue > campValueMap.red.pkValue {
                dataSoure.result = .blue
            } else {
                dataSoure.result = .red
            }
        }
    }
}
struct RoomPKModel: SmartCodable {
    var currentTime: Double?
    var startTime: Double?
    var endTime: Double?
    var status:RMPKStatusEnum = .normal
    var pkTime: Int?
    var roundId: String?
    var campValueMap: campValueMapModel?
    var result:RMPKResult?
}
struct campValueMapModel: SmartCodable {
    var red: campValueModel = campValueModel()
    var blue: campValueModel = campValueModel()
}
struct campValueModel: SmartCodable {
    var pkValue: Int = 0
    var topAvatarList: [UsInfoItem] = []
}
