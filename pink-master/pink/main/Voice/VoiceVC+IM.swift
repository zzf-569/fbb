import Foundation
extension VoiceVC: IMServiceDelegate {
    
    
    @objc func nt_receiveImNewMessage(notification: NSNotification) {
        guard let msgModel = notification.userInfo?["msg"] as? IMMessageModel else { return }
        if let _ = msgModel.roomId {
            handlePrivateChatMessage(msgModel)
        }
    }
    
    
    func d_imNewGroupMessage(_ message: IMMessageModel?) {
        guard let msgModel = message else { return }
        if let _ = msgModel.roomId {
            handleRoomMessage(msgModel)
        }
        if let _ = msgModel.roomId {
            handlePrivateChatMessage(msgModel)
        }
    }
    
    
    @objc func nt_imUnreadMessageCountChange(notification: NSNotification) {
        guard let count = notification.userInfo?["count"] as? Int else { return }
        self.roomView.bottomView.set_MessageCount(count)
    }
    
    
    func handleRoomMessage(_ msgModel: IMMessageModel) {
        guard let roomId = msgModel.roomId,roomId == self.viewModel.roomItem.imRoomId else { return }
        switch msgModel.type {
        case .close_mic:
            guard let seatList = [RoomSeatItem].deserialize(from: msgModel.msgDict["seatList"] as? [[String: Any]]) else { return  }
            self.viewModel.roomItem.seatList = seatList
            let user = UsInfoItem.deserialize(from: msgModel.msgDict["userInfo"] as? [String: Any])
            if let userId = user?.userId, userId == UserShared.user?.userId {
                RTCService.shared.muteMicrophone(true)
            }
            self.roomView.seatView.set_Seats(self.viewModel.seats)
            self.roomView.topView.set_Seats(self.viewModel.seats)
            self.roomView.bottomView.setDataSoure(viewModel)
            if viewModel.roomItem.roomType == .dispatch, PDViewModel?.status == .audition {
                if let userId = user?.userId, let seat = seatList.first(where: { $0.userInfo?.userId == userId }) {
                    if seat.seatIndex != 0, seat.seatIndex != 8 {
                        if seat.seatIndex == 7 {
                            roomView.seatView.updateAuditionSeatUser(seat)
                        } else {
                            if let nextSeat = viewModel.seats.first(where: { $0.seatIndex > seat.seatIndex && $0.seatIndex < 7 && $0.userInfo?.userId != nil }) {
                                roomView.seatView.updateAuditionSeatUser(nextSeat)
                            }
                        }
                    }
                }
            }
        case .open_mic:
            guard let seatList = [RoomSeatItem].deserialize(from: msgModel.msgDict["seatList"] as? [[String: Any]]) else { return  }
            self.viewModel.roomItem.seatList = seatList
            let user = UsInfoItem.deserialize(from: msgModel.msgDict["userInfo"] as? [String: Any])
            if let userId = user?.userId, userId == UserShared.user?.userId {
                RTCService.shared.muteMicrophone(false)
            }
            self.roomView.seatView.set_Seats(self.viewModel.seats)
            self.roomView.topView.set_Seats(self.viewModel.seats)
            self.roomView.bottomView.setDataSoure(viewModel)
            if viewModel.roomItem.roomType == .dispatch, PDViewModel?.status == .audition {
                if let userId = user?.userId, let seat = seatList.first(where: { $0.userInfo?.userId == userId }) {
                    if seat.seatIndex != 0, seat.seatIndex != 8 {
                        roomView.seatView.updateAuditionSeatUser(seat)
                    }
                }
            }
        case .set_admin:
            guard let user = UsInfoItem.deserialize(from: msgModel.msgDict["user"] as? [String: Any]) else { return }
            if user.userId == UserShared.user?.userId {
                viewModel.roomItem.role = .admin
                self.roomView.sequenceView.role = self.viewModel.roomItem.role
                self.roomView.bottomView.setDataSoure(viewModel)
                self.roomView.moreView.setDataSoure(self.viewModel.getRoomMoreItems())
                self.roomView.bottomView.newJoinSort(self.viewModel)
            }
        case .cancel_admin :
            guard let user = UsInfoItem.deserialize(from: msgModel.msgDict["user"] as? [String: Any]) else { return }
            if user.userId == UserShared.user?.userId {
                viewModel.roomItem.role = .audience
                self.roomView.sequenceView.role = self.viewModel.roomItem.role
                self.roomView.bottomView.setDataSoure(viewModel)
                self.roomView.moreView.setDataSoure(self.viewModel.getRoomMoreItems())
                self.roomView.bottomView.newJoinSort(self.viewModel)
            }
        case .set_chair:
            guard let user = UsInfoItem.deserialize(from: msgModel.msgDict["user"] as? [String: Any]) else { return }
            if user.userId == UserShared.user?.userId {
                viewModel.roomItem.role = .host
                self.roomView.sequenceView.role = self.viewModel.roomItem.role
                self.roomView.bottomView.setDataSoure(viewModel)
                self.roomView.moreView.setDataSoure(self.viewModel.getRoomMoreItems())
                self.roomView.bottomView.newJoinSort(self.viewModel)
            }
        case .cancel_chair:
            guard let user = UsInfoItem.deserialize(from: msgModel.msgDict["user"] as? [String: Any]) else { return }
            if user.userId == UserShared.user?.userId {
                viewModel.roomItem.role = .audience
                self.roomView.sequenceView.role = self.viewModel.roomItem.role
                self.roomView.bottomView.setDataSoure(viewModel)
                self.roomView.moreView.setDataSoure(self.viewModel.getRoomMoreItems())
                self.roomView.bottomView.newJoinSort(self.viewModel)
            }
        case .upseat:
            guard let seatList = [RoomSeatItem].deserialize(from: msgModel.msgDict["seatList"] as? [[String: Any]]) else { return  }
            self.viewModel.roomItem.seatList = seatList
            let user = UsInfoItem.deserialize(from: msgModel.msgDict["userInfo"] as? [String: Any])
            if let userId = user?.userId, userId == UserShared.user?.userId {
                self.viewModel.onSeat()
                if viewModel.roomItem.roomType == .dispatch {
                    daRenView?.isOnSeat = true
                }
                if let _ = seatList.first(where: { $0.userInfo?.userId == userId && $0.seatIndex == 0 }) {
                    self.roomView.showPkInviteinfo(self.viewModel.roomItem.inviteInfo)
                }
                self.roomView.moreView.setDataSoure(self.viewModel.getRoomMoreItems())
            }
            if viewModel.roomItem.roomPkInfo != nil {
                self.roomView.seatView.set_PkView(viewModel)
            }
            self.roomView.seatView.set_Seats(self.viewModel.seats)
            self.roomView.topView.set_Seats(self.viewModel.seats)
            self.roomView.bottomView.setDataSoure(viewModel)
            self.roomView.giftView.set_Seats(viewModel.seats,roomItem: viewModel.roomItem)
            if viewModel.roomItem.roomType == .dispatch {
                if let userId = user?.userId, userId == UserShared.user?.userId, viewModel.isHostSeat(userId) {
                    self.roomView.seatView.set_DispatchStatus(viewModel, PDViewModel: PDViewModel)
                }
            }
        case .down_seat:
            guard let seatList = [RoomSeatItem].deserialize(from: msgModel.msgDict["seatList"] as? [[String: Any]]) else { return  }
            let tempSeatList = self.viewModel.roomItem.seatList
            self.viewModel.roomItem.seatList = seatList
            let user = UsInfoItem.deserialize(from: msgModel.msgDict["userInfo"] as? [String: Any])
            if let userId = user?.userId, userId == UserShared.user?.userId {
                self.viewModel.downSeat()
                if viewModel.roomItem.roomType == .dispatch {
                    daRenView?.isOnSeat = false
                }
                self.roomView.showPkInviteinfo(nil)
                self.roomView.moreView.setDataSoure(self.viewModel.getRoomMoreItems())
            }
            if viewModel.roomItem.roomPkInfo != nil {
                self.roomView.seatView.set_PkView(viewModel)
            }
            self.roomView.seatView.set_Seats(self.viewModel.seats)
            self.roomView.topView.set_Seats(self.viewModel.seats)
            self.roomView.bottomView.setDataSoure(viewModel)
            self.roomView.giftView.set_Seats(viewModel.seats,roomItem: viewModel.roomItem)
            if viewModel.roomItem.roomType == .dispatch {
                if let userId = user?.userId, userId == UserShared.user?.userId, let _ = tempSeatList.first(where: { $0.userInfo?.userId == userId && $0.seatIndex == 0 }) {
                    self.roomView.seatView.set_DispatchStatus(viewModel, PDViewModel: PDViewModel)
                }
                if PDViewModel?.status == .audition {
                    self.roomView.seatView.auditionUserDownSeat(user?.userId ?? "")
                }
            }
        case .lock:
            guard let seatList = [RoomSeatItem].deserialize(from: msgModel.msgDict["seatList"] as? [[String: Any]]) else { return  }
            self.viewModel.roomItem.seatList = seatList
            self.roomView.seatView.set_Seats(self.viewModel.seats)
            self.roomView.topView.set_Seats(self.viewModel.seats)
        case .unlock:
            guard let seatList = [RoomSeatItem].deserialize(from: msgModel.msgDict["seatList"] as? [[String: Any]]) else { return  }
            self.viewModel.roomItem.seatList = seatList
            self.roomView.seatView.set_Seats(self.viewModel.seats)
            self.roomView.topView.set_Seats(self.viewModel.seats)
        case .mic_change:
            viewModel.updateSeatSequences { isSuccess, _ in
                if isSuccess {
                    self.roomView.sequenceView.setDataSoure(self.viewModel.seatSequenceList)
                    self.roomView.bottomView.newJoinSort(self.viewModel)
                    guard let user = UsInfoItem.deserialize(from: msgModel.msgDict["userInfo"] as? [String: Any]) else { return }
                    if user.userId == UserShared.user?.userId {
                        self.roomView.bottomView.setDataSoure(self.viewModel)
                        if let _ = VoiceShared.roomViewController?.viewModel.userSeatInfo(UserShared.user?.userId) {
                        } else {
                        }
                    }
                }
            }
        case .send_animation_gift:
            self.roomView.chatListView.addMessage(VoiceChatListModel(messageModel: msgModel))
            guard let model = SuiteAnimationModel.deserialize(from: msgModel.msgDict["data"] as? [String: Any]) else { return }
            let state = viewModel.getAnimationState()
            if model.needAnimation, !state {
                self.roomView.giftAniView.addAnimation(model)
            }
            if !state {
                guard let userId = (msgModel.msgDict["data"] as? [String: Any])?["userId"] as? String,
                      let toUserId = (msgModel.msgDict["data"] as? [String: Any])?["toUserId"] as? String,
                      let giftIcon = (msgModel.msgDict["data"] as? [String: Any])?["iconUrl"] as? String else { return }
                giftTrackManager.add(LMRMGiftTrackModel(userId: userId, toUserIds: [toUserId], giftIcon: giftIcon))
            }
        case .float_screen_gift:
            LMFloatingManager.shared.add(LMFloatingModel(message: msgModel))
        case .all_float_screen_gift:
            LMFloatingManager.shared.add(LMFloatingModel(message: msgModel))
        case.roomInfoUpdate :
            guard let infoDict = msgModel.msgDict["roomInfo"] as? [String: Any] else { return  }
            viewModel.roomItem.roomName = infoDict["roomName"] as? String ?? ""
            viewModel.roomItem.cover = infoDict["cover"] as? String ?? ""
            viewModel.roomItem.notification = infoDict["notification"] as? String ?? ""
            viewModel.roomItem.background = infoDict["background"] as? String ?? ""
            self.roomView.topView.setDataSoure(viewModel.roomItem)
        case .mic_special_change:
            PDViewModel?.updateDaRenlist(roomId: viewModel.roomId, block: { [weak self] in
                guard let self = self else { return }
                self.daRenView?.setDataSoure(self.PDViewModel?.sequenceList ?? [])
                self.daRenView?.isInSequence = PDViewModel?.isInSequence ?? false
                self.roomView.seatView.set_DaRenCount(PDViewModel?.sequenceList.count ?? 0)
                self.roomView.seatView.newUserJoinAuditionSequence(viewModel, PDViewModel: PDViewModel)
            })
        case .clear_seat:
            guard let seatList = [RoomSeatItem].deserialize(from: msgModel.msgDict["seatList"] as? [[String: Any]]) else { return  }
            self.viewModel.roomItem.seatList = seatList
            let userIdList = msgModel.msgDict["userIdList"] as? [Int]
            if (userIdList?.first(where: { $0.toString() == UserShared.user?.userId })) != nil {
                self.viewModel.downSeat()
                if viewModel.roomItem.roomType == .dispatch {
                    daRenView?.isOnSeat = false
                }
            }
            self.roomView.seatView.set_Seats(self.viewModel.seats)
            self.roomView.topView.set_Seats(self.viewModel.seats)
            self.roomView.bottomView.setDataSoure(viewModel)
            self.roomView.giftView.set_Seats(viewModel.seats,roomItem: viewModel.roomItem)
        case .auto_upseat:
            guard let seatList = [RoomSeatItem].deserialize(from: msgModel.msgDict["seatList"] as? [[String: Any]]) else { return  }
            self.viewModel.roomItem.seatList = seatList
            let userIdList = msgModel.msgDict["userIdList"] as? [Int]
            if (userIdList?.first(where: { $0.toString() == UserShared.user?.userId })) != nil {
                self.viewModel.onSeat()
                if viewModel.roomItem.roomType == .dispatch {
                    daRenView?.isOnSeat = true
                }
            }
            self.roomView.seatView.set_Seats(self.viewModel.seats)
            self.roomView.topView.set_Seats(self.viewModel.seats)
            self.roomView.bottomView.setDataSoure(viewModel)
            self.roomView.giftView.set_Seats(viewModel.seats,roomItem: viewModel.roomItem)
        case .update_rm_dispatch_status:
            if let status = RoomPDStatus(rawValue: msgModel.msgDict["status"] as? Int ?? 0) {
                self.PDViewModel?.status = status
            } else {
                self.PDViewModel?.status = .normal
            }
            let demand = DispatchItem.deserialize(from: msgModel.msgDict["demandInfo"] as? [String: Any])
            self.PDViewModel?.DispatchItem = demand
            self.roomView.seatView.set_DispatchStatus(viewModel, PDViewModel: PDViewModel)
        case .pk_open_status:
            guard let pkInfo = msgModel.msgDict["pkInfo"] as? [String: Any] else { return }
            guard let status = RMPKStatusEnum(rawValue: pkInfo["status"] as? Int ?? -1) else { return }
            pkViewModel?.dataSoure.status = status
            viewModel.roomItem.seatList = viewModel.roomItem.seatList
            roomView.set_PkStatus(viewModel, pkViewModel: pkViewModel)
            roomView.seatView.set_Seats(viewModel.seats)
            self.roomView.topView.set_Seats(self.viewModel.seats)
        case .pk_value_change :
            guard let pkModel = RoomPKModel.deserialize(from: msgModel.msgDict["pkInfo"] as? [String: Any]) else { return }
            pkViewModel?.dataSoure = pkModel
            if let pkViewModel = pkViewModel {
                roomView.updatePKValue(pkViewModel)
            }
        case .pk_stepchange:
            guard let pkModel = RoomPKModel.deserialize(from: msgModel.msgDict["pkInfo"] as? [String: Any]) else { return }
            if pkModel.status == .start || pkModel.status == .end {
                pkViewModel?.dataSoure = pkModel
                if pkModel.status == .start {
                    for (index, _) in viewModel.roomItem.seatList.enumerated() {
                        viewModel.roomItem.seatList[index].seatValue = 0
                    }
                    roomView.seatView.set_Seats(viewModel.seats)
                    roomView.topView.set_Seats(self.viewModel.seats)
                }
                if pkModel.status == .end {
                    pkViewModel?.set_upEndPK()
                }
                roomView.set_PkStatus(viewModel, pkViewModel: pkViewModel)
                if let pkViewModel = pkViewModel {
                    roomView.updatePKValue(pkViewModel)
                }
            }
            if pkViewModel?.dataSoure.status == .start {
                startPKTimer()
            }
            if pkViewModel?.dataSoure.status == .end {
                endPKTimer()
            }
        case .hot_value:
            guard let seatList = [RoomSeatItem].deserialize(from: msgModel.msgDict["seatList"] as? [[String: Any]]) else { return  }
            self.viewModel.roomItem.seatList = seatList
            let seat = seatList[0]
            if seat.seatIndex == -1 {
                if seat.mute == true {
                    self.viewModel.stopRoomPkPublishingStream()
                } else {
                    self.viewModel.startPlayingRoomPKStream()
                }
            }
            self.roomView.seatView.set_Seats(self.viewModel.seats)
            self.roomView.seatView.set_PkView(self.viewModel)
            self.roomView.topView.set_Seats(self.viewModel.seats)
            
        case .only_hot_value:
            let hotValue = msgModel.msgDict["hotValue"] as? Int ?? 0
            viewModel.roomItem.hotValue = hotValue
            roomView.topView.setDataSoure(viewModel.roomItem)
        case .join:
            guard let user = UsInfoItem.deserialize(from: msgModel.msgDict["user"] as? [String: Any]), user.userId != UserShared.user?.userId else { return }
            self.roomView.chatListView.addMessage(VoiceChatListModel(messageModel: msgModel))
            guard let user = VoiceChatListModel(messageModel: msgModel).user else {
                return
            }
            if user.richLevel > 10 {
                LMRMWelcomeManager.shared.add(user)
            }
        case .at_msg:
            self.roomView.chatListView.addMessage(VoiceChatListModel(messageModel: msgModel))
        case .text_msg:
            self.roomView.chatListView.addMessage(VoiceChatListModel(messageModel: msgModel))
        case .face_msg:
            let model = VoiceChatListModel(messageModel: msgModel)
            guard let emojiModel = model.emojiModel else { return }
            guard let user = model.user else { return }
            if let seat = viewModel.userSeatInfo(user.userId) {
                self.roomView.seatView.playEmoji(emojiModel, seatIndex: seat.seatIndex)
            }
            self.roomView.chatListView.addMessage(model)
        case .close_room:
            if self.viewModel.roomItem.role != .owner {
                let view = LMRMClosePopVC()
                view.setDataSoure(headImage: self.viewModel.roomItem.cover,RoomName: self.viewModel.roomItem.roomName, peoNum: "")
                view.show()
                VoiceService.shared.removeFloatingView()
            }
        case .game_status:
            guard let status = msgModel.msgDict["status"] as? String, status == "1" else {
                self.viewModel.roomItem.gameStatus = .normal
                self.viewModel.roomItem.gameId = 0
                self.roomView.set_UIinfo(viewModel, pkViewModel: pkViewModel, roomPkModel: roomPkModel)
                return
            }
            let gameId = msgModel.msgDict["gameId"] as? Int
            self.viewModel.roomItem.gameStatus = .isGame
            self.viewModel.roomItem.gameId = gameId ?? 0
            self.roomView.set_UIinfo(viewModel, pkViewModel: pkViewModel, roomPkModel: roomPkModel)
        case .send_dress:
            self.roomView.chatListView.addMessage(VoiceChatListModel(messageModel: msgModel))
            let state = viewModel.getAnimationState()
            if !state {
                guard let userId = (msgModel.msgDict["data"] as? [String: Any])?["userId"] as? String,
                      let toUserId = (msgModel.msgDict["data"] as? [String: Any])?["toUserId"] as? String,
                      let giftIcon = (msgModel.msgDict["data"] as? [String: Any])?["dressUpIcon"] as? String else { return }
                giftTrackManager.add(LMRMGiftTrackModel(userId: userId, toUserIds: [toUserId], giftIcon: giftIcon))
            }
        case .seat_userRefresh:
            guard let seatList = [RoomSeatItem].deserialize(from: msgModel.msgDict["seatList"] as? [[String: Any]]) else { return  }
            self.viewModel.roomItem.seatList = seatList
            let user = UsInfoItem.deserialize(from: msgModel.msgDict["userInfo"] as? [String: Any])
            if let userId = user?.userId, userId == UserShared.user?.userId {
                self.viewModel.onSeat()
                if viewModel.roomItem.roomType == .dispatch {
                    daRenView?.isOnSeat = true
                }
            }
            self.roomView.seatView.set_Seats(self.viewModel.seats)
            self.roomView.topView.set_Seats(self.viewModel.seats)
            self.roomView.bottomView.setDataSoure(viewModel)
            self.roomView.giftView.set_Seats(viewModel.seats,roomItem: viewModel.roomItem)
            if viewModel.roomItem.roomType == .dispatch {
                if let userId = user?.userId, userId == UserShared.user?.userId, viewModel.isHostSeat(userId) {
                    self.roomView.seatView.set_DispatchStatus(viewModel, PDViewModel: PDViewModel)
                }
            }
        case .changeBGI:
            let background = msgModel.msgDict["background"] as? String ?? ""
            self.roomView.changeBackGround(url: background)
        case .pk_invite:
            guard let inviteInfo = inviteInfo.deserialize(from: msgModel.msgDict["inviteInfo"] as? [String: Any]) else {
                self.viewModel.roomItem.inviteInfo = nil
                self.roomView.showPkInviteinfo(nil)
                return
            }
            if inviteInfo.type == .reject || inviteInfo.type == .cancel {
                self.viewModel.roomItem.inviteInfo = nil
                self.roomView.showPkInviteinfo(nil)
                return
            }
            if viewModel.isHostSeat(UserShared.user?.userId) == false {
                self.viewModel.roomItem.inviteInfo = inviteInfo
                self.roomView.showPkInviteinfo(nil)
                return
            }
            self.viewModel.roomItem.inviteInfo = inviteInfo
            self.roomView.showPkInviteinfo(inviteInfo)
        case .pk_cancle:
            self.viewModel.roomItem.inviteInfo = nil
            self.roomView.showPkInviteinfo(nil)
        case .roompk_star:
            guard let RoomPkInfo = invitePkInfo.deserialize(from: msgModel.msgDict["roomPkInfo"] as? [String: Any]) else { return  }
            if roomPkModel.dataSoure.status == .end,RoomPkInfo.status != .close {
                return
            }
            if RoomPkInfo.roomMap == nil {
                if viewModel.roomItem.roomPkInfo == nil {
                    return
                }
                self.viewModel.roomItem.roomPkInfo = nil
                self.roomPkModel.dataSoure = invitePkInfo()
                self.roomView.showPkInviteinfo(nil)
                self.viewModel.roomItem.seatList = RoomPkInfo.seatList ?? []
                roomPkModel.clearTimer()
                self.roomView.set_UIinfo(viewModel, pkViewModel: pkViewModel, roomPkModel: roomPkModel)
                return
            }
            if viewModel.roomItem.roomPkInfo == nil {
                self.viewModel.roomItem.roomPkInfo = RoomPkInfo
                self.roomPkModel.dataSoure = RoomPkInfo
                self.viewModel.roomItem.seatList = RoomPkInfo.seatList ?? []
                self.viewModel.roomItem.inviteInfo = nil
                self.roomView.showPkInviteinfo(nil)
                self.roomView.set_UIinfo(viewModel, pkViewModel: pkViewModel, roomPkModel: roomPkModel)
                self.startCrossPKTimer()
                return
            }
            if viewModel.roomItem.roomPkInfo?.status == .start,RoomPkInfo.status == .start {
                self.viewModel.roomItem.roomPkInfo = RoomPkInfo
                self.roomPkModel.dataSoure = RoomPkInfo
                self.roomView.seatView.set_RoomPKValue(self.viewModel.roomItem)
                return
            }
       
        default:
            break
        }
    }
    
    func handlePrivateChatMessage(_ messageModel: IMMessageModel) {
        
    }
}
