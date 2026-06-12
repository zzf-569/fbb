import UIKit
class MinePhoneViewController: LMBaseVC {
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: .textDefaulColor)
            .lmtext("当前手机号码")
        lb.textAlignment(.center)
        return lb
    }()
    lazy var phoneView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScaleWidth(310), height: kScaleWidth(96)))
        view.set_Border(radius: 16, borderWidth: 0.5, borderColor: lmColorHex("#2B313D29"))
        return view
    }()
    lazy var phonelb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(20), textColor: .textDefaulColor)
        lb.textAlignment(.center)
        return lb
    }()
    lazy var eyesbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "myPhone_eye_s"), target: self, action: #selector(eyesbtnClick))
        btn.setImage(UIImage(named: "myPhone_eye"), for: .selected)
        return btn
    }()
    lazy var surebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .white, target: self, action: #selector(sendsms))
        btn.backgroundColor(lmColorHex("#FF4F7DFF"))
        btn.cornerRadius(12)
        btn.lmtitle("更换手机号")
        return btn
    }()
    lazy var changebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: lmColorHex("#F5455CFF"), target: self, action: #selector(cancelUser))
        btn.cornerRadius(12)
        btn.lmtitle("注销手机号")
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setDataSoure()
    }
    private func setViewSnp() {
        backgroundImage = nil
        view.backgroundColor = .white
        view.addSubview(titleLab)
        view.addSubview(phoneView)
        phoneView.addSubview(phonelb)
        phoneView.addSubview(eyesbtn)
        view.addSubview(surebtn)
        view.addSubview(changebtn)
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(40) + kNavigationHeight)
            make.height.equalTo(kScaleWidth(32))
        }
        phoneView.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(kScaleWidth(80))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(310), height: kScaleWidth(96)))
        }
        phonelb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(kScaleWidth(83))
        }
        eyesbtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-kScaleWidth(20))
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        surebtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(kScaleWidth(56) + kTabBarSafeHeight))
            make.size.equalTo(CGSize(width: kScaleWidth(310), height: kScaleWidth(56)))
        }
        changebtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(kScaleWidth(120) + kTabBarSafeHeight))
            make.size.equalTo(CGSize(width: kScaleWidth(310), height: kScaleWidth(56)))
        }
    }
    func setDataSoure() {
        guard let mobel = UserShared.user?.mobile else {
            return
        }
        phonelb.lmtext("\( mobel.hide12BitsPhone())")
    }
    @objc func sendsms() {
        guard let mobel = UserShared.user?.mobile else {
            return
        }
        self.navigationController?.pushViewController(ChangePhoneSendSmsViewController(phone: mobel, type: "check"), animated: true)
    }
    @objc func cancelUser() {
        self.navigationController?.pushViewController(CancelAccountViewController(), animated: true)
    }
    @objc func eyesbtnClick() {
        guard let mobel = UserShared.user?.mobile else {
            return
        }
        eyesbtn.isSelected = !eyesbtn.isSelected
        if eyesbtn.isSelected == false {
            phonelb.lmtext("\( mobel.hide12BitsPhone())")
        } else {
            phonelb.lmtext(mobel)
        }
    }
}
