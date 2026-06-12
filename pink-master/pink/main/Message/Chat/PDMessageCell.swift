import UIKit
import TIMCommon
class PDMessageCell: TUIBubbleMessageCell {
    var cellData: PDMessageCellData?
    private lazy var skillNamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#000000"))
        return lb
    }()
    private lazy var skillIconimv: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
        return imv
    }()
    private lazy var statuslb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#000000"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var orderTimelb: UILabel = {
        let time = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#707070"))
        return time
    }()
    private lazy var userView: UIView = {
        let view = UIView()
            .backgroundColor(.clear)
            .cornerRadius(6)
        return view
    }()
    private lazy var userBgimv: UIImageView = {
        let imv = UIImageView()
        let image = UIImage.gradient(["#E2FFF5", "#FEFFEB"], size: CGSize(width: 176.0, height: 72.0), direction: .horizontal)
        imv.image = image
        return imv
    }()
    private lazy var directionlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#2B313D"))
        return lb
    }()
    private lazy var userusheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_avatar)
            contentMode(.scaleAspectFill)
            .cornerRadius(32/2)
        return imv
    }()
    private lazy var userNamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#2B313D"))
        return lb
    }()
    private lazy var rejectbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "msg_dispatch_reject"), target: self, action: #selector(a_rejectbtnAction))
            .isHidden(true)
        return btn
    }()
    private lazy var acceptbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "msg_dispatch_accept"), target: self, action: #selector(a_acceptbtnAction))
            .isHidden(true)
        return btn
    }()
    private lazy var chatbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "msg_dispatch_chat"), target: self, action: #selector(a_chatbtnAction))
            .isHidden(true)
        return btn
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func fill(with data: TUIBubbleMessageCellData) {
        super.fill(with: data)
        guard let data = data as? PDMessageCellData else { return }
        guard let sourceUserInfo = data.sourceUserInfo else { return }
        guard let targetUserInfo = data.targetUserInfo else { return }
        guard let order = data.order else { return }
        self.cellData = data
        if order.sourceType == 1 {
            self.skillNamelb.text = order.bizName + " x\(order.bizNum)"
            self.skillIconimv.set_Image(url: data.bizIcon)
            let timeString = Date.timestampStringToDate(data.orderTime)?.dateToFormatString("yyyy年MM月dd日 HH:mm") ?? ""
            self.orderTimelb.text = "时间：\(timeString)"
            if UserShared.user?.userId == sourceUserInfo.userId {
                self.directionlb.text = "接单大神"
                self.userusheaderView.set_Image(url: targetUserInfo.avatar)
                self.userNamelb.text = targetUserInfo.nickname
            } else {
                self.directionlb.text = "来自"
                self.userusheaderView.set_Image(url: sourceUserInfo.avatar)
                self.userNamelb.text = sourceUserInfo.nickname
            }
            self.statuslb.text = order.status.text
            switch order.status {
            case .missed:
                if UserShared.user?.userId == sourceUserInfo.userId {
                    self.rejectbtn.isHidden = true
                    self.acceptbtn.isHidden = true
                    self.chatbtn.isHidden = true
                } else {
                    self.rejectbtn.isHidden = false
                    self.acceptbtn.isHidden = false
                    self.chatbtn.isHidden = true
                }
            case .received:
                self.rejectbtn.isHidden = true
                self.acceptbtn.isHidden = true
                self.chatbtn.isHidden = false
            case .cancel, .reject:
                self.rejectbtn.isHidden = true
                self.acceptbtn.isHidden = true
                self.chatbtn.isHidden = true
            default:
                self.rejectbtn.isHidden = true
                self.acceptbtn.isHidden = true
                self.chatbtn.isHidden = true
            }
        }
        if order.sourceType == 2 {
            self.skillNamelb.text = order.bizName + " x\(order.bizNum)"
            self.skillIconimv.set_Image(url: data.bizIcon)
            let timeString = Date.timestampStringToDate(data.orderTime)?.dateToFormatString("yyyy年MM月dd日 HH:mm") ?? ""
            self.orderTimelb.text = "时间：\(timeString)"
            let messageUserId = data.innerMessage.userID
            if UserShared.user?.userId == sourceUserInfo.userId {
                self.directionlb.text = "接单大神"
                self.userusheaderView.set_Image(url: targetUserInfo.avatar)
                self.userNamelb.text = targetUserInfo.nickname
            } else if UserShared.user?.userId == targetUserInfo.userId {
                self.directionlb.text = "来自"
                self.userusheaderView.set_Image(url: sourceUserInfo.avatar)
                self.userNamelb.text = sourceUserInfo.nickname
            } else {
                self.directionlb.text = "派单"
                if messageUserId == sourceUserInfo.imUserId {
                    self.userusheaderView.set_Image(url: targetUserInfo.avatar)
                    self.userNamelb.text = targetUserInfo.nickname
                } else if messageUserId == targetUserInfo.imUserId {
                    self.userusheaderView.set_Image(url: sourceUserInfo.avatar)
                    self.userNamelb.text = sourceUserInfo.nickname
                } else {
                    self.userusheaderView.set_Image(url: targetUserInfo.avatar)
                    self.userNamelb.text = targetUserInfo.nickname
                }
            }
            self.rejectbtn.isHidden = true
            self.acceptbtn.isHidden = true
            self.statuslb.text = order.status.text
            switch order.status {
            case .received:
                self.chatbtn.isHidden = false
            default:
                self.chatbtn.isHidden = true
            }
        }
    }
}
private extension PDMessageCell {
    func set_Subviews() {
        self.container.addSubview(statuslb)
        statuslb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12.0)
            make.centerY.equalTo(container)
            make.height.equalTo(24.0)
        }
        self.container.addGestureTap { [weak self] _ in
                guard let self = self else { return }
                guard let data = data as? PDMessageCellData else { return }
                guard let sourceUserInfo = data.sourceUserInfo else { return }
                guard let targetUserInfo = data.targetUserInfo else { return }
                guard let order = data.order else { return }
            let msgSenderUserId = kUserId(imUserId: data.innerMessage.userID ?? "")
                if UserShared.user?.userId == sourceUserInfo.userId {
                    viewController?.navigationController?.pushViewController(OrderPageViewController(), animated: true)
                } else if UserShared.user?.userId == targetUserInfo.userId {
                    viewController?.navigationController?.pushViewController(LMRecOrdPageVC(), animated: true)
                } else {
                }
            }
    }
    @objc func a_rejectbtnAction() {
        guard let orderNo = cellData?.order?.orderNo else { return }
        HUD.showLoading()
        OrderApi.submit(orderNo: orderNo, status: 4).lmrequest { _ in
            HUD.showSuccess("已拒绝订单")
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func a_acceptbtnAction() {
        guard let orderNo = cellData?.order?.orderNo else { return }
        HUD.showLoading()
        OrderApi.submit(orderNo: orderNo, status: 0).lmrequest { _ in
            HUD.showSuccess("已接受订单")
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func a_chatbtnAction() {
        guard let sourceUserInfo = cellData?.sourceUserInfo else { return }
        guard let targetUserInfo = cellData?.targetUserInfo else { return }
        guard let order = cellData?.order else { return }
        if UserShared.user?.userId == sourceUserInfo.userId {
            RouteService.pushChat(targetUserInfo.userId, vc: viewController)
        } else if UserShared.user?.userId == targetUserInfo.userId {
            RouteService.pushChat(sourceUserInfo.userId, vc: viewController)
        } else {
            RouteService.pushChat(targetUserInfo.userId, vc: viewController)
        }
    }
}
extension PDMessageCell {
    override class func getContentSize(_ data: TUIMessageCellData!) -> CGSize {
        guard let data = data as? PDMessageCellData else { return CGSize(width: 200.0, height: 188.0) }
        guard let order = data.order else { return CGSize(width: 120.0, height: 38.0) }
        let size = order.status.text.textWidth(height: 38, font: lmFontR(14))
        return CGSize(width: size + 24, height: 38.0)
    }
}
