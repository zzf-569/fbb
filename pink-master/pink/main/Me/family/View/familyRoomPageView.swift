import UIKit
import JXSegmentedView
class familyRoomPageView: UIView {
    var dataList: [GuildRoomModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var page: Int = 1
    var type: Int = 0
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [familyRoomPageCell.self])
        return collectionView
    }()
    var dataSoure: GuildItem
    init(model: GuildItem, type: Int) {
        self.dataSoure = model
        self.type = type
        super.init(frame: .zero)
        setViewSnp()
        addRefresh()
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
    func getViewData() {
        GuildNetWork.FamilyRoomCharm(familyId: dataSoure.familyId, page: page, type: type).lmrequest {[weak self] responseModel in
            guard let model = [GuildRoomModel].deserialize(from: responseModel.data as? [Any]) else { return }
            self?.dataList = model
            self?.collectionView.endRefreshing()
        } failureBlock: {[weak self] _ in
            self?.collectionView.endRefreshing()
        }
    }
}
private extension familyRoomPageView {
    func addRefresh() {
        collectionView.addHeader { [weak self] in
            guard let self = self else { return }
            self.page = 1
            self.getViewData()
        }
        collectionView.addFooter { [weak self] in
            guard let self = self else { return }
            self.page += 1
            self.getViewData()
        }
        self.collectionView.footerHidden(true)
        collectionView.headerBeginRefreshing()
    }
}
extension familyRoomPageView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: familyRoomPageCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataList[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth, height: kScaleWidth(80))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let roomItem = dataList[indexPath.row]
        VoiceShared.turnToRM(roomItem.roomId)
    }
}
extension familyRoomPageView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
