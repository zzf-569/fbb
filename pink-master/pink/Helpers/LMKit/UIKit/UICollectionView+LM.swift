import UIKit
public extension UICollectionView {
    convenience init(target: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate, cellTypes: [UICollectionViewCell.Type] = [], scrollDirection: UICollectionView.ScrollDirection = .vertical) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        self.init(frame: CGRect.zero, collectionViewLayout: layout)
        self.dataSource = target
        self.delegate = target
        self.backgroundColor = .clear
        self.neverAdjustContentInset()
        for type in cellTypes {
            self.register(cellClass: type)
        }
    }
}
public extension   UICollectionView {
    func register(cellClass: UICollectionViewCell.Type) {
         self.register(cellClass.self, forCellWithReuseIdentifier: "ID" + cellClass.className)
    }
    func register(nib: UINib) {
         self.register(nib, forCellWithReuseIdentifier: "ID" + nib.className)
    }
    func dequeueReusableCell<T: UICollectionViewCell>(cellType: T.Type, cellForRowAt indexPath: IndexPath) -> T {
        return  self.dequeueReusableCell(withReuseIdentifier: "ID" + cellType.className, for: indexPath) as! T
    }
    func lm_registerReusableView(reusableView: UICollectionReusableView.Type, forSupplementaryViewOfKind elementKind: String) {
         self.register(reusableView.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: "ID" + reusableView.className)
    }
    func lm_dequeueSupplementaryView<T: UICollectionReusableView>(reusableView: T.Type, ofKind elementKind: String, for indexPath: IndexPath) -> T {
        return  self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: "ID" + reusableView.className, for: indexPath) as! T
    }
}
