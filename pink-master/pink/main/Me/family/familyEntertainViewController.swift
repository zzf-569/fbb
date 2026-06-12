import UIKit
class familyEntertainViewController: LMBaseVC {
    var dataSoure: GuildItem = GuildItem() {
        didSet {
            backImage.set_Image(url: dataSoure.cover, placeholder: kPlaceholder_avatar)
            if dataSoure.joinStatus == 1 {
                self.statesbtn.lmtitle("审核中")
                self.statesbtn.backgroundColor = lmColorHex("#182F36")
                self.statesbtn.titleColor(lmColorHex("#FFFFFF", alpha: 0.24))
            }
        }
    }
    lazy var backImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var maskView: UIView = {
        let imageV = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScaleWidth(256)))
        view.addGradientLayer(colors: [lmColorHex("#000000BF").cgColor, lmColorHex("#00000000", alpha: 0).cgColor], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1), locations: [0, 1])
        return imageV
    }()
    lazy var statesbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .whitePrimary, target: self, action: #selector(joinClick))
        btn.lmtitle("加入公会")
        btn.cornerRadius(kScaleWidth(13))
        btn.backgroundColor = lmColorHex("#FF4F7D")
        return btn
    }()
    required init(model: GuildItem) {
        self.dataSoure = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setData()
    }
    private func setViewSnp() {
        backgroundImage = nil
        let btn = UIButton(image: UIImage(named: "cm_back_white"), target: self, action: #selector(backItemDidiClick))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        view.addSubview(backImage)
        backImage.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.size.equalTo(CGSize(width: kScreenWidth, height: kScreenWidth))
        }
        view.addSubview(maskView)
        maskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    @objc func joinClick() {
        GuildNetWork.joinFamile(familyId: dataSoure.familyId).lmrequest {[weak self] _ in
            HUD.showSuccess("申请成功")
            self?.statesbtn.lmtitle("审核中")
            self?.statesbtn.backgroundColor = lmColorHex("#182F36")
            self?.statesbtn.titleColor(lmColorHex("#FFFFFF", alpha: 0.24))
            self?.navigationController?.popToRootViewController(animated: true)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    func setData() {
        GuildNetWork.DetailFamile(familyId: dataSoure.familyId).lmrequest {[weak self] responseModel in
            guard let model = GuildItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self?.dataSoure = model
        } failureBlock: { _ in
        }
    }
    @objc func backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
