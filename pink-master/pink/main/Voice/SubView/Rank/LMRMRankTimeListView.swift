import UIKit
class LMRMRankTimeListView: UIView {
    private let rankType:RMRANKType
    let segmentedView = JXSegmentedView()
    private lazy var segData: JXSegmentedTitleDataSource = {
        let segData = LMLocalizedSegmentedTitleDataSource()
        segData.titles = [RMRTimeType.daily.text,RMRTimeType.weekly.text,RMRTimeType.month.text]
        segData.titleNormalFont = lmFontF(14)
        segData.titleNormalColor = lmColorHex("#FFFFFF")
        segData.titleSelectedColor = lmColorHex("#00DBA8")
        segData.itemSpacing = 0.0
        segData.itemWidth = 56.0
        segData.isTitleMaskEnabled = true
        return segData
    }()
    private lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    private lazy var refreshbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_rank_refresh"))
        btn.addGestureTap { [weak self] _ in
            guard let self = self else {return}
            if let list = self.listContainerView.validListDict[self.segmentedView.selectedIndex] as?LMRMRankListView {
                list.refreshList()
            }
        }
        return btn
    }()
    init(rankType:RMRANKType, frame: CGRect) {
        self.rankType = rankType
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LMRMRankTimeListView {
    func reConfigUI() {
        for list in self.listContainerView.validListDict.values {
            if let listView = list as?LMRMRankListView {
                listView.reConfigUI()
            }
        }
    }
    func refreshList() {
        for list in self.listContainerView.validListDict.values {
            if let listView = list as?LMRMRankListView {
                listView.refreshList()
            }
        }
    }
}
private extension LMRMRankTimeListView {
    private func setViewSnp() {
        self.segmentedView.delegate = self
        self.segmentedView.dataSource = segData
        self.segmentedView.listContainer = listContainerView
        self.segmentedView.layer.masksToBounds = true
        self.segmentedView.layer.cornerRadius = 32.0/2
        self.segmentedView.layer.borderColor = UIColor.clear.cgColor
        self.segmentedView.layer.borderWidth = 0.5
        self.segmentedView.backgroundColor = lmColorHex("#FFFFFF", alpha: 0.1)
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 28.0
        indicator.indicatorWidthIncrement = 0
        indicator.indicatorColor = UIColor.white
        self.segmentedView.indicators = [indicator]
        self.listContainerView.scrollView.isScrollEnabled = false
        self.addSubview(self.segmentedView)
        self.addSubview(self.listContainerView)
        self.addSubview(self.refreshbtn)
        self.segmentedView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalToSuperview().offset(12.0)
            make.height.equalTo(32.0)
            make.width.equalTo(56.0 * 3)
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
}
extension LMRMRankTimeListView: JXSegmentedViewDelegate {
}
extension LMRMRankTimeListView: JXSegmentedListContainerViewDataSource {
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
        return LMRMRankListView(rankType: self.rankType, timeType: timeType, frame: CGRect.zero)
    }
}
extension LMRMRankTimeListView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        self
    }
}
