import UIKit
class WalletViewController: LMBaseVC {
    var dataSoure: WalletItem = WalletItem() {
        didSet {
            headView.setDataSoure(model: dataSoure)
        }
    }
    lazy var topView: UIView = {
        let view = UIView()
            .backgroundColor(.white)
        view.addSubview(headView)
        view.addSubview(centerView)
        return view
    }()
    lazy var headView: WalletHeaderView = {
        let view = WalletHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScaleWidth(168)))
        return view
    }()
    lazy var tipslb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#2B313D"))
            .lmtext("交易记录")
        return lb
    }()
    lazy var centerView: UIView = {
        let view = UIView().backgroundColor(.white).frame(CGRect(x: 0, y: kScaleWidth(168), width: kScreenWidth, height: kScaleWidth(56)))
        return view
    }()
    lazy var pagingView = JXPagingView(delegate: self)
    lazy var segmentedView = JXSegmentedView()
    let dataSource = LMLocalizedSegmentedTitleDataSource()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setDataSoure()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
    private func setViewSnp() {
        title = "我的钱包"
        backgroundImage = UIImage(named: "me_walletBg")
        view.backgroundColor = lmColorHex("#FFFFFF")
        view.addSubview(pagingView)
        centerView.addSubview(tipslb)
        centerView.addSubview(segmentedView)
        tipslb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.centerY.equalTo(segmentedView.snp.centerY)
            make.height.equalTo(kScaleWidth(24))
        }
        segmentedView.backgroundColor(lmColorHex("#2B313D0F"))
        segmentedView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(20))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(100), height: kScaleWidth(24)))
        }
        segmentedView.cornerRadius(kScaleWidth(12))
        pagingView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight)
        }
        dataSource.titles = ["钻石", "贝壳"]
        dataSource.titleNormalFont = lmFontR(12)
        dataSource.titleSelectedFont = lmFontM(12)
        dataSource.titleNormalColor = lmColorHex("#2B313DAD")
        dataSource.titleSelectedColor = lmColorHex("#2B313D")
        dataSource.itemSpacing = kScaleWidth(0)
        dataSource.itemWidth = kScaleWidth(48)
        dataSource.isItemSpacingAverageEnabled = false
        segmentedView.dataSource = dataSource
        pagingView.mainTableView.backgroundColor(.white)
        segmentedView.listContainer = pagingView.listContainerView as? any JXSegmentedViewListContainer
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = kScaleWidth(48)
        indicator.indicatorHeight = kScaleWidth(24)
        indicator.indicatorColor = .white
        indicator.indicatorPosition = .top
        segmentedView.indicators = [indicator]
        pagingView.reloadData()
    }
    func setDataSoure() {
        WalletNetWork.getAccount().lmrequest {[weak self] responseModel in
            guard let model = WalletItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self?.dataSoure = model
        } failureBlock: { _ in
        }
    }
}
extension WalletViewController: JXSegmentedViewDelegate, JXPagingViewDelegate {
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        0
    }
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        UIView()
    }
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        topView
    }
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        Int(kScaleWidth(56 + 168))
    }
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        dataSource.titles.count
    }
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        WalletRecordPageViewController(type: index)
    }
}
