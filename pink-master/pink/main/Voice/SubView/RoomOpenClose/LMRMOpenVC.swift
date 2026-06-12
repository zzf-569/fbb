import UIKit
import ZLPhotoBrowser
import Qiniu
extension LMRMOpenVC {
    func show(_ vc: UIViewController? = nil) {
        if let viewController = vc {
            viewController.addChild(self)
            viewController.view.addSubview(self.view)
        } else {
            UIViewController.current?.addChild(self)
            UIViewController.current?.view.addSubview(self.view)
        }
        self.view.frame = UIScreen.main.bounds
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.bgView.snp.updateConstraints { make in
                    make.top.equalToSuperview().offset(0)
                }
                self.view.layoutIfNeeded()
            } completion: { _ in
            }
        }
    }
    @objc func hide() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.bgView.snp.updateConstraints { make in
                    make.top.equalToSuperview().offset(kScreenHeight)
                }
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.clear()
            }
        }
    }
}
class LMRMOpenVC: LMBaseVC {
    var dataSoure:RoomItem = RoomItem() {
        didSet {
           roomName.lmtext(dataSoure.roomName)
        }
    }
    private lazy var bgView: UIImageView = {
        let imv = UIImageView(frame: view.bounds)
        imv.isUserInteractionEnabled = true
        imv.image(UIImage(named: "rm_open_bg"))
        return imv
    }()
    private lazy var closebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_popclose"), target: self, action: #selector(hide))
        return btn
    }()
    lazy var roomName: UITextField = {
        let textField = UITextField(lmfont: lmFontASHTB(36), textColor: .white)
        textField.textAlignment = .center
        textField.backgroundColor(.clear)
        return textField
    }()
    lazy var agreementBoxbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_box"), target: self, action: #selector(boxbtnAction))
            .image(UIImage(named: "cm_box_s"), .selected)
        btn.isSelected = true
        return btn
    }()
    lazy var agreementlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(14), textColor: UIColor.textSecondColor)
            .textAlignment(.center)
            .lmtext("")
        return lb
    }()
    lazy var openbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .white, target: self, action: #selector(openAction))
            .lmtitle("立即开播")
            .backgroundColor(lmColorHex("#FF4F7DFF"))
            .cornerRadius(12)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.backgroundImage = nil
        self.view.backgroundColor = .clear
        setViewSnp()
        set_upAgreement()
    }
    private func setViewSnp() {
        view.addSubview(bgView)
        bgView.addSubview(closebtn)
        bgView.addSubview(roomName)
        bgView.addSubview(openbtn)
        bgView.addSubview(agreementlb)
        bgView.addSubview(agreementBoxbtn)
        bgView.snp.makeConstraints { make in
            make.left.right.height.equalToSuperview()
            make.top.equalToSuperview().offset(kScreenHeight)
        }
        closebtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(4))
            make.top.equalToSuperview().offset(kNavigationBarHeight + kScaleWidth(4))
            make.size.equalTo(CGSize(width: kScaleWidth(48), height: kScaleWidth(48)))
        }
       roomName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(86) + kNavigationHeight)
            make.size.equalTo(CGSize(width: kScreenWidth, height: kScaleWidth(48)))
        }
        agreementlb.snp.makeConstraints { make in
            make.bottom.equalTo(openbtn.snp.top).offset(-kScaleWidth(20.0))
            make.centerX.equalToSuperview()
        }
        agreementBoxbtn.snp.makeConstraints { make in
            make.right.equalTo(agreementlb.snp.left).offset(-6.0)
            make.centerY.equalTo(agreementlb.snp.centerY)
            make.width.height.equalTo(16.0)
        }
        openbtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(kScaleWidth(56) + kTabBarSafeHeight))
            make.size.equalTo(CGSize(width: kScaleWidth(310), height: kScaleWidth(56)))
        }
        bgView.addGestureTap { [weak self] _ in
            self?.roomName.resignFirstResponder()
        }
    }
    func set_upAgreement() {
        let text = "开播即代表同意 "
        let textAction1 = "主播协议"
        let textAnd = " 和 "
        let textAction2 = "房间协议"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: lmFontR(12), .foregroundColor: lmColorHex("#FFFFFF")])
        attributedString.append(NSAttributedString(string: textAction1, attributes: [.font: lmFontR(12), .foregroundColor: UIColor.textLink]))
        attributedString.append(NSAttributedString(string: textAnd, attributes: [.font: lmFontR(12), .foregroundColor: lmColorHex("#FFFFFF")]))
        attributedString.append(NSAttributedString(string: textAction2, attributes: [.font: lmFontR(12), .foregroundColor: UIColor.textLink]))
        self.agreementlb.attributedText = attributedString
        self.agreementlb.addGestureTap { [weak self] tap in
            (tap as? UITapGestureRecognizer)?.didTapLabelAttributedText([textAction1, textAction2]) { [weak self] text in
                guard let self = self else { return }
                if textAction1 == text {
                    self.navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.service), animated: true)
                }
                if textAction2 == text {
                    self.navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.privacy), animated: true)
                }
            }
        }
    }
    @objc func boxbtnAction(_ btn: UIButton) {
        btn.isSelected(!btn.isSelected)
    }
}
extension LMRMOpenVC {
    @objc func openAction() {
        guard agreementBoxbtn.isSelected else {
            HUD.show("请同意主播协议和房间协议")
            return
        }
       RoomNetWork.openRoom(roomId: self.dataSoure.roomId, cover: self.dataSoure.cover,roomName: self.roomName.text, notification: self.dataSoure.notification).lmrequest {[weak self] _ in
            guard let self = self else {return}
            self.hide()
           VoiceShared.turnToRM(self.dataSoure.roomId)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
