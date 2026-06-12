import UIKit
extension LMRMRolePopVC {
    @discardableResult
    static func show(roomId: String, role:RMRoleType, dataSource: [RMUserListType]) ->LMRMRolePopVC {
        let pop = LMRMRolePopVC(roomId:roomId, role: role, dataSource: dataSource)
        UIViewController.current?.addChild(pop)
        UIViewController.current?.view.addSubview(pop.view)
        pop.view.frame = UIScreen.main.bounds
        return pop
    }
}
class LMRMRolePopVC: UIViewController {
    private lazy var bgView: UIView = {
        let view = UIView()
            .backgroundColor(lmColorHex("#0000008F"))
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
        return imv
    }()
    let segmentedView = JXSegmentedView()
    private lazy var segData: JXSegmentedTitleDataSource = {
        var titles = [String]()
        for type in self.dataSource {
            if type == .host {
                titles.append("主持人")
            }
            if type == .admin {
                titles.append("房间管理")
            }
            if type == .disableMessage {
                titles.append("禁言名单")
            }
        }
        let segData = LMLocalizedSegmentedTitleDataSource()
        segData.titles = titles
        segData.titleNormalFont = lmFontASHTB(16)
        segData.titleNormalColor = lmColorHex("#FFFFFF", alpha: 0.4)
        segData.titleSelectedColor = lmColorHex("#FFFFFF")
        segData.isItemSpacingAverageEnabled = false
        segData.itemSpacing = 20.0
        return segData
    }()
    private lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    private lazy var endEditingView: UIView = {
        let view = UIView()
        return view
    }()
    var dataSource: [RMUserListType]
    private let roomId: String
    private let role:RMRoleType
    init(roomId: String, role:RMRoleType, dataSource: [RMUserListType]) {
        self.roomId = roomId
        self.role = role
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setViewSnp()
        getViewData()
        show()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        endEditingView.addGestureRecognizer(tapGesture)
    }
}
extension LMRMRolePopVC: UIGestureRecognizerDelegate {
    @objc func endEditing() {
        view.endEditing(false)
    }
}
private extension LMRMRolePopVC {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(bodyimv)
        self.segmentedView.contentEdgeInsetLeft = 16.0
        self.segmentedView.delegate = self
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
        bdView.addSubview(self.endEditingView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(0)
            make.height.equalTo(kScaleWidth(640))
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
        endEditingView.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.height.equalTo(segmentedView)
            make.left.equalTo(segmentedView.snp.right)
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
    func show() {
        UIView.animate(withDuration: 0.3) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
    func hide() {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}
extension LMRMRolePopVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.view.endEditing(true)
    }
}
extension LMRMRolePopVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = self.segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return LMRMRoleListVC(roomId:roomId, role: role, listType: dataSource[index])
    }
}
