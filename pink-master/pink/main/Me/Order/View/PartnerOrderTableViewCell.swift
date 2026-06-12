import UIKit
protocol PartnerOrderTableViewCellDelegate: NSObjectProtocol {
    func d_chatClick(userId: String)
}
class PartnerOrderTableViewCell: LMBaseTableViewCell {
    weak var delegale: PartnerOrderTableViewCellDelegate?
    var dataSoure: OrderItem = OrderItem() {
        didSet {
            orderName.lmtext("\(dataSoure.itemName) x \(dataSoure.number)")
            orderTime.lmtext("时间 \(dataSoure.createTime)")
            orderUserName.lmtext(dataSoure.targetUserInfo.nickname)
            orderAvatar.set_Image(url: dataSoure.targetUserInfo.avatar)
            switch dataSoure.status {
            case -1:
                status.image(UIImage(named: "order_un"))
                status.lmtitle("未接单")
                status.titleColor(lmColorHex("#FF9F40FF"))
                case 0:
                status.image(UIImage(named: "order_no"))
                status.lmtitle("未开始")
                status.titleColor(lmColorHex("#FFDD00FF"))
                case 1:
                status.image(UIImage(named: "order_palying"))
                status.lmtitle("进行中")
                status.titleColor(lmColorHex("#00DBA9FF"))
                case 3:
                status.image(UIImage(named: "order_over"))
                status.lmtitle("已完成")
                status.titleColor(lmColorHex("#2B313D"))
                case 4:
                status.image(UIImage(named: "order_cancle"))
                status.lmtitle("已取消")
                status.titleColor(lmColorHex("#2B313D66"))
                case 2:
                status.image(UIImage(named: "order_cancle"))
                status.lmtitle("已取消")
                status.titleColor(lmColorHex("#2B313D66"))
            default:
                break
            }
        }
    }
    lazy var backImage: UIView = {
        let imageV = UIView()
        imageV.set_Border(radius: 12, borderWidth: 0.5, borderColor: lmColorHex("#2B313D29"))
        imageV.backgroundColor = lmColorHex("#FFFFFF")
        return imageV
    }()
    lazy var status: UIButton = {
        let btn = UIButton(lmfont: lmFontR(12), titleColor: .textTerColor).lmtitle("进行中")
        btn.image(UIImage(named: "order_palying"))
        return btn
    }()
    lazy var orderName: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(20), textColor: .textDefaulColor).lmtext("王者荣耀 X1")
        return lb
    }()
    lazy var orderTime: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textTerColor).lmtext("时间 2024-10-01 14:00")
        return lb
    }()
    lazy var orderUser: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textDefaulColor).lmtext("来自:")
        return lb
    }()
    lazy var orderAvatar: UIImageView = {
        let imageV = UIImageView().cornerRadius(kScaleWidth(12))
        return imageV
    }()
    lazy var orderUserName: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textDefaulColor)
        return lb
    }()
    lazy var sendMsg: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: .textDefaulColor).lmtitle("发消息").cornerRadius(6)
        btn.backgroundColor(lmColorHex("#2B313D0A"))
        btn.addTarget(self, action: #selector(a_sendMesgClick), for: .touchUpInside)
        return btn
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func set_Subviews() {
        contentView.addSubview(backImage)
        backImage.addSubview(orderName)
        backImage.addSubview(orderTime)
        backImage.addSubview(orderUser)
        backImage.addSubview(orderAvatar)
        backImage.addSubview(orderUserName)
        backImage.addSubview(sendMsg)
        backImage.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(124))
        }
        orderName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.height.equalTo(kScaleWidth(24))
        }
        orderTime.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.top.equalTo(orderName.snp.bottom).offset(kScaleWidth(4))
            make.height.equalTo(kScaleWidth(20))
        }
        orderUser.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.bottom.equalToSuperview().offset(-kScaleWidth(16))
        }
        orderAvatar.snp.makeConstraints { make in
            make.left.equalTo(orderUser.snp.right).offset(kScaleWidth(4))
            make.centerY.equalTo(orderUser.snp.centerY)
            make.size.equalTo(CGSize(width: kScaleWidth(24), height: kScaleWidth(24)))
        }
        orderUserName.snp.makeConstraints { make in
            make.left.equalTo(orderAvatar.snp.right).offset(kScaleWidth(4))
            make.centerY.equalTo(orderUser.snp.centerY)
            make.height.equalTo(kScaleWidth(20))
        }
        sendMsg.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.centerY.equalTo(orderUser.snp.centerY)
            make.size.equalTo(CGSize(width: kScaleWidth(64), height: kScaleWidth(28)))
        }
        status.set_ImageTitleLayout(.imgLeft, spacing: 2)
        let lineV = UIView().backgroundColor(lmColorHex("#2B313D29"))
        backImage.addSubview(lineV)
        lineV.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.bottom.equalToSuperview().offset(-kScaleWidth(52))
            make.height.equalTo(kScaleWidth(1))
        }
    }
    @objc func a_sendMesgClick() {
        self.delegale?.d_chatClick(userId: dataSoure.targetUserInfo.userId)
    }
}
