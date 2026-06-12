import UIKit
enum LMRMWaterType: Int {
    case day = 0
    case week = 1
    case month = 2
}
extension LMRMWaterVC {
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
class LMRMWaterVC: UIViewController {
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
    private lazy var bodyimv: UIImageView = {
        let imv = UIImageView()
        let effec = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effec)
        imv.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return imv
    }()
    private lazy var titleV: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(18), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .textAlignment(.center)
            .lmtext("房间流水")
        return lb
    }()
    private lazy var closebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_popclose"), target: self, action: #selector(closehbtnAction))
        return btn
    }()
    private lazy var refreshbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_list_refresh"), target: self, action: #selector(refreshbtnAction))
        return btn
    }()
    let segmentedView = JXSegmentedView()
    private lazy var segData: JXSegmentedTitleDataSource = {
        let titles = dataSource.map { item -> String in
            switch item {
            case .day:
                return "日流水"
            case .week:
                return "周流水"
            case .month:
                return "月流水"
            }
        }
        let segData = LMLocalizedSegmentedTitleDataSource()
        segData.titles = titles
        segData.titleNormalFont = lmFontF(16)
        segData.titleNormalColor = lmColorHex("#FFFFFF", alpha: 0.64)
        segData.titleSelectedFont = lmFontM(16)
        segData.titleSelectedColor = lmColorHex("#FFFFFF")
        segData.isItemSpacingAverageEnabled = false
        segData.itemSpacing = 24.0
        return segData
    }()
    private lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    private let roomId: String
    private let dataSource: [LMRMWaterType] = [.day, .week, .month]
    init(roomId: String) {
        self.roomId = roomId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        self.navigationController?.navigationBar.isHidden = true
    }
}
private extension LMRMWaterVC {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(bodyimv)
        bdView.addSubview(refreshbtn)
        segmentedView.contentEdgeInsetLeft = 16.0
        segmentedView.contentEdgeInsetRight = 16.0
        segmentedView.delegate = self
        segmentedView.dataSource = segData
        segmentedView.listContainer = listContainerView
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 12.0
        indicator.indicatorHeight = 3.0
        indicator.indicatorColor = lmColorHex("#FFFFFF")
        indicator.verticalOffset = 10.0
        segmentedView.indicators = [indicator]
        bdView.addSubview(self.segmentedView)
        bdView.addSubview(self.listContainerView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(0)
            make.height.equalTo(kScreenHeight/3*2)
        }
        bodyimv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        refreshbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20.0)
            make.centerY.equalTo(segmentedView.snp.centerY)
            make.width.height.equalTo(24.0)
        }
        segmentedView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-70.0)
            make.top.equalToSuperview().offset(44.0)
            make.height.equalTo(48.0)
        }
        listContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
        }
        view.layoutIfNeeded()
        bdView.set_Border(radius: 16.0, conrners: [.topLeft, .topRight])
        let lineView = UIView().backgroundColor(lmColorHex("#FFFFFF3D"))
            .cornerRadius(2)
        bdView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(8))
            make.size.equalTo(CGSize(width: 48, height: 4))
        }
    }
    func getViewData() {
    }
    func refreshSubviews() {
    }
    @objc func closehbtnAction() {
        self.hide()
    }
    @objc func refreshbtnAction() {
        if let currentList = listContainerView.validListDict[segmentedView.selectedIndex] as?LMRMWaterListVC {
            currentList.refreshList()
        }
    }
}
extension LMRMWaterVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
    }
}
extension LMRMWaterVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = self.segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return LMRMWaterListVC(roomId:roomId, listType: dataSource[index])
    }
}
