import UIKit
class SearchPersonResultView: LMBaseViewController {
    var keyString: String = "" {
        didSet {
            self.act_rqeuestData()
        }
    }
    private var page: Int = 1
    private var dataSource: [RoomModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [SearchRoomCell.self, SearchUserCell.self])
        collectionView.act_registerCollectionReusableView(reusableView: UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        collectionView.act_registerCollectionReusableView(reusableView: UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage = nil
        self.view.backgroundColor = lmColorHex("#F5F6FA")
        act_setUISubViews()
    }
    private func act_setUISubViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    func act_rqeuestData() {
        ConfigNetWork.searchPerson(content: keyString, page: page).lmrequest {[weak self] responseModel in
            self?.collectionView.act_endRefreshing()
            guard let self = self else { return }
            guard let model = PageModel.deserialize(from: responseModel.data as? [String: Any]),
                  let list = [RoomModel].deserialize(from: model.records) else {
                self.collectionView.act_footerHidden(true)
                return
            }
            if self.page == 1 {
                self.dataSource = list
            } else {
                self.dataSource.append(contentsOf: list)
            }
        } failureBlock: { _ in
        }
    }
    func act_likeRoom(roomModel: RoomModel) {
        RoomNetWork.like(roomId: roomModel.roomId, liked: true).lmrequest { [weak self] _ in
            HUD.act_hide()
            guard let self = self else { return }
            self.act_rqeuestData()
        } failureBlock: { error in
            HUD.act_showFailure(error.message)
        }
    }
}
extension SearchPersonResultView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataSource.count > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: kScreenWidth, height: kScaleWidth(12))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: kScreenWidth, height: kScaleWidth(20))
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.act_dequeueReusableSupplementaryView(reusableView: UICollectionReusableView.self, ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
            let view = UIView(frame: CGRect(x: (kScreenWidth - kScaleWidth(358))/2, y: 0, width: kScaleWidth(358), height: kScaleWidth(12))).act_backgroundColor(.white)
            view.roundedRect([.topLeft, .topRight], withCornerRatio: 12)
            header.addSubview(view)
            return header
        }
        let footer = collectionView.act_dequeueReusableSupplementaryView(reusableView: UICollectionReusableView.self, ofKind: UICollectionView.elementKindSectionFooter, for: indexPath)
        let view = UIView(frame: CGRect(x: (kScreenWidth - kScaleWidth(358))/2, y: 0, width: kScaleWidth(358), height: 12)).act_backgroundColor(.white)
        view.roundedRect([.bottomLeft, .bottomRight], withCornerRatio: 12)
        footer.addSubview(view)
        return footer
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.act_dequeueReusableCell(cellType: SearchRoomCell.self, cellForRowAt: indexPath)
        cell.act_setConfigData(dataSource[indexPath.row])
        cell.selectedClosure = {[weak self]string, model in
            if string == "去房间" {
                RoomShared.act_enter(model.roomId)
            } else {
                self?.act_likeRoom(roomModel: model)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScaleWidth(358), height: kScaleWidth(72))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        RoomShared.act_enter(self.dataSource[indexPath.row].roomId)
    }
}
extension SearchPersonResultView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
