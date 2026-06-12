import UIKit
class MineAccountSafeViewController: LMBaseVC {
    lazy var phoneView = LMVerticalView(title: "手机号", type: .lbType)
    lazy var realyView = LMVerticalView(title: "实名认证", type: .lbType)
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "账号与安全"
        setViewSnp()
        setDataSoure()
    }
    private func setViewSnp() {
        let safeView = UIView()
        safeView.backgroundColor = .white
        safeView.set_Border(radius: kScaleWidth(16))
        view.addSubview(safeView)
        realyView.subtitleLab.textColor = .textLink
        safeView.addSubview(phoneView)
        safeView.addSubview(realyView)
        for (index, view) in safeView.subviews.enumerated() {
            view.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(CGFloat(index) * kScaleWidth(56))
                make.height.equalTo(kScaleWidth(56))
                if index == safeView.subviews.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
        }
        safeView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.width.equalTo(kScreenWidth - kScaleWidth(32))
            make.top.equalToSuperview().offset(kScaleWidth(16) + kNavigationHeight)
        }
        let resignView = LMVerticalView(title: "注销账号", type: .nomal)
        resignView.set_Border(radius: kScaleWidth(16))
        resignView.titleLab.textColor = lmColorHex("#F5455C")
        view.addSubview(resignView)
        resignView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.width.equalTo(kScreenWidth - kScaleWidth(32))
            make.height.equalTo(kScaleWidth(56))
            make.top.equalTo(safeView.snp.bottom).offset(kScaleWidth(20))
        }
        phoneView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(MinePhoneViewController(), animated: true)
        }
        realyView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(RealAuthViewController(routetype: .popView), animated: true)
        }
        resignView.addGestureTap { [weak self] _ in
            self?.navigationController?.pushViewController(CancelAccountViewController(), animated: true)
        }
    }
    func setDataSoure() {
        if let mobel = UserShared.user?.mobile {
            phoneView.subtitleLab.text = "尾号 \(mobel.sub(start: 7, length: 4))"
        } else {
            phoneView.subtitleLab.text = ""
        }
        if UserShared.user?.realAuth == true {
            realyView.subtitleLab.text = "已认证"
        } else {
            realyView.subtitleLab.text = "未认证"
        }
    }
}
