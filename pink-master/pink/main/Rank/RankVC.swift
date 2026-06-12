import UIKit
import AttributedString
extension RankVC {
}
class RankVC: LMBaseVC {
    private lazy var customNavigationView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var backbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "cm_back_white"), target: self, action: #selector(backbtnAction))
        return btn
    }()
    let segmentedView = JXSegmentedView()
    private lazy var segData: JXSegmentedTitleDataSource = {
        let segData = LMLocalizedSegmentedTitleDataSource()
        segData.titles = [RMRANKType.RY.text, RMRANKType.RQ.text]
        segData.titleNormalFont = lmFontR(18)
        segData.titleNormalColor = lmColorHex("#FFFFFFA3")
        segData.titleSelectedColor = lmColorHex("#FFFFFF")
        segData.itemWidth = kScaleWidth(54)
        segData.isItemSpacingAverageEnabled = false
        segData.itemSpacing = kScaleWidth(24)
        return segData
    }()
    private lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    private lazy var rankRulebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rank_Rule"), target: self, action: #selector(rankRulebtnAction))
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        getViewData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}
private extension RankVC {
    func setViewSnp() {
        backgroundImage = UIImage(named: "rank_honor_bg")
        self.segmentedView.contentEdgeInsetLeft = 0.0
        self.segmentedView.delegate = self
        self.segmentedView.dataSource = segData
        self.segmentedView.listContainer = listContainerView
        view.addSubview(customNavigationView)
        customNavigationView.addSubview(backbtn)
        customNavigationView.addSubview(segmentedView)
        customNavigationView.addSubview(rankRulebtn)
        view.addSubview(self.listContainerView)
        customNavigationView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight)
            make.height.equalTo(kNavigationBarHeight)
        }
        backbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40.0)
        }
        self.segmentedView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(kScaleWidth(34))
            make.width.equalTo(kScaleWidth(54 + 54 + 24 + 30))
        }
        self.listContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.customNavigationView.snp.bottom).offset(0)
            make.bottom.equalToSuperview()
        }
        self.rankRulebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(self.segmentedView)
            make.width.equalTo(28.0)
            make.height.equalTo(28.0)
        }
        self.view.layoutIfNeeded()
    }
    func getViewData() {
    }
    func refreshSubviews() {
    }
    @objc func backbtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func rankRulebtnAction() {
        let content: ASAttributedString = """
        \("榜单规则：", .font(lmFontM(14)), .foreground(lmColorHex("#2B313D")))
        \("荣誉榜：按照用户在房间内送出礼物的钻石高低进行排名。 人气榜：按照主播在房间内收到礼物的星光高低进行排名。", .font(lmFontF(14)), .foreground(lmColorHex("#2B313DA3")))
        \("数据更新时间：", .font(lmFontM(14)), .foreground(lmColorHex("#2B313D")))
        \("日榜数据每日00:00:00更新；周榜数据每周一00:00:00更新；月榜数据每月1号00:00:00更新；更新后，之前榜单数据清零，开始新一轮统计。", .font(lmFontF(14)), .foreground(lmColorHex("#2B313DA3")))
        """
        let alert = LMAlertBottomVC(title: "榜单规则说明", messageAttributedString: content, cancel: nil, confirm: nil) { _ in
        }
        alert.show(self)
    }
}
extension RankVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        backgroundImage = index == 0 ? UIImage(named: "rank_honor_bg") : UIImage(named: "rank_popularity_bg")
    }
}
extension RankVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = self.segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return RankTimeVC(rankType: index == 0 ? .RY : .RQ)
    }
}
