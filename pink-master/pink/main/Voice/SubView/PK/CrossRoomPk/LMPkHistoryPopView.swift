import UIKit
extension LMPkHistoryPopView {
    func show(_ vc: UIViewController? = nil) {
        if let viewController = vc {
            viewController.addChild(self)
            viewController.view.addSubview(self.view)
        } else {
            UIViewController.current?.addChild(self)
            UIViewController.current?.view.addSubview(self.view)
        }
        self.view.frame = UIScreen.main.bounds
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.clear()
        }
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
class LMPkHistoryPopView: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setViewSnp()
    }
    private lazy var bgView: UIView = {
        let view = UIView()
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var bdView: UIView = {
        let view = UIView()
        return view
    }()
    let segmentedView = JXSegmentedView()
    private lazy var segData: JXSegmentedTitleDataSource = {
        var titles = ["房内PK", "跨房PK"]
        let segData = LMLocalizedSegmentedTitleDataSource()
        segData.titles = titles
        segData.titleNormalFont = lmFontF(18)
        segData.titleNormalColor = lmColorHex("#FFFFFF", alpha: 0.64)
        segData.titleSelectedFont = lmFontM(18)
        segData.titleSelectedColor = lmColorHex("#FFFFFFF5")
        segData.isItemSpacingAverageEnabled = false
        segData.itemSpacing = 8.0
        return segData
    }()
    lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    func scrollToindex(_ index: Int) {
        listContainerView.didClickSelectedItem(at: index)
    }
}
private extension LMPkHistoryPopView {
    private func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(listContainerView)
        segmentedView.contentEdgeInsetLeft = 16.0
        segmentedView.contentEdgeInsetRight = 16.0
        segmentedView.dataSource = segData
        segmentedView.listContainer = listContainerView
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 12.0
        indicator.indicatorHeight = 3.0
        indicator.indicatorColor = lmColorHex("#FFFFFFF5")
        indicator.verticalOffset = 10.0
        segmentedView.indicators = [indicator]
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        listContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(0.0)
            make.bottom.equalToSuperview()
        }
        view.layoutIfNeeded()
    }
    @objc func closehbtnAction() {
        self.hide()
    }
}
extension LMPkHistoryPopView: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return 2
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            return LMPkHistoryView()
        }
        return LMRMPkHistoryView()
    }
}
extension LMPkHistoryPopView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        self.view
    }
}
