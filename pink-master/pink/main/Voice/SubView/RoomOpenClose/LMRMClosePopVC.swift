import UIKit
extension LMRMClosePopVC {
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
    func hide() {
        self.clear()
    }
}
class LMRMClosePopVC: UIViewController {
    private lazy var bgView: UIImageView = {
        let imv = UIImageView(frame: view.bounds)
        imv.isUserInteractionEnabled = true
        imv.image(UIImage(named: "rm_open_bg"))
        return imv
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: lmColorHex("#FFFFFF"))
            .lmtext("当前直播已关闭").textAlignment(.center)
        return lb
    }()
    lazy var headImage: UIImageView = {
        let imageV = UIImageView().cornerRadius(kScaleWidth(32))
        return imageV
    }()
    private lazy var roomName: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#FFFFFFF5")).textAlignment(.center)
        return lb
    }()
    private lazy var closebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .white)
            .backgroundColor(lmColorHex("#FF4F7DFF"))
            .cornerRadius(12)
            .lmtitle("退出")
        btn.addTarget(self, action: #selector(closebtnClick), for: .touchUpInside)
        return btn
    }()
    private lazy var morebtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(closebtnClick), for: .touchUpInside)
        btn.backgroundColor(lmColorHex("#FFFFFF0F"))
        btn.lmtitle("去看更多精彩直播")
        btn.image(UIImage(named: "fam_more_w"))
        btn.font(lmFontR(14))
        btn.isHidden = true
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setViewSnp()
    }
    private func setViewSnp() {
        view.addSubview(bgView)
        bgView.addSubview(titleLab)
        bgView.addSubview(closebtn)
        bgView.addSubview(headImage)
        bgView.addSubview(roomName)
        bgView.addSubview(morebtn)
        bgView.snp.makeConstraints { make in
            make.left.right.height.equalToSuperview()
            make.top.equalToSuperview().offset(kScreenHeight)
        }
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(358))
        }
        headImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(100) + kNavigationHeight)
            make.size.equalTo(CGSize(width: kScaleWidth(64), height: kScaleWidth(64)))
        }
       roomName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headImage.snp.bottom).offset(kScaleWidth(20))
        }
        closebtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(430))
            make.size.equalTo(CGSize(width: kScaleWidth(220), height: kScaleWidth(56)))
        }
        morebtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalTo(roomName.snp.bottom).offset(kScaleWidth(40))
            make.height.equalTo(kScaleWidth(48))
        }
        morebtn.set_ImageTitleLayout(.imgRight)
    }
    func setDataSoure(headImage: String,RoomName: String, peoNum: String) {
    }
    @objc func closebtnClick() {
       VoiceShared.quiteRM()
        hide()
    }
}
extension LMRMClosePopVC {
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
