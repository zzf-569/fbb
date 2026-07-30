import Foundation


extension VoiceVC {
    
    func entryRoom() {
        self.viewModel.enterRoom {
            for seat in self.viewModel.roomItem.seatList {
                if var user = seat.userInfo {
                    user.streamId = self.viewModel.roomItem.roomId + "_" + user.userId
                }
            }
            switch self.viewModel.roomItem.roomType {
            case .dispatch:
                let demandInfo = self.viewModel.roomItem.demandInfo
                self.PDViewModel = LMRMPDViewModel()
                if let status = RoomPDStatus(rawValue: demandInfo?["status"] as? Int ?? 0) {
                    self.PDViewModel?.status = status
                } else {
                    self.PDViewModel?.status = .normal
                }
                let demand = DispatchItem.deserialize(from: demandInfo?["demand"] as? [String: Any])
                self.PDViewModel?.DispatchItem = demand
            case .normal, .party:
                self.pkViewModel = LMRMPKViewModel()
                if
                    self.viewModel.roomItem.pk,
                    let pkModel = RoomPKModel.deserialize(from:self.viewModel.roomItem.pkInfo) {
                    self.pkViewModel?.dataSoure = pkModel
                    if self.pkViewModel?.dataSoure.status == .start {
                        let timeString = self.pkViewModel?.getTimeString()
                        if timeString == nil {
                            lmPrint("PK 已结束")
                            self.pkViewModel?.dataSoure.status = .end
                            if let campValueMap = self.pkViewModel?.dataSoure.campValueMap {
                                if campValueMap.blue.pkValue == campValueMap.red.pkValue {
                                    self.pkViewModel?.dataSoure.result = .dogfall
                                } else if campValueMap.blue.pkValue > campValueMap.red.pkValue {
                                    self.pkViewModel?.dataSoure.result = .blue
                                } else {
                                    self.pkViewModel?.dataSoure.result = .red
                                }
                            }
                        }
                    }
                    self.viewModel.roomItem.seatList = self.viewModel.roomItem.seatList
                }
            default:
                break
            }
            self.viewModel.roomItem.gameStatus = self.viewModel.roomItem.gameId == 0 ? .normal : .isGame
            if let inviteInfo = self.viewModel.roomItem.roomPkInfo {
                self.roomPkModel = LMinvitePkViewModel()
                self.roomPkModel.dataSoure = inviteInfo
            }
            
            self.configData()
            self.roomView.moreView.setDataSoure(self.viewModel.getRoomMoreItems())
            self.roomView.sequenceView.role = self.viewModel.roomItem.role
            self.roomView.sequenceView.setDataSoure(self.viewModel.seatSequenceList)
            
        }
        self.roomView.giftView = LMRMSendGiftPopController(roomId: viewModel.roomItem.roomId)

        LMFloatingManager.shared.set_SuperView(view)
        giftTrackManager.set_SuperView(roomView)
        LMRMWelcomeManager.shared.set_SuperView(roomView.chatListView)
    }
    func configData() {
        self.roomView.set_UIinfo(viewModel, pkViewModel: pkViewModel, roomPkModel: roomPkModel)
        
        self.roomView.bottomView.newJoinSort(self.viewModel)
        self.roomView.chatListView.addMessage(VoiceChatListModel(style: .notice,roomId: viewModel.roomId, info: "平台倡导绿色直播，内容凡涉及黄赌毒政等将被封号处理。严厉打击诈骗行为，请广大用户谨防陌生用户以任何名义索取钱财和密码及短信验证码，避免损失！网警 24 小时在线巡查。"))
        if viewModel.roomItem.notification.count > 0 {
            self.roomView.chatListView.addMessage(VoiceChatListModel(style: .notice,roomId: viewModel.roomId, info: viewModel.roomItem.notification))
        }
        if let user = UserShared.user {
            self.roomView.chatListView.addMessage(VoiceChatListModel(style: .join,roomId: viewModel.roomId, info: user))
        }
        if viewModel.roomItem.roomType == .dispatch {
            self.roomView.seatView.set_DispatchStatus(viewModel, PDViewModel: PDViewModel)
            self.daRenView?.role = self.viewModel.roomItem.role
            self.PDViewModel?.enterRoom(roomId: viewModel.roomItem.roomId, block: { [weak self] in
                guard let self = self else { return }
                self.daRenView?.setDataSoure(self.PDViewModel?.sequenceList ?? [])
                self.roomView.seatView.set_DaRenCount(PDViewModel?.sequenceList.count ?? 0)
            })
        }
        if let pkViewModel = pkViewModel {
            if pkViewModel.dataSoure.status == .start {
                startPKTimer()
            }
        }
        if viewModel.roomItem.roomPkInfo != nil {
            startCrossPKTimer()
            self.roomView.seatView.set_RoomPKValue(self.viewModel.roomItem)
        }
        
        let userId = UserShared.user?.userId
        if viewModel.isHostSeat(userId) {
            self.roomView.showPkInviteinfo(self.viewModel.roomItem.inviteInfo)
        } else {
            self.roomView.showPkInviteinfo(nil)
        }
        self.updateBanner()
        self.getOnlineUser()
        
    }
    func switchRoom(_ model:RoomItem) {
        viewModel.exitRoom { [weak self] in
            guard let self = self else { return }
            self.viewModel.roomItem = model
            self.entryRoom()
        }
    }
}
