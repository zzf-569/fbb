import UIKit
class LMShopLictVC: LMBaseVC {
    var type: Int?
    var page = 1
    var selectdNum = 0
    var clickModel: ShopListItem?
    var c_clickShopItemblock: ((ShopListItem) -> Void)?
    var dataSource: [ShopListItem] = []
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [LMShopListViewCell.self])
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        lmrequestData()
        addRefresh()
    }
    func addRefresh() {
        collectionView.addHeader { [weak self] in
            self?.page = 1
            self?.lmrequestData()
        }
        collectionView.addFooter { [weak self] in
            self?.page += 1
            self?.lmrequestData()
        }
    }
    private func setViewSnp() {
        backgroundImage = nil
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.top.equalToSuperview()
        }
    }
    func lmrequestData() {
        ShopNetWork.getDressUpList(type: type, page: page).lmrequest {[weak self] responseModel in
            self?.collectionView.endRefreshing()
            guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]),
            let list = [ShopListItem].deserialize(from: model.records), let self = self else {
                return
            }
            self.page == 1 ? self.dataSource = list : self.dataSource.append(contentsOf: list)
            self.collectionView.confEmptyView(isEmpty: self.dataSource.count <= 0, model: LMEmptyDataModel( titleColor: .textTerColor))
            self.collectionView.footerHidden(model.total <= self.dataSource.count)
            collectionView.reloadData()
        } failureBlock: { _ in
        }
    }
}
extension LMShopLictVC: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: LMShopListViewCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataSource[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: kScaleWidth(106), height: kScaleWidth(118))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        kScaleWidth(4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        kScaleWidth(20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: kScaleWidth(16), bottom: 0, right: kScaleWidth(16))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.selectdNum = indexPath.row
        self.clickModel = dataSource[indexPath.row]
        self.c_clickShopItemblock?(dataSource[indexPath.row])
        collectionView.reloadData()
    }
}
extension LMShopLictVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
