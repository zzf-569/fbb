import UIKit
class LMHearVC: UIViewController, JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    var roomList: [RoomItem] = []
    lazy var pagingView = JXSegmentedListContainerView(dataSource: self)
    lazy var segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 48))
    let dataSource = LMLocalizedSegmentedTitleDataSource()
    private var typeList: [HomeTypeItem] = []
    lazy var headerView: LMHearHeaderView = {
        let view = LMHearHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: kScaleWidth(241) +  kNavigationBarHeight))
        view.Callbackblock = {index in
            switch index {
            case 0:
                if let user = UserShared.user {
                    self.navigationController?.pushViewController(GiftWallViewController(model: user), animated: true)
                }
            case 1:
                self.navigationController?.pushViewController(RankVC(), animated: true)
            case 2:
                if self.roomList.count > 0 {
                    var inde = index - 2
                    inde = inde < 0 ? 0 : inde
                    if inde > self.roomList.count - 1{
                        return
                    }
                    RouteService.pushRoom(self.roomList[inde].roomId)
                }
            case 3:
                if self.roomList.count > 0 {
                    var inde = index - 2
                    inde = inde < 0 ? 0 : inde
                    if inde > self.roomList.count - 1{
                        return
                    }
                    RouteService.pushRoom(self.roomList[inde].roomId)
                }
            case 4:
                if self.roomList.count > 0 {
                    var inde = index - 2
                    inde = inde < 0 ? 0 : inde
                    if inde > self.roomList.count - 1{
                        return
                    }
                    RouteService.pushRoom(self.roomList[inde].roomId)
                }
            case 5:
                if self.roomList.count > 0 {
                    var inde = index - 2
                    inde = inde < 0 ? 0 : inde
                    if inde > self.roomList.count - 1{
                        return
                    }
                    RouteService.pushRoom(self.roomList[inde].roomId)
                }
            default:
                break
            }
        }
        return view
    }()
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
        let bgImage = UIImageView(image: UIImage(named: "hear_bg"))
        bgImage.frame = self.view.bounds
        view.addSubview(bgImage)
        view.addSubview(headerView)
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
        pagingView.backgroundColor(.clear)
        pagingView.listCellBackgroundColor = .clear
        segmentedView.listContainer = pagingView
        view.addSubview(pagingView)
        view.addSubview(segmentedView)
        segmentedView.frame = CGRect(x: 0, y: kScaleWidth(241) +  kNavigationBarHeight, width: self.view.width, height: kScaleWidth(56))
        pagingView.frame = CGRect(x: 0, y: kScaleWidth(241 + 56) +  kNavigationBarHeight, width: self.view.width, height: self.view.height - kScaleWidth(241 + 56) - kTabBarSafeHeight - kTabBarHeight - kNavigationBarHeight)
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
        if index == 0 {
            view.viewModel.type = 0
        } else {
            view.viewModel.type = self.typeList[index - 1].tagId
        }
        return view
    }
}
