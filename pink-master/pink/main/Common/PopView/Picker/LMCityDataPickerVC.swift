import UIKit
import BRPickerView
extension LMCityDataPickerVC {
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
class LMCityDataPickerVC: UIViewController {
    enum PickerType {
        case city, data
    }
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
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(20), textColor: .textDefaulColor)
            .textAlignment(.center)
            .lmtext(_title)
        return lb
    }()
    private lazy var pickerCenter: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var pickerView: BRTextPickerView = {
        let style = BRPickerStyle()
        style.pickerTextColor = .textDefaulColor
        style.pickerTextFont = lmFontM(18)
        style.pickerColor = .clear
        style.separatorColor = .clear
        let pickerView = BRTextPickerView(pickerMode: .componentCascade)
        pickerView.title = "请选择地区"
        pickerView.fileName = "region_tree_data.json"
        pickerView.showColumnNum = 2
        pickerView.backgroundColor(.clear)
        pickerView.pickerHeaderView = nil
        pickerView.pickerFooterView = nil
        pickerView.pickerStyle = style
        self.selectString = "东城区"
        pickerView.multiChangeBlock = {[weak self] models, _ in
            self?.selectString = models?.last?.text
        }
        return pickerView
    }()
    private lazy var dataPickerView: BRDatePickerView = {
        let style = BRPickerStyle()
        style.pickerTextColor = .textDefaulColor
        style.pickerTextFont = lmFontM(18)
        style.pickerColor = .clear
        style.separatorColor = .clear
        let pickerView = BRDatePickerView(pickerMode: dataModel)
        pickerView.title = "请选择生日"
        pickerView.backgroundColor(.clear)
        pickerView.pickerHeaderView = nil
        pickerView.pickerFooterView = nil
        pickerView.pickerStyle = style
        let currentDate = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = -18
        let date18YearsAgo = calendar.date(byAdding: dateComponents, to: currentDate)
        pickerView.maxDate = date18YearsAgo
        pickerView.selectDate = date18YearsAgo
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timer = (dateFormatter.string(from: date18YearsAgo ?? Date()))
        self.selectString = timer
        pickerView.changeRangeBlock = {[weak self] _, _, selectValue in
            self?.selectString = selectValue
        }
        return pickerView
    }()
    private lazy var cancelbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(18), titleColor: .textDefaulColor, target: self, action: #selector(cancelbtnAction))
            .lmtitle(cancel)
            .cornerRadius(12.0)
            .backgroundColor(lmColorHex("#2B313D0A"))
        return btn
    }()
    private lazy var confirmbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(18), titleColor: lmColorHex("#FFFFFFE0"), target: self, action: #selector(confirmbtnAction))
            .lmtitle(confirm)
            .cornerRadius(12.0)
            .backgroundColor(lmColorHex("#FF4F7DFF"))
        return btn
    }()
    private let _title: String
    private let pickerType: PickerType
    private let dataModel: BRDatePickerMode
    private let cancel: String
    private let confirm: String
    private let callbackblock: (String?) -> Void
    private var selectString: String?
    public init(title: String, pickerType: PickerType, dataModel: BRDatePickerMode = .YMD, cancel: String, confirm: String, complete block: @escaping (String?) -> Void) {
        self._title = title
        self.pickerType = pickerType
        self.dataModel = dataModel
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
private extension LMCityDataPickerVC {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(contentView)
        contentView.addSubview(titleLab)
        contentView.addSubview(pickerCenter)
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
        pickerCenter.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalTo(titleLab.snp.bottom).offset(32.0)
            make.height.equalTo(150.0)
        }
        if self.pickerType == .city {
            pickerView.addPicker(to: pickerCenter)
            pickerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            dataPickerView.addPicker(to: pickerCenter)
            dataPickerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        cancelbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.top.equalTo(pickerCenter.snp.bottom).offset(32.0)
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
        let item = selectString
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
