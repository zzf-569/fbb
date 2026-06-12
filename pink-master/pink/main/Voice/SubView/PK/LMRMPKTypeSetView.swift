import UIKit
extension LMRMPKTypeSetView {
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
class LMRMPKTypeSetView: UIViewController {
    private let roomId: String
    private var viewModel:VoiceVM
    var pkViewModel: LMRMPKViewModel?
    var selectedPKTimeblock: ((Int) -> Void)?
    init(roomId: String, viewModel:VoiceVM, pkViewModel: LMRMPKViewModel?) {
        self.roomId = roomId
        self.viewModel = viewModel
        self.pkViewModel = pkViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
    private lazy var bodyimv: UIImageView = {
        let imv = UIImageView()
           .backgroundColor(lmColorHex("#37355B8F"))
        let effec = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effec)
        imv.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imv.addGestureTap { [weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
            }
        return imv
    }()
    let segmentedView = JXSegmentedView()
    let listsegmentedView = JXSegmentedView()
    private lazy var segData: JXSegmentedTitleDataSource = {
        var titles = ["设置", "记录"]
        let segData = LMLocalizedSegmentedTitleDataSource()
        segData.titles = titles
        segData.titleNormalFont = lmFontASHTB(16)
        segData.titleNormalColor = lmColorHex("#FFFFFF", alpha: 0.4)
        segData.titleSelectedColor = lmColorHex("#FFFFFF")
        segData.isItemSpacingAverageEnabled = false
        segData.itemSpacing = 20.0
        return segData
    }()
    private lazy var lissegData: JXSegmentedTitleDataSource = {
        var titles = ["房内", "跨房"]
        let segData = LMLocalizedSegmentedTitleDataSource()
        segData.titles = titles
        segData.titleNormalFont = lmFontM(12)
        segData.titleNormalColor = lmColorHex("#FFFFFFFF")
        segData.titleSelectedColor = lmColorHex("#2B313D")
        segData.isItemSpacingAverageEnabled = false
        segData.itemSpacing = 0.0
        segData.itemWidth = kScaleWidth(44)
        return segData
    }()
    private lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    let hisView:LMPkHistoryPopView = LMPkHistoryPopView()
}
private extension LMRMPKTypeSetView {
    private func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(bodyimv)
        self.segmentedView.delegate = self
        self.segmentedView.contentEdgeInsetLeft = 16.0
        self.segmentedView.dataSource = segData
        self.segmentedView.listContainer = listContainerView
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 12.0
        indicator.indicatorHeight = 4.0
        indicator.indicatorColor = .white
        indicator.verticalOffset = 12.0
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
        segmentedView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(44)
            make.width.equalTo(250.0)
            make.height.equalTo(56.0)
        }
        listContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.segmentedView.snp.bottom).offset(0)
            make.bottom.equalToSuperview()
        }
        self.listsegmentedView.isHidden = true
        self.listsegmentedView.dataSource = lissegData
        self.listsegmentedView.listContainer = hisView.listContainerView
        self.listsegmentedView.backgroundColor(lmColorHex("#FFFFFF14"))
        self.listsegmentedView.cornerRadius(kScaleWidth(12))
        let listindicator = JXSegmentedIndicatorLineView()
        listindicator.indicatorWidth = kScaleWidth(44)
        listindicator.indicatorHeight = kScaleWidth(24)
        listindicator.indicatorColor = lmColorHex("#FFFFFF")
        listindicator.indicatorPosition = .top
        listsegmentedView.indicators = [listindicator]
        bdView.addSubview(self.listsegmentedView)
        listsegmentedView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(segmentedView.snp.centerY)
            make.size.equalTo(CGSize(width: kScaleWidth(88), height: kScaleWidth(24)))
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
        segmentedView.reloadData()
        listsegmentedView.reloadData()
    }
    @objc func closehbtnAction() {
        self.hide()
    }
}
extension LMRMPKTypeSetView: JXSegmentedListContainerViewDataSource, JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        listsegmentedView.isHidden = index == 0
    }
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = self.segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 1 {
            return hisView
        }
        let view = LMRMPKSetupVC(roomId:roomId, viewModel: viewModel, pkViewModel: pkViewModel)
        view.selectedPKTimeblock = {[weak self] time in
            self?.hide()
            self?.selectedPKTimeblock?(time)
        }
        view.hidden = {[weak self] in
            self?.hide()
        }
        return view
    }
}
