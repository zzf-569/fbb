import UIKit
extension UserCardExtendTagView {
    func setDataSoure(_ list: [String]) {
        dataSource = list
        collectionView.reloadData()
        DispatchQueue.main {
            let collectionContentHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.viewHeightChange?(collectionContentHeight)
        }
    }
}
class UserCardExtendTagView: UIView {
    var viewHeightChange: ((Double) -> Void)?
    private var dataSource: [String] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var collectionView: UICollectionView = {
        let flowLayout = LMCollectionViewAlignFlowLayout()
        flowLayout.alignDirection = .left
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.neverAdjustContentInset()
        collectionView.register(cellClass: UserCardExtendTagCell.self)
        return collectionView
    }()
}
private extension UserCardExtendTagView {
    private func setViewSnp() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension UserCardExtendTagView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: UserCardExtendTagCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(dataSource[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UserCardExtendTagCell.getCellWidth(dataSource[indexPath.row]), height: 24.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        4.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
