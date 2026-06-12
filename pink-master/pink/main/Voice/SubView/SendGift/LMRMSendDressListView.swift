import UIKit
class LMRMSendDressListView: UIView {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [LMRMSendDressListCell.self])
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    var page = 1
    private var dataSource: [ShopListItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var selectedDressBack: ((ShopListItem) -> Void)?
    var selectedDress: ShopListItem = ShopListItem()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
        self.addRefresh()
        self.lmrequestData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func lmrequestData() {
        ShopNetWork.getDressUpList(page: page).lmrequest {[weak self] responseModel in
            self?.collectionView.endRefreshing()
            guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]),
            let list = [ShopListItem].deserialize(from: model.records), let self = self else {
                return
            }
            self.page == 1 ? self.dataSource = list : self.dataSource.append(contentsOf: list)
            self.collectionView.confEmptyView(isEmpty: self.dataSource.count <= 0)
            self.collectionView.footerHidden(model.total <= self.dataSource.count)
        } failureBlock: { _ in
        }
    }
}
 extension LMRMSendDressListView {
    private func setViewSnp() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.top.bottom.equalToSuperview()
        }
    }
    private func addRefresh() {
        collectionView.addHeader { [weak self] in
            self?.page = 1
            self?.lmrequestData()
        }
        collectionView.addFooter { [weak self] in
            self?.page += 1
            self?.lmrequestData()
        }
    }
}
extension LMRMSendDressListView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType:LMRMSendDressListCell.self, cellForRowAt: indexPath)
        var dataSoure = dataSource[indexPath.row]
        if dataSoure.id == self.selectedDress.id {
            dataSoure.isSelected = true
        }
        cell.setDataSoure(dataSoure)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: kScaleWidth(82), height: kScaleWidth(96))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        kScaleWidth(8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        kScaleWidth(10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.selectedDress = dataSource[indexPath.row]
        self.selectedDressBack?(dataSource[indexPath.row])
        collectionView.reloadData()
    }
}
extension LMRMSendDressListView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
