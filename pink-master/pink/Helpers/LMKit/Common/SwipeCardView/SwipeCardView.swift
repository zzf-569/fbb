import UIKit
protocol SwipeCardViewDelegate: NSObjectProtocol {
    func swipeCard(swipeCardView view: SwipeCardView) -> Int
    func swipeCard(swipeCardView view: SwipeCardView, forItemAt index: Int) -> SwipeCardItemViewDelegate
    func swipeCard(swipeCardView view: SwipeCardView, itemSize index: Int) -> CGSize
    func swipeCard(swipeCardView view: SwipeCardView, willShowItemForIndex index: Int, item: SwipeCardItemViewDelegate)
    func swipeCard(swipeCardView view: SwipeCardView, didCurrentItem index: Int)
    func swipeCard(swipeCardView view: SwipeCardView, willHideItemForIndex index: Int, item: SwipeCardItemViewDelegate)
}
protocol SwipeCardItemViewDelegate: UIView {
    func setDataSoure(_ model: Any?)
}
extension SwipeCardView {
    func reloadView() {
        if let currentItemView = currentItemView {
            delegate?.swipeCard(swipeCardView: self, willHideItemForIndex: currentIndex, item: currentItemView)
        }
        currentItemView?.removeFromSuperview()
        currentItemView = nil
        nextItemView?.removeFromSuperview()
        nextItemView = nil
        currentIndex = 0
        totalNum = self.delegate?.swipeCard(swipeCardView: self) ?? 0
        let itemSize = self.delegate?.swipeCard(swipeCardView: self, itemSize: 0) ?? CGSize(width: 100, height: 100)
        if totalNum > 1 {
            nextItemView = self.delegate?.swipeCard(swipeCardView: self, forItemAt: 1)
            nextItemView!.frame = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
            addSubview(nextItemView!)
        }
        if totalNum > 0 {
            currentItemView = self.delegate?.swipeCard(swipeCardView: self, forItemAt: 0)
            currentItemView!.frame = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
            addSubview(currentItemView!)
            self.delegate?.swipeCard(swipeCardView: self, willShowItemForIndex: currentIndex, item: currentItemView!)
            self.delegate?.swipeCard(swipeCardView: self, didCurrentItem: self.currentIndex)
        }
    }
    func nextAction() {
        isAnimation = true
        guard let currentItemView = self.currentItemView else { isAnimation = false; return }
        guard let nextItemView = self.nextItemView else {
            delegate?.swipeCard(swipeCardView: self, willHideItemForIndex: currentIndex, item: currentItemView)
            UIView.animate(withDuration: 0.3) {
                currentItemView.frame = CGRect(x: 0, y: -currentItemView.height, width: currentItemView.width, height: currentItemView.height)
                currentItemView.alpha = 0
            } completion: { _ in
                self.currentItemView?.removeFromSuperview()
                self.currentItemView = nil
                self.isAnimation = false
            }
            return
        }
        delegate?.swipeCard(swipeCardView: self, willHideItemForIndex: currentIndex, item: currentItemView)
        UIView.animate(withDuration: 0.3) {
            currentItemView.frame = CGRect(x: 0, y: -currentItemView.height, width: currentItemView.width, height: currentItemView.height)
            currentItemView.alpha = 0
        }
        currentIndex += 1
        delegate?.swipeCard(swipeCardView: self, willShowItemForIndex: currentIndex, item: nextItemView)
        nextItemView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            nextItemView.transform = .identity
        } completion: { _ in
            self.currentItemView = nextItemView
            currentItemView.removeFromSuperview()
            self.nextItemView = nil
            let nextIndex = self.currentIndex + 1
            if self.totalNum > nextIndex {
                let itemSize = self.delegate?.swipeCard(swipeCardView: self, itemSize: 0) ?? CGSize(width: 100, height: 100)
                self.nextItemView = self.delegate?.swipeCard(swipeCardView: self, forItemAt: nextIndex)
                self.nextItemView!.frame = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
                self.insertSubview(self.nextItemView!, belowSubview: self.currentItemView!)
            }
            self.delegate?.swipeCard(swipeCardView: self, didCurrentItem: self.currentIndex)
            self.isAnimation = false
        }
    }
    func viewWillAppear() {
        if let currentItemView = currentItemView {
            self.delegate?.swipeCard(swipeCardView: self, willShowItemForIndex: currentIndex, item: currentItemView)
        }
    }
    func viewWillDisappear() {
        if let currentItemView = currentItemView {
            delegate?.swipeCard(swipeCardView: self, willHideItemForIndex: currentIndex, item: currentItemView)
        }
    }
}
class SwipeCardView: UIView {
    weak var delegate: SwipeCardViewDelegate?
    private var currentItemView: SwipeCardItemViewDelegate?
    private var nextItemView: SwipeCardItemViewDelegate?
    private var currentIndex: Int = 0
    private var totalNum: Int = 0
    private var isAnimation: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isAnimation {
            if let currentItemView = self.currentItemView {
                let itemSize = self.delegate?.swipeCard(swipeCardView: self, itemSize: currentIndex) ?? CGSize(width: 100, height: 100)
                currentItemView.frame = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
            }
            if let nextItemView = self.nextItemView {
                let itemSize = self.delegate?.swipeCard(swipeCardView: self, itemSize: currentIndex + 1) ?? CGSize(width: 100, height: 100)
                nextItemView.frame = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
            }
        }
    }
}
private extension SwipeCardView {
}
