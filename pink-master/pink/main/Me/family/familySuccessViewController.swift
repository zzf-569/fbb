import UIKit
class familySuccessViewController: LMBaseVC {
    lazy var logoImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "me_success"))
        return imageV
    }()
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(20), textColor: .whitePrimary)
        lb.text = "创建公会认证审核中"
        lb.textAlignment(.center)
        return lb
    }()
    lazy var subTitle: UILabel = {
        let lb = UILabel(lmfont: lmFontR(15), textColor: .whiteSecondary)
        lb.text = "加急处理中，请您耐心等待"
        lb.textAlignment(.center)
        return lb
    }()
    lazy var surebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .textDefaulColor, target: self, action: #selector(back))
        btn.backgroundColor(lmColorHex("#FF4F7D"))
        btn.cornerRadius(28)
        btn.lmtitle("我知道了")
        return btn
    }()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        titleColor = .whitePrimary
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
    private func setViewSnp() {
        backgroundImage = nil
        let btn = UIButton(image: UIImage(named: "cm_back_white"), target: self, action: #selector(back))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        view.backgroundColor = .textDefaulColor
        view.addSubview(logoImage)
        view.addSubview(titleLab)
        view.addSubview(subTitle)
        view.addSubview(surebtn)
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(40) + kNavigationHeight)
            make.size.equalTo(CGSize(width: kScaleWidth(108), height: kScaleWidth(108)))
        }
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImage.snp.bottom).offset(kScaleWidth(24))
            make.height.equalTo(kScaleWidth(28))
        }
        subTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(kScaleWidth(4))
            make.height.equalTo(kScaleWidth(28))
        }
        surebtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(kScaleWidth(154) + kTabBarSafeHeight)
            make.size.equalTo(CGSize(width: kScaleWidth(230), height: kScaleWidth(56)))
        }
    }
    func setData() {
    }
    @objc func back() {
        self.navigationController?.popToViewControllerAtIndex(index: 1)
    }
}
