import UIKit
class PackageViewController: LMBaseVC {
    var typeList: [ShopTypeModel] = [] {
        didSet {
            for model in typeList {
                dataSource.titles.append(model.typeName)
            }
            segmentedView.reloadData()
        }
    }
    lazy var pagingView = JXSegmentedListContainerView(dataSource: self)
    lazy var segmentedView = JXSegmentedView()
    let dataSource = LMLocalizedSegmentedTitleDataSource()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setDataSoure()
        lmrequestData()
    }
    private func setViewSnp() {
        title = "我的装扮"
        backgroundImage = nil
        view.backgroundColor = .white
        let backbtn = UIButton(image: UIImage(named: "cm_back"), target: self, action: #selector(backItemDidiClick))
        backbtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: backbtn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        let hisbtn = UIButton(lmfont: lmFontM(18), titleColor: .textDefaulColor)
        hisbtn.addTarget(self, action: #selector(turntoHistory), for: .touchUpInside)
        hisbtn.image(UIImage(named: "shophistory"))
        hisbtn.frame = CGRect(x: 0, y: 0, width: kScaleWidth(58), height: kScaleWidth(26)) 
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: hisbtn)]
        let topview = UIView(frame: CGRect(x: 0, y: kNavigationHeight, width: kScreenWidth, height: kScaleWidth(56)))
            .backgroundColor(.white)
        topview.addGradientLayer(colors: [lmColorHex("#F5F5F5").cgColor, lmColorHex("#FFFFFF", alpha: 0).cgColor], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1), locations: [0, 1])
        view.addSubview(topview)
        segmentedView.backgroundColor(.clear)
        view.addSubview(segmentedView)
        view.addSubview(pagingView)
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight)
            make.height.equalTo(kScaleWidth(44))
        }
        pagingView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom)
        }
    }
    func setDataSoure() {
        dataSource.titleNormalFont = lmFontR(16)
        dataSource.titleSelectedFont = lmFontASHTB(16)
        dataSource.titleNormalColor = .textSecondColor
        dataSource.titleSelectedColor = .textDefaulColor
        dataSource.itemSpacing = 20
        dataSource.isItemSpacingAverageEnabled = false
        pagingView.backgroundColor(.clear)
        segmentedView.dataSource = dataSource
        segmentedView.listContainer = pagingView
        segmentedView.backgroundColor(.clear)
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 12
        indicator.indicatorHeight = 4
        indicator.indicatorColor = lmColorHex("#FF4F7DFF")
        indicator.verticalOffset = 4.0
        segmentedView.indicators = [indicator]
        segmentedView.reloadData()
    }
    func lmrequestData() {
        ShopNetWork.getDressTypeList().lmrequest {[weak self] responseModel in
            guard let list = [ShopTypeModel].deserialize(from: responseModel.data as? [Any]) else {
                return
            }
            self?.typeList = list
        } failureBlock: { _ in
        }
    }
    @objc func turntoshop() {
        self.navigationController?.pushViewController(LMShopVC(), animated: true)
    }
    @objc func turntoHistory() {
        self.navigationController?.pushViewController(LMBageRecordVC(), animated: true)
    }
    @objc func backItemDidiClick() {
        guard let viewControllers = self.navigationController?.viewControllers, viewControllers.count > 3 else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        for (index, view) in viewControllers.enumerated() {
            if index == 2 {
                self.navigationController?.popToViewController(view, animated: true)
            }
        }
    }
}
extension PackageViewController: JXSegmentedListContainerViewDataSource, JXSegmentedViewDelegate {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        dataSource.titles.count
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> any JXSegmentedListContainerViewListDelegate {
        let view = LMBagePageVC()
        view.type = self.typeList[index].id
        return view
    }
}
