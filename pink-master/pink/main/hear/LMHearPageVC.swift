import UIKit
class LMHearPageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let viewModel = LMHearViewModel()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - kTabBarSafeHeight - kTabBarHeight), collectionViewLayout: layout)
        collectionView.register(LMHearPageCell.self, forCellWithReuseIdentifier: "LMHearPageCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
        view.backgroundColor = .clear
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
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.roomList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScaleWidth(60), height: collectionView.height - 30)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LMHearPageCell", for: indexPath) as! LMHearPageCell
        cell.set_(model: viewModel.roomList[indexPath.row], index: indexPath.row)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.turnToRoom(roomId: viewModel.roomList[indexPath.row].roomId)
    }
}
extension LMHearPageVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
