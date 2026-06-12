import UIKit
class LMBagePageVC: LMBaseVC {
    var type: Int?
    var page = 1
    var dataSource: [UserDressModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [LMBageViewCell.self])
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        lmrequestData()
        addRefresh()
    }
    func addRefresh() {
        collectionView.addHeader { [weak self] in
            self?.page = 1
            self?.lmrequestData()
        }
        collectionView.addFooter { [weak self] in
            self?.page += 1
            self?.lmrequestData()
        }
    }
    private func setViewSnp() {
        backgroundImage = nil
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
        }
    }
    func lmrequestData() {
        ShopNetWork.getPackageList(type: type, page: page).lmrequest {[weak self] responseModel in
            self?.collectionView.endRefreshing()
            guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]),
            let list = [UserDressModel].deserialize(from: model.records), let self = self else {
                return
            }
            self.page == 1 ? self.dataSource = list : self.dataSource.append(contentsOf: list)
            self.collectionView.confEmptyView(isEmpty: self.dataSource.count <= 0, model: LMEmptyDataModel(titleColor: .textTerColor))
            self.collectionView.footerHidden(model.total <= self.dataSource.count)
        } failureBlock: { _ in
        }
    }
}
extension LMBagePageVC: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate, LMBageViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: LMBageViewCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataSource[indexPath.row]
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: kScaleWidth(358), height: kScaleWidth(88))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        kScaleWidth(16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        kScaleWidth(16)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    func dg_userDressClick(dressModel: UserDressModel) {
        if dressModel.isActive == true {
            ShopNetWork.cancelDress(id: dressModel.id, type: dressModel.type, roomId: VoiceShared.roomViewController?.viewModel.roomId).lmrequest { responseModel in
                HUD.show("取消成功")
                for (index, model) in self.dataSource.enumerated() {
                    var repModel = model
                    repModel.isActive = false
                    self.dataSource[index] = repModel
                }
                self.collectionView.reloadData()
            } failureBlock: { error in
            }
        }else {
            ShopNetWork.useDress(id: dressModel.id, type: dressModel.type, roomId: VoiceShared.roomViewController?.viewModel.roomId).lmrequest { responseModel in
                HUD.show("佩戴成功")
                for (index, model) in self.dataSource.enumerated() {
                    var repModel = model
                    repModel.isActive = false
                    if model.id == dressModel.id {
                        repModel.isActive = true
                    }
                    self.dataSource[index] = repModel
                }
                self.collectionView.reloadData()
            } failureBlock: { error in
            }
        }
    }
}
extension LMBagePageVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
