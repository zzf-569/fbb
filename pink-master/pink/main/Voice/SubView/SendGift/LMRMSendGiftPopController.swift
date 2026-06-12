import UIKit
extension LMRMSendGiftPopController {
    func set_Seats(_ seats: [RoomSeatItem],roomItem:RoomItem) {
        if roomItem.roomType != self.roomItem.roomType {
            self.seats = []
        }
        self.roomItem = roomItem
        var seats = seats
        for (index, seat) in seats.enumerated() {
            if seat.seatIndex == -1 {
                seats.remove(at: index)
            }
        }
        if self.seats.count == 0 {
            if roomItem.roomType == .person {
                self.seats = Array(seats[..<2])
            } else {
                self.seats = seats
            }
        } else {
            if self.isAll {
                self.seats = seats.map({ model ->RoomSeatItem in
                    var dataSoure = model
                    if let user = dataSoure.userInfo, user.userId != UserShared.user?.userId {
                        dataSoure.isSelected = self.isAll
                    } else {
                        dataSoure.isSelected = false
                    }
                    return model
                })
            } else {
                var userIds: [String] = []
                for seat in self.seats {
                    if let user = seat.userInfo, seat.isSelected {
                        userIds.append(user.userId)
                    }
                }
                self.seats = seats.map({ seat ->RoomSeatItem in
                    var seat = seat
                    if let user = seat.userInfo {
                        for userId in userIds {
                            if user.userId == userId {
                                seat.isSelected = true
                            }
                        }
                    }
                    return seat
                })
            }
            if roomItem.roomType == .person {
                self.seats = Array(self.seats[..<2])
            }
            self.userView.updateSeats(self.seats)
        }
    }
    func show(_ user:LMSeatusInfoModel? = nil) {
        self.isAll = false
        self.seats = seats.map({ model ->RoomSeatItem in
            var dataSoure = model
            dataSoure.isSelected = false
            return model
        })
        if let user = user {
            self.user = user
            self.userView.set_UserInfo(user)
        } else {
            self.user = nil
            self.userView.set_Seats(self.seats, isAll: self.isAll)
        }
        reset()
        UIViewController.current?.addChild(self)
        UIViewController.current?.view.addSubview(self.view)
        self.view.frame = UIScreen.main.bounds
        UIView.animate(withDuration: 0.3) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}
class LMRMSendGiftPopController: UIViewController {
    private lazy var bgView: UIView = {
        let view = UIView()
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var bdView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var bodyimv: UIImageView = {
        let imv = UIImageView()
        let effec = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effec)
        imv.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return imv
    }()
    private lazy var userView:LMRMSendGiftUserView = {
        let view = LMRMSendGiftUserView()
        view.cornerRadius(9)
        view.selectedSeatblock = { [weak self] seat in
            guard let self = self else { return }
            if let seat = seat {
                self.selectSeatAction(seat)
            } else {
                self.selectAllSeatsAction()
            }
        }
        return view
    }()
    private lazy var giftListView:LMRMSendGiftView = {
        let view = LMRMSendGiftView()
        view.selectedGiftBack = { [weak self] GiftItem in
            guard let self = self else { return }
            self.selectGiftAction(GiftItem)
        }
        view.selectedGiftTypeBack = { [weak self] type in
            guard let self = self else { return }
            self.selectGiftTypeAction(type)
        }
        view.selectedDressBack = { [weak self] dressModel in
            guard let self = self else { return }
            self.selectedDress = dressModel
        }
        view.selectedPackageBack = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.pushViewController(PackageViewController(), animated: true)
        }
        return view
    }()
    private lazy var bottomView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var balanceView:LMRMSendGiftBalanceView = {
        let balanceView = LMRMSendGiftBalanceView()
        balanceView.addGestureTap { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.pushViewController(RechargeViewController(), animated: true)
            }
        return balanceView
    }()
    private lazy var numView:LMRMSendGiftNumView = {
        let view = LMRMSendGiftNumView()
        view.set_Border(radius: 32/2)
        view.c_selectedNumblock = { [weak self] num in
            guard let self = self else { return }
            self.count = num
        }
        view.c_sendGiftblock = { [weak self] in
            guard let self = self else { return }
            self.sendGiftAction()
        }
        view.c_sendPackageGiftblock = { [weak self] in
            guard let self = self else { return }
            self.buyDressView()
        }
        view.c_useDressblock = { [weak self] in
            guard let self = self else { return }
            self.useDress()
        }
        return view
    }()
    private lazy var giftCardImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: ""))
        imageV.contentMode = .scaleAspectFill
        imageV.layer.masksToBounds = true
        imageV.isUserInteractionEnabled = true
        imageV.isHidden = true
        return imageV
    }()
    private let roomId: String
    private var user:LMSeatusInfoModel?
    private var seats: [RoomSeatItem] = []
    private var isAll: Bool = false
    private var dataSource: [GiftCategoryModel] = []
    private var selectedGift: GiftItem?
    private var selectedDress: ShopListItem?
    private var selectedPackageDress: UserDressModel?
    private var count: Int = 1
    private var roomItem:RoomItem = RoomItem()
    init(roomId: String) {
        self.roomId = roomId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setViewSnp()
    }
}
private extension LMRMSendGiftPopController {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(bodyimv)
        bdView.addSubview(giftCardImage)
        bdView.addSubview(self.userView)
        bdView.addSubview(self.giftListView)
        bdView.addSubview(self.bottomView)
        bottomView.addSubview(self.balanceView)
        bottomView.addSubview(self.numView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(0)
            make.height.equalTo(kScaleWidth(366 + 79) + kTabBarSafeHeight)
        }
        bodyimv.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(72)
            make.left.right.bottom.equalToSuperview()
        }
        giftCardImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kScaleWidth(15))
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(kScaleWidth(48))
        }
        userView.snp.makeConstraints { make in
            make.top.equalTo(giftCardImage.snp.bottom).offset(kScaleWidth(16))
            make.left.right.equalToSuperview().inset(0)
            make.height.equalTo(kScaleWidth(56))
        }
        giftListView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(userView.snp.bottom).offset(kScaleWidth(0))
            make.height.equalTo(kScaleWidth(250))
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(giftListView.snp.bottom)
            make.height.equalTo(kScaleWidth(48))
        }
        balanceView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(kScaleWidth(32))
        }
        numView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(210.0)
            make.height.equalTo(32)
        }
        view.layoutIfNeeded()
        bodyimv.set_Border(radius: 16.0, conrners: [.topLeft, .topRight])
        giftCardImage.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            if self.giftCardImage.image == UIImage(named: "rm_giftCard_shop") {
                self.navigationController?.pushViewController(LMShopVC(), animated: true)
                return
            }
            guard let selectedGift = self.selectedGift else {
                return
            }
            WebPopViewController(loadUrl: selectedGift.cardInfo, title: "玩法介绍").show(self)
        }
    }
    func getViewData() {
        GiftNetWork.giftcategory().lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            guard let giftList = [GiftCategoryModel].deserialize(from: responseModel.data as? [Any]) else { return }
            self.dataSource = giftList
            self.giftListView.setDataSoure(self.dataSource)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
        updataAccount()
    }
    func updataAccount() {
        WalletNetWork.getAccount().lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            guard let model = WalletItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self.balanceView.set_Balance(model.coin)
        } failureBlock: { _ in
        }
    }
    func refreshSubviews() {
    }
    func reset() {
        getViewData()
        self.count = 1
        self.numView.set_SendGiftNum(self.count)
        updataAccount()
    }
}
private extension LMRMSendGiftPopController {
    func sendGiftAction() {
        guard let selectedGift = self.selectedGift else {
            HUD.showFailure("请选择礼物")
            return
        }
        if self.count <= 0 {
            HUD.showFailure("赠送数量不能是0")
            return
        }
        var userIds: [String] = []
        if let user = user {
            userIds.append(user.userId)
        }
        for seat in self.seats {
            if let user = seat.userInfo, seat.isSelected {
                userIds.append(user.userId)
            }
        }
        guard userIds.count > 0 else {
            HUD.showFailure("请选择赠送对象")
            return
        }
        GiftNetWork.sendV2(giftId: selectedGift.id, count: self.count, toUserIdList: userIds,roomId: self.roomId, isMagicGift: selectedGift.isMagicGift).lmrequest { [weak self] _ in
            guard let self = self else { return }
            self.updataAccount()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    func buyDressView() {
        var userIds: [Int] = []
        if let user = user {
            if let userId = Int(user.userId) {
                userIds.append(userId)
            }
        }
        for seat in self.seats {
            if let user = seat.userInfo, seat.isSelected {
                if let userId = Int(user.userId) {
                    userIds.append(userId)
                }
            }
        }
        guard let selectedDress = self.selectedDress else { return }
        LMShopBuyPopView(theme: .dark, confirmText: "赠送", model: selectedDress, block: { [weak self] pricemodel in
            guard let pricemodel = pricemodel, let self = self else {return}
            ShopNetWork.sendDress(id: selectedDress.id, priceId: pricemodel.id, days: pricemodel.days, toUserIds: userIds,roomId:roomItem.roomId).lmrequest { _ in
            } failureBlock: { error in
                HUD.show(error.message)
            }
        }).show()
    }
    func useDress() {
        if let selectedPackageDress = self.selectedPackageDress {
            if selectedPackageDress.isActive == true {
            } else {
                ShopNetWork.useDress(id: selectedPackageDress.id, type: selectedPackageDress.type,roomId:roomItem.roomId).lmrequest { _ in
                    self.selectedPackageDress = nil
                    self.numView.set_SendType(type: 2)
                    self.giftListView.refreshBagView()
                    if selectedPackageDress.type == 4, self.roomItem.roomId != UserShared.user?.roomId {
                        HUD.show("请前往自己房间查看皮肤")
                    } else {
                        HUD.show("佩戴成功")
                    }
                } failureBlock: { _ in
                }
            }
        } else {
            HUD.show("请选择装扮")
        }
    }
    func selectNumAction() {
        LMRMSendGiftNumSeleView.show(parentView: self.view) { [weak self] num in
            guard let self = self else { return }
            self.count = num
            self.numView.set_SendGiftNum(num)
        }
    }
    func selectGiftTypeAction(_ type: Int) {
        self.userView.isHidden = type == 2
        if type == 2 {
            self.giftCardImage.isHidden = true
        }
        if type == 1 {
            self.giftCardImage.isHidden = false
            self.giftCardImage.image = UIImage(named: "rm_giftCard_shop")
        }
        self.numView.set_SendType(type: type, dressModel: selectedPackageDress)
    }
    func selectGiftAction(_ model: GiftItem) {
        giftCardImage.isHidden = model.giftCard.isEmpty == true
        giftCardImage.set_Image(url: model.giftCard, placeholder: nil)
        self.selectedGift = model
    }
    func selectAllSeatsAction() {
        self.isAll = !self.isAll
        self.seats = seats.map({ model ->RoomSeatItem in
            var dataSoure = model
            if let user = model.userInfo, user.userId != UserShared.user?.userId {
                dataSoure.isSelected = self.isAll
            } else {
                dataSoure.isSelected = false
            }
            return model
        })
        self.userView.set_Seats(self.seats, isAll: self.isAll)
    }
    func selectSeatAction(_ seat:RoomSeatItem) {
        guard let currentUser = seat.userInfo, currentUser.userId != UserShared.user?.userId else { return }
        self.seats = seats.map({ model in
            var dataSoure = model
            if let user = model.userInfo, user.userId == currentUser.userId {
                dataSoure.isSelected = !model.isSelected
            } else {
            }
            return dataSoure
        })
        self.userView.set_Seats(self.seats, isAll: self.isAll)
    }
    @objc func turntoRecord() {
        self.navigationController?.pushViewController(LMBageRecordVC(), animated: true)
    }
}
