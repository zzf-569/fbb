import Foundation
struct PageItem: SmartCodable {
    var pages: Int = 0
    var total: Int = 0
    var size: Int = 0
    var current: Int = 0
    @SmartAny
    var records: [Any]?
}
