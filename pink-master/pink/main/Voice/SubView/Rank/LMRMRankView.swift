import UIKit
class LMRMRankView: UIView {
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
    lazy var daybtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(12), titleColor: .white)
            .titleColor(lmColorHex("#2B313D"), .selected)
            .backgroundColor(.white)
            .cornerRadius(10)
            .lmtitle("日")
            .isSelected(true)
            .add(self, action: #selector(dayAction))
        return btn
    }()
    lazy var weekbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(12), titleColor: .white)
            .titleColor(lmColorHex("#2B313D"), .selected)
            .backgroundColor(.clear)
            .cornerRadius(10)
            .lmtitle("周")
            .add(self, action: #selector(weekAction))
        return btn
    }()
    lazy var mouthbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(12), titleColor: .white)
            .titleColor(lmColorHex("#2B313D"), .selected)
            .backgroundColor(.clear)
            .cornerRadius(10)
            .lmtitle("月")
            .add(self, action: #selector(mouthAction))
        return btn
    }()
    let segmentedView = JXSegmentedView()
    private lazy var segData: JXSegmentedTitleDataSource = {
        let segData = LMLocalizedSegmentedTitleDataSource()
        segData.titles = [RMRANKType.RY.text,RMRANKType.RQ.text]
        segData.titleNormalFont = lmFontM(16)
        segData.titleNormalColor = lmColorHex("#FFFFFFA3")
        segData.titleSelectedColor = lmColorHex("#FFFFFF")
        segData.isItemSpacingAverageEnabled = false
        segData.itemSpacing = 24.0
        return segData
    }()
    private lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    lazy var timeView: UIView = {
        let view = UIView()
            .backgroundColor(lmColorHex("#FFFFFF14"))
            .cornerRadius(12)
        return view
    }()
    var timeType = RMRTimeType.daily
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func reConfigUI() {
        for list in self.listContainerView.validListDict.values {
            if let listView = list as?LMRMRankTimeListView {
                listView.reConfigUI()
            }
        }
    }
    func refreshList() {
        for list in self.listContainerView.validListDict.values {
            if let listView = list as?LMRMRankTimeListView {
                listView.refreshList()
            }
        }
    }
    func show() {
        UIView.animate(withDuration: 0.3) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
private extension LMRMRankView {
    func setViewSnp() {
        addSubview(bgView)
        addSubview(bdView)
        bdView.addSubview(bodyimv)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.snp.bottom).offset(0)
            make.height.equalTo(kScaleWidth(640))
        }
        bodyimv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.segmentedView.contentEdgeInsetLeft = 16.0
        self.segmentedView.delegate = self
        self.segmentedView.dataSource = segData
        self.segmentedView.listContainer = listContainerView
        bdView.addSubview(self.segmentedView)
        bdView.addSubview(self.listContainerView)
        self.segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(44.0)
        }
        self.listContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.segmentedView.snp.bottom).offset(0)
            make.bottom.equalToSuperview()
        }
        bdView.addSubview(self.timeView)
        timeView.addSubview(self.daybtn)
        timeView.addSubview(self.weekbtn)
        timeView.addSubview(self.mouthbtn)
        timeView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(44)
            make.size.equalTo(CGSize(width: 100, height: 24))
        }
        daybtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(2)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32, height: 20))
        }
        weekbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-2)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32, height: 20))
        }
        mouthbtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32, height: 20))
        }
        layoutIfNeeded()
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
    @objc func dayAction() {
        daybtn.isSelected(true)
        weekbtn.isSelected(false)
        mouthbtn.isSelected(false)
        daybtn.backgroundColor(.white)
        weekbtn.backgroundColor(.clear)
        mouthbtn.backgroundColor(.clear)
        timeType = .daily
        segmentedView.reloadData()
    }
    @objc func weekAction() {
        daybtn.isSelected(false)
        weekbtn.isSelected(true)
        mouthbtn.isSelected(false)
        daybtn.backgroundColor(.clear)
        weekbtn.backgroundColor(.white)
        mouthbtn.backgroundColor(.clear)
        timeType = .weekly
        segmentedView.reloadData()
    }
    @objc func mouthAction() {
        daybtn.isSelected(false)
        weekbtn.isSelected(false)
        mouthbtn.isSelected(true)
        daybtn.backgroundColor(.clear)
        weekbtn.backgroundColor(.clear)
        mouthbtn.backgroundColor(.white)
        timeType = .month
        segmentedView.reloadData()
    }
}
extension LMRMRankView: JXSegmentedViewDelegate {
}
extension LMRMRankView: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = self.segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return LMRMRankListView(rankType: index == 0 ? .RY : .RQ, timeType: timeType, frame: CGRect.zero)
    }
}
