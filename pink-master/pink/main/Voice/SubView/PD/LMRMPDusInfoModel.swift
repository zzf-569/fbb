import Foundation
struct LMRMPDusInfoModel: SmartCodable, LMDanmuModelProtocol {
    var avatar: String = ""
    var nickname: String = ""
    var bizName: String = "王者荣耀"
    var beginTime: TimeInterval = 0.0
    var liveTime: TimeInterval = 6.0
}
