import UIKit
class GiftWallPageView: UIView {
    var userId: String = ""
    var dataSoure: GiftWallModel = GiftWallModel() {
        didSet {
            collectionView.reloadData()
        }
    }
    lazy var collectionView: UICollectionView = {
        collectionView = UICollectionView(target: self, cellTypes: [GiftWallPageViewCell.self])
        collectionView.backgroundColor = nil
        return collectionView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init(userId: String) {
        self.userId = userId
        super.init(frame: .zero)
        setViewSnp()
        setDataSoure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func setDataSoure() {
        UserNetWork.GiftWall(type: 0, userId: self.userId).lmrequest { responseModel in
            guard let list = GiftWallModel.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self.dataSoure = list
        } failureBlock: { _ in
        }
    }
}
extension GiftWallPageView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSoure.giftList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: GiftWallPageViewCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataSoure.giftList[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScaleWidth(106), height: kScaleWidth(134))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 16, bottom: 8, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let view = GiftWallDetailPopView()
        view.setDataSoure(dataSoure.giftList[indexPath.row])
        view.show()
    }
}
extension GiftWallPageView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        self
    }
}
