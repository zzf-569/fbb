import UIKit
class MyGenePageView: LMBaseVC {
    var dataSource: [labelListModel] = []
    var seleSource: [labelListModel] = [] {
        didSet {
            dataSource = dataSource.filter { item in
                !self.seleSource.contains(where: {$0.labelValue == item.labelValue})
                   }
            collectionView.reloadData()
        }
    }
    private var lbType: lbType = .defaultCase
    private lazy var collectionView: UICollectionView = {
        let flowLayout = LMCollectionViewAlignFlowLayout()
        flowLayout.alignDirection = .left
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        collectionView.neverAdjustContentInset()
        collectionView.register(cellClass: UserCardExtendTagCell.self)
        return collectionView
    }()
    var selectedblock: ((labelListModel) -> Void)?
    required init(lbType: lbType, seleData: [labelListModel]) {
        self.lbType = lbType
        self.seleSource = seleData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setDataSoure()
    }
    private func setViewSnp() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func setDataSoure() {
        set_NetWork.labelList(lbType: lbType).lmrequest {[weak self] responseModel in
            guard var dataSoures = [labelListModel].deserialize(from: responseModel.data as? [Any]), let self = self else { return }
            dataSoures = dataSoures.filter { item in
                !self.seleSource.contains(where: {$0.labelValue == item.labelValue})
                   }
            self.dataSource = dataSoures
            self.collectionView.reloadData()
        } failureBlock: { _ in
        }
    }
}
extension MyGenePageView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: UserCardExtendTagCell.self, cellForRowAt: indexPath)
        let list = dataSource.map {$0.labelName}
        cell.setDataSoure(list[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let list = dataSource.map {$0.labelName}
        return CGSize(width: UserCardExtendTagCell.getCellWidth((list[indexPath.row])), height: 24.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedblock?(dataSource[indexPath.row])
        self.seleSource.append(dataSource[indexPath.row])
    }
}
extension MyGenePageView: JXPagingViewListViewDelegate {
    func listScrollView() -> UIScrollView {
        UIScrollView()
    }
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        listViewDidScrollCallback = callback
    }
    func listView() -> UIView {
        return self.view
    }
}
