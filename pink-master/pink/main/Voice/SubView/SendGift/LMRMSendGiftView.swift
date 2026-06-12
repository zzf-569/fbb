import UIKit
extension LMRMSendGiftView {
    func setDataSoure(_ giftSections: [GiftCategoryModel]) {
        self.dataSource = giftSections
        let titles = self.dataSource.map { $0.name }
        if self.segData.titles.count < 2 {
            self.segData.titles = titles
            self.segData.titles.append("装扮")
            self.segmentedView.reloadData()
        }
        self.segmentedView.snp.updateConstraints { make in
            make.width.equalTo(44 * self.segData.titles.count)
        }
    }
    func refreshBagView() {
        for (_, list) in self.listContainerView.validListDict {
            if let list = list as?LMRMPackageListView {
                list.lmrequestData()
            }
        }
    }
}
class LMRMSendGiftView: UIView {
    let segmentedView = JXSegmentedView()
    private lazy var segData: JXSegmentedTitleDataSource = {
        let segData = LMLocalizedSegmentedTitleDataSource()
        segData.titleNormalFont = lmFontM(12)
        segData.titleNormalColor = lmColorHex("#FFFFFFA3")
        segData.titleSelectedColor = lmColorHex("#FFF0F8FF")
        segData.isItemSpacingAverageEnabled = false
        segData.itemSpacing = 0
        segData.itemWidth = 44
        return segData
    }()
    private lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    lazy var packagebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_package"), target: self, action: #selector(packageAction))
            .lmtitle("包裹")
            .titleColor(lmColorHex("#FFD660FF"))
            .font(lmFontM(14))
        return btn
    }()
    private var dataSource: [GiftCategoryModel] = []
    var selectedGiftBack: ((GiftItem) -> Void)?
    var selectedDressBack: ((ShopListItem) -> Void)?
    var selectedPackageBack: (() -> Void)?
    var selectedGiftTypeBack: ((Int) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMSendGiftView {
    private func setViewSnp() {
        self.segmentedView.contentEdgeInsetLeft = 0
        self.segmentedView.delegate = self
        self.segmentedView.dataSource = segData
        self.segmentedView.listContainer = listContainerView
        self.segmentedView.backgroundColor(lmColorHex("#FFFFFF14"))
        self.segmentedView.cornerRadius(12)
        let indicator = JXSegmentedIndicatorImageView()
        indicator.indicatorWidth = 44.0
        indicator.indicatorHeight = 24.0
        indicator.image = UIImage(named: "rm_slide_bg")
        indicator.indicatorPosition = .center
        segmentedView.indicators = [indicator]
        self.addSubview(self.segmentedView)
        self.addSubview(self.listContainerView)
        self.addSubview(self.packagebtn)
        self.segmentedView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(44 * self.segData.titles.count)
            make.top.equalToSuperview().offset(6)
            make.height.equalTo(24)
        }
        self.listContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.segmentedView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
        self.packagebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(segmentedView)
            make.height.equalTo(24)
        }
    }
}
extension LMRMSendGiftView: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if index < self.dataSource.count {
            for (viewindex, list) in self.listContainerView.validListDict {
                if let list = list as?LMRMSendGiftListView, index == viewindex {
                    guard let model = list.selectedGift else {
                        return
                    }
                    self.selectedGiftBack?(model)
                }
            }
            self.selectedGiftTypeBack?(0)
        } else if index == self.dataSource.count {
            self.selectedGiftTypeBack?(1)
        } else if index == self.dataSource.count + 1 {
            self.selectedGiftTypeBack?(2)
            for (_, list) in self.listContainerView.validListDict {
                if let list = list as?LMRMPackageListView {
                    list.reloadData()
                }
            }
        }
    }
    @objc func packageAction() {
        self.selectedPackageBack?()
    }
}
extension LMRMSendGiftView: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = self.segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index < self.dataSource.count {
            let view = LMRMSendGiftListView(categoryId: self.dataSource[index].id)
            view.selectedGiftBack = { [weak self] model in
                guard let self = self else { return }
                self.selectedGiftBack?(model)
            }
            return view
        } else if index == self.dataSource.count {
            let view = LMRMSendDressListView()
            view.selectedDressBack = { [weak self] model in
                guard let self = self else { return }
                self.selectedDressBack?(model)
            }
            return view
        }
        let view = LMRMPackageListView()
        view.selectedPackageBack = { [weak self] _ in
        }
        return view
    }
}
