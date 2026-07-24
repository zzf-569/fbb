import UIKit
class LMHearPageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let viewModel = LMHearViewModel()
    lazy var collectionView: UICollectionView = {
        let layout = makeCollectionLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - kTabBarSafeHeight - kTabBarHeight), collectionViewLayout: layout)
        collectionView.register(LMHearPageCell.self, forCellWithReuseIdentifier: "LMHearPageCell")
        collectionView.register(LMHomeHotCell.self, forCellWithReuseIdentifier: "LMHomeHotCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        getData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
    func setViewSnp() {
        view.backgroundColor = lmColorHex("#F5F6FA")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func getData() {
        if viewModel.type == 0 {
            viewModel.getHotList {[weak self] _ in
                self?.collectionView.reloadData()
            }
        } else {
            viewModel.getRoomList {[weak self] _ in
                self?.collectionView.reloadData()
            }
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.roomList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LMHomeHotCell", for: indexPath) as! LMHomeHotCell
            cell.set_(model: viewModel.roomList[indexPath.item])
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LMHearPageCell", for: indexPath) as! LMHearPageCell
        cell.set_(model: viewModel.roomList[indexPath.row], index: indexPath.row)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.turnToRoom(roomId: viewModel.roomList[indexPath.row].roomId)
    }

    private func makeCollectionLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, environment in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(kScaleWidth(159)),
                    heightDimension: .absolute(kScaleWidth(177))
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                // 159pt 卡片以 103pt 的步进排列，让居中卡片覆盖两侧约三分之一。
                section.interGroupSpacing = -kScaleWidth(56)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: kScaleWidth(14),
                    leading: kScaleWidth(16),
                    bottom: kScaleWidth(14),
                    trailing: kScaleWidth(16)
                )
                section.visibleItemsInvalidationHandler = { visibleItems, offset, layoutEnvironment in
                    let containerWidth = layoutEnvironment.container.effectiveContentSize.width
                    let centerX = offset.x + containerWidth / 2
                    let maximumDistance = kScaleWidth(103)
                    let sideScale = CGFloat(141.0 / 159.0)
                    guard let centerItem = visibleItems.min(by: {
                        abs($0.frame.midX - centerX) < abs($1.frame.midX - centerX)
                    }) else { return }
                    let centerIndex = centerItem.indexPath.item

                    visibleItems.forEach { visibleItem in
                        let indexDistance = abs(visibleItem.indexPath.item - centerIndex)
                        guard indexDistance <= 1 else {
                            visibleItem.alpha = 0
                            visibleItem.transform = CGAffineTransform(scaleX: sideScale, y: sideScale)
                            visibleItem.zIndex = -1
                            return
                        }

                        visibleItem.alpha = 1
                        let distance = min(abs(visibleItem.frame.midX - centerX), maximumDistance)
                        let progress = distance / maximumDistance
                        let scale = 1 - progress * (1 - sideScale)
                        visibleItem.transform = CGAffineTransform(scaleX: scale, y: scale)
                        visibleItem.zIndex = visibleItem.indexPath.item == centerIndex ? 1000 : 100
                    }
                }
                return section
            }

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(kScaleWidth(112))
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = kScaleWidth(12)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: kScaleWidth(16),
                bottom: kScaleWidth(16),
                trailing: kScaleWidth(16)
            )
            return section
        }
    }
}
extension LMHearPageVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
