import UIKit
class LMScrollView: UIScrollView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event)
        let view = super.hitTest(point, with: event)
        if view?.superview?.superview is MineFansCell {
            self.isScrollEnabled = false
        } else {
            self.isScrollEnabled = true
        }
        return view
    }
}
