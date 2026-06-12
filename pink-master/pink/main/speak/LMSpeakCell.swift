import UIKit
import DanmakuKit
class LMSpeakCell: DanmakuCell {
    required init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor =  lmColorHex("#FF7CC0")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func displaying(_ context: CGContext, _ size: CGSize, _ isCancelled: Bool) {
        guard let model = model as? LMSpeakItem else { return }
        let text = NSString(string: model.text)
        var image = UIImage(named: "sp_\(Int.random(in: 1 ..< 13))")
        image?.draw(at: CGPointMake(10, 4))
        let attributes: [NSAttributedString.Key: Any] = [.font: model.font, .foregroundColor: UIColor.white]
        text.draw(at: CGPointMake(40, 4), withAttributes: attributes)
    }
}
