import Foundation
public class LMRMWelcomeManager {
    static let shared = LMRMWelcomeManager()
    private init() { }
    private var dataSource: [UsInfoItem] = []
    private var floatingScreenView:LMRMWelcomeView?
    private var playing: Bool = false
    private var superView: UIView?
    func set_SuperView(_ view: UIView?) {
        self.superView = view
        if view == nil {
            if playing {
                removeFloatingView()
            }
            playing = false
            dataSource.removeAll()
        }
    }
    func add(_ model: UsInfoItem) {
        dataSource.append(model)
        if !playing {
            startAnimation()
        }
    }
}
private extension LMRMWelcomeManager {
    func startAnimation() {
        if let model = dataSource.first, let superView = self.superView {
            playing = true
            floatingScreenView = createFloatingScreenView(model, superView: superView)
            floatingScreenView?.showAnimation(superView)
        }
    }
    func createFloatingScreenView(_ model: UsInfoItem, superView: UIView) ->LMRMWelcomeView {
        let floatingScreenView = LMRMWelcomeView(frame: CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: 64.0))
        floatingScreenView.setDataSoure(model)
        floatingScreenView.scrollCompleteblock = { [weak self] in
            guard let self = self else { return }
            removeFloatingView()
            if dataSource.first != nil {
                dataSource.removeFirst()
            }
            playing = false
            startAnimation()
        }
        return floatingScreenView
    }
    func removeFloatingView() {
        if floatingScreenView != nil {
            floatingScreenView?.clear()
            floatingScreenView?.removeFromSuperview()
            floatingScreenView = nil
        }
    }
}
