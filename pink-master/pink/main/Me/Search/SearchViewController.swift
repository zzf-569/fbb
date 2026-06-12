import UIKit
extension SearchViewController {
}
class SearchViewController: LMBaseViewController {
    var keyString: String = "" {
        didSet {
            self.act_rqeuestData()
        }
    }
    var selectedClosure: ((SearchResult?) -> Void)?
    private var page: Int = 1
    private var dataSource: [SearchResultModel] = []
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [SearchRoomCell.self, SearchUserCell.self, SearchexactUserCell.self, SearchexactRoomCell.self, SearchcommandRoomCell.self, SearchcommandUserCell.self])
        collectionView.act_backgroundColor(.clear)
        collectionView.act_registerCollectionReusableView(reusableView: SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.act_registerCollectionReusableView(reusableView: UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage = nil
        backgroundImageColor = (lmColorHex("#F5F6FAFF"))
        view.backgroundColor = .clear
        act_setUISubViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}
private extension SearchViewController {
    func act_setUISubViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    func act_rqeuestData() {
        HUD.act_showLoading()
        ConfigNetWork.search(content: keyString).lmrequest { [weak self] responseModel in
            HUD.act_hide()
            guard let self = self else { return }
            if self.page == 1 {
                self.dataSource.removeAll()
            }
            if let commandRoom = RoomModel.deserialize(from: (responseModel.data as? [String: Any])?["commandRoom"] as? [String: Any]) {
                self.dataSource.append(SearchResultModel(type: .commandRoom, commandRoom: [commandRoom]))
            }
            if let commandUser = UserModel.deserialize(from: (responseModel.data as? [String: Any])?["commandUser"] as? [String: Any]) {
                self.dataSource.append(SearchResultModel(type: .commandUser, commandUser: [commandUser]))
            }
            if let exactRoomList = [RoomModel].deserialize(from: (responseModel.data as? [String: Any])?["exactRoomList"] as? [Any]), exactRoomList.count > 0 {
                self.dataSource.append(SearchResultModel(type: .exactRoom, exactRoomList: exactRoomList))
            }
            if let exactUserList = [UserModel].deserialize(from: (responseModel.data as? [String: Any])?["exactUserList"] as? [Any]), exactUserList.count > 0 {
                self.dataSource.append(SearchResultModel(type: .exactUser, exactUserList: exactUserList))
            }
            if let roomList = [RoomModel].deserialize(from: (responseModel.data as? [String: Any])?["roomList"] as? [Any]), roomList.count > 0 {
                self.dataSource.append(SearchResultModel(type: .party, partyList: roomList))
            }
            if let podcastList = [RoomModel].deserialize(from: (responseModel.data as? [String: Any])?["podcastList"] as? [Any]), podcastList.count > 0 {
                self.dataSource.append(SearchResultModel(type: .person, personList: podcastList))
            }
            if let userList = [UserModel].deserialize(from: (responseModel.data as? [String: Any])?["userList"] as? [Any]), userList.count > 0 {
                self.dataSource.append(SearchResultModel(type: .user, userList: userList))
            }
            self.collectionView.act_endRefreshing()
            self.collectionView.reloadData()
            self.collectionView.act_configEmptyView(isEmpty: self.dataSource.count <= 0, model: YDEmptyDataModel(title: "未搜索到相关内容，请重新输入", titleColor: lmColorHex("#1C1C293D"), offsetY: -100))
        } failureBlock: { [weak self] error in
            HUD.act_showFailure(error.message)
            guard let self = self else { return }
            self.collectionView.act_configEmptyView(isEmpty: self.dataSource.count <= 0, model: YDEmptyDataModel(title: "未搜索到相关内容，请重新输入", titleColor: lmColorHex("#1C1C293D"), offsetY: -100))
        }
    }
    func act_likeRoom(roomModel: RoomModel) {
        RoomNetWork.like(roomId: roomModel.roomId, liked: true).lmrequest { [weak self] _ in
            HUD.act_hide()
            guard let self = self else { return }
            HUD.act_show("谢谢关注房间")
            self.act_rqeuestData()
        } failureBlock: { error in
            HUD.act_showFailure(error.message)
        }
    }
}
private extension SearchViewController {
    func act_addRefresh() {
        collectionView.act_addHeader { [weak self] in
            guard let self = self else { return }
            self.page = 1
            self.act_rqeuestData()
        }
    }
}
extension SearchViewController: kCollectionViewProtocol {
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
                let header = collectionView.act_dequeueReusableSupplementaryView(reusableView: SearchHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
                header.titleLabel.act_lmtext(dataSource[indexPath.section].type.rawValue)
                header.selectedClosure = {[weak self] in
                    self?.selectedClosure?(self?.dataSource[indexPath.section].type)
                }
                return header
            }
        }
        if kind == UICollectionView.elementKindSectionFooter {
            if dataSource[indexPath.section].type == .user || dataSource[indexPath.section].type == .party || dataSource[indexPath.section].type == .person {
                let footer = collectionView.act_dequeueReusableSupplementaryView(reusableView: UICollectionReusableView.self, ofKind: UICollectionView.elementKindSectionFooter, for: indexPath)
                let view = UIView(frame: CGRect(x: (kScreenWidth - kScaleWidth(358))/2, y: 0, width: kScaleWidth(358), height: 12)).act_backgroundColor(.white)
                view.roundedRect([.bottomLeft, .bottomRight], withCornerRatio: 8)
                footer.addSubview(view)
                return footer
            }
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if dataSource[indexPath.section].type == .commandRoom {
            let cell = collectionView.act_dequeueReusableCell(cellType: SearchcommandRoomCell.self, cellForRowAt: indexPath)
            cell.act_setConfigData(dataSource[indexPath.section].commandRoom[indexPath.row], keyString: keyString)
            cell.selectedClosure = {[weak self]string, model in
                if string == "去房间" {
                    RoomShared.act_enter(model.roomId, commandCode: self?.keyString)
                } else {
                    self?.act_likeRoom(roomModel: model)
                }
            }
            return cell
        }
        if dataSource[indexPath.section].type == .commandUser {
            let cell = collectionView.act_dequeueReusableCell(cellType: SearchcommandUserCell.self, cellForRowAt: indexPath)
            cell.act_setConfigData(dataSource[indexPath.section].commandUser[indexPath.row], keyString: keyString)
            cell.selectedClosure = {[weak self] model in
                RouteService.act_pushChat(model.userId, vc: self, commandCode: self?.keyString)
            }
            return cell
        }
        if dataSource[indexPath.section].type == .party {
            let cell = collectionView.act_dequeueReusableCell(cellType: SearchRoomCell.self, cellForRowAt: indexPath)
            cell.act_setConfigData(dataSource[indexPath.section].partyList[indexPath.row], keyString: keyString)
            cell.selectedClosure = {[weak self]string, model in
                if string == "去房间" {
                    RoomShared.act_enter(model.roomId)
                } else {
                    self?.act_likeRoom(roomModel: model)
                }
            }
            return cell
        }
        if dataSource[indexPath.section].type == .user {
            let cell = collectionView.act_dequeueReusableCell(cellType: SearchUserCell.self, cellForRowAt: indexPath)
            cell.act_setConfigData(dataSource[indexPath.section].userList)
            return cell
        }
        if dataSource[indexPath.section].type == .person {
            let cell = collectionView.act_dequeueReusableCell(cellType: SearchRoomCell.self, cellForRowAt: indexPath)
            cell.act_setConfigData(dataSource[indexPath.section].personList[indexPath.row], keyString: keyString)
            cell.selectedClosure = {[weak self]string, model in
                if string == "去房间" {
                    RoomShared.act_enter(model.roomId)
                } else {
                    self?.act_likeRoom(roomModel: model)
                }
            }
            return cell
        }
        if dataSource[indexPath.section].type == .exactUser {
            let cell = collectionView.act_dequeueReusableCell(cellType: SearchexactUserCell.self, cellForRowAt: indexPath)
            cell.act_setConfigData(dataSource[indexPath.section].exactUserList[indexPath.row])
            cell.selectedClosure = {model in
                RouteService.act_pushChat(model.userId, vc: self)
            }
            return cell
        }
        if dataSource[indexPath.section].type == .exactRoom {
            let cell = collectionView.act_dequeueReusableCell(cellType: SearchexactRoomCell.self, cellForRowAt: indexPath)
            cell.act_setConfigData(dataSource[indexPath.section].exactRoomList[indexPath.row])
            cell.selectedClosure = {[weak self]string, model in
                if string == "去房间" {
                    RoomShared.act_enter(model.roomId)
                } else {
                    self?.act_likeRoom(roomModel: model)
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
                RoomShared.act_enter(model.roomId, commandCode: self.keyString)
            } else {
                HUD.act_show("该房间已关播")
            }
        }
        if  dataSource[indexPath.section].type == .party {
            let model = dataSource[indexPath.section].partyList[indexPath.row]
            if model.status == 1 {
                RoomShared.act_enter(model.roomId)
            } else {
                HUD.act_show("该房间已关播")
            }
        }
        if  dataSource[indexPath.section].type == .person {
            let model = dataSource[indexPath.section].personList[indexPath.row]
            if model.status == 1 {
                RoomShared.act_enter(model.roomId)
            } else {
                HUD.act_show("该房间已关播")
            }
        }
        if  dataSource[indexPath.section].type == .exactRoom {
            let model = dataSource[indexPath.section].exactRoomList[indexPath.row]
            if model.status == 1 {
                RoomShared.act_enter(model.roomId)
            } else {
                HUD.act_show("该房间已关播")
            }
        }
        if  dataSource[indexPath.section].type == .exactUser {
            let model = dataSource[indexPath.section].exactUserList[indexPath.row]
            RouteService.act_pushUserMainPage(model.userId, vc: self)
        }
        if  dataSource[indexPath.section].type == .user {
            let model = dataSource[indexPath.section].userList[indexPath.row]
            RouteService.act_pushUserMainPage(model.userId, vc: self)
        }
        if  dataSource[indexPath.section].type == .commandUser {
            let model = dataSource[indexPath.section].commandUser[indexPath.row]
            RouteService.act_pushUserMainPage(model.userId, vc: self)
        }
    }
}
extension SearchViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
