import Foundation
import AttributedString
import TUIChat

extension VoiceVC {
    func configMether() {
        Mediator.shared.register(event: LMRMViewMethon.topOnlineUserAction) { (message: String) in
            LMOnlinePopVC.show(roomId: self.viewModel.roomId, role: self.viewModel.roomItem.role) { [weak self] user in
                guard let self = self else { return }
                showUserCard(user.userId)
            } onSeatblock: { [weak self] user in
                guard let self = self else { return }
                var items = [LMSheetItemModel]()
                for seat in self.viewModel.seats where seat.seatIndex > 0 {
                    if let user = seat.userInfo, user.userId.count > 0 {
                        if seat.seatIndex == 8 {
                            items.append(LMSheetItemModel(title: "8号麦", imageName: "rm_sheet_seat_boss_n", isEnable: false, index: seat.seatIndex))
                        } else {
                            items.append(LMSheetItemModel(title: "号麦", imageName: "rm_sheet_seat_\(seat.seatIndex)_n", isEnable: false, index: seat.seatIndex))
                        }
                    } else {
                        if seat.seatIndex == 8 {
                            items.append(LMSheetItemModel(title: "8号麦", imageName: "rm_sheet_seat_boss", isEnable: true, index: seat.seatIndex))
                        } else {
                            items.append(LMSheetItemModel(title: "号麦", imageName: "rm_sheet_seat_\(seat.seatIndex)", isEnable: true, index: seat.seatIndex))
                        }
                    }
                }
                LMSheetCollectionVC.show(theme: .light, title: user.nickname, items: items, cancel: "取消") { [weak self] item in
                    guard let self = self else { return }
                    guard let item = item, item.isEnable else { return }
                    HUD.showLoading()
                    self.viewModel.request(RoomNetWork.operateUserSeat(roomId: self.viewModel.roomItem.roomId, toUserId: user.userId, upSeat: true, seatIndex: item.index) ) { _ in
                        HUD.hide()
                    } failureBlock: { error in
                        HUD.showFailure(error.message)
                    }
                }
            }
        }
        Mediator.shared.register(event: LMRMViewMethon.topRankAction) { (message: String) in
            let view = LMRMRankView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            self.view.addSubview(view)
            view.show()
        }
        Mediator.shared.register(event: LMRMViewMethon.topNoticeAction) { (message: String) in
            VoiceDeailView(model: self.viewModel.roomItem, role: self.viewModel.roomItem.role).show()
        }
        Mediator.shared.register(event: LMRMViewMethon.topCollectAction) { (message: String) in
            HUD.showLoading()
            self.viewModel.request(RoomNetWork.like(roomId: self.viewModel.roomItem.roomId, liked:self.viewModel.roomItem.like)) { _ in
                HUD.hide()
            } failureBlock: { _ in
            }
        }
        Mediator.shared.register(event: LMRMViewMethon.clickMoreAction) { (message: String) in
            self.roomView.moreView.show()
        }
        Mediator.shared.register(event: LMRMViewMethon.seatClickAction) { (message: [String: Any]) in
            let index = message["seatIndex"] as! Int
            let view = message["seatView"] as! UIView
            lmPrint("选中 \(index)号麦")
            if self.viewModel.roomItem.role == .audience {
                if let currentSeatUser = self.viewModel.seats[index].userInfo {
                    self.showUserCard(currentSeatUser.userId)
                } else {
                    if let seat = self.viewModel.userSeatInfo(UserShared.user?.userId),
                       let _ = seat.userInfo {
                    } else {
                        if self.viewModel.roomItem.roomType == .dispatch, index != 0, index != 8 {
                            HUD.showLoading()
                            RoomPDApi.applyDaRenlist(roomId: self.viewModel.roomId, seatIndex: nil).lmrequest { _ in
                                HUD.showSuccess("已排挡")
                            } failureBlock: { error in
                                HUD.showFailure(error.message)
                            }
                        } else {
                            HUD.showLoading()
                            self.viewModel.applyOnSeat(index) { isSuccess, msg in
                                if isSuccess {
                                    HUD.showSuccess(msg)
                                } else {
                                    HUD.showFailure(msg)
                                }
                            }
                        }
                    }
                }
            } else {
                var items: [LMSheetTabModel] = []
                let currentSeat = self.viewModel.seats[index]
                if let currentSeatUser = currentSeat.userInfo {
                    if currentSeatUser.userId != UserShared.user?.userId {
                        guard let user = currentSeat.userInfo else { return }
                        self.showUserCard(user.userId)
                        return
                    } else {
                        items.append(LMSheetTabModel(title: "下麦"))
                        if currentSeat.mute {
                            items.append(LMSheetTabModel(title: "开麦"))
                        } else {
                            items.append(LMSheetTabModel(title: "闭麦"))
                        }
                    }
                } else {
                    items.append(LMSheetTabModel(title: "上麦"))
                    if currentSeat.locked {
                        items.append(LMSheetTabModel(title: "解锁"))
                    } else {
                        items.append(LMSheetTabModel(title: "锁定"))
                    }
                }
                let window = UIApplication.shared.delegate?.window!
                LMSheetTableVC(title: nil, dataSource: items, cancel: "取消") { model in
                    if model?.title == "上麦" {
                        guard let _ = UserShared.user else { return }
                        HUD.showLoading()
                        self.viewModel.request(RoomNetWork.upSeat(roomId: self.viewModel.roomItem.roomId, seatIndex: index) ) { responseModel in
                            HUD.showSuccess(responseModel.message)
                        } failureBlock: { error in
                            HUD.showFailure(error.message)
                        }
                    }
                    if model?.title == "下麦" {
                        guard let user = currentSeat.userInfo else { return }
                        HUD.showLoading()
                        self.viewModel.request(RoomNetWork.operateUserSeat(roomId: self.viewModel.roomItem.roomId, toUserId: user.userId, upSeat: false) ) { _ in
                            HUD.hide()
                        } failureBlock: { error in
                            HUD.showFailure(error.message)
                        }
                    }
                    if model?.title == "名片" {
                        guard let user = currentSeat.userInfo else { return }
                        self.showUserCard(user.userId)
                    }
                    if model?.title == "送礼" {
                        guard let user = currentSeat.userInfo else { return }
                        self.roomView.giftView.show(user)
                    }
                    if model?.title == "解锁" {
                        HUD.showLoading()
                        self.viewModel.request(RoomNetWork.seatLock(roomId: self.viewModel.roomItem.roomId, seatIndex: currentSeat.seatIndex, type: 0)) { _ in
                            HUD.hide()
                        } failureBlock: { error in
                            HUD.showFailure(error.message)
                        }
                    }
                    if model?.title == "锁定" {
                        HUD.showLoading()
                        self.viewModel.request(RoomNetWork.seatLock(roomId: self.viewModel.roomItem.roomId, seatIndex: currentSeat.seatIndex, type: 1) ) { _ in
                            HUD.hide()
                        } failureBlock: { error in
                            HUD.showFailure(error.message)
                        }
                    }
                    if model?.title == "闭麦" {
                        guard let user = currentSeat.userInfo else { return }
                        HUD.showLoading()
                        self.viewModel.request(RoomNetWork.operateUserMic(roomId: self.viewModel.roomItem.roomId, toUserId: user.userId, open: false) ) { _ in
                            HUD.hide()
                        } failureBlock: { error in
                            HUD.showFailure(error.message)
                        }
                    }
                    if model?.title == "开麦" {
                        guard let user = currentSeat.userInfo else { return }
                        HUD.showLoading()
                        self.viewModel.request(RoomNetWork.operateUserMic(roomId: self.viewModel.roomItem.roomId, toUserId: user.userId, open: true) ) { _ in
                            HUD.hide()
                        } failureBlock: { error in
                            HUD.showFailure(error.message)
                        }
                    }
                }.show()
            }
        }
        Mediator.shared.register(event: LMRMViewMethon.clickmicMuteAction) { (message: String) in
            guard let seat = self.viewModel.userSeatInfo(UserShared.user?.userId) else { return }
            HUD.showLoading()
            self.viewModel.request(RoomNetWork.mic(roomId: self.viewModel.roomItem.roomId, status: seat.mute ? 0 : 1) ) { _ in
                HUD.hide()
            } failureBlock: { error in
                HUD.show(error.message)
            }
        }
        Mediator.shared.register(event: LMRMViewMethon.clickMsgListAction) { (message: String) in
            LMRMMsgVC().show(self)
        }
        Mediator.shared.register(event: LMRMViewMethon.clickGiftAction) { (message: String) in
            self.roomView.giftView.set_Seats(self.viewModel.seats,roomItem: self.viewModel.roomItem)
            self.roomView.giftView.show()
        }
        Mediator.shared.register(event: LMRMViewMethon.showSortViewAction) { (message: String) in
            self.roomView.sequenceView.show()
        }
        Mediator.shared.register(event: LMRMViewMethon.clickMegViewAction) { (message: String) in
            LMRMMsgPopVC.show(roomId: self.viewModel.roomItem.roomId)
        }
        Mediator.shared.register(event: LMRMViewMethon.dRSortAction) { (message: String) in
            if self.daRenView == nil {
                self.daRenView = self.createDaRenSequenceView()
            }
            self.daRenView?.show()
        }
        Mediator.shared.register(event: LMRMViewMethon.onGuestSeatAction) { (message: String) in
            HUD.showLoading()
            self.viewModel.request(RoomNetWork.upSeat(roomId: self.viewModel.roomItem.roomId, seatIndex: 8) ) { _ in
                HUD.show("申请成功")
                HUD.hide()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        }
        Mediator.shared.register(event: LMRMViewMethon.clickViewDispatchAction) { (message: String) in
            guard let DispatchItem = self.PDViewModel?.DispatchItem else { return }
            let pop = VoicePDOrderVC(roomId:self.viewModel.roomItem.roomId) {
            } cancelblock: {
            } editblock: { [weak self] in
                guard let self = self else { return }
                dg_ReleaseDispatchAction()
            } updateGuestblock: { [weak self] user in
                guard let self = self else { return }
                self.PDViewModel?.DispatchItem?.guestUser = user
            } updateAnchorblock: { [weak self] user in
                guard let self = self else { return }
                self.PDViewModel?.DispatchItem?.anchorUser = user
            }
            pop.updateSkill(DispatchItem)
            pop.show(UIViewController.current)
        }
        Mediator.shared.register(event: LMRMViewMethon.roomPKendAction) { (message: String) in
            if  self.roomPkModel.dataSoure.status == .start {
                LMAlertBottomVC(theme: .light, title: "温馨提示", message: "正在 PK 中，逃跑之后直接输掉比赛，确定要继续吗？", cancel: "取消", confirm: "逃跑") { actionTitle in
                    if let title = actionTitle, title == "逃跑" {
                        self.viewModel.request(RoomPKNetWork.closePK(roomId: self.viewModel.roomItem.roomId) ) { _ in
                        } failureBlock: { error in
                            HUD.show(error.message)
                        }
                    }
                }.show()
                return
            }
            LMAlertBottomVC(theme: .light, title: "退出提示", message: "确定要退出并结束 PK 吗？", cancel: "取消", confirm: "退出") { actionTitle in
                if let title = actionTitle, title == "退出" {
                    self.viewModel.request(RoomPKNetWork.closePK(roomId: self.viewModel.roomItem.roomId) ) { _ in
                    } failureBlock: { error in
                        HUD.show(error.message)
                    }
                }
            }.show()
        }
        Mediator.shared.register(event: LMRMViewMethon.redRoomAction) { (mute: Bool) in
            guard let invitePkInfo = self.viewModel.roomItem.roomPkInfo else {
                return
            }
            self.viewModel.request(RoomPKNetWork.roompkmic(roomId: self.viewModel.roomItem.roomId, inviteId: invitePkInfo.inviteId, mute: mute == true ? 1:0) ) { _ in
            } failureBlock: { error in
                HUD.show(error.message)
            }
        }
        Mediator.shared.register(event: LMRMViewMethon.pkDidClickStartOrEndAction) { (message: String) in
        }
        Mediator.shared.register(event: LMRMViewMethon.bannerDidClickItem) { (banner: BannerItem) in
            RouteService.bannerAction(banner, vc: self)
        }
        Mediator.shared.register(event: LMRMViewMethon.chatListClickUser) { (message: String) in
            self.showUserCard(message)
        }
        Mediator.shared.register(event: LMRMViewMethon.chatListWelcomeUser) { (message: String) in
            self.viewModel.request(MessageNetWork.send(roomId: self.viewModel.roomItem.roomId, content: "欢迎", type: .text, emojiId: nil, atUserIdList: [message])) { _ in
                HUD.hide()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        }
        Mediator.shared.register(event: LMRMViewMethon.rankViewUserAction) { (user: VoiceRankItem) in
            self.showUserCard(user.userId)
        }
        Mediator.shared.register(event: LMRMViewMethon.invitebtnClick) { (user: VoiceRankItem) in
            self.showUserCard(user.userId)
        }
        Mediator.shared.register(event: LMRMViewMethon.invitebtnShow) { (message: String) in
            self.dg_invitebtnClick()
        }
        Mediator.shared.register(event: LMRMViewMethon.bottomSeatAction) { (message: String) in
            self.bottomSeatAction()
        }
        Mediator.shared.register(event: LMRMViewMethon.releaseDispatchAction) { (message: String) in
            self.dg_ReleaseDispatchAction()
        }
        
        Mediator.shared.register(event: LMRMViewMethon.moreViewMethon) { (message: LMRMMoreItemModel) in
            self.moreViewMethon(message)
        }
        Mediator.shared.register(event: LMRMViewMethon.removeUserSeatSort) { (message: UsInfoItem) in
            self.removeUserSort(message)
        }
        Mediator.shared.register(event: LMRMViewMethon.holdUserOnSeat) { (message: UsInfoItem) in
            self.userOnSeat(message)
        }
        
        
    }
    func bottomSeatAction(){
        if let _ = self.viewModel.userSeatInfo(UserShared.user?.userId) {
            HUD.showLoading()
            self.viewModel.applyDownSeat {[weak self] success, msg in
                if success {
                    guard let self = self else { return }
                    HUD.showSuccess("下麦成功")
                    self.roomView.sequenceView.hide()
                } else {
                    HUD.showFailure(msg)
                }
            }
        } else {
            let currentSeat = self.viewModel.seats[0]
            if currentSeat.userInfo == nil {
                if self.viewModel.roomItem.role == .host || self.viewModel.roomItem.role == .owner {
                    self.viewModel.request(RoomNetWork.upSeat(roomId: self.viewModel.roomItem.roomId, seatIndex: 0) ) { responseModel in
                        HUD.showSuccess(responseModel.message)
                    } failureBlock: { error in
                        HUD.showFailure(error.message)
                    }
                    return
                }
            }
            HUD.showLoading()
            self.viewModel.applyOnSeat { isSuccess, msg in
                if isSuccess {
                    HUD.showSuccess(msg)
                } else {
                    HUD.showFailure(msg)
                }
            }
        }
    }
    func dg_ReleaseDispatchAction() {
        let pop = LMRMPDReleaseVC(roomId:viewModel.roomItem.roomId, DispatchItem: self.PDViewModel?.DispatchItem)
        pop.show(UIViewController.current)
    }
    func dg_invitebtnClick() {
        guard let inviteInfo = self.viewModel.roomItem.inviteInfo else {
            return
        }
        let view = LMRMPkInviteCenView(isSender: inviteInfo.type == .receive) { string in
            if string == "同意" {
                self.viewModel.request(RoomPKNetWork.roompkaccept(roomId: self.viewModel.roomId, inviteId: inviteInfo.inviteId, status: 1) ) { _ in
                } failureBlock: { error in
                    HUD.show(error.message)
                }
            }
            if string == "取消" {
                if inviteInfo.type == .receive {
                    self.viewModel.request(RoomPKNetWork.roomPkCancle(inviteId: inviteInfo.inviteId) ) { _ in
                        self.viewModel.roomItem.inviteInfo = nil
                        self.roomView.showPkInviteinfo(nil)
                    } failureBlock: { error in
                        HUD.show(error.message)
                    }
                } else {
                    self.viewModel.request(RoomPKNetWork.roompkaccept(roomId: self.viewModel.roomId, inviteId: inviteInfo.inviteId, status: 2) ) { _ in
                        self.viewModel.roomItem.inviteInfo = nil
                        self.roomView.showPkInviteinfo(nil)
                    } failureBlock: { error in
                        HUD.show(error.message)
                    }
                }
            }
        }
        view.setDataSoure(inviteInfo,roomItem: self.viewModel.roomItem)
        view.show()
    }
}
extension VoiceVC {
    func showUserCard(_ userId: String) {
        var host = false
        if self.viewModel.roomItem.role == .host || self.viewModel.roomItem.role == .owner {
            host = true
        }
        if let user = UserShared.user, userId == user.userId {
            host = false
        }
        let seat = self.viewModel.userSeatInfo(userId)
        LMRMUserCardController.show(roomId: self.viewModel.roomItem.roomId, userId: userId, isHost: host, seat: seat) { user, action, seat in
            if action == .chat {
                RouteService.pushChat(user.userId, isRoom: false, vc: self)
            }
            if action == .aitTA {
                LMRMMsgPopVC.show(roomId: self.viewModel.roomItem.roomId, aitusInfoModel: user)
            }
            if action == .sendGift {
                guard let seatUser = self.viewModel.userSeatInfo(user.userId) else {
                    HUD.show("不在麦上禁止送礼")
                    return }
                self.roomView.giftView.show(seatUser.userInfo)
            }
            if action == .seatDown {
                HUD.showLoading()
                self.viewModel.request(RoomNetWork.operateUserSeat(roomId: self.viewModel.roomItem.roomId, toUserId: user.userId, upSeat: false) ) { _ in
                    HUD.hide()
                } failureBlock: { error in
                    HUD.showFailure(error.message)
                }
            }
            if action == .lock {
                guard let seat = seat else {
                    return
                }
                HUD.showLoading()
                self.viewModel.request(RoomNetWork.seatLock(roomId: self.viewModel.roomItem.roomId, seatIndex: seat.seatIndex, type: 1) ) { _ in
                    HUD.hide()
                } failureBlock: { error in
                    HUD.showFailure(error.message)
                }
            }
            if action == .Room {
                HUD.showLoading()
                self.viewModel.request(RoomNetWork.operateUserMic(roomId: self.viewModel.roomItem.roomId, toUserId: user.userId, open: false) ) { _ in
                    HUD.hide()
                } failureBlock: { error in
                    HUD.showFailure(error.message)
                }
            }
            if action == .mic {
                let items = [
                    PickerListModel(title: "1 小时", value: 60 * 60),
                    PickerListModel(title: "1 天", value: 60 * 60 * 24),
                    PickerListModel(title: "1 周", value: 60 * 60 * 24 * 7),
                    PickerListModel(title: "1 月", value: 60 * 60 * 24 * 30),
                    PickerListModel(title: "1 年", value: 60 * 60 * 24 * 356)
                ]
                let picker = LMPickerVC(theme: .light, title: user.nickname, dataSource: items, cancel: "取消", confirm: "确定") { item in
                    guard let item = item else { return }
                    guard let muteTime = item.value as? Int else { return }
                    HUD.showLoading()
                    self.viewModel.request(RoomNetWork.forbidUser(roomId: self.viewModel.roomId, userIdList: [user.userId], muteTime: muteTime) ) { _ in
                        HUD.showSuccess("禁言成功")
                    } failureBlock: { error in
                        HUD.showFailure(error.message)
                    }
                }
                picker.show()
            }
            if action == .admin {
                var items: [LMSheetTabModel] = []
                switch user.currentRoom?.role {
                case .owner:
                    lmPrint("不处理")
                    items = []
                case .host:
                    items.append(LMSheetTabModel(title: "取消主持人"))
                case .admin:
                    items.append(LMSheetTabModel(title: "取消管理员"))
                case .audience:
                    items.append(LMSheetTabModel(title: "设为管理员"))
                    items.append(LMSheetTabModel(title: "设为主持人"))
                case .none:
                    break
                }
                LMSheetTableVC(title: nil, dataSource: items, cancel: "取消") { item in
                    guard let item = item else { return }
                    if item.title == "取消主持人" {
                        HUD.showLoading()
                        self.viewModel.request(RoomNetWork.operateUserChair(roomId: self.viewModel.roomId, toUserId: user.userId, chair: false) ) { _ in
                            HUD.showSuccess("已取消主持人")
                        } failureBlock: { error in
                            HUD.showFailure(error.message)
                        }
                    }
                    if item.title == "取消管理员" {
                        HUD.showLoading()
                        self.viewModel.request(RoomNetWork.operateUserSetting(roomId: self.viewModel.roomId, toUserId: user.userId, admin: false) ) { _ in
                            HUD.showSuccess("已取消房管")
                        } failureBlock: { error in
                            HUD.showFailure(error.message)
                        }
                    }
                    if item.title == "设为主持人" {
                        HUD.showLoading()
                        self.viewModel.request(RoomNetWork.operateUserChair(roomId: self.viewModel.roomId, toUserId: user.userId, chair: true) ) { _ in
                            HUD.showSuccess("已设置主持人")
                        } failureBlock: { error in
                            HUD.showFailure(error.message)
                        }
                    }
                    if item.title == "设为管理员" {
                        HUD.showLoading()
                        self.viewModel.request(RoomNetWork.operateUserSetting(roomId: self.viewModel.roomId, toUserId: user.userId, admin: true) ) { _ in
                            HUD.showSuccess("已设置房管")
                        } failureBlock: { error in
                            HUD.showFailure(error.message)
                        }
                    }
                }.show()
            }
            if action == .quite {
            }
        }
    }
    
    func getOnlineUser() {
        RoomNetWork.userList(roomId:roomId).lmrequest { [weak self] responseModel in
             guard let self = self else { return }
             let userList = (responseModel.data as? [String: Any])?["userList"]
             guard let list = [UsInfoItem].deserialize(from: userList as? [Any]) else { return }
            self.roomView.topView.onlineView.setDataSource(list)
         } failureBlock: {  error in
            
         }
    }
    
    func updateBanner() {
        self.viewModel.request(set_NetWork.banner(scene: 5) ) { [weak self] responseModel in
            guard let self = self else { return }
            if let list = [BannerItem].deserialize(from: responseModel.data as? [Any]) {
                self.roomView.bannerView.setDataSoure(list)
            } else {
                self.roomView.bannerView.setDataSoure([])
            }
        } failureBlock: { _ in
            self.roomView.bannerView.setDataSoure([])
        }
    }
    
    func inviteRoomPK(_ roomItem:RoomItem, pkTime: Int) {
        self.viewModel.request(RoomPKNetWork.roompkInvite(roomId: self.viewModel.roomId, targetRoomId:roomItem.roomId, pkTime: pkTime) ) { _ in
            HUD.show("等待对方同意")
        } failureBlock: { error in
            HUD.show(error.message)
        }
    }
    
    
    
    func moreViewMethon(_ item:LMRMMoreItemModel) {
        switch item.type {
        case .setTing:
            break
        case .role:
            LMRMRolePopVC.show(roomId: self.viewModel.roomItem.roomId, role: self.viewModel.roomItem.role, dataSource: [.admin, .host])
        case .callFans:
            HUD.show(item.title)
        case .clearStar:
            HUD.showLoading()
            self.viewModel.request(RoomNetWork.clearCharm(roomId: self.viewModel.roomItem.roomId) ) { _ in
                HUD.hide()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        case .pkSet:
            if self.viewModel.roomItem.gameStatus == .isGame {
                HUD.show("请关闭游戏")
                return
            }
            if self.viewModel.roomItem.inviteInfo != nil {
                HUD.show("你还有PK邀请未处理")
                return
            }
            if let pkViewModel = self.pkViewModel, pkViewModel.dataSoure.status != .normal {
                let view = LMRMPKTypeSetView(roomId: self.viewModel.roomId, viewModel: self.viewModel, pkViewModel: pkViewModel)
                view.selectedPKTimeblock = {[weak self] time in
                    guard let roomId = self?.viewModel.roomId else {
                        return
                    }
                    let view = LMRMPkInvitePopView(roomId:roomId)
                    view.selectedPKRoomblock = {[weak self] model in
                        self?.inviteRoomPK(model, pkTime: time * 60)
                    }
                    view.show()
                }
                view.show()
                return
            }
            if self.viewModel.roomItem.roomType == .person {
                let view = LMRMPKSetTimeView()
                view.selectedPKTimeblock = {[weak self] time in
                    guard let roomId = self?.viewModel.roomId else {
                        return
                    }
                    if self?.viewModel.roomItem.roomPkInfo != nil {
                        HUD.show("请先结束PK")
                        return
                    }
                    let view = LMRMPkInvitePopView(roomId:roomId)
                    view.selectedPKRoomblock = {[weak self] model in
                        self?.inviteRoomPK(model, pkTime: time)
                    }
                    view.show()
                }
                view.show()
                return
            }
            let view = LMRMPKTypeSetView(roomId: self.viewModel.roomId, viewModel: self.viewModel, pkViewModel: pkViewModel)
            view.selectedPKTimeblock = {[weak self] time in
                guard let roomId = self?.viewModel.roomId else {
                    return
                }
                let view = LMRMPkInvitePopView(roomId:roomId)
                view.selectedPKRoomblock = {[weak self] model in
                    self?.inviteRoomPK(model, pkTime: time)
                }
                view.show()
            }
            view.show()
        case .waterList:
            LMRMWaterVC(roomId: self.viewModel.roomId).show(self)
        case .muteOn:
            let state = self.viewModel.getMuteState()
            self.viewModel.set_MuteState(!state)
            self.roomView.moreView.setDataSoure(viewModel.getRoomMoreItems())
            HUD.showSuccess(!state ? "已开启声音" : "已关闭声音")
        case .aniSet:
            let state = self.viewModel.getAnimationState()
            self.viewModel.set_AnimationState(!state)
            self.roomView.moreView.setDataSoure(viewModel.getRoomMoreItems())
            HUD.showSuccess(!state ? "已关闭动效" : "已开启动效")
        case .report:
            navigationController?.pushViewController(ReportViewController(reportType: .room,roomItem: self.viewModel.roomItem), animated: true)
        case .close:
            LMAlertBottomVC(theme: .light, title: "温馨提示", message: "观众正在路上哦，确定关闭直播吗？", cancel: "取消", confirm: "关闭房间") {[weak self] actionTitle in
                if let title = actionTitle, title == "关闭房间" {
                    self?.viewModel.closeRoom(complete: { _ in
                        self?.viewModel.Seversdelegate?.quiteRM()
                    })
                }
            }.show()
        case .game:
            break
            
        case .mini:
            self.viewModel.Seversdelegate?.reduceRM()
        case .quite:
            self.viewModel.Seversdelegate?.quiteRM()
        case .bid:
            LMRMRolePopVC.show(roomId: self.viewModel.roomItem.roomId, role: self.viewModel.roomItem.role, dataSource: [.disableMessage])
        case .clearChat:
            self.roomView.chatListView.reConfigUI()
        }
    }
    
    
    func removeUserSort(_ user: UsInfoItem) {
        
        if viewModel.roomItem.role == .audience {
            HUD.showLoading()
            RoomNetWork.cancelMicApply(roomId: viewModel.roomItem.roomId).lmrequest { responseModel in
                HUD.hide()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        }else {
            LMAlertBottomVC(theme: .dark, title: "删除提示", message: "确定删除该用户上麦申请吗？", cancel: "取消", confirm: "确定") { actionTitle in
                if let title = actionTitle, title == "确定" {
                    HUD.showLoading()
                    RoomNetWork.clearMicOrder(roomId: self.viewModel.roomId, toUserId: user.userId).lmrequest { responseModel in
                        HUD.hide()
                        
                    } failureBlock: { error in
                        HUD.showFailure(error.message)
                    }
                }
            }.show()
        }
        
    }
    
    
    func userOnSeat(_ user: UsInfoItem) {
        var items = [LMSheetItemModel]()
        if self.viewModel.roomItem.roomType == .person {
            self.viewModel.request(RoomNetWork.operateUserSeat(roomId: self.viewModel.roomItem.roomId, toUserId: user.userId, upSeat: true, seatIndex: 1) ) { _ in
                HUD.hide()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
            return
        }
        for seat in self.viewModel.seats where seat.seatIndex > 0 {
            if let _ = seat.userInfo {
                if seat.seatIndex == 8 {
                    items.append(LMSheetItemModel(title: "嘉宾", imageName: "rm_sheet_seat_boss_n", isEnable: false, index: seat.seatIndex, theme: .onlyTitle))
                } else {
                    items.append(LMSheetItemModel(title: "号麦", imageName: "rm_sheet_seat_\(seat.seatIndex)_n", isEnable: false, index: seat.seatIndex, theme: .onlyTitle))
                }
            } else {
                if seat.seatIndex == 8 {
                    items.append(LMSheetItemModel(title: "嘉宾", imageName: "rm_sheet_seat_boss", isEnable: true, index: seat.seatIndex, theme: .onlyTitle))
                } else {
                    items.append(LMSheetItemModel(title: "号麦", imageName: "rm_sheet_seat_\(seat.seatIndex)", isEnable: true, index: seat.seatIndex, theme: .onlyTitle))
                }
            }
        }
        LMSheetCollectionVC.show(theme: .light, title: user.nickname, items: items, cancel: "取消") { [weak self] item in
            guard let self = self else { return }
            guard let item = item, item.isEnable else { return }
            HUD.showLoading()
            self.viewModel.request(RoomNetWork.operateUserSeat(roomId: self.viewModel.roomItem.roomId, toUserId: user.userId, upSeat: true, seatIndex: item.index) ) { _ in
                HUD.hide()
            } failureBlock: { error in
                HUD.showFailure(error.message)
            }
        }
    }
}


