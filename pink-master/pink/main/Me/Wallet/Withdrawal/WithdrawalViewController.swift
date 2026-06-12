import UIKit
class WithdrawalViewController: LMBaseVC {
    var dataList: [WithdrawConfigItem] = [] {
        didSet {
            seydtem = dataList.first
            collectionView.reloadData()
        }
    }
    var seydtem: WithdrawConfigItem?
    lazy var topView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScaleWidth(350), height: kScaleWidth(48)))
        view.set_Border(radius: 12, borderWidth: 0.5, borderColor: lmColorHex("#2B313D29"))
        return view
    }()
    lazy var coinImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "cm_cash"))
        return imageV
    }()
    lazy var cointips: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: .textSecondColor)
            .lmtext("贝壳")
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
    lazy var withdrawalbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: lmColorHex("#FF4F7D"), target: self, action: #selector(withdrawalbtnClick))
        btn.lmtitle("提现")
        btn.backgroundColor(lmColorHex("#DEFCF1"))
        btn.cornerRadius(kScaleWidth(28))
        btn.isHidden = true
        return btn
    }()
    lazy var exchangebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .white, target: self, action: #selector(exchangebtnClick))
        btn.lmtitle("兑换")
        btn.backgroundColor(lmColorHex("#FF4F7DFF"))
        btn.cornerRadius(kScaleWidth(12))
        return btn
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [WithdrawalCollectionViewCell.self])
        return collectionView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setDataSoure()
        getCoin()
    }
    private func setViewSnp() {
        title = "贝壳余额"
        backgroundImage = nil
        view.backgroundColor = .white
        view.addSubview(topView)
        view.addSubview(contentView)
        topView.addSubview(coinImage)
        topView.addSubview(cointips)
        topView.addSubview(coinlb)
        contentView.addSubview(collectionView)
        contentView.addSubview(withdrawalbtn)
        contentView.addSubview(exchangebtn)
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
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.bottom.equalToSuperview().offset(-kScaleWidth(360))
        }
        withdrawalbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(24))
            make.bottom.equalToSuperview().offset(-(kScaleWidth(56) + kTabBarSafeHeight))
            make.size.equalTo(CGSize(width: kScaleWidth(163), height: kScaleWidth(56)))
        }
        exchangebtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(kScaleWidth(56) + kTabBarSafeHeight))
            make.size.equalTo(CGSize(width: kScreenWidth - kScaleWidth(40), height: kScaleWidth(56)))
        }
        let tipslb = UILabel(lmfont: lmFontASHTB(18), textColor: .textDefaulColor)
        tipslb.lmtext("兑换说明：")
        contentView.addSubview(tipslb)
        let tips = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#2B313DA3"))
        tips.lmtext("1.贝壳可兑换成为钻石，1贝壳=100钻石；\n2.钻石到账时间为T+0实时发放；\n3.请核对账户余额及换算结果，兑换操作具有不可逆性。")
        tips.numberOfLines(0)
        contentView.addSubview(tips)
        tipslb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.bottom.equalTo(tips.snp.top).offset(-kScaleWidth(8))
            make.height.equalTo(kScaleWidth(24))
        }
        tips.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.bottom.equalTo(exchangebtn.snp.top).offset(-kScaleWidth(265))
        }
    }
    func setDataSoure() {
        WalletNetWork.WithdrawConfig().lmrequest { responseModel in
            guard let model = WithdrawConfig.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self.dataList = model.toCoinConfig
        } failureBlock: { _ in
        }
    }
    func getCoin() {
        WalletNetWork.getAccount().lmrequest {[weak self] responseModel in
            guard let model = WalletItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self?.coinlb.text = String(model.cash)
        } failureBlock: { _ in
        }
    }
    @objc func withdrawalbtnClick() {
    }
    @objc func exchangebtnClick() {
        guard let itemId = self.seydtem?.itemId, let user = UserShared.user else { return }
        if user.realAuth == false {
            self.navigationController?.pushViewController(RealAuthViewController(routetype: .toRoom), animated: true)
        } else {
            WalletNetWork.WithdrawCoin(itemId: itemId).lmrequest {[weak self] _ in
                HUD.showSuccess("兑换成功")
                self?.getCoin()
            } failureBlock: { error in
                HUD.show(error.message)
            }
        }
    }
}
extension WithdrawalViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let cell = collectionView.dequeueReusableCell(cellType: WithdrawalCollectionViewCell.self, cellForRowAt: indexPath)
        let model = dataList[indexPath.row]
        cell.dataSoure = model
        if model.itemId == seydtem?.itemId {
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
