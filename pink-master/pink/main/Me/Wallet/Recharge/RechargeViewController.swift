import UIKit
import AttributedString
class RechargeViewController: LMBaseVC {
    var dataList: [RechargeItem] = [] {
        didSet {
            seydtem = dataList.first
            collectionView.reloadData()
        }
    }
    var seydtem: RechargeItem?
    lazy var topView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScaleWidth(350), height: kScaleWidth(48)))
        view.set_Border(radius: 12, borderWidth: 0.5, borderColor: lmColorHex("#2B313D29"))
        return view
    }()
    lazy var coinImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "cm_coin"))
        return imageV
    }()
    lazy var cointips: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: .textSecondColor)
            .lmtext("钻石")
        return lb
    }()
    lazy var coinlb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: .textDefaulColor)
            .textAlignment(.right)
        return lb
    }()
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var rechargebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .white, target: self, action: #selector(appleRechargeClick))
            .lmtitle("支付")
            .backgroundColor(lmColorHex("#2B313D"))
        btn.cornerRadius(kScaleWidth(28))
        return btn
    }()
    lazy var agreementBoxbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "cm_box"), target: self, action: #selector(boxbtnAction))
            .image(UIImage(named: "cm_box_s"), .selected)
        btn.isSelected = true
        return btn
    }()
    lazy var agreementlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(16), textColor: .textSecondColor)
            .textAlignment(.center)
            .lmtext("我已阅读并同意")
        return lb
    }()
    lazy var custonlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(14), textColor: .textTerColor)
            .textAlignment(.left)
            .lmtext("充值遇到问题？点击联系")
            .numberOfLines(0)
        return lb
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [RechargeCollectionViewCell.self])
        return collectionView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        set_upAgreement()
        set_upCustom()
        setViewSnp()
        setDataSoure()
        updateBalance()
    }
    private func setViewSnp() {
        title = "充值"
        view.backgroundColor = lmColorHex("#FFFFFF")
        view.addSubview(topView)
        topView.addSubview(coinImage)
        topView.addSubview(cointips)
        topView.addSubview(coinlb)
        view.addSubview(contentView)
        contentView.addSubview(collectionView)
        topView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kNavigationHeight + kScaleWidth(12))
            make.height.equalTo(kScaleWidth(48))
        }
        coinImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(24))
            make.centerY.equalToSuperview()
            make.width.height.equalTo(kScaleWidth(24))
        }
        cointips.snp.makeConstraints { make in
            make.left.equalTo(coinImage.snp.right).offset(kScaleWidth(8))
            make.centerY.equalToSuperview()
            make.height.equalTo(kScaleWidth(40))
        }
        coinlb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.centerY.equalToSuperview()
            make.height.equalTo(kScaleWidth(40))
        }
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(76) + kNavigationHeight)
        }
        contentView.layoutIfNeeded()
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.bottom.equalToSuperview().offset(-kScaleWidth(360))
        }
        contentView.addSubview(rechargebtn)
        contentView.addSubview(custonlb)
        let agreementView = UIView()
        contentView.addSubview(agreementView)
        agreementView.addSubview(agreementBoxbtn)
        agreementView.addSubview(agreementlb)
        rechargebtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(kScaleWidth(48) + kTabBarSafeHeight))
            make.size.equalTo(CGSize(width: kScaleWidth(342), height: kScaleWidth(56)))
        }
        agreementBoxbtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(4))
            make.size.equalTo(CGSize(width: kScaleWidth(16), height: kScaleWidth(16)))
        }
        agreementlb.snp.makeConstraints { make in
            make.left.equalTo(agreementBoxbtn.snp.right).offset(kScaleWidth(6))
            make.top.right.equalToSuperview()
            make.height.equalTo(kScaleWidth(24))
        }
        agreementView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(kScaleWidth(130) + kTabBarSafeHeight))
            make.height.equalTo(kScaleWidth(24))
        }
        let tipslb = UILabel(lmfont: lmFontASHTB(18), textColor: .textDefaulColor)
        tipslb.lmtext("余额充值说明：")
        contentView.addSubview(tipslb)
        tipslb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.bottom.equalTo(custonlb.snp.top).offset(-kScaleWidth(8))
            make.height.equalTo(kScaleWidth(24))
        }
        custonlb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.bottom.equalTo(rechargebtn.snp.top).offset(-kScaleWidth(160))
        }
    }
    func setDataSoure() {
        set_NetWork.payProductList().lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            guard let list = [RechargeItem].deserialize(from: (responseModel.data as? [String: Any])?["applePay"] as? [[String: Any]]) else { return }
            dataList = list
        } failureBlock: { _ in
        }
    }
    func set_upAgreement() {
        let text = "已同意并阅读"
        let textAction1 = "《充值协议》"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: lmFontR(14), .foregroundColor: UIColor.textDefaulColor])
        attributedString.append(NSAttributedString(string: textAction1, attributes: [.font: lmFontR(14), .foregroundColor: UIColor.textLink]))
        self.agreementlb.attributedText = attributedString
        self.agreementlb.addGestureTap { [weak self] tap in
            (tap as? UITapGestureRecognizer)?.didTapLabelAttributedText([textAction1]) { _ in
                guard let self = self else { return }
                self.navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.recharge), animated: true)
            }
            (tap as? UITapGestureRecognizer)?.didTapLabelAttributedText([text]) { _ in
                guard let self = self else { return }
                self.agreementBoxbtn.isSelected = !self.agreementBoxbtn.isSelected
            }
        }
    }
    func set_upCustom() {
        let text = "1.钻石用户APP内提供的增值服务，1元=100钻石；\n2.未成年人不可充值，未成年请在监护人陪同许可下使用APP；\n3.如充值遇到疑问，请联系"
        let textAction1 = "人工客服"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: lmFontR(14), .foregroundColor: lmColorHex("#2B313DAD")])
        attributedString.append(NSAttributedString(string: textAction1, attributes: [.font: lmFontR(14), .foregroundColor: UIColor.textLink]))
        self.custonlb.attributedText = attributedString
        self.custonlb.addGestureTap { [weak self] tap in
            (tap as? UITapGestureRecognizer)?.didTapLabelAttributedText([textAction1]) { _ in
                guard let weakSelf = self else { return }
                let view = CustomChatController(kImUserId(converID: AppConfig.IMConfig.customUserId), isRoom: false)
                weakSelf.navigationController?.pushViewController(view, animated: true)
            }
        }
    }
    @objc func boxbtnAction(_ btn: UIButton) {
        btn.isSelected(!btn.isSelected)
    }
    @objc func appleRechargeClick() {
        createPayOrder(channelId: 0, type: .apple)
    }
    func createPayOrder(channelId: Int, type: PayType) {
        guard agreementBoxbtn.isSelected else {
            HUD.showFailure("请选中充值协议")
            return
        }
        guard let item = seydtem else {
            HUD.showFailure("请选择充值项")
            return
        }
        HUD.showLoading("支付中")
        WalletNetWork.StarPay(productId: item.productId, channelId: channelId).lmrequest { responseModel in
            guard let model = PayServiceModel.deserialize(from: responseModel.data as? [String: Any]) else {
                HUD.showSuccess("订单创建失败")
                return
            }
            PayService.pay(type, payModel: model, product: item) { [weak self] (_, _, error) in
                guard let self = self else { return }
                if error != nil {
                    HUD.showFailure(error?.message ?? "")
                } else {
                    HUD.showSuccess("支付成功")
                    self.updateBalance()
                }
            }
        } failureBlock: { error in
            if error.code == 6006 {
                HUD.hide()
                let view = LMAuthPopVC(theme: .light, cancel: "取消", confirm: "去实名") { title in
                    if title == "去实名" {
                        UIViewController.current?.navigationController?.pushViewController(RealAuthViewController(routetype: .toRoom), animated: true)
                    }
                }
                view.show()
            } else {
                HUD.showFailure(error.message)
            }
        }
    }
    func updateBalance() {
        WalletNetWork.getAccount().lmrequest {[weak self] responseModel in
            guard let model = WalletItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self?.coinlb.text = String(model.coin)
        } failureBlock: { _ in
        }
    }
}
extension RechargeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: kScaleWidth(106), height: kScaleWidth(56))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: kScaleWidth(20), bottom: 12, right: kScaleWidth(20))
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: RechargeCollectionViewCell.self, cellForRowAt: indexPath)
        let model = dataList[indexPath.row]
        cell.dataSoure = model
        if model.productId == seydtem?.productId {
            cell.isSelectedItem = true
        } else {
            cell.isSelectedItem = false
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        seydtem = dataList[indexPath.row]
        self.collectionView.reloadData()
    }
}
