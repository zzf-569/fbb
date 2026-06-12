import UIKit
extension RankTimeVC {
}
class RankTimeVC: LMBaseVC {
    private let rankType: RMRANKType
    let segmentedView = JXSegmentedView()
    private lazy var segData: JXSegmentedTitleDataSource = {
        let segData = LMLocalizedSegmentedTitleDataSource()
        segData.titles = [RMRTimeType.daily.text, RMRTimeType.weekly.text, RMRTimeType.month.text]
        segData.titleNormalFont = lmFontM(14)
        segData.titleNormalColor = lmColorHex("#FFFFFFFF")
        segData.titleSelectedColor = lmColorHex("#A56CFFFF")
        segData.itemWidth = kScaleWidth(52)
        segData.itemSpacing = 0
        segData.isItemSpacingAverageEnabled = true
        return segData
    }()
    private lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    private lazy var refreshbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "he_rank_refresh"))
        btn.isHidden = true
        btn.addGestureTap { [weak self] _ in
            guard let self = self else {return}
            if let list = self.listContainerView.validListDict[self.segmentedView.selectedIndex] as? RankListVC {
                list.headerRefreshData()
            }
        }
        return btn
    }()
    init(rankType: RMRANKType) {
        self.rankType = rankType
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .clear
        setViewSnp()
        getViewData()
    }
}
private extension RankTimeVC {
    func setViewSnp() {
        if self.rankType == .RY {
            segData.titleSelectedColor = lmColorHex("#A56CFFFF")
        } else {
            segData.titleSelectedColor = lmColorHex("#63B6FF")
        }
        self.segmentedView.delegate = self
        self.segmentedView.contentEdgeInsetLeft = 0.0
        self.segmentedView.dataSource = segData
        self.segmentedView.listContainer = listContainerView
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = kScaleWidth(52)
        indicator.indicatorHeight = kScaleWidth(28)
        indicator.indicatorColor = lmColorHex("#FFFFFF")
        indicator.indicatorPosition = .top
        segmentedView.indicators = [indicator]
        view.addSubview(self.segmentedView)
        view.addSubview(self.listContainerView)
        view.addSubview(self.refreshbtn)
        self.segmentedView.backgroundColor(lmColorHex("#FFFFFF40"))
        self.segmentedView.cornerRadius(kScaleWidth(14))
        self.segmentedView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(28))
            make.width.equalTo(kScaleWidth(160))
        }
        self.listContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.segmentedView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        self.refreshbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalTo(self.segmentedView)
            make.width.height.equalTo(32.0)
        }
    }
    func getViewData() {
    }
    func refreshSubviews() {
    }
}
extension RankTimeVC: JXSegmentedViewDelegate {
}
extension RankTimeVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = self.segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        var timeType = RMRTimeType.daily
        switch index {
        case 0:
            timeType = .daily
        case 1:
            timeType = .weekly
        case 2:
            timeType = .month
        default:
            timeType = .daily
        }
        return RankListVC(rankType: self.rankType, timeType: timeType)
    }
}
extension RankTimeVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        self.view
    }
}
