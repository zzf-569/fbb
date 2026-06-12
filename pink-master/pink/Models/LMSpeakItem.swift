import UIKit
import DanmakuKit
class LMSpeakItem: DanmakuCellModel {
    var identifier = ""
    var text = ""
    var font = UIFont.systemFont(ofSize: 15)
    var offsetTime: TimeInterval = 0
    var cellClass: DanmakuCell.Type {
        return LMSpeakCell.self
    }
    var size: CGSize = .zero
    var track: UInt?
    var displayTime: Double = 8
    var type: DanmakuCellType = .floating
    var isPause = false
    func calculateSize() {
        size = CGSize(width: NSString(string: text).boundingRect(with: CGSize(width: CGFloat(Float.infinity
                                                                                            ), height: 20), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: font], context: nil).size.width + 50, height: 28)
    }
    func isEqual(to cellModel: DanmakuCellModel) -> Bool {
        return identifier == cellModel.identifier
    }
}
