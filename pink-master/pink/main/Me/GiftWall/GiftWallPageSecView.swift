import UIKit
class GiftWallPageSecView: UIView {
    var userId: String = ""
    var dataSoure: [IhListModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    lazy var collectionView: UICollectionView = {
        collectionView = UICollectionView(target: self, cellTypes: [GiftWallPageSecCell.self])
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
        UserNetWork.IhList(userId: self.userId).lmrequest { responseModel in
            guard let list = [IhListModel].deserialize(from: responseModel.data as? [Any]) else { return }
            self.dataSoure = list
        } failureBlock: { _ in
        }
    }
}
extension GiftWallPageSecView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSoure.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: GiftWallPageSecCell.self, cellForRowAt: indexPath)
        cell.degegate = self
        cell.userid = userId
        cell.dataSoure = dataSoure[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScaleWidth(350), height: getCellHeight(model: dataSoure[indexPath.row]))
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
    }
    func getCellHeight(model: IhListModel) -> Double {
        var height = kScaleWidth(0)
        if userId == UserShared.user?.userId {
            height += (kScaleWidth(52) + kScaleWidth(48))
        } else {
            height += kScaleWidth(56)
        }
        height += CGFloat(((model.detail.ihGiftList.count - 1) / 4) + 1) * kScaleWidth(104)
        return height
    }
}
extension GiftWallPageSecView: GiftWallPageSecCellDelegate {
    func dg_cellClickRward(model: IhListModel) {
        GiftNetWork.receiveReward(ihId: model.id).lmrequest { _ in
            HUD.show("领取成功")
            self.setDataSoure()
        } failureBlock: { _ in
        }
    }
}
extension GiftWallPageSecView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        self
    }
}
