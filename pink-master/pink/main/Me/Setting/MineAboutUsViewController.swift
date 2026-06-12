import UIKit
import SwiftUI
extension MineAboutUsViewController {
}
struct TestModel {
    var value1: String = ""
    var value2: String = ""
}
class MineAboutUsViewController: LMBaseVC {
    var cancle: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "关于我们"
        setViewSnp()
    }
}
private extension MineAboutUsViewController {
    func setViewSnp() {
        let logoimv = UIImageView(image: UIImage(named: "ICON"))
            .cornerRadius(20.0)
        view.addSubview(logoimv)
        let appNamelb = UILabel(lmfont: lmFontASHTB(28), textColor: lmColorHex("#2B313D"))
            .textAlignment(.center)
            .lmtext(kAppName)
        view.addSubview(appNamelb)
        let appVersionlb = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#2B313D66"))
            .textAlignment(.center)
            .lmtext("version" + kAppShortVersion )
        view.addSubview(appVersionlb)
        let tipslb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#2B313D"))
            .textAlignment(.left)
            .lmtext("棱角刺破洪流\n\n在0.1厘米的社交距离里\n\n名字与故事开始坍缩\n\n当指尖按下❤️的刹那我们以量子态\n\n交换了彼此的温度")
            .numberOfLines(0)
        view.addSubview(tipslb)
        tipslb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(34)
            make.top.equalToSuperview().offset(kScaleWidth(340))
        }
        let bottomView = createBottomView()
        view.addSubview(bottomView)
        logoimv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(34)
            make.top.equalToSuperview().offset(kNavigationHeight + 40.0)
            make.width.height.equalTo(80.0)
        }
        appNamelb.snp.makeConstraints { make in
            make.centerX.equalTo(logoimv.snp.centerX)
            make.top.equalTo(logoimv.snp.bottom).offset(20.0)
        }
        appVersionlb.snp.makeConstraints { make in
            make.centerX.equalTo(logoimv.snp.centerX)
            make.top.equalTo(appNamelb.snp.bottom).offset(2.0)
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(34)
            make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
            make.height.equalTo(70.0)
        }
    }
    func createBottomView() -> UIView {
        let bottomView = UIView()
        let agreementView = UIView()
        bottomView.addSubview(agreementView)
        let userAgreementbtn = UIButton(lmfont: lmFontF(12), titleColor: lmColorHex("#328BF9"), target: self, action: #selector(userAgreementbtnAction))
            .lmtitle("服务协议")
        agreementView.addSubview(userAgreementbtn)
        let oneLine = UIView().backgroundColor(lmColorHex("#2B313D1F"))
        agreementView.addSubview(oneLine)
        let privacyAgreementbtn = UIButton(lmfont: lmFontF(12), titleColor: lmColorHex("#328BF9"), target: self, action: #selector(privacyAgreementbtnAction))
            .lmtitle("隐私政策")
        agreementView.addSubview(privacyAgreementbtn)
        let twoLine = UIView().backgroundColor(lmColorHex("#2B313D1F"))
        agreementView.addSubview(twoLine)
        let underageAgreementbtn = UIButton(lmfont: lmFontF(12), titleColor: lmColorHex("#328BF9"), target: self, action: #selector(underageAgreementbtnAction))
            .lmtitle("未成年保护")
        agreementView.addSubview(underageAgreementbtn)
        let copyrightlb = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#2B313D66"))
            .textAlignment(.left)
            .lmtext("© 2025 海南粉贝贝科技有限公司 版权所有")
        bottomView.addSubview(copyrightlb)
        let recordlb = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#2B313D66"))
            .textAlignment(.left)
            .lmtext("琼ICP备2025053487")
        bottomView.addSubview(recordlb)
        agreementView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(20.0)
        }
        userAgreementbtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        oneLine.snp.makeConstraints { make in
            make.left.equalTo(userAgreementbtn.snp.right).offset(24)
            make.centerY.equalToSuperview()
            make.width.equalTo(1.0)
            make.height.equalTo(12.0)
        }
        privacyAgreementbtn.snp.makeConstraints { make in
            make.left.equalTo(oneLine.snp.right)
            make.centerY.equalToSuperview()
            make.width.equalTo(95.0)
        }
        twoLine.snp.makeConstraints { make in
            make.left.equalTo(privacyAgreementbtn.snp.right)
            make.centerY.equalToSuperview()
            make.width.equalTo(1.0)
            make.height.equalTo(12.0)
        }
        underageAgreementbtn.snp.makeConstraints { make in
            make.left.equalTo(twoLine.snp.right)
            make.centerY.equalToSuperview()
            make.width.equalTo(100.0)
            make.right.equalToSuperview()
        }
        copyrightlb.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(agreementView.snp.bottom).offset(8.0)
        }
        recordlb.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(copyrightlb.snp.bottom).offset(4.0)
        }
        return bottomView
    }
   
    @objc func feedbackbtnAction() {
        self.navigationController?.pushViewController(CusTomFeedBackViewController(), animated: true)
    }
    @objc func userAgreementbtnAction() {
        self.navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.service), animated: true)
    }
    @objc func privacyAgreementbtnAction() {
        self.navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.privacy), animated: true)
    }
    @objc func underageAgreementbtnAction() {
        self.navigationController?.pushViewController(BaseWebViewController(loadUrl: AppConfig.URL.minorsProtection), animated: true)
    }
}
