import UIKit
protocol LMRMEmojiListViewDelegate: NSObjectProtocol {
    func dg_sendFace(_ model: LMEmojiListModel)
}
extension LMRMEmojiListView {
}
class LMRMEmojiListView: UIView {
    private var dataSource: [LMEmojiListModel] = []
    weak var delegate:LMRMEmojiListViewDelegate?
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [RoomEmojiItemCell.self])
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    init(frame: CGRect, dataSource: [LMEmojiListModel], delegate:LMRMEmojiListViewDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMEmojiListView {
    private func setViewSnp() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
extension LMRMEmojiListView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType:RoomEmojiItemCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(dataSource[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 64.0, height: 84.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.delegate?.dg_sendFace(dataSource[indexPath.row])
    }
}
extension LMRMEmojiListView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
