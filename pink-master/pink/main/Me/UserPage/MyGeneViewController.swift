import UIKit
class MyGeneViewController: LMBaseVC {
    private var dataSource: [String] = []
    private var interest: [labelListModel] = []
    private var game: [labelListModel] = []
    private var accomplishment: [labelListModel] = []
    lazy var pagingView = JXPagingView(delegate: self)
    lazy var segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 48))
    let titleData = LMLocalizedSegmentedTitleDataSource()
    private lazy var collectionView: UICollectionView = {
        let flowLayout = LMCollectionViewAlignFlowLayout()
        flowLayout.alignDirection = .left
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = lmColorHex("#F7F8FAFF")
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        collectionView.neverAdjustContentInset()
        collectionView.register(cellClass: UserCardExtendDeleCell.self)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setDataSoure()
    }
    private func setViewSnp() {
        title = "我的基因"
        view.backgroundColor = .white
        let btn = UIButton(lmfont: lmFontM(18), titleColor: .textDefaulColor)
        btn.addTarget(self, action: #selector(save), for: .touchUpInside)
        btn.lmtitle("保存")
        btn.frame = CGRect(x: 0, y: 0, width: kScaleWidth(64), height: kScaleWidth(32)) 
        let rightBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        titleData.titleNormalFont = lmFontR(16)
        titleData.titleSelectedFont = lmFontM(16)
        titleData.titleNormalColor = .textDefaulColor
        titleData.titleSelectedColor = .textDefaulColor
        titleData.itemSpacing = kScaleWidth(18)
        titleData.titles = ["兴趣", "游戏", "爱好"]
        titleData.isItemSpacingAverageEnabled = false
        segmentedView.backgroundColor(.clear)
        segmentedView.dataSource = titleData
        segmentedView.listContainer = pagingView.listContainerView as! any JXSegmentedViewListContainer
        segmentedView.delegate = self
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 12
        indicator.indicatorHeight = 3
        indicator.indicatorColor = lmColorHex("#FF4F7DFF")
        indicator.verticalOffset = 10.0
        segmentedView.indicators = [indicator]
        pagingView.backgroundColor(.clear)
        pagingView.mainTableView.backgroundColor(.clear)
        pagingView.listContainerView.backgroundColor(.white)
        pagingView.listContainerView.listCellBackgroundColor = .white
        pagingView.isListHorizontalScrollEnabled = false
        pagingView.listContainerView.isCategoryNestPagingEnabled = true
        view.addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavigationHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(kScreenHeight)
        }
    }
    func setDataSoure() {
        guard let model = UserShared.user else {
            return
        }
        var acctagList: [String] = []
        acctagList = model.userLabel.accomplishmentList.map {$0.labelName}
        accomplishment = model.userLabel.accomplishmentList
        var instagList: [String] = []
        instagList = model.userLabel.interestList.map {$0.labelName}
        interest = model.userLabel.interestList
        var gameList: [String] = []
        gameList = model.userLabel.gameList.map {$0.labelName}
        game = model.userLabel.gameList
        dataSource = acctagList + instagList + gameList
        collectionView.reloadData()
    }
    @objc func save() {
        let group = DispatchGroup()
        group.enter()
        set_NetWork.uplabelList(lbType: .accomplishment, labelList: accomplishment, customlb: "").lmrequest { _ in
            group.leave()
        } failureBlock: { _ in
            group.leave()
        }
        group.enter()
        set_NetWork.uplabelList(lbType: .game, labelList: game, customlb: "").lmrequest { _ in
            group.leave()
        } failureBlock: { _ in
            group.leave()
        }
        group.enter()
        set_NetWork.uplabelList(lbType: .interest, labelList: interest, customlb: "").lmrequest { _ in
            group.leave()
        } failureBlock: { _ in
            group.leave()
        }
        group.notify(queue: .main) {[weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension MyGeneViewController: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: UserCardExtendDeleCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(dataSource[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UserCardExtendDeleCell.getCellWidth(dataSource[indexPath.row]), height: 24.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let string = dataSource[indexPath.row]
        for (index, str) in dataSource.enumerated() {
            if str == string {
                dataSource.remove(at: index)
            }
        }
        for (index, str) in game.enumerated() {
            if str.labelName == string {
                game.remove(at: index)
            }
        }
        for (index, str) in interest.enumerated() {
            if str.labelName == string {
                interest.remove(at: index)
            }
        }
        for (index, str) in accomplishment.enumerated() {
            if str.labelName == string {
                accomplishment.remove(at: index)
            }
        }
        pagingView.reloadData()
        collectionView.reloadData()
    }
}
extension MyGeneViewController: JXSegmentedViewDelegate, JXPagingViewDelegate {
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return 200
    }
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        collectionView
    }
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        self.segmentedView
    }
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        48
    }
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        titleData.titles.count
    }
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if index == 0 {
            let view = MyGenePageView(lbType: .interest, seleData: self.interest)
            view.selectedblock = {[weak self] model in
                guard let self = self else {return}
                for list in self.interest {
                    if list.labelValue == model.labelValue {
                        return
                    }
                }
                self.interest.append(model)
                self.dataSource.append(model.labelName)
                self.collectionView.reloadData()
            }
            return view
        } else if index == 1 {
            let view = MyGenePageView(lbType: .game, seleData: self.game)
            view.selectedblock = {[weak self] model in
                guard let self = self else {return}
                for list in self.game {
                    if list.labelValue == model.labelValue {
                        return
                    }
                }
                self.game.append(model)
                self.dataSource.append(model.labelName)
                self.collectionView.reloadData()
            }
            return view
        }
        let view = MyGenePageView(lbType: .accomplishment, seleData: self.accomplishment)
        view.selectedblock = {[weak self] model in
            guard let self = self else {return}
            for list in self.accomplishment {
                if list.labelValue == model.labelValue {
                    return
                }
            }
            self.accomplishment.append(model)
            self.dataSource.append(model.labelName)
            self.collectionView.reloadData()
        }
        return view
    }
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
    }
}
