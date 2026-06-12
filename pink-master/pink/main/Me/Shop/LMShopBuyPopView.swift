import UIKit
extension LMShopBuyPopView {
    func show(_ vc: UIViewController? = nil) {
        if let viewController = vc {
            viewController.addChild(self)
            viewController.view.addSubview(self.view)
        } else {
            UIViewController.current?.addChild(self)
            UIViewController.current?.view.addSubview(self.view)
        }
        self.view.frame = UIScreen.main.bounds
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
            self.contentView.y = kScreenHeight - self.contentView.height
        } completion: { _ in
        }
    }
    func hide(callback: ShopPriceList?) {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.contentView.y = kScreenHeight
        } completion: { _ in
            self.callbackblock(callback)
            self.clear()
        }
    }
}
class LMShopBuyPopView: BasePopViewController {
    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            .backgroundColor(lmColorHex("#00000080"))
            .alpha(0)
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide(callback: nil)
        }
        return view
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
            .backgroundColor(theme == .dark ? lmColorHex("#2B313D") : .white)
        return view
    }()
    lazy var headerView: UIImageView = {
        let imageV = UIImageView()
        imageV.cornerRadius(kScaleWidth(112/2))
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
        lb.textAlignment(.center)
        return lb
    }()
    lazy var headWear: LMAnimationPlayer = {
        let pagView = LMAnimationPlayer()
        return pagView
    }()
    lazy var voiceWave: LMAnimationPlayer = {
        let pagView = LMAnimationPlayer()
        return pagView
    }()
    lazy var textlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(20), textColor: .textDefaulColor)
            .textAlignment(.center)
            .lmtext("粉贝贝")
            .numberOfLines(0)
        return lb
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(18), textColor: theme == .dark ? lmColorHex("#FFFFFF") : .textDefaulColor)
            .lmtext(model.dressUpName)
        return lb
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [LMShopBuyCell.self])
        return collectionView
    }()
    private lazy var closebtn: UIButton = {
        let btn = UIButton(image: theme == .dark ?  UIImage(named: "rm_popclose") : UIImage(named: "cm_close_dark"), target: self, action: #selector(cancelbtnAction))
        return btn
    }()
    private lazy var tipsView: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: theme == .dark ? .whiteSecondary : .textSecondColor)
            .lmtitle("选择购买时间")
            .image(UIImage(named: theme == .dark ? "shopbuy_tips_dark" : "shopbuy_tips"))
        return btn
    }()
    private lazy var balanceView: LMShopBalanceView = {
        let view = LMShopBalanceView(theme: theme)
        view.addGestureTap { [weak self] _ in
            UIViewController.current?.navigationController?.pushViewController(RechargeViewController(), animated: true)
        }
        return view
    }()
    lazy var butbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(18), titleColor: .white, target: self, action: #selector(confirmbtnAction))
            .backgroundColor(lmColorHex("#FF4F7DFF"))
            .lmtitle(confirmText)
            .cornerRadius(kScaleWidth(24))
        return btn
    }()
    private let theme: UIUserInterfaceStyle
    private let model: ShopListItem
    private let callbackblock: (ShopPriceList?) -> Void
    private var selectModel: ShopPriceList?
    private var confirmText: String = ""
    public init(theme: UIUserInterfaceStyle, confirmText: String, model: ShopListItem, block: @escaping (ShopPriceList?) -> Void) {
        self.theme = theme
        self.model = model
        self.confirmText = confirmText
        self.callbackblock = block
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setDataSoure()
    }
    deinit {
        lmPrint("UIViewController deinit：----------------\(Self.className)已被销毁")
    }
}
private extension LMShopBuyPopView {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(contentView)
        contentView.addSubview(closebtn)
        contentView.addSubview(titleLab)
        contentView.addSubview(tipsView)
        contentView.addSubview(balanceView)
        contentView.addSubview(collectionView)
        contentView.addSubview(butbtn)
        contentView.addSubview(voiceWave)
        contentView.addSubview(headerView)
        contentView.addSubview(headWear)
        contentView.addSubview(namelb)
        headerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(64))
            make.size.equalTo(CGSize(width: kScaleWidth(112), height: kScaleWidth(112)))
        }
        headWear.snp.makeConstraints { make in
            make.center.equalTo(headerView)
            make.size.equalTo(CGSize(width: kScaleWidth(144), height: kScaleWidth(144)))
        }
        voiceWave.snp.makeConstraints { make in
            make.center.equalTo(headerView)
            make.size.equalTo(CGSize(width: kScaleWidth(160), height: kScaleWidth(160)))
        }
        namelb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(kScaleWidth(12))
        }
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        closebtn.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(kScaleWidth(10))
            make.size.equalTo(CGSize(width: kScaleWidth(36), height: kScaleWidth(36)))
        }
        var height: Int = 0
        if model.priceList.count%3 == 0 {
            height = model.priceList.count/3
        } else {
            height = model.priceList.count/3 + 1
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(222))
            make.height.equalTo(CGFloat(height) * kScaleWidth(90))
        }
        tipsView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.top.equalTo(collectionView.snp.bottom).offset(kScaleWidth(24))
            make.size.equalTo(CGSize(width: 92, height: kScaleWidth(20)))
        }
        balanceView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.top.equalTo(collectionView.snp.bottom).offset(kScaleWidth(24))
            make.height.equalTo(kScaleWidth(20))
        }
        butbtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalTo(collectionView.snp.bottom).offset(kScaleWidth(64))
            make.height.equalTo(kScaleWidth(48))
            make.bottom.equalToSuperview().offset(-(kScaleWidth(8) + kTabBarSafeHeight))
        }
        view.layoutIfNeeded()
        contentView.set_Border(radius: 24.0, conrners: [.topLeft, .topRight])
        balanceView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(RechargeViewController(), animated: true)
        }
    }
    func setDataSoure() {
        WalletNetWork.getAccount().lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            guard let model = WalletItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self.balanceView.set_Balance(model.coin)
        } failureBlock: { _ in
        }
        headWear.clear()
        voiceWave.clear()
        headerView.isHidden = true
        textlb.isHidden = true
        namelb.lmtext(model.dressUpName)
        switch model.type {
        case 1:
            headerView.isHidden = false
            headerView.set_Image(url: UserShared.user?.avatar, placeholder: kPlaceholder_avatar)
            headWear.play(url: model.resource, repeatCount: 0)
        case 2:
            headerView.isHidden = false
            headerView.set_Image(url: UserShared.user?.avatar, placeholder: kPlaceholder_avatar)
            voiceWave.play(url: model.resource, repeatCount: 0)
        case 3:
            break
        case 4:
            break
        default:
            break
        }
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @objc func confirmbtnAction() {
        if self.selectModel == nil {
            HUD.show("请选择购买时间")
            return
        }
        hide(callback: self.selectModel)
    }
    @objc func cancelbtnAction() {
        hide(callback: nil)
    }
}
extension LMShopBuyPopView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.priceList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: LMShopBuyCell.self, cellForRowAt: indexPath)
        let pricemodel = model.priceList[indexPath.row]
        cell.dataSoure = pricemodel
        cell.theme = theme
        if let selectModel = self.selectModel {
            cell.select = selectModel.id == pricemodel.id
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: kScaleWidth(106), height: kScaleWidth(72))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        kScaleWidth(4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        kScaleWidth(16)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectModel = model.priceList[indexPath.row]
        collectionView.reloadData()
    }
}
