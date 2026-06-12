import UIKit
import AttributedString
class GiftWallViewController: LMBaseVC {
    var dataSoure: UsInfoItem = UsInfoItem()
    lazy var headerView: GiftWallHeaderView = {
        let view = GiftWallHeaderView()
        return view
    }()
    let segmentedView = JXSegmentedView()
    private lazy var segData: JXSegmentedTitleDataSource = {
        var titles = [String]()
        titles = ["礼物图鉴", "典藏图鉴"]
        let segData = LMLocalizedSegmentedTitleDataSource()
        segData.titles = titles
        segData.titleNormalFont = lmFontM(16)
        segData.titleNormalColor = lmColorHex("#FFFFFF", alpha: 0.4)
        segData.titleSelectedColor = lmColorHex("#FFFFFF")
        segData.isItemSpacingAverageEnabled = false
        segData.itemSpacing = 20.0
        return segData
    }()
    private lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    required init(model: UsInfoItem) {
        self.dataSoure = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setDataSoure()
    }
    private func setViewSnp() {
        backgroundImage = UIImage(named: "gw_bg")
        let btn = UIButton(image: UIImage(named: "cm_back_white"), target: self, action: #selector(backItemDidiClick))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        view.addSubview(headerView)
        view.addSubview(segmentedView)
        view.addSubview(listContainerView)
        self.segmentedView.contentEdgeInsetLeft = 16.0
        self.segmentedView.dataSource = segData
        self.segmentedView.listContainer = listContainerView
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 12.0
        indicator.indicatorHeight = 4.0
        indicator.indicatorColor = .white
        indicator.verticalOffset = 12.0
        segmentedView.indicators = [indicator]
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight)
            make.height.equalTo(kScaleWidth(130))
        }
        segmentedView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalTo(headerView.snp.bottom)
            make.width.equalTo(250.0)
            make.height.equalTo(56.0)
        }
        listContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.segmentedView.snp.bottom).offset(0)
            make.bottom.equalToSuperview().offset(-(kTabBarSafeHeight))
        }
        headerView.setDataSoure(model: dataSoure)
    }
    func setDataSoure() {
    }
    @objc func backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension GiftWallViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return 2
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            let view = GiftWallPageView(userId: dataSoure.userId)
            return view
        }
        return GiftWallPageSecView(userId: dataSoure.userId)
    }
}
extension GiftWallViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        self.view
    }
}
