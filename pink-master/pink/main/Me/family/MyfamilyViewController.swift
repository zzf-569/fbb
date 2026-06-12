import UIKit
class MyfamilyViewController: LMBaseVC {
    var dataSoure: GuildItem = GuildItem() {
        didSet {
            backImage.set_Image(url: dataSoure.cover, placeholder: kPlaceholder_avatar)
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
    lazy var guildPageView: familyPageView = {
        let view = familyPageView(model: dataSoure)
        return view
    }()
    required init(model: GuildItem) {
        self.dataSoure = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setData()
        guildPageView.pagingView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
    private func setViewSnp() {
        backgroundImage = nil
        view.addSubview(backImage)
        backImage.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.size.equalTo(CGSize(width: kScreenWidth, height: kScaleWidth(256)))
        }
        view.addSubview(maskView)
        maskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let btn = UIButton(image: UIImage(named: "cm_back_white"), target: self, action: #selector(back))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        view.addSubview(guildPageView)
        guildPageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kScaleWidth(120) + kNavigationHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        guildPageView.layoutIfNeeded()
        guildPageView.set_Border(radius: 12, conrners: [.topLeft, .topRight])
    }
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    func setData() {
        GuildNetWork.DetailFamile(familyId: dataSoure.familyId).lmrequest {[weak self] responseModel in
            guard let model = GuildItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            let applyCnt = self?.dataSoure.applyCnt
            self?.dataSoure = model
            self?.dataSoure.applyCnt = applyCnt ?? 0
        } failureBlock: { _ in
        }
    }
    @objc func backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
