import Foundation
public class LMFloatingManager {
    static let shared = LMFloatingManager()
    private init() { }
    private var dataSource: [LMFloatingModel] = []
    private var floatingView:LMFloatingView?
    private var isPlaying: Bool = false
    private var superView: UIView?
    func set_SuperView(_ view: UIView?) {
        self.superView = view
        if view == nil {
            if isPlaying {
                removeFloatingView()
            }
            isPlaying = false
            dataSource.removeAll()
        }
    }
    func add(_ model: LMFloatingModel) {
        dataSource.append(model)
        if !isPlaying {
            startAnimation()
        }
    }
}
private extension LMFloatingManager {
    func startAnimation() {
        if let model = dataSource.first, let superView = self.superView {
            isPlaying = true
            if model.style == .gift {
                floatingView = configFloatingView(model, superView: superView)
                floatingView?.showAnimation(superView)
            }
        }
    }
    func configFloatingView(_ model: LMFloatingModel, superView: UIView) ->LMFloatingView {
        let floatingScreenView = LMFloatingView(frame: CGRect(x: kScreenWidth, y: kNavigationHeight + 40.0, width: kScreenWidth, height: 64.0))
        floatingScreenView.setDataSoure(model)
        floatingScreenView.scrollCompleteblock = { [weak self] in
            guard let self = self else { return }
            removeFloatingView()
            if dataSource.first != nil {
                dataSource.removeFirst()
            }
            isPlaying = false
            startAnimation()
        }
        return floatingScreenView
    }
    func removeFloatingView() {
        if floatingView != nil {
            floatingView?.clear()
            floatingView?.removeFromSuperview()
            floatingView = nil
        }
    }
}
