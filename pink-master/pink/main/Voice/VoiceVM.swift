import Foundation
import AttributedString
class VoiceVM: NSObject {
    weak var Seversdelegate:VoiceServiceDelegate?
    var roomItem:RoomItem = RoomItem()
    var roomId: String {roomItem.roomId }
    var seats: [RoomSeatItem] { self.roomItem.seatList }
    var seatSequenceList: [UsInfoItem] = []
    var streamId: String {roomItem.roomId + "_" + UserShared.user!.userId }
    init(roomItem:RoomItem) {
        self.roomItem = roomItem
        super.init()
    }
    deinit {
        lmPrint("NSObject deinit：----------------\(Self.className)已被销毁")
    }
}
extension VoiceVM {
    func enterRoom(complete block: @escaping () -> Void) {
        let group = DispatchGroup()
        group.enter()
       RoomNetWork.join(roomId:roomItem.roomId).lmrequest { responseModel in
            guard let model = RoomItem.deserialize(from: responseModel.data as? [String: Any]) else {
                group.leave()
                return
            }
            self.roomItem.token = model.token
           RTCService.shared.enterRoom(self.roomItem.roomId, rtcUserId: UserShared.user!.userId, token: self.roomItem.token)
            IMService.shared.enterRoom(self.roomItem.imRoomId)
            group.leave()
        } failureBlock: { _ in
            group.leave()
        }
        group.enter()
       RoomNetWork.micApplyList(roomId:roomItem.roomId, admin: false).lmrequest { responseModel in
            guard let list = [UsInfoItem].deserialize(from: responseModel.data as? [Any]) else { return }
            self.seatSequenceList = list
            group.leave()
        } failureBlock: { _ in
            group.leave()
        }
        group.notify(queue: .main) {
            block()
            if self.isUserOnSeat(UserShared.user!.userId) {
                self.onSeat()
            }
            let state = self.getMuteState()
            RTCService.shared.muteSpeaker(state)
        }
    }
    func exitRoom(complete block: @escaping () -> Void) {
        IMService.shared.quitRoom(roomItem.imRoomId)
        RTCService.shared.quitRoom()
       RoomNetWork.leave(roomId:roomItem.roomId).lmrequest { _ in
            block()
        } failureBlock: { _ in
            block()
        }
    }
    func closeRoom(complete block: @escaping (RoomCloseModel?) -> Void) {
       RoomNetWork.close(roomId:roomItem.roomId).lmrequest {responseModel in
            guard let model = RoomCloseModel.deserialize(from: responseModel.data as? [String: Any]) else {
                block(nil)
                return }
            block(model)
        } failureBlock: { _ in
            block(nil)
        }
    }
    func applyOnSeat(_ seatIndex: Int? = nil, complete block: @escaping (Bool, String) -> Void) {
       RoomNetWork.upSeat(roomId:roomItem.roomId, seatIndex: seatIndex).lmrequest { responseModel in
            block(true, responseModel.message)
        } failureBlock: { error in
            block(false, error.message)
        }
    }
    func applyDownSeat(complete block: @escaping (Bool, String) -> Void) {
       RoomNetWork.downSeat(roomId:roomItem.roomId).lmrequest { _ in
            block(true, "")
        } failureBlock: { error in
            block(false, error.message)
        }
    }
    func onSeat() {
        guard let seat = userSeatInfo(UserShared.user?.userId) else { return }
        RTCService.shared.startPublishingStream(self.streamId)
        RTCService.shared.muteMicrophone(seat.mute)
    }
    func downSeat() {
        RTCService.shared.stopPublishingStream()
    }
    func updateSeatSequences(complete block: @escaping (Bool, String) -> Void) {
       RoomNetWork.micApplyList(roomId:roomItem.roomId, admin: false).lmrequest { responseModel in
            guard let list = [UsInfoItem].deserialize(from: responseModel.data as? [Any]) else { return }
            self.seatSequenceList = list
            block(true, "")
        } failureBlock: { error in
            block(false, error.message)
        }
    }
    func startPlayingRoomPKStream() {
        guard let invitePkInfo = self.roomItem.roomPkInfo, let userId = self.roomItem.seatList[0].userInfo?.userId else {
            return
        }
        if let keys = invitePkInfo.roomMap?.map({ $0.key }) {
            for string in keys {
                if string == roomItem.roomId {
                } else {
                    RTCService.shared.startPlayingStream(string, userId: userId)
                }
            }
        }
    }
    func stopRoomPkPublishingStream() {
        guard let invitePkInfo = self.roomItem.roomPkInfo, let userId = self.roomItem.seatList[0].userInfo?.userId else {
            return
        }
        if let keys = invitePkInfo.roomMap?.map({ $0.key }) {
            for string in keys {
                if string == roomItem.roomId {
                } else {
                    RTCService.shared.stopPlayingStream(string, userId: userId)
                }
            }
        }
    }
}
extension VoiceVM {
    func isUserOnSeat(_ userId: String) -> Bool {
        for seat in self.seats {
            if let user = seat.userInfo, user.userId == userId {
                return true
            }
        }
        return false
    }
    func isHostSeat(_ userId: String?) -> Bool {
        if userId == nil || userId?.count == 0 {
            return false
        }
        for seat in self.seats {
            if let user = seat.userInfo, user.userId == userId, seat.seatIndex == 0 {
                return true
            }
        }
        return false
    }
    func isOnSeat() -> Bool {
        if let user = UserShared.user {
            return isUserOnSeat(user.userId)
        }
        return false
    }
    func userSeatInfo(_ userId: String?) ->RoomSeatItem? {
        guard let userId = userId else { return nil }
        for seat in self.seats {
            if let user = seat.userInfo, user.userId == userId {
                return seat
            }
        }
        return nil
    }
    func userSeatSequenceInfo(_ userId: String?) -> UsInfoItem? {
        guard let userId = userId else { return nil }
        for user in self.seatSequenceList {
            if user.userId == userId {
                return user
            }
        }
        return nil
    }
    func getRoomMoreItems() -> [LMRMMoreSectionModel] {
        var dataSource: [LMRMMoreSectionModel] = []
        if self.roomItem.role == .host || self.roomItem.role == .owner {
            var items: [LMRMMoreItemModel] = []
            items.append(LMRMMoreItemModel(type: .pkSet, cellType: .itemW, title: "PK", imageName: "rm_more_pk"))
            if roomItem.roomType == .normal || roomItem.roomType == .party {
                if isHostSeat(UserShared.user?.userId) {
                }
            }
            items.append(LMRMMoreItemModel(type: .waterList, cellType: .itemW, title: "流水", imageName: "rm_more_water"))
            if self.roomItem.role == .owner {
                items.append(LMRMMoreItemModel(type: .close, cellType: .itemW, title: "关播", imageName: "rm_more_close"))
            }
            dataSource.append(LMRMMoreSectionModel(title: "", dataSource: items))
        }
        var items: [LMRMMoreItemModel] = []
        items.append(LMRMMoreItemModel(type: .mini, title: "收起", imageName: "rm_more_mini"))
        items.append(LMRMMoreItemModel(type: .quite, title: "退出", imageName: "rm_more_quite"))
        if getMuteState() {
            items.append(LMRMMoreItemModel(type: .muteOn, title: "开启中", imageName: "rm_more_mute"))
        } else {
            items.append(LMRMMoreItemModel(type: .muteOn, title: "关闭中", imageName: "rm_more_mute_s"))
        }
        if getAnimationState() {
            items.append(LMRMMoreItemModel(type: .aniSet, title: "打开动效", imageName: "rm_more_animation"))
        } else {
            items.append(LMRMMoreItemModel(type: .aniSet, title: "关闭动效", imageName: "rm_more_animation_s"))
        }
        items.append(LMRMMoreItemModel(type: .clearChat, title: "清屏", imageName: "rm_more_clear"))
        dataSource.append(LMRMMoreSectionModel(title: "", dataSource: items))
        if self.roomItem.role == .host || self.roomItem.role == .owner {
            var otheritems: [LMRMMoreItemModel] = []
            otheritems.append(LMRMMoreItemModel(type: .role, cellType: .vertical, title: "管理员", imageName: "rm_more_role"))
            otheritems.append(LMRMMoreItemModel(type: .bid, cellType: .vertical, title: "禁言用户", imageName: "rm_more_bid"))
            otheritems.append(LMRMMoreItemModel(type: .clearStar, cellType: .vertical, title: "清空心动值", imageName: "rm_more_clearValue"))
            dataSource.append(LMRMMoreSectionModel(title: "", dataSource: otheritems))
        }
        dataSource.append(LMRMMoreSectionModel(title: "", dataSource: [LMRMMoreItemModel(type: .report, cellType: .vertical, title: "举报", imageName: "rm_more_report")]))
        return dataSource
    }
    func getMuteState() -> Bool {
        UserDefaults().bool(forKey: UserDefaultKeys.roomMuteState)
    }
    func set_MuteState(_ state: Bool) {
        RTCService.shared.muteSpeaker(state)
        UserDefaults().set(state, forKey: UserDefaultKeys.roomMuteState)
    }
    func getAnimationState() -> Bool {
        UserDefaults().bool(forKey: UserDefaultKeys.roomAnimationState)
    }
    func set_AnimationState(_ state: Bool) {
        UserDefaults().set(state, forKey: UserDefaultKeys.roomAnimationState)
    }
    func request(_ request: BaseTargetType, successBlock: @escaping LMHttpSuccess, failureBlock: @escaping LMHttpFailure) {
        request.lmrequest { responseModel in
            successBlock(responseModel)
        } failureBlock: { error in
            failureBlock(error)
        }
    }
}
