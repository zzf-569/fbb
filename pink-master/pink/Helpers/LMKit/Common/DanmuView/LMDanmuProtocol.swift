import Foundation
public protocol LMDanmuViewProtocol: NSObjectProtocol {
    var currentTime: TimeInterval { get }
    func dMViewForItem(model: LMDanmuModelProtocol) -> UIView
    func dMViewDidClick(item: UIView, at point: CGPoint)
    func dMViewDataSourceDidEmpty()
}
public protocol LMDanmuModelProtocol {
    var beginTime: TimeInterval { get }
    var liveTime: TimeInterval { get }
}
