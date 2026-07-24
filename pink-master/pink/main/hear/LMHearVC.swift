import UIKit
class LMHearVC: UIViewController, JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    var roomList: [RoomItem] = []
    lazy var pagingView = JXSegmentedListContainerView(dataSource: self)
    lazy var segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 48))
    let dataSource = JXSegmentedTitleImageDataSource()
    private var typeList: [HomeTypeItem] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        getHot()
        CommonNetWork.typeList().lmrequest {[weak self] responseModel in
            guard let self = self, let list = [HomeTypeItem].deserialize(from: responseModel.data as? [Any]) else { return }
            self.typeList = list
            self.dataSource.titles.append("热门")
            self.dataSource.titles.append(contentsOf: self.typeList.map { $0.tagName })
            self.segmentedView.reloadData()
        } failureBlock: { _ in
        }
    }
    func setViewSnp() {
       
        dataSource.titleNormalFont = lmFontR(16)
        dataSource.titleSelectedFont = lmFontM(16)
        dataSource.titleNormalColor = .textDefaulColor
        dataSource.titleSelectedColor = .textDefaulColor
        dataSource.itemSpacing = kScaleWidth(18)
        dataSource.isItemSpacingAverageEnabled = false
        segmentedView.backgroundColor(.clear)
        segmentedView.dataSource = dataSource
        segmentedView.delegate = self
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 12
        indicator.indicatorHeight = 3
        indicator.indicatorColor = lmColorHex("#FF4F7DFF")
        indicator.verticalOffset = 10.0
        segmentedView.indicators = [indicator]
        pagingView.backgroundColor(lmColorHex("#F5F6FA"))
        segmentedView.listContainer = pagingView
        view.addSubview(pagingView)
        view.addSubview(segmentedView)
        segmentedView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: kScaleWidth(56))
        pagingView.frame = CGRect(x: 0, y: kScaleWidth(56), width: self.view.width, height: self.view.height - kScaleWidth(56))
    }
    func getHot() {
        set_NetWork.roomTopList(page: 1, size: AppConfig.pageSize).lmrequest { responseModel in
            guard let list = [RoomItem].deserialize(from: responseModel.data as? [Any]) else { return }
            self.roomList = list
        } failureBlock: { _ in
        }
    }
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        dataSource.titles.count
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> any JXSegmentedListContainerViewListDelegate {
        let view = LMHearPageVC()
        
        return view
    }
}

extension LMHearVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
