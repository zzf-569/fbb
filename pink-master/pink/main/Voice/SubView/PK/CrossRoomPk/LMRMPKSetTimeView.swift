import UIKit
extension LMRMPKSetTimeView {
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
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.clear()
        }
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
class LMRMPKSetTimeView: UIViewController {
    var selectedPKTimeblock: ((Int) -> Void)?
    var selectdtime: Int?
    private var dataSource: [LMRMPKSetupModel] = {
        [LMRMPKSetupModel(title: "15分", imageName: "rm_pk_15bg", selected: false, time: 900),
        LMRMPKSetupModel(title: "30分", imageName: "rm_pk_30bg", selected: false, time: 1800),
        LMRMPKSetupModel(title: "45分", imageName: "rm_pk_45bg", selected: false, time: 2700)]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setViewSnp()
    }
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [LMRMPkSetTimeCell.self])
        return collectionView
    }()
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
        imv.addGestureTap { [weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
            }
        return imv
    }()
    private lazy var titleV: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(18), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .textAlignment(.center)
            .lmtext("PK邀请")
        return lb
    }()
    private lazy var hisTorybtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_pk_history"), target: self, action: #selector(historybtnAction))
        return btn
    }()
    private lazy var closebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_popclose"), target: self, action: #selector(closehbtnAction))
        return btn
    }()
    private lazy var starbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_pk_starbtn"), target: self, action: #selector(starbtnAction))
        return btn
    }()
}
private extension LMRMPKSetTimeView {
    private func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(bodyimv)
        bdView.addSubview(titleV)
        bdView.addSubview(collectionView)
        bdView.addSubview(starbtn)
        titleV.addSubview(titleLab)
        titleV.addSubview(closebtn)
        titleV.addSubview(hisTorybtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(0)
            make.height.equalTo(350.0 + kTabBarSafeHeight)
        }
        bodyimv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(56.0)
        }
        titleLab.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        closebtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36.0)
        }
        hisTorybtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36.0)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(12))
            make.top.equalTo(titleV.snp.bottom).offset(8.0)
            make.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 8.0 + 56.0))
        }
        starbtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(kScaleWidth(38) + kTabBarSafeHeight))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(358), height: kScaleWidth(56)))
        }
        view.layoutIfNeeded()
        bdView.set_Border(radius: 16.0, conrners: [.topLeft, .topRight])
    }
    @objc func closehbtnAction() {
        self.hide()
    }
    @objc func starbtnAction() {
        guard let time = self.selectdtime else {
            HUD.show("请选择PK时长")
            return
        }
        self.hide()
        self.selectedPKTimeblock?(time)
    }
    @objc func historybtnAction() {
    }
}
extension LMRMPKSetTimeView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType:LMRMPkSetTimeCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(dataSource[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScaleWidth(114), height: kScaleWidth(135))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        for (index, _) in dataSource.enumerated() {
            if index == indexPath.row {
                dataSource[index].selected = true
            } else {
                dataSource[index].selected = false
            }
        }
        collectionView.reloadData()
        self.selectdtime = dataSource[indexPath.row].time
    }
}
