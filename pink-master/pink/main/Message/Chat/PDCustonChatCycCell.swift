import UIKit
class PDCustonChatCycCell: UICollectionViewCell {
    var dataSoure: OrderItem = OrderItem() {
        didSet {
            self.namelb.text = dataSoure.itemName + " x\(dataSoure.number)"
            self.iconImage.set_Image(url: dataSoure.itemIcon)
            self.timelb.text = "时间：\(dataSoure.createTime)"
            if dataSoure.targetUserInfo.userId == UserShared.user?.userId {
                acceptbtn.isHidden = true
                rejectbtn.isHidden = true
                starbtn.isHidden = true
                endbtn.isHidden = true
                if dataSoure.status == -1 {
                    statuslb.text = "待接单"
                }
                if dataSoure.status == 0 {
                    statuslb.text = "未开始"
                }
                if dataSoure.status == 1 {
                    statuslb.text = "进行中"
                }
            } else {
                if dataSoure.status == -1 {
                    statuslb.text = "待接单"
                    acceptbtn.isHidden = false
                    rejectbtn.isHidden = false
                    starbtn.isHidden = true
                    endbtn.isHidden = true
                } else if dataSoure.status == 0 {
                    statuslb.text = "未开始"
                    acceptbtn.isHidden = true
                    rejectbtn.isHidden = true
                    starbtn.isHidden = false
                    endbtn.isHidden = true
                } else if dataSoure.status == 1 {
                    statuslb.text = "进行中"
                    acceptbtn.isHidden = false
                    rejectbtn.isHidden = false
                    starbtn.isHidden = true
                    endbtn.isHidden = false
                } else {
                    acceptbtn.isHidden = true
                    rejectbtn.isHidden = true
                    starbtn.isHidden = true
                    endbtn.isHidden = true
                }
            }
        }
    }
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var iconImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
        return lb
    }()
    lazy var statuslb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(10), textColor: lmColorHex("#F5455CFF"))
        lb.backgroundColor(lmColorHex("#F5455C14"))
        lb.cornerRadius(10)
        lb.textAlignment = .center
        return lb
    }()
    lazy var timelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#2B313DAD"))
        return lb
    }()
    lazy var rejectbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(12), titleColor: lmColorHex("#2B313D"), target: self, action: #selector(a_rejectbtnAction))
        btn.lmtitle("拒绝")
        btn.backgroundColor(lmColorHex("#2B313D0A"))
        btn.cornerRadius(14)
        btn.isHidden = true
        return btn
    }()
    lazy var acceptbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(12), titleColor: lmColorHex("#FFFFFF"), target: self, action: #selector(a_acceptbtnAction))
        btn.lmtitle("接受")
        btn.backgroundColor(lmColorHex("#FF4F7DFF"))
        btn.cornerRadius(14)
        btn.isHidden = true
        return btn
    }()
    lazy var starbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(12), titleColor: lmColorHex("#FFFFFF"), target: self, action: #selector(a_starbtnAction))
        btn.lmtitle("开始")
        btn.backgroundColor(lmColorHex("#FF4F7DFF"))
        btn.cornerRadius(14)
        btn.isHidden = true
        return btn
    }()
    lazy var endbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(12), titleColor: lmColorHex("#FFFFFF"), target: self, action: #selector(a_endbtnAction))
        btn.lmtitle("结束")
        btn.backgroundColor(lmColorHex("#FF4F7DFF"))
        btn.cornerRadius(14)
        btn.isHidden = true
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func set_Subviews() {
        addSubview(backView)
        backView.addSubview(iconImage)
        backView.addSubview(namelb)
        backView.addSubview(statuslb)
        backView.addSubview(timelb)
        backView.addSubview(rejectbtn)
        backView.addSubview(acceptbtn)
        backView.addSubview(starbtn)
        backView.addSubview(endbtn)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        iconImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 56, height: 56))
        }
        namelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(80)
            make.top.equalToSuperview().offset(17)
        }
        statuslb.snp.makeConstraints { make in
            make.left.equalTo(namelb.snp.right).offset(4)
            make.centerY.equalTo(namelb)
            make.size.equalTo(CGSize(width: 38, height: 20))
        }
        timelb.snp.makeConstraints { make in
            make.left.equalTo(namelb)
            make.bottom.equalToSuperview().offset(-17)
        }
        acceptbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
            make.size.equalTo(CGSize(width: 56, height: 28))
        }
        rejectbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 56, height: 28))
        }
        starbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 56, height: 28))
        }
        endbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 56, height: 28))
        }
    }
    @objc func a_rejectbtnAction() {
        HUD.showLoading()
        OrderApi.submit(orderNo: dataSoure.orderNo, status: 4).lmrequest { _ in
            HUD.showSuccess("已拒绝订单")
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func a_acceptbtnAction() {
        HUD.showLoading()
        OrderApi.submit(orderNo: dataSoure.orderNo, status: 0).lmrequest { _ in
            HUD.showSuccess("已接受订单")
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func a_starbtnAction() {
        OrderApi.submit(orderNo: dataSoure.orderNo, status: 1).lmrequest { _ in
        } failureBlock: { _ in
        }
    }
    @objc func a_endbtnAction() {
        OrderApi.submit(orderNo: dataSoure.orderNo, status: 3).lmrequest { _ in
        } failureBlock: { _ in
        }
    }
}
