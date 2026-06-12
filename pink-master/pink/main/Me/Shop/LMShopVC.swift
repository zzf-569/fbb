import UIKit
class LMShopVC: LMBaseVC {
    var typeList: [ShopTypeModel] = [] {
        didSet {
            for model in typeList {
                dataSource.titles.append(model.typeName)
            }
            segmentedView.reloadData()
        }
    }
    var selecdModel: ShopListItem = ShopListItem()
    lazy var pagingView = JXSegmentedListContainerView(dataSource: self)
    lazy var segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScaleWidth(56)))
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
        view.backgroundColor = .white
        title = "装扮中心"
        let backbtn = UIButton(image: UIImage(named: "cm_back"), target: self, action: #selector(backItemDidiClick))
        backbtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: backbtn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        let btn = UIButton(lmfont: lmFontM(18), titleColor: .textDefaulColor)
        btn.addTarget(self, action: #selector(turnPackage), for: .touchUpInside)
        btn.image(UIImage(named: "shopmyicon"))
        btn.frame = CGRect(x: 0, y: 0, width: kScaleWidth(44), height: kScaleWidth(24)) 
        btn.set_ImageTitleLayout(.imgLeft, spacing: 4)
        let rightBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        let topview = UIView(frame: CGRect(x: 0, y: kNavigationHeight, width: kScreenWidth, height: kScaleWidth(56)))
            .backgroundColor(.white)
        topview.addGradientLayer(colors: [lmColorHex("#F5F5F5").cgColor, lmColorHex("#FFFFFF", alpha: 0).cgColor], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1), locations: [0, 1])
        view.addSubview(topview)
        segmentedView.backgroundColor(.clear)
        view.addSubview(segmentedView)
        view.addSubview(pagingView)
        pagingView.backgroundColor(.clear)
        segmentedView.delegate = self
        segmentedView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavigationHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(kScaleWidth(56))
        }
        pagingView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
        }
        view.layoutIfNeeded()
    }
    func setDataSoure() {
        dataSource.titleNormalFont = lmFontR(16)
        dataSource.titleSelectedFont = lmFontASHTB(16)
        dataSource.titleNormalColor = .textSecondColor
        dataSource.titleSelectedColor = .textDefaulColor
        dataSource.itemSpacing = 20
        dataSource.isItemSpacingAverageEnabled = false
        segmentedView.dataSource = dataSource
        segmentedView.listContainer = pagingView
        segmentedView.backgroundColor(.clear)
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 12
        indicator.indicatorHeight = 4
        indicator.indicatorColor = lmColorHex("#FF4F7DFF")
        indicator.verticalOffset = 12.0
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
    @objc func buybtnClick() {
        if selecdModel.id == 0 {
            HUD.show("请选择装扮")
            return
        }
        LMShopBuyPopView(theme: .light, confirmText: "购买", model: selecdModel, block: {[weak self] pricemodel in
            guard let pricemodel = pricemodel, let self = self else {
                return}
            HUD.showLoading()
            ShopNetWork.buyDress(id: self.selecdModel.id, priceId: pricemodel.id, days: pricemodel.days).lmrequest { _ in
                HUD.show("购买成功")
            } failureBlock: { error in
                HUD.show(error.message)
            }
        }).show()
    }
    @objc func turnPackage() {
        self.navigationController?.pushViewController(PackageViewController(), animated: true)
    }
    @objc func backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension LMShopVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        for (listindex, list) in self.pagingView.validListDict {
            if let list = list as? LMShopLictVC, listindex == index {
                guard let model = list.clickModel else {
                    self.selecdModel = ShopListItem()
                    return
                }
                self.selecdModel = model
            }
        }
    }
}
extension LMShopVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        dataSource.titles.count
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> any JXSegmentedListContainerViewListDelegate {
        let view = LMShopLictVC()
        view.type = typeList[index].id
        view.c_clickShopItemblock = {[weak self] model in
            if index == self?.segmentedView.selectedIndex {
                self?.selecdModel = model
                self?.buybtnClick()
            }
        }
        return view
    }
}
