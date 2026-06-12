import UIKit
extension LMRMSendGiftNumView {
    func set_SendGiftNum(_ num: Int) {
    }
    func set_SendType(type: Int, dressModel: UserDressModel? = UserDressModel()) {
        switch type {
        case 0:
            sendbtn.isHidden(false)
            sendPackagebtn.isHidden(true)
            userDressbtn.isHidden(true)
            self.set_Border(radius: 32/2)
        case 1:
            sendbtn.isHidden(true)
            sendPackagebtn.isHidden(false)
            userDressbtn.isHidden(true)
            set_Border(radius: 32/2)
        default:
            sendbtn.isHidden(true)
            sendPackagebtn.isHidden(true)
            userDressbtn.isHidden(false)
            set_Border(radius: 32/2)
            if let dressModel = dressModel {
                if dressModel.isActive == false {
                    userDressbtn.lmtitle("使用")
                } else {
                    userDressbtn.lmtitle("使用中")
                }
            } else {
                userDressbtn.lmtitle("使用")
            }
        }
    }
}
class LMRMSendGiftNumView: UIView {
  lazy var sendbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: .white, target: self, action: #selector(sendbtnAction))
            .lmtitle("赠送")
            .backgroundImage(UIImage(named: "rm_slide_bg"))
            .cornerRadius(32/2)
        return btn
    }()
    private lazy var sendPackagebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: .white, target: self, action: #selector(sendPackagebtnAction))
            .lmtitle("赠送")
            .backgroundImage(UIImage(named: "rm_slide_bg"))
            .cornerRadius(32/2)
            .isHidden(true)
        return btn
    }()
    private lazy var userDressbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: .white, target: self, action: #selector(useDressbtnAction))
            .lmtitle("使用")
            .backgroundImage(UIImage(named: "rm_slide_bg"))
            .cornerRadius(32/2)
            .isHidden(true)
        return btn
    }()
    private var numbtnArray: [UIButton] = []
    var c_selectedNumblock: ((Int) -> Void)?
    var c_sendGiftblock: (() -> Void)?
    var c_sendPackageGiftblock: (() -> Void)?
    var c_useDressblock: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMSendGiftNumView {
    private func setViewSnp() {
        self.backgroundColor(lmColorHex("#FFFFFF14"))
        self.addSubview(sendbtn)
        self.addSubview(sendPackagebtn)
        self.addSubview(userDressbtn)
        sendbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(0.0)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        sendPackagebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(0.0)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        userDressbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(0.0)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        let numlist = ["1", "10", "99", "188", "999"]
        let numWidth = [24, 25, 27, 32, 34]
        for (index, str) in numlist.enumerated() {
            let btn = UIButton(lmfont: lmFontM(12), titleColor: lmColorHex("#FFFFFFA3"))
                .lmtitle(str)
                .titleColor(lmColorHex("#FF4F7DFF"), .selected)
                .backgroundColor(.clear)
                .cornerRadius(12)
            btn.addTarget(self, action: #selector(selectedNumAction), for: .touchUpInside)
            btn.tag = str.toInt() ?? 1
            if index == 0 {
                btn.isSelected = true
                btn.backgroundColor(.white)
            }
            addSubview(btn)
            btn.snp.makeConstraints { make in
                if index == 0 {
                    make.left.equalToSuperview().offset(4)
                } else {
                    make.left.equalTo(numbtnArray[index - 1].snp.right)
                }
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: numWidth[index], height: 24))
            }
            numbtnArray.append(btn)
        }
    }
    @objc func selectedNumAction(send: UIButton) {
        self.c_selectedNumblock?(send.tag)
        for btn in self.numbtnArray {
            if btn == send {
                btn.backgroundColor(.white)
                btn.isSelected = true
            } else {
                btn.backgroundColor(.clear)
                btn.isSelected = false
            }
        }
    }
    @objc func sendbtnAction() {
        self.c_sendGiftblock?()
    }
    @objc func sendPackagebtnAction() {
        self.c_sendPackageGiftblock?()
    }
    @objc func useDressbtnAction() {
        self.c_useDressblock?()
    }
}
