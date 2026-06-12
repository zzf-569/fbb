import Foundation
struct VoiceCrossPkItem: SmartCodable {
    var scene: Int = 0
    var createTime: String = ""
    var pkValue: Int = 0
    var targetValue: Int = 0
    var crossmmfo: String = ""
    var corsmfdf: String = ""
    var crovvojjf: String = ""
    var result: pkResult = .defaultCase
    var roomName: String = ""
}
enum pkResult: String, SmartCaseDefaultable {
    static var defaultCase: pkResult = .draw
    case draw = "draw"
    case victory = "victory"
    case defeat = "defeat"
}
