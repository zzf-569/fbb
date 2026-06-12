import UIKit
extension LMRMNamePopController {
    @discardableResult
    static func show(text: String,roomId: String, completion block: @escaping ((String) -> Void)) ->LMRMNamePopController {
        let pop = LMRMNamePopController(text,roomId:roomId, block: block)
        UIViewController.current?.addChild(pop)
        UIViewController.current?.view.addSubview(pop.view)
        pop.view.frame = UIScreen.main.bounds
        return pop
    }
}
class LMRMNamePopController: UIViewController, UITextFieldDelegate {
    private lazy var bgView: UIView = {
        let view = UIView()
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.textField.resignFirstResponder()
        }
        return view
    }()
    private lazy var bdView: UIView = {
        let view = UIView()
            .backgroundColor(lmColorHex("#212130"))
        return view
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(18), textColor: .white)
            .lmtext("房间标题")
        return lb
    }()
    private lazy var savebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: .white, target: self, action: #selector(savebtnAction))
            .lmtitle("保存")
            .backgroundColor(lmColorHex("#FF4F7D"))
            .cornerRadius(32/2)
        return btn
    }()
    private lazy var textView: UIView = {
        let view = UIView()
            .backgroundColor(lmColorHex("#292938"))
            .cornerRadius(16)
        return view
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField(lmfont: lmFontM(16), textColor: .white)
            .placeholder("请输出房间标题")
            .lmtext(text)
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .send
        return textField
    }()
    private lazy var explainlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#FFFFFF", alpha: 0.4))
            .textAlignment(.center)
            .lmtext("最多输入12个字")
        return lb
    }()
    private let roomId: String
    private let text: String
    private let block: ((String) -> Void)
    init(_ text: String,roomId: String, block: @escaping ((String) -> Void)) {
        self.text = text
        self.roomId = roomId
        self.block = block
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setViewSnp()
        getViewData()
        addKeyboardNotification()
        self.textField.becomeFirstResponder()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.savebtnAction()
        return true
    }
}
private extension LMRMNamePopController {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(titleLab)
        bdView.addSubview(savebtn)
        bdView.addSubview(textView)
        bdView.addSubview(explainlb)
        textView.addSubview(textField)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(0)
            make.height.equalTo(64.0 + 8.0 + 56.0 + 8.0 + 20.0 + 16.0)
        }
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(19.0)
            make.height.equalTo(26.0)
        }
        savebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalToSuperview().offset(16.0)
            make.width.equalTo(56.0)
            make.height.equalTo(32.0)
        }
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(titleLab.snp.bottom).offset(27.0)
            make.height.equalTo(56.0)
        }
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(40.0)
        }
        explainlb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textView.snp.bottom).offset(8.0)
        }
        view.layoutIfNeeded()
        bdView.set_Border(radius: 16.0, conrners: [.topLeft, .topRight])
    }
    func getViewData() {
    }
    func refreshSubviews() {
    }
    @objc func savebtnAction() {
        guard let text = textField.text else {
            HUD.showFailure("请输入名称")
            return
        }
        HUD.showLoading()
       RoomNetWork.updateInfo(roomId:roomId, title: text).lmrequest { _ in
            HUD.showSuccess("修改成功")
            self.block(text)
            self.textField.resignFirstResponder()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
private extension LMRMNamePopController {
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(nt_keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nt_keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func nt_keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
            UIView.animate(withDuration: duration) {
                self.bdView.snp.updateConstraints { make in
                    make.top.equalTo(self.view.snp.bottom).offset(-(self.bdView.height + keyboardSize.height))
                }
                self.bdView.superview?.layoutIfNeeded()
            }
        }
    }
    @objc func nt_keyboardWillHide(notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
        UIView.animate(withDuration: duration) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}
