import UIKit
class EditNameViewController: LMBaseVC {
    var dataSoure: UsInfoItem = UsInfoItem()
    lazy var textView: UITextView = {
        let textView = UITextView(lmfont: lmFontR(16), textColor: .textDefaulColor)
        textView.backgroundColor(.clear)
        textView.text = dataSoure.nickname
        return textView
    }()
    required init(model: UsInfoItem) {
        self.dataSoure = model
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
    private func setViewSnp() {
        view.backgroundColor = lmColorHex("#F5F6FA")
        backgroundImage = nil
        title = "昵称"
        let btn = UIButton(lmfont: lmFontM(18), titleColor: .textDefaulColor)
        btn.addTarget(self, action: #selector(save), for: .touchUpInside)
        btn.lmtitle("保存")
        btn.frame = CGRect(x: 0, y: 0, width: kScaleWidth(64), height: kScaleWidth(32)) 
        let rightBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(16) + kNavigationHeight)
            make.height.equalTo(kScreenHeight)
        }
    }
    func setDataSoure() {
    }
    @objc func save() {
        guard let name = textView.text else {
            LMToast.show("请输入昵称")
            return
        }
        HUD.showLoading()
        UserNetWork.updateUserInfo(nickname: name).lmrequest {[weak self] _ in
            LMToast.hide()
            self?.navigationController?.popViewController(animated: true)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
extension EditNameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 12
        }
}
