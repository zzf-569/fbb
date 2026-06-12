import UIKit
class LMSheetCollectionVC: UIViewController {
    enum Theme {
        case light
        case dark
    }
    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            .backgroundColor(theme == .dark ? lmColorHex("#2B313D", alpha: 0.4) : lmColorHex("#0000007F"))
            .alpha(0)
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.cancelAction()
        }
        return view
    }()
    private lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 100.0))
            .backgroundColor(theme == .dark ? lmColorHex("#2B313D") : lmColorHex("#F5F6FA"))
        return view
    }()
    private lazy var titleLable: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: theme == .dark ? .white : lmColorHex("#2B313D"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [LMSheetCell.self])
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    private lazy var cancelbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(18), titleColor: theme == .dark ? .white : lmColorHex("#2B313D"), target: self, action: #selector(cancelAction))
            .backgroundColor(theme == .dark ? lmColorHex("#292938") : .white)
            .cornerRadius(12.0)
        return btn
    }()
    private let theme: LMSheetCollectionVC.Theme
    private let contentTitle: String?
    private let dataSource: [LMSheetItemModel]
    private let cancel: String?
    private let callbackblock: (LMSheetItemModel?) -> Void
    private var itemHSpacing = kScaleWidth(16.0)
    private var itemVSpacing = kScaleWidth(16.0)
    private init(theme: LMSheetCollectionVC.Theme, title: String?, dataSource: [LMSheetItemModel], cancel: String?, callbackblock: @escaping (LMSheetItemModel?) -> Void) {
        self.theme = theme
        self.contentTitle = title
        self.dataSource = dataSource
        self.cancel = cancel
        self.callbackblock = callbackblock
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        show()
    }
    deinit {
        lmPrint("UIViewController deinit：----------------\(Self.className)已被销毁")
    }
}
extension LMSheetCollectionVC {
    @discardableResult
    static func show(theme: LMSheetCollectionVC.Theme = .dark, title: String?, items: [LMSheetItemModel], cancel: String?, callback block: @escaping (LMSheetItemModel?) -> Void) -> LMSheetCollectionVC {
        let sheet = LMSheetCollectionVC(theme: theme, title: title, dataSource: items, cancel: cancel, callbackblock: block)
        UIViewController.current?.addChild(sheet)
        UIViewController.current?.view.addSubview(sheet.view)
        sheet.view.frame = UIScreen.main.bounds
        return sheet
    }
}
private extension LMSheetCollectionVC {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(contentView)
        var contentHeight = 0.0
        if let contentTitle = contentTitle {
            contentHeight += itemVSpacing   
            contentHeight += 24.0
            contentView.addSubview(titleLable)
            titleLable.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(itemVSpacing)
                make.height.equalTo(24.0)
            }
            titleLable.text = contentTitle
        }
        contentHeight += itemVSpacing   
        contentView.addSubview(collectionView)
        let itemWidth = 72.0
        let itemHeight = 82.0
        let trueWidth = itemHSpacing + Double(dataSource.count) * itemWidth + (Double(dataSource.count) - 1.0) * itemHSpacing + itemHSpacing
        if trueWidth > kScreenWidth {
            let listHeight = itemHeight + itemHSpacing + itemHeight
            collectionView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(itemHSpacing)
                make.right.equalToSuperview().offset(-itemHSpacing)
                make.top.equalToSuperview().offset(contentHeight)
                make.height.equalTo(listHeight)
            }
            contentHeight += listHeight
        } else {
            itemHSpacing = (kScreenWidth - Double(dataSource.count) * itemWidth)/(Double(dataSource.count) + 1.0) - 0.5
            collectionView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(itemHSpacing)
                make.right.equalToSuperview().offset(-itemHSpacing)
                make.top.equalToSuperview().offset(contentHeight)
                make.height.equalTo(itemHeight)
            }
            contentHeight += itemHeight
        }
        if let cancel = cancel {
            contentHeight += itemVSpacing   
            contentView.addSubview(cancelbtn)
            cancelbtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(kScaleWidth(16.0))
                make.right.equalToSuperview().offset(-kScaleWidth(16.0))
                make.top.equalToSuperview().offset(contentHeight)
                make.height.equalTo(56.0)
            }
            contentHeight += 56.0
            cancelbtn.lmtitle(cancel)
        }
        contentHeight += itemVSpacing   
        contentHeight += kTabBarSafeHeight
        contentView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: contentHeight)
        contentView.set_Border(radius: 24.0, conrners: [.topLeft, .topRight])
        collectionView.reloadData()
    }
    func show() {
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
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @objc func cancelAction() {
        callbackblock(nil)
        hide()
    }
}
extension LMSheetCollectionVC: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: LMSheetCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(dataSource[indexPath.row])
        cell.set_Theme(theme)
        cell.contentView.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.selectedCell(indexPath)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 64.0, height: 64.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        itemVSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        itemHSpacing
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    func selectedCell(_ indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if model.isEnable {
            callbackblock(dataSource[indexPath.row])
            hide()
        }
    }
}
