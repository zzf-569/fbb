import UIKit
extension LMSheetTableVC {
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
class LMSheetTableVC: LMBaseVC {
    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            .backgroundColor(lmColorHex("#2B313D", alpha: 0.4))
            .alpha(0)
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.cancelAction()
        }
        return view
    }()
    private lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 100.0))
            .backgroundColor(lmColorHex("#F5F6FA"))
        return view
    }()
    private lazy var titleLable: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#2B313D"))
            .textAlignment(.center)
        return lb
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMSheetTableCell.self])
        return tableView
    }()
    private lazy var cancelbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(18), titleColor: .textDefaulColor, target: self, action: #selector(cancelAction))
            .backgroundColor(lmColorHex("#2B313D0A"))
            .cornerRadius(12.0)
        return btn
    }()
    private let contentTitle: String?
    private let dataSource: [LMSheetTabModel]
    private let cancel: String?
    private let callbackblock: (LMSheetTabModel?) -> Void
    private let cellHeight = 56.0 + 24.0
    init(title: String?, dataSource: [LMSheetTabModel], cancel: String?, callbackblock: @escaping (LMSheetTabModel?) -> Void) {
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
        self.navigationController?.navigationBar.isHidden = true
        setViewSnp()
    }
    deinit {
        lmPrint("UIViewController deinit：----------------\(Self.className)已被销毁")
    }
}
private extension LMSheetTableVC {
    func setViewSnp() {
        backgroundImage = nil
        view.backgroundColor = .clear
        view.addSubview(bgView)
        view.addSubview(contentView)
        var contentHeight = 0.0
        if let contentTitle = contentTitle {
            contentHeight += 24.0   
            contentHeight += 24.0
            contentView.addSubview(titleLable)
            titleLable.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(24.0)
                make.height.equalTo(24.0)
            }
            titleLable.text = contentTitle
        }
        contentHeight += 24.0   
        contentView.addSubview(tableView)
        var listHeight = Double(self.dataSource.count) * cellHeight
        let listMaxHeight = 5.0 * cellHeight
        if listHeight > listMaxHeight {
            listHeight = listMaxHeight
        }
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalToSuperview().offset(contentHeight)
            make.height.equalTo(listHeight)
        }
        contentHeight += listHeight
        if let cancel = cancel, cancel.isEmpty == false {
            contentHeight += 24.0   
            contentView.addSubview(cancelbtn)
            cancelbtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24.0)
                make.right.equalToSuperview().offset(-24.0)
                make.top.equalToSuperview().offset(contentHeight)
                make.height.equalTo(56.0)
            }
            contentHeight += 56.0
            cancelbtn.lmtitle(cancel)
        }
        contentHeight += 24.0   
        contentHeight += kTabBarSafeHeight
        contentView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: contentHeight)
        contentView.set_Border(radius: 24.0, conrners: [.topLeft, .topRight])
        tableView.reloadData()
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
extension LMSheetTableVC: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: LMSheetTableCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(dataSource[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        callbackblock(dataSource[indexPath.row])
        hide()
    }
}
