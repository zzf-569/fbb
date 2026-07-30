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
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
        view.backgroundColor = lmColorHex("#F5F6FA")

        let nav = UIView()
        view.addSubview(nav)
        nav.snp.makeConstraints { $0.top.left.right.equalToSuperview(); $0.height.equalTo(kNavigationHeight) }
        let back = UIButton(type: .custom)
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = lmColorHex("#202620")
        back.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        nav.addSubview(back)
        back.snp.makeConstraints { $0.left.equalToSuperview().offset(12); $0.bottom.equalToSuperview().offset(-4); $0.size.equalTo(40) }
        let navTitle = UILabel(lmfont: lmFontM(22), textColor: lmColorHex("#171C18"))
        navTitle.text = "Recharge"
        navTitle.textAlignment = .center
        nav.addSubview(navTitle)
        navTitle.snp.makeConstraints { $0.centerX.equalToSuperview(); $0.centerY.equalTo(back) }
        let restore = UIButton(type: .custom)
        restore.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        restore.tintColor = lmColorHex("#202620")
        restore.addTarget(self, action: #selector(restoreAction), for: .touchUpInside)
        nav.addSubview(restore)
        restore.snp.makeConstraints { $0.right.equalToSuperview().offset(-12); $0.centerY.equalTo(back); $0.size.equalTo(32) }

        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        view.addSubview(scroll)
        scroll.snp.makeConstraints { $0.top.equalTo(nav.snp.bottom); $0.left.right.bottom.equalToSuperview() }
        let page = UIView()
        scroll.addSubview(page)
        page.snp.makeConstraints { $0.edges.equalToSuperview(); $0.width.equalToSuperview(); $0.height.greaterThanOrEqualTo(kScreenHeight - kNavigationHeight) }

        let balanceCard = UIView()
        balanceCard.backgroundColor = lmColorHex("#142018")
        balanceCard.layer.cornerRadius = 14
        balanceCard.clipsToBounds = true
        page.addSubview(balanceCard)
        balanceCard.snp.makeConstraints { $0.top.equalToSuperview().offset(14); $0.left.right.equalToSuperview().inset(20); $0.height.equalTo(120) }

        cointips.text = "Coins"
        cointips.textColor = .white
        balanceCard.addSubview(cointips)
        cointips.snp.makeConstraints { $0.left.equalToSuperview().offset(12); $0.top.equalToSuperview().offset(8) }
        let largeCoin = UIImageView(image: UIImage(named: "cm_coin"))
        largeCoin.contentMode = .scaleAspectFit
        balanceCard.addSubview(largeCoin)
        largeCoin.snp.makeConstraints { $0.right.equalToSuperview().offset(-8); $0.top.equalToSuperview().offset(-10); $0.size.equalTo(72) }

        let amountView = UIView()
        amountView.backgroundColor = .white
        amountView.layer.cornerRadius = 12
        balanceCard.addSubview(amountView)
        amountView.snp.makeConstraints { $0.left.right.bottom.equalToSuperview().inset(4); $0.height.equalTo(78) }
        let faintCoin = UIImageView(image: UIImage(named: "cm_coin"))
        faintCoin.alpha = 0.15
        amountView.addSubview(faintCoin)
        faintCoin.snp.makeConstraints { $0.left.equalToSuperview().offset(10); $0.centerY.equalToSuperview(); $0.size.equalTo(62) }
        coinlb.textColor = lmColorHex("#202620")
        coinlb.font = lmFontM(32)
        coinlb.textAlignment = .center
        amountView.addSubview(coinlb)
        coinlb.snp.makeConstraints { $0.center.equalToSuperview(); $0.left.equalToSuperview().offset(52); $0.right.equalToSuperview().offset(-52) }
        let details = UIButton(type: .custom)
        details.setTitle("Details", for: .normal)
        details.setTitleColor(lmColorHex("#B9FF63"), for: .normal)
        details.titleLabel?.font = lmFontR(11)
        details.backgroundColor = lmColorHex("#142018")
        details.layer.cornerRadius = 5
        details.addTarget(self, action: #selector(detailsAction), for: .touchUpInside)
        amountView.addSubview(details)
        details.snp.makeConstraints { $0.right.equalToSuperview().offset(-10); $0.centerY.equalToSuperview(); $0.width.equalTo(52); $0.height.equalTo(28) }

        let sectionTitle = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#202620"))
        sectionTitle.text = "Recharge Coins"
        page.addSubview(sectionTitle)
        sectionTitle.snp.makeConstraints { $0.left.equalToSuperview().offset(20); $0.top.equalTo(balanceCard.snp.bottom).offset(18) }
        page.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.left.right.equalToSuperview(); $0.top.equalTo(sectionTitle.snp.bottom).offset(6); $0.height.equalTo(154) }

        let supportLine = UIView()
        supportLine.backgroundColor = lmColorHex("#D7DAD7")
        page.addSubview(supportLine)
        supportLine.snp.makeConstraints { $0.left.right.equalToSuperview().inset(20); $0.bottom.equalToSuperview().offset(-145); $0.height.equalTo(1) }
        let supportIcon = UIImageView(image: UIImage(named: "support"))
        supportIcon.contentMode = .scaleAspectFit
        page.addSubview(supportIcon)
        supportIcon.snp.makeConstraints { $0.left.equalToSuperview().offset(32); $0.top.equalTo(supportLine.snp.bottom).offset(14); $0.size.equalTo(30) }
        let supportTitle = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#202620"))
        supportTitle.text = "Customer Support"
        page.addSubview(supportTitle)
        supportTitle.snp.makeConstraints { $0.left.equalTo(supportIcon.snp.right).offset(8); $0.centerY.equalTo(supportIcon) }
        let contact = UIButton(type: .custom)
        contact.setTitle("Contact", for: .normal)
        contact.setTitleColor(lmColorHex("#202620"), for: .normal)
        contact.titleLabel?.font = lmFontR(10)
        contact.layer.cornerRadius = 5
        contact.layer.borderWidth = 1
        contact.layer.borderColor = lmColorHex("#B9BCB9").cgColor
        contact.addTarget(self, action: #selector(contactAction), for: .touchUpInside)
        page.addSubview(contact)
        contact.snp.makeConstraints { $0.right.equalToSuperview().offset(-32); $0.centerY.equalTo(supportIcon); $0.width.equalTo(64); $0.height.equalTo(28) }

        page.addSubview(agreementlb)
        agreementlb.snp.makeConstraints { $0.left.right.equalToSuperview().inset(18); $0.top.equalTo(supportIcon.snp.bottom).offset(20); $0.height.equalTo(18) }
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
        let text = "By recharging you agree to the  "
        let textAction1 = "Recharge Agreement"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: lmFontR(12), .foregroundColor: lmColorHex("#A5AAA6")])
        attributedString.append(NSAttributedString(string: textAction1, attributes: [.font: lmFontR(12), .foregroundColor: lmColorHex("#747A75")]))
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

    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func restoreAction() {
        setDataSoure()
        updateBalance()
    }

    @objc private func detailsAction() {
        navigationController?.pushViewController(WalletRecordPageViewController(type: 0), animated: true)
    }

    @objc private func contactAction() {
        let controller = CustomChatController(kImUserId(converID: AppConfig.IMConfig.customUserId), isRoom: false)
        navigationController?.pushViewController(controller, animated: true)
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
        appleRechargeClick()
    }
}
