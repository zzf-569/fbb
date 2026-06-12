import UIKit
import JXPagingView
import JXSegmentedView
class OrderPageViewController: LMBaseVC {
    lazy var pagingView = JXSegmentedListContainerView(dataSource: self)
    lazy var segmentedView = JXSegmentedView()
    let dataSource = LMLocalizedSegmentedTitleDataSource()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        set_Subviews()
    }
    private func set_Subviews() {
        title = "开黑订单"
        backgroundImage = nil
        view.backgroundColor = (lmColorHex("#F5F6FAFF"))
        view.addSubview(segmentedView)
        view.addSubview(pagingView)
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight)
            make.height.equalTo(44)
        }
        pagingView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom)
        }
        dataSource.titles = ["待接单", "未开始", "进行中", "已完成", "已取消"]
        dataSource.titleNormalFont = lmFontR(16)
        dataSource.titleSelectedFont = lmFontM(16)
        dataSource.titleNormalColor = .textSecondColor
        dataSource.titleSelectedColor = .textDefaulColor
        dataSource.isItemSpacingAverageEnabled = true
        segmentedView.dataSource = dataSource
        segmentedView.listContainer = pagingView
        let indicator = JXSegmentedIndicatorImageView()
        indicator.indicatorWidth = 32
        indicator.indicatorHeight = 24
        indicator.image = UIImage(named: "order_Indicator")
        indicator.verticalOffset = 12.0
        segmentedView.indicators = [indicator]
    }
    func setDataSoure() {
    }
}
extension OrderPageViewController: JXSegmentedListContainerViewDataSource, JXSegmentedViewDelegate {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        dataSource.titles.count
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> any JXSegmentedListContainerViewListDelegate {
        let view = PartnerOrderViewController()
        if index == 0 {
            view.status = -1
        } else if index == 1 {
            view.status = 0
        } else if index == 2 {
            view.status = 1
        } else {
            view.status = index
        }
        return view
    }
}
