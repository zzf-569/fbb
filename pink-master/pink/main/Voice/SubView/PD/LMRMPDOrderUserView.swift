import UIKit
extension LMRMPDOrderUserView {
    func set_User(_ model: UsInfoItem?) {
        if let model = model {
            addView.isHidden = true
            userView.isHidden = false
            usheaderView.set_Image(url: model.avatar)
            namelb.text = model.nickname
            textField.text = ""
        } else {
            addView.isHidden = false
            userView.isHidden = true
            usheaderView.image = nil
            namelb.text = ""
            textField.text = ""
        }
    }
}
class LMRMPDOrderUserView: UIView, UITextFieldDelegate {
    private let title: String
    private let addUserblock: (UsInfoItem) -> Void
    private let removeUserblock: () -> Void
    init(frame: CGRect, title: String, addUserblock: @escaping (UsInfoItem) -> Void, removeUserblock: @escaping () -> Void) {
        self.title = title
        self.addUserblock = addUserblock
        self.removeUserblock = removeUserblock
        super.init(frame: frame)
        self.set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var markimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_dispatch_release_mark"))
        return imv
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFF"))
            .lmtext(title)
        return lb
    }()
    private lazy var bgView: UIView = {
        let view = UIView()
            .backgroundColor(lmColorHex("#000000", alpha: 0.2))
            .cornerRadius(24.0, borderColor: lmColorHex("#FFFFFF", alpha: 0.16), borderWidth: 0.5)
        return view
    }()
    private lazy var addView: UIView = {
        let view = UIView()
            .backgroundColor(.clear)
        return view
    }()
    private lazy var textField: UITextField = {
        let placeholder = title == "下单嘉宾" ? "请输入用户 ID" : "请输入陪玩主播ID"
        let textField = UITextField(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFF", alpha: 0.96), placeholder: placeholder, placeholderColor: lmColorHex("#FFFFFF", alpha: 0.24))
            .keyboardType(.phonePad)
        textField.rightView = addbtn
        textField.rightViewMode = .always
        textField.delegate = self
        return textField
    }()
    private lazy var addbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_dispatch_order_add_n"), target: self, action: #selector(addbtnAction))
            .image(UIImage(named: "rm_dispatch_order_add_d"), .disabled)
            .frame(CGRect(x: 0, y: 0, width: 28.0, height: 28.0))
            .isEnabled(false)
        return btn
    }()
    private lazy var userView: UIView = {
        let view = UIView()
            .backgroundColor(.clear)
            .isHidden(true)
        return view
    }()
    private lazy var usheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_avatar)
            .contentMode(.scaleAspectFill)
            .cornerRadius(24/2, borderColor: .white, borderWidth: 1.0)
        return imv
    }()
    private lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        return lb
    }()
    private lazy var removebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_dispatch_order_remove"), target: self, action: #selector(removebtnAction))
        return btn
    }()
    func textFieldDidEndEditing(_ textField: UITextField) {
        addbtn.isEnabled = textField.text?.length ?? 0 > 0 ? true : false
    }
}
private extension LMRMPDOrderUserView {
    private func set_Subviews() {
        addSubview(markimv)
        addSubview(titleLab)
        addSubview(bgView)
        bgView.addSubview(addView)
        addView.addSubview(textField)
        bgView.addSubview(userView)
        userView.addSubview(usheaderView)
        userView.addSubview(namelb)
        userView.addSubview(removebtn)
        markimv.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(5.0)
            make.width.equalTo(3.0)
            make.height.equalTo(12.0)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(markimv.snp.right).offset(8.0)
            make.centerY.equalTo(markimv)
        }
        bgView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(48.0)
        }
        addView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(40.0)
            make.right.equalToSuperview().offset(-16.0)
        }
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        userView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(48.0)
        }
        usheaderView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24.0)
        }
        namelb.snp.makeConstraints { make in
            make.left.equalTo(usheaderView.snp.right).offset(8.0)
            make.centerY.equalToSuperview()
        }
        removebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28.0)
        }
    }
    @objc func addbtnAction() {
        guard let text = textField.text else { HUD.showFailure("请输入正确的用户 ID"); return }
        HUD.showLoading()
        UserNetWork.userBaseInfo(targetUserId: text).lmrequest { [weak self] responseModel in
            HUD.hide()
            guard let self = self else { return }
            guard let model = UsInfoItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self.addUserblock(model)
            self.set_User(model)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func removebtnAction() {
        self.removeUserblock()
        self.set_User(nil)
    }
}
