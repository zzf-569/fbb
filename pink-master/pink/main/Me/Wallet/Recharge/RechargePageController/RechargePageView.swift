import UIKit
class RechargePageView: UIView {
    var dataList: [RechargeItem] = [] {
        didSet {
            guard let item = dataList.first else { return }
            seydtem = item
        }
    }
    var seydtem: RechargeItem = RechargeItem()
    var block: ((RechargeItem) -> Void)?
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [RechargeCollectionViewCell.self])
        return collectionView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
        setDataSoure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    func setDataSoure() {
        collectionView.reloadData()
    }
}
extension RechargePageView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: kScaleWidth(106), height: kScaleWidth(72))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: RechargeCollectionViewCell.self, cellForRowAt: indexPath)
        let model = dataList[indexPath.row]
        cell.dataSoure = model
        if model.productId == seydtem.productId {
            cell.isSelectedItem = true
        } else {
            cell.isSelectedItem = false
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        seydtem = dataList[indexPath.row]
        block?(seydtem)
        self.collectionView.reloadData()
    }
}
extension RechargePageView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
