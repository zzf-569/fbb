import UIKit
import TencentCloudHuiyanSDKFace
class RealAuthViewController: LMBaseVC {
    enum routeType {
        case popView
        case toRoom
    }
    lazy var topImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "realAuth_top"))
        return imageV
    }()
    lazy var topView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScaleWidth(350), height: kScaleWidth(56)))
            .backgroundColor(lmColorHex("#F8F8FAFF"))
        view.set_Border(radius: 12, conrners: [.topLeft, .topRight])
        return view
    }()
    lazy var centerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScaleWidth(350), height: kScaleWidth(256)))
            .backgroundColor(.white)
        view.set_Border(radius: 12, conrners: [.bottomLeft, .bottomRight])
        return view
    }()
    lazy var nameField: UITextField = {
        let textField = UITextField(lmfont: lmFontR(16), textColor: .textDefaulColor, placeholder: "请输入真实姓名", placeholderColor: .textDisColor)
        textField.backgroundColor = lmColorHex("#2B313D0A")
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: kScaleWidth(100), height: kScaleWidth(56)))
        let lb = UILabel(lmfont: lmFontR(16), textColor: .textDefaulColor)
        lb.frame = CGRect(x: 0, y: 0, width: kScaleWidth(100), height: kScaleWidth(56))
        lb.lmtext("真实姓名")
        lb.textAlignment(.center)
        leftView.addSubview(lb)
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.cornerRadius(12)
        return textField
    }()
    lazy var cardField: UITextField = {
        let textField = UITextField(lmfont: lmFontR(16), textColor: .textDefaulColor, placeholder: "请输入身份证号码", placeholderColor: .textDisColor)
        textField.backgroundColor = lmColorHex("#2B313D0A")
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: kScaleWidth(100), height: kScaleWidth(56)))
        let lb = UILabel(lmfont: lmFontR(16), textColor: .textDefaulColor)
        lb.lmtext("身份证号")
        lb.frame = CGRect(x: 0, y: 0, width: kScaleWidth(100), height: kScaleWidth(56))
        lb.textAlignment(.center)
        leftView.addSubview(lb)
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.cornerRadius(12)
        return textField
    }()
    lazy var autnbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .white, target: self, action: #selector(getFaceId))
        btn.backgroundColor(lmColorHex("#618DF0FF"))
        btn.cornerRadius(12)
        btn.lmtitle("立即认证")
        return btn
    }()
    lazy var tipslb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
            .lmtext("请您使用有效身份证信息认证")
        return lb
    }()
    var orderNo: String = ""
    var routetype: routeType = .popView
    init(routetype: routeType) {
        self.routetype = routetype
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
    private func setViewSnp() {
        let btn = UIButton(image: UIImage(named: "cm_back_white"), target: self, action: #selector(backItemDidiClick))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#F7F8FAFF")
        view.addSubview(topImage)
        view.addSubview(topView)
        view.addSubview(centerView)
        topView.addSubview(tipslb)
        centerView.addSubview(nameField)
        centerView.addSubview(cardField)
        centerView.addSubview(autnbtn)
        topImage.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(370))
        }
        topView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(104) + kNavigationHeight)
            make.height.equalTo(kScaleWidth(56))
        }
        tipslb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.centerY.equalToSuperview()
        }
        centerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(kScaleWidth(256))
        }
        nameField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(20))
            make.height.equalTo(kScaleWidth(56))
        }
        cardField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalTo(nameField.snp.bottom).offset(kScaleWidth(20))
            make.height.equalTo(kScaleWidth(56))
        }
        let lineView = UIView().backgroundColor(lmColorHex("#FF4F7DFF"))
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalTo(centerView.snp.bottom).offset(kScaleWidth(43))
            make.size.equalTo(CGSize(width: 4, height: 16))
        }
        let tipslb = UILabel(lmfont: lmFontASHTB(16), textColor: .textDefaulColor).lmtext("温馨提示")
        view.addSubview(tipslb)
        tipslb.snp.makeConstraints { make in
            make.left.equalTo(lineView.snp.right).offset(kScaleWidth(8))
            make.centerY.equalTo(lineView.snp.centerY)
            make.size.equalTo(CGSize(width: kScreenWidth, height: 21))
        }
        let textlb = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#2B313DAD"))
            .lmtext("·认证前请确认您已满18岁，未满18岁您将无法认证。\n·您提供的证件信息将受到严格保护，未经本人许可不会用做其他用途；")
            .numberOfLines(0)
        view.addSubview(textlb)
        textlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.width.equalTo(kScreenWidth - kScaleWidth(40))
            make.top.equalTo(lineView.snp.bottom).offset(15)
        }
        autnbtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalTo(cardField.snp.bottom).offset(kScaleWidth(32))
            make.height.equalTo(kScaleWidth(56))
        }
        self.view.addGestureTap { [weak self] _ in
            self?.nameField.resignFirstResponder()
            self?.cardField.resignFirstResponder()
        }
    }
    @objc func backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
    func setDataSoure() {
        UserNetWork.realAuth().lmrequest { responseModel in
            guard let dic = responseModel.data as? [String: Any], let realyName =  dic["realName"] as? String, let idCard =  dic["idCard"] as? String else {return}
            self.nameField.text = realyName.replacingCharacters(range: NSRange(location: 1, length: 1), replacingString: "*")
            self.cardField.text = idCard.replacingCharacters(range: NSRange(location: 6, length: 8), replacingString: "********")
        } failureBlock: { _ in
        }
    }
    @objc func getFaceId() {
        self.nameField.resignFirstResponder()
        self.cardField.resignFirstResponder()
        guard let name = nameField.text else {
            HUD.show("请输入姓名")
            return
        }
        guard let idCard = cardField.text else {
            HUD.show("请输入身份证号")
            return
        }
        UserNetWork.getFaceId(name: name, idCard: idCard).lmrequest {[weak self] responseModel in
            guard let dic = responseModel.data as? [String: Any] else {return}
            self?.txAuto(dic: dic)
        } failureBlock: { error in
            HUD.show(error.message)
        }
    }
    func txAuto(dic: [String: Any]) {
        guard let userId = dic["userId"] as? String, let nonce = dic["nonce"] as? String, let sign = dic["sign"] as? String, let orderNo = dic["orderNo"] as? String, let faceId = dic["faceId"] as? String  else {
            return
        }
        let config = WBFaceVerifySDKConfig()
        config.useAdvanceCompare = true
        config.recordVideo = false
        let sever = WBFaceVerifyCustomerService.sharedInstance()
        sever.delegate = self
        sever.initAdvanceSDK(withUserId: userId, nonce: nonce, sign: sign, appid: AppConfig.FACE.appId, orderNo: orderNo, apiVersion: "1.0.0", licence: AppConfig.FACE.License, faceId: faceId, sdkConfig: config) {[weak self] in
            self?.orderNo = orderNo
            sever.startWbFaceVeirifySdk()
        } failure: { WBFaceError in
            HUD.show(WBFaceError.domain)
        }
    }
}
extension RealAuthViewController: WBFaceVerifyCustomerServiceDelegate {
    func wbfaceVerifyCustomerServiceDidFinished(with faceVerifyResult: WBFaceVerifyResult) {
        if faceVerifyResult.isSuccess {
            self.faceCheck()
        } else {
            HUD.show("验证失败")
        }
    }
    func faceCheck() {
        UserNetWork.faceCheck(orderNo: orderNo).lmrequest {[weak self] _ in
            HUD.showSuccess("认证成功")
            if self?.routetype == .popView {
                self?.navigationController?.popToViewControllerAtIndex(index: 1)
            } else {
                UserShared.getUserInfo {
                    guard let user = UserShared.user else {
                        return
                    }
                    self?.navigationController?.popToViewControllerAtIndex(index: 1)
                }
            }
        } failureBlock: { _ in
        }
    }
}
