import UIKit
extension LMRMSendGiftListView {
}
class LMRMSendGiftListView: UIView {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [LMRMSendGiftListCell.self])
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    private var dataSource: [GiftItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var selectedGiftBack: ((GiftItem) -> Void)?
    var selectedGift: GiftItem?
    var categoryId: Int = 0
    var page = 1
    init(categoryId: Int) {
        super.init(frame: .zero)
        self.categoryId = categoryId
        self.setViewSnp()
        self.lmrequestData()
        self.addRefresh()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMSendGiftListView {
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
            self?.selectedGift = nil
            self?.page = 1
            self?.lmrequestData()
        }
        collectionView.addFooter { [weak self] in
            self?.page += 1
            self?.lmrequestData()
        }
    }
    func lmrequestData() {
        GiftNetWork.giftList(page: page, categoryId: categoryId).lmrequest {[weak self] responseModel in
            self?.collectionView.endRefreshing()
            guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]),
                  let list = [GiftItem].deserialize(from: model.records), let self = self else {
                return
            }
            self.page == 1 ? self.dataSource = list : self.dataSource.append(contentsOf: list)
            if self.page == 1, self.selectedGift == nil, self.dataSource.count > 0 {
                var dataSoure = self.dataSource[0]
                dataSoure.isSelected = true
                self.dataSource[0] = dataSoure
                self.selectedGift = self.dataSource[0]
                self.selectedGiftBack?(self.dataSource[0])
            }
            self.collectionView.confEmptyView(isEmpty: self.dataSource.count <= 0)
            self.collectionView.footerHidden(model.total <= self.dataSource.count)
        } failureBlock: { _ in
        }
    }
}
extension LMRMSendGiftListView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType:LMRMSendGiftListCell.self, cellForRowAt: indexPath)
        let model = dataSource[indexPath.row]
        cell.setDataSoure(model)
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
        for (index, model) in self.dataSource.enumerated() {
            var tempmodel = model
            tempmodel.isSelected = false
            self.dataSource[index] = tempmodel
        }
        var dataSoure = self.dataSource[indexPath.row]
        dataSoure.isSelected = true
        self.dataSource[indexPath.row] = dataSoure
        self.selectedGift = dataSoure
        collectionView.reloadData()
        self.selectedGiftBack?(dataSoure)
    }
}
extension LMRMSendGiftListView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
