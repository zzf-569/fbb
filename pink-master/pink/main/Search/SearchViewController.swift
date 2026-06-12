import UIKit
extension SearchViewController {
}
class SearchViewController: LMBaseVC {
    var keyString: String = "" {
        didSet {
            self.getViewData()
        }
    }
    var selectedblock: ((SearchResult?) -> Void)?
    private var page: Int = 1
    private var dataSource: [SearchResultItem] = []
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [SearchRoomCell.self, SearchUserCell.self, SearchexactUserCell.self, SearchexactRoomCell.self, SearchcommandRoomCell.self, SearchcommandUserCell.self])
        collectionView.backgroundColor(.clear)
        collectionView.lm_registerReusableView(reusableView: SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.lm_registerReusableView(reusableView: UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage = nil
        view.backgroundColor = (lmColorHex("#F5F6FAFF"))
        view.backgroundColor = .clear
        setViewSnp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}
private extension SearchViewController {
    func setViewSnp() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    func getViewData() {
        HUD.showLoading()
        set_NetWork.search(content: keyString).lmrequest { [weak self] responseModel in
            HUD.hide()
            guard let self = self else { return }
            if self.page == 1 {
                self.dataSource.removeAll()
            }
            if let commandRoom = RoomItem.deserialize(from: (responseModel.data as? [String: Any])?["commandRoom"] as? [String: Any]) {
                self.dataSource.append(SearchResultItem(type: .commandRoom, commandRoom: [commandRoom]))
            }
            if let commandUser = UsInfoItem.deserialize(from: (responseModel.data as? [String: Any])?["commandUser"] as? [String: Any]) {
                self.dataSource.append(SearchResultItem(type: .commandUser, commandUser: [commandUser]))
            }
            if let exactRoomList = [RoomItem].deserialize(from: (responseModel.data as? [String: Any])?["exactRoomList"] as? [Any]), exactRoomList.count > 0 {
                self.dataSource.append(SearchResultItem(type: .exactRoom, exactRoomList: exactRoomList))
            }
            if let exactUserList = [UsInfoItem].deserialize(from: (responseModel.data as? [String: Any])?["exactUserList"] as? [Any]), exactUserList.count > 0 {
                self.dataSource.append(SearchResultItem(type: .exactUser, exactUserList: exactUserList))
            }
            if let roomList = [RoomItem].deserialize(from: (responseModel.data as? [String: Any])?["roomList"] as? [Any]), roomList.count > 0 {
                self.dataSource.append(SearchResultItem(type: .party, partyList: roomList))
            }
            if let podcastList = [RoomItem].deserialize(from: (responseModel.data as? [String: Any])?["podcastList"] as? [Any]), podcastList.count > 0 {
                self.dataSource.append(SearchResultItem(type: .person, personList: podcastList))
            }
            if let userList = [UsInfoItem].deserialize(from: (responseModel.data as? [String: Any])?["userList"] as? [Any]), userList.count > 0 {
                self.dataSource.append(SearchResultItem(type: .user, userList: userList))
            }
            self.collectionView.endRefreshing()
            self.collectionView.reloadData()
            self.collectionView.confEmptyView(isEmpty: self.dataSource.count <= 0, model: LMEmptyDataModel(title: "未搜索到相关内容，请重新输入", titleColor: lmColorHex("#2B313D3D"), offsetY: -100))
        } failureBlock: { [weak self] error in
            HUD.showFailure(error.message)
            guard let self = self else { return }
            self.collectionView.confEmptyView(isEmpty: self.dataSource.count <= 0, model: LMEmptyDataModel(title: "未搜索到相关内容，请重新输入", titleColor: lmColorHex("#2B313D3D"), offsetY: -100))
        }
    }
    func likeRoom(roomItem: RoomItem) {
        RoomNetWork.like(roomId: roomItem.roomId, liked: true).lmrequest { [weak self] _ in
            HUD.hide()
            guard let self = self else { return }
            HUD.show("谢谢关注房间")
            self.getViewData()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
private extension SearchViewController {
    func addRefresh() {
        collectionView.addHeader { [weak self] in
            guard let self = self else { return }
            self.page = 1
            self.getViewData()
        }
    }
}
extension SearchViewController: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var num = 0
        switch dataSource[section].type {
        case .commandRoom:
            num = dataSource[section].commandRoom.count
        case .commandUser:
            num = dataSource[section].commandUser.count
        case .exactRoom:
            num = dataSource[section].exactRoomList.count
        case .exactUser:
            num = dataSource[section].exactUserList.count
        case .party:
            num = dataSource[section].partyList.count
        case .person:
            num = dataSource[section].personList.count
        case .user:
            num = 1
        }
        return num
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size = CGSize(width: kScreenWidth, height: kScaleWidth(0))
        switch dataSource[section].type {
        case .party:
            size = CGSize(width: kScreenWidth - 40, height: kScaleWidth(46))
        case .person:
            size = CGSize(width: kScreenWidth - 40, height: kScaleWidth(46))
        case .user:
            size = CGSize(width: kScreenWidth - 40, height: kScaleWidth(46))
        default:
            size = CGSize(width: kScreenWidth - 40, height: kScaleWidth(0))
        }
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        var size = CGSize(width: kScreenWidth, height: kScaleWidth(0))
        switch dataSource[section].type {
        case .party:
            size = CGSize(width: kScreenWidth - 40, height: kScaleWidth(24))
        case .person:
            size = CGSize(width: kScreenWidth - 40, height: kScaleWidth(24))
        case .user:
            size = CGSize(width: kScreenWidth - 40, height: kScaleWidth(24))
        default:
            size = CGSize(width: kScreenWidth - 40, height: kScaleWidth(0))
        }
        return size
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if dataSource[indexPath.section].type == .user || dataSource[indexPath.section].type == .party || dataSource[indexPath.section].type == .person {
                let header = collectionView.lm_dequeueSupplementaryView(reusableView: SearchHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
                header.titleLab.lmtext(dataSource[indexPath.section].type.rawValue)
                header.selectedblock = {[weak self] in
                    self?.selectedblock?(self?.dataSource[indexPath.section].type)
                }
                return header
            }
        }
        if kind == UICollectionView.elementKindSectionFooter {
            if dataSource[indexPath.section].type == .user || dataSource[indexPath.section].type == .party || dataSource[indexPath.section].type == .person {
                let footer = collectionView.lm_dequeueSupplementaryView(reusableView: UICollectionReusableView.self, ofKind: UICollectionView.elementKindSectionFooter, for: indexPath)
                let view = UIView(frame: CGRect(x: (kScreenWidth - kScaleWidth(358))/2, y: 0, width: kScaleWidth(358), height: 12)).backgroundColor(.white)
                view.roundedRect([.bottomLeft, .bottomRight], withCornerRatio: 8)
                footer.addSubview(view)
                return footer
            }
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if dataSource[indexPath.section].type == .commandRoom {
            let cell = collectionView.dequeueReusableCell(cellType: SearchcommandRoomCell.self, cellForRowAt: indexPath)
            cell.setDataSoure(dataSource[indexPath.section].commandRoom[indexPath.row], keyString: keyString)
            cell.selectedblock = {[weak self]string, model in
                if string == "去房间" {
                    VoiceShared.turnToRM(model.roomId, commandCode: self?.keyString)
                } else {
                    self?.likeRoom(roomItem: model)
                }
            }
            return cell
        }
        if dataSource[indexPath.section].type == .commandUser {
            let cell = collectionView.dequeueReusableCell(cellType: SearchcommandUserCell.self, cellForRowAt: indexPath)
            cell.setDataSoure(dataSource[indexPath.section].commandUser[indexPath.row], keyString: keyString)
            cell.selectedblock = {[weak self] model in
                RouteService.pushChat(model.userId, vc: self, commandCode: self?.keyString)
            }
            return cell
        }
        if dataSource[indexPath.section].type == .party {
            let cell = collectionView.dequeueReusableCell(cellType: SearchRoomCell.self, cellForRowAt: indexPath)
            cell.setDataSoure(dataSource[indexPath.section].partyList[indexPath.row], keyString: keyString)
            cell.selectedblock = {[weak self]string, model in
                if string == "去房间" {
                    VoiceShared.turnToRM(model.roomId)
                } else {
                    self?.likeRoom(roomItem: model)
                }
            }
            return cell
        }
        if dataSource[indexPath.section].type == .user {
            let cell = collectionView.dequeueReusableCell(cellType: SearchUserCell.self, cellForRowAt: indexPath)
            cell.setDataSoure(dataSource[indexPath.section].userList)
            return cell
        }
        if dataSource[indexPath.section].type == .person {
            let cell = collectionView.dequeueReusableCell(cellType: SearchRoomCell.self, cellForRowAt: indexPath)
            cell.setDataSoure(dataSource[indexPath.section].personList[indexPath.row], keyString: keyString)
            cell.selectedblock = {[weak self]string, model in
                if string == "去房间" {
                    VoiceShared.turnToRM(model.roomId)
                } else {
                    self?.likeRoom(roomItem: model)
                }
            }
            return cell
        }
        if dataSource[indexPath.section].type == .exactUser {
            let cell = collectionView.dequeueReusableCell(cellType: SearchexactUserCell.self, cellForRowAt: indexPath)
            cell.setDataSoure(dataSource[indexPath.section].exactUserList[indexPath.row])
            cell.selectedblock = {model in
                RouteService.pushChat(model.userId, vc: self)
            }
            return cell
        }
        if dataSource[indexPath.section].type == .exactRoom {
            let cell = collectionView.dequeueReusableCell(cellType: SearchexactRoomCell.self, cellForRowAt: indexPath)
            cell.setDataSoure(dataSource[indexPath.section].exactRoomList[indexPath.row])
            cell.selectedblock = {[weak self]string, model in
                if string == "去房间" {
                    VoiceShared.turnToRM(model.roomId)
                } else {
                    self?.likeRoom(roomItem: model)
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if dataSource[indexPath.section].type == .party {
            return CGSize(width: kScaleWidth(358), height: kScaleWidth(72))
        }
        if dataSource[indexPath.section].type == .user {
            return CGSize(width: kScaleWidth(358), height: kScaleWidth(135))
        }
        if dataSource[indexPath.section].type == .person {
            return CGSize(width: kScaleWidth(358), height: kScaleWidth(72))
        }
        if dataSource[indexPath.section].type == .exactUser {
            return CGSize(width: kScaleWidth(358), height: kScaleWidth(110))
        }
        if dataSource[indexPath.section].type == .exactRoom {
            return CGSize(width: kScaleWidth(358), height: kScaleWidth(110))
        }
        if dataSource[indexPath.section].type == .commandRoom {
            return CGSize(width: kScaleWidth(358), height: kScaleWidth(110))
        }
        if dataSource[indexPath.section].type == .commandUser {
            return CGSize(width: kScaleWidth(358), height: kScaleWidth(110))
        }
        return CGSize(width: kScaleWidth(358), height: kScaleWidth(80))
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
        if dataSource[indexPath.section].type == .commandRoom {
            let model = dataSource[indexPath.section].commandRoom[indexPath.row]
            if model.status == 1 {
                VoiceShared.turnToRM(model.roomId, commandCode: self.keyString)
            } else {
                HUD.show("该房间已关播")
            }
        }
        if  dataSource[indexPath.section].type == .party {
            let model = dataSource[indexPath.section].partyList[indexPath.row]
            if model.status == 1 {
                VoiceShared.turnToRM(model.roomId)
            } else {
                HUD.show("该房间已关播")
            }
        }
        if  dataSource[indexPath.section].type == .person {
            let model = dataSource[indexPath.section].personList[indexPath.row]
            if model.status == 1 {
                VoiceShared.turnToRM(model.roomId)
            } else {
                HUD.show("该房间已关播")
            }
        }
        if  dataSource[indexPath.section].type == .exactRoom {
            let model = dataSource[indexPath.section].exactRoomList[indexPath.row]
            if model.status == 1 {
                VoiceShared.turnToRM(model.roomId)
            } else {
                HUD.show("该房间已关播")
            }
        }
        if  dataSource[indexPath.section].type == .exactUser {
            let model = dataSource[indexPath.section].exactUserList[indexPath.row]
            RouteService.pushUserMainPage(model.userId, vc: self)
        }
        if  dataSource[indexPath.section].type == .user {
            let model = dataSource[indexPath.section].userList[indexPath.row]
            RouteService.pushUserMainPage(model.userId, vc: self)
        }
        if  dataSource[indexPath.section].type == .commandUser {
            let model = dataSource[indexPath.section].commandUser[indexPath.row]
            RouteService.pushUserMainPage(model.userId, vc: self)
        }
    }
}
extension SearchViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
