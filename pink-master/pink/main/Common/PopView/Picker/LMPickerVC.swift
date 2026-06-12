import UIKit
extension LMPickerVC {
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
class LMPickerVC: UIViewController {
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
            .backgroundColor(kTheme(style: theme, lightColor: lmColorHex("#F5F6FA"), darkColor: lmColorHex("#2B313D")))
        return view
    }()
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(16), textColor: kTheme(style: theme, lightColor: .textDefaulColor, darkColor: .white))
            .textAlignment(.center)
            .lmtext(_title)
        return lb
    }()
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor(.clear)
        return pickerView
    }()
    lazy var cancelbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: kTheme(style: theme, lightColor: .textDefaulColor, darkColor: lmColorHex("#FFFFFFE0")), target: self, action: #selector(cancelbtnAction))
            .lmtitle(cancel)
            .cornerRadius(12.0)
            .backgroundColor(kTheme(style: theme, lightColor: .white, darkColor: lmColorHex("#FFFFFF14")))
        return btn
    }()
    private lazy var confirmbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: lmColorHex("#FFFFFFE0"), target: self, action: #selector(confirmbtnAction))
            .lmtitle(confirm)
            .cornerRadius(12.0)
            .backgroundColor(lmColorHex("#FF4F7D"))
        return btn
    }()
    private let theme: UIUserInterfaceStyle
    private let _title: String
    private let dataSource: [PickerListModel]
    private let cancel: String
    private let confirm: String
    private let callbackblock: (PickerListModel?) -> Void
    public init(theme: UIUserInterfaceStyle, title: String, dataSource: [PickerListModel], cancel: String, confirm: String, complete block: @escaping (PickerListModel?) -> Void) {
        self.theme = theme
        self._title = title
        self.dataSource = dataSource
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
        setViewSnp()
    }
    deinit {
        lmPrint("UIViewController deinit：----------------\(Self.className)已被销毁")
    }
}
private extension LMPickerVC {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(contentView)
        contentView.addSubview(titleLab)
        contentView.addSubview(pickerView)
        contentView.addSubview(cancelbtn)
        contentView.addSubview(confirmbtn)
        let contentHeight = getContentHeight()
        contentView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: contentHeight)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalToSuperview().offset(24.0)
            make.height.equalTo(24.0)
        }
        pickerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalTo(titleLab.snp.bottom).offset(32.0)
            make.height.equalTo(150.0)
        }
        cancelbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.top.equalTo(pickerView.snp.bottom).offset(32.0)
            make.height.equalTo(56.0)
        }
        confirmbtn.snp.makeConstraints { make in
            make.left.equalTo(cancelbtn.snp.right).offset(16.0)
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalTo(cancelbtn)
            make.height.equalTo(56.0)
            make.width.equalTo(cancelbtn)
        }
        contentView.set_Border(radius: 24.0, conrners: [.topLeft, .topRight])
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @objc func cancelbtnAction() {
        callbackblock(nil)
        hide()
    }
    @objc func confirmbtnAction() {
        let item = self.dataSource[self.pickerView.selectedRow(inComponent: 0)]
        callbackblock(item)
        hide()
    }
    func getContentHeight() -> Double {
        var allHeight = 24.0
        allHeight += 24.0
        allHeight += 32.0
        allHeight += 150.0
        allHeight += 32.0
        allHeight += 56.0
        allHeight += 32.0
        allHeight += kTabBarSafeHeight
        return allHeight
    }
}
extension LMPickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return kScreenWidth - 48
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 48.0
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            let title = dataSource[row].title
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: kTheme(style: theme, lightColor: .textDefaulColor, darkColor: .white),
                .font: UIFont.systemFont(ofSize: 18)
            ]
            return NSAttributedString(string: title, attributes: attributes)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}
