import UIKit
class SearchPartyResultView: LMBaseVC {
    var keyString: String = "" {
        didSet {
            self.getViewData()
        }
    }
    private var page: Int = 1
    private var dataSource: [RoomItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [SearchRoomCell.self, SearchUserCell.self])
        collectionView.lm_registerReusableView(reusableView: UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        collectionView.lm_registerReusableView(reusableView: UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
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
        setViewSnp()
    }
    private func setViewSnp() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    func getViewData() {
        set_NetWork.searchParty(content: keyString, page: page).lmrequest {[weak self] responseModel in
            self?.collectionView.endRefreshing()
            guard let self = self else { return }
            guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]),
                  let list = [RoomItem].deserialize(from: model.records)else {
                self.collectionView.footerHidden(true)
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
    func likeRoom(roomItem: RoomItem) {
        RoomNetWork.like(roomId: roomItem.roomId, liked: true).lmrequest { [weak self] _ in
            HUD.hide()
            guard let self = self else { return }
            self.getViewData()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
extension SearchPartyResultView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            let header = collectionView.lm_dequeueSupplementaryView(reusableView: UICollectionReusableView.self, ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
            let view = UIView(frame: CGRect(x: (kScreenWidth - kScaleWidth(358))/2, y: 0, width: kScaleWidth(358), height: kScaleWidth(12))).backgroundColor(.white)
            view.roundedRect([.topLeft, .topRight], withCornerRatio: 12)
            header.addSubview(view)
            return header
        }
        let footer = collectionView.lm_dequeueSupplementaryView(reusableView: UICollectionReusableView.self, ofKind: UICollectionView.elementKindSectionFooter, for: indexPath)
        let view = UIView(frame: CGRect(x: (kScreenWidth - kScaleWidth(358))/2, y: 0, width: kScaleWidth(358), height: 12)).backgroundColor(.white)
        view.roundedRect([.bottomLeft, .bottomRight], withCornerRatio: 12)
        footer.addSubview(view)
        return footer
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: SearchRoomCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(dataSource[indexPath.row])
        cell.selectedblock = {[weak self]string, model in
            if string == "去房间" {
                VoiceShared.turnToRM(model.roomId)
            } else {
                self?.likeRoom(roomItem: model)
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
        VoiceShared.turnToRM(self.dataSource[indexPath.row].roomId)
    }
}
