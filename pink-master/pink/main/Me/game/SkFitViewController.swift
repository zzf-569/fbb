import UIKit
extension SkFitViewController {
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
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.contentView.y = kScreenHeight
        } completion: { _ in
            self.clear()
        }
    }
}
class SkFitViewController: LMBaseVC {
    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            .backgroundColor(lmColorHex("#0000007F"))
            .alpha(0)
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 100.0))
            .backgroundColor(lmColorHex("#2B313D"))
        return view
    }()
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(20), textColor: .textDefaulColor)
            .textAlignment(.left)
            .lmtext(_title)
        return lb
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [SkFilCell.self])
        return collectionView
    }()
    lazy var cancelbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .textDefaulColor, target: self, action: #selector(a_cancelbtnAction))
            .lmtitle(cancel)
            .cornerRadius(12.0)
            .backgroundColor(lmColorHex("#2B313D0A"))
        return btn
    }()
    private lazy var confirmbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: lmColorHex("#00DBA9FF"), target: self, action: #selector(a_confirmbtnAction))
            .lmtitle(confirm)
            .cornerRadius(12.0)
            .backgroundColor(lmColorHex("#00DBA914"))
        return btn
    }()
    private var selectItem: [SkillItem] = []
    private let _title: String
    private let dataSource: [SkillItem]
    private let cancel: String
    private let confirm: String
    private let callbackblock: ([SkillItem]) -> Void
    public init(title: String, dataSource: [SkillItem], seleData: [SkillItem], cancel: String, confirm: String, complete block: @escaping ([SkillItem]) -> Void) {
        self._title = title
        self.dataSource = dataSource
        self.selectItem = seleData
        self.cancel = cancel
        self.confirm = confirm
        self.callbackblock = block
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        set_Subviews()
    }
    deinit {
        lmPrint("UIViewController deinit：----------------\(Self.className)已被销毁")
    }
}
private extension SkFitViewController {
    func set_Subviews() {
        backgroundImage = nil
        view.addSubview(bgView)
        view.addSubview(contentView)
        contentView.addSubview(titleLab)
        contentView.addSubview(collectionView)
        contentView.addSubview(cancelbtn)
        contentView.addSubview(confirmbtn)
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalToSuperview().offset(24.0)
            make.height.equalTo(24.0)
        }
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(-0)
            make.top.equalTo(titleLab.snp.bottom).offset(32.0)
            make.height.equalTo(getContentHeight())
        }
        cancelbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.top.equalTo(collectionView.snp.bottom).offset(32.0)
            make.height.equalTo(56.0)
        }
        confirmbtn.snp.makeConstraints { make in
            make.left.equalTo(cancelbtn.snp.right).offset(16.0)
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalTo(cancelbtn)
            make.height.equalTo(56.0)
            make.width.equalTo(cancelbtn)
            make.bottom.equalToSuperview().offset(-kScaleWidth(32.0) - kTabBarSafeHeight )
        }
        contentView.layoutIfNeeded()
        contentView.set_Border(radius: 24.0, conrners: [.topLeft, .topRight])
        collectionView.reloadData()
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @objc func a_cancelbtnAction() {
        callbackblock([])
        hide()
    }
    @objc func a_confirmbtnAction() {
        callbackblock(selectItem)
        hide()
    }
    func getContentHeight() -> Double {
        var allHeight = 0.00
        if dataSource.count%4 == 0 {
            allHeight = (Double(dataSource.count/4) * kScaleWidth(84))
        } else {
            allHeight = Double(dataSource.count/4 + 1) * kScaleWidth(84)
        }
        return allHeight
    }
}
extension SkFitViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: kScaleWidth(72), height: kScaleWidth(72))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: kScaleWidth(24), bottom: 0, right: kScaleWidth(24))
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: SkFilCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataSource[indexPath.row]
        cell.isSelectedItem = false
        for item in self.selectItem {
            if dataSource[indexPath.row].skillId == item.skillId {
                cell.isSelectedItem = true
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if self.selectItem.contains(where: {$0.skillId == model.skillId}) == false {
            self.selectItem.append(model)
        } else {
            for (index, item) in self.selectItem.enumerated() {
                if item.skillId == model.skillId {
                    self.selectItem.remove(at: index)
                }
            }
        }
        self.collectionView.reloadData()
    }
}
