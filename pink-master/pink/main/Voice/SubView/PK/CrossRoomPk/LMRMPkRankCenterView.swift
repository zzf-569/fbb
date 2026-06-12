import UIKit
extension LMRMPkRankCenterView {
    func setDataSoure(_ data: invitePkInfo) {
        let campValueMap = data.campValueMap
        let allkeys = campValueMap?.map({ $0.key })
        if let keys = allkeys {
            for string in keys {
                if let model = campValueMap?[string] {
                    if string == VoiceService.shared.roomViewController?.viewModel.roomItem.roomId {
                        blueList = model.topAvatarList
                    } else {
                        redList = model.topAvatarList
                    }
                }
            }
        }
        if blueList.count == 0 && redList.count == 0 {
        } else if blueList.count == 0 {
            let reduser = redList[0]
            topAavtar.set_Image(url: reduser.avatar)
            topUserName.lmtext(reduser.nickname)
            topCharm.lmtext("贡献 \(reduser.amount.toString())")
        } else if redList.count == 0 {
            let blueuser = blueList[0]
            topAavtar.set_Image(url: blueuser.avatar)
            topUserName.lmtext(blueuser.nickname)
            topCharm.lmtext("贡献 \(blueuser.amount.toString())")
        } else {
            let blueuser = blueList[0]
            let reduser = redList[0]
            if blueuser.amount >= reduser.amount {
                topAavtar.set_Image(url: blueuser.avatar)
                topUserName.lmtext(blueuser.nickname)
                topCharm.lmtext("贡献 \(blueuser.amount.toString())")
            } else {
                topAavtar.set_Image(url: reduser.avatar)
                topUserName.lmtext(reduser.nickname)
                topCharm.lmtext("贡献 \(reduser.amount.toString())")
            }
        }
    }
    func show(_ vc: UIViewController? = nil) {
        if let viewController = vc {
            viewController.addChild(self)
            viewController.view.addSubview(self.view)
        } else {
            UIViewController.current?.addChild(self)
            UIViewController.current?.view.addSubview(self.view)
        }
        self.view.frame = UIScreen.main.bounds
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
            self.contentView.alpha = 1
            self.closebtn.alpha = 1
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.contentView.alpha = 0
            self.closebtn.alpha = 0
        } completion: { _ in
            self.clear()
        }
    }
}
class LMRMPkRankCenterView: UIViewController {
    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            .backgroundColor(lmColorHex("#0000007F"))
            .alpha(0)
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
            .alpha(0)
        return view
    }()
    lazy var topheadWear: UIImageView = {
        let view = UIImageView(image: UIImage(named: "rm_pk_rank_top"))
            .isUserInteractionEnabled(true)
        return view
    }()
    lazy var topAavtar: UIImageView = {
        let view = UIImageView()
            .cornerRadius(33)
        return view
    }()
    private lazy var contentimage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "rm_pk_rankBg"))
            .isUserInteractionEnabled(true)
        return view
    }()
    lazy var topUserName: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
            .textAlignment(.center)
        return lb
    }()
    lazy var topCharm: UILabel = {
        let lb = UILabel(lmfont: lmFontR(10), textColor: lmColorHex("#CF1F9AFF"))
            .textAlignment(.center)
        return lb
    }()
    lazy var blueTitle: UIButton = {
        let btn = UIButton()
            .backgroundImage(UIImage(named: "rm_pk_rank_bluetitle"))
            .lmtitle("我方")
        return btn
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMRMPkRankCenterCell.self])
            .backgroundColor(.clear)
        return tableView
    }()
    lazy var redTitle: UIButton = {
        let btn = UIButton()
            .backgroundImage(UIImage(named: "rm_pk_rank_redtitle"))
            .lmtitle("对方")
        return btn
    }()
    lazy var tableBack: UIImageView = {
        let view = UIImageView(image: UIImage(named: "rm_pk_rank_cenbg"))
            .isUserInteractionEnabled(true)
        return view
    }()
    private lazy var closebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_popclose"), target: self, action: #selector(closebtnAction))
            .cornerRadius(12)
            .alpha(0)
        return btn
    }()
    var blueList: [LMtopAvatarModel] = []
    var redList: [LMtopAvatarModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setViewSnp()
    }
    deinit {
        lmPrint("UIViewController deinit：----------------\(Self.className)已被销毁")
    }
}
private extension LMRMPkRankCenterView {
    func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(contentView)
        contentView.addSubview(contentimage)
        contentView.addSubview(closebtn)
        contentView.addSubview(topheadWear)
        contentView.addSubview(topAavtar)
        contentView.addSubview(topUserName)
        contentView.addSubview(topCharm)
        contentView.addSubview(redTitle)
        contentView.addSubview(blueTitle)
        contentView.addSubview(tableBack)
        tableBack.addSubview(tableView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(318), height: kScaleWidth(254 + 61)))
        }
        contentimage.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(61))
        }
        topAavtar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(10))
            make.size.equalTo(CGSize(width: kScaleWidth(66), height: kScaleWidth(66)))
        }
        topheadWear.snp.makeConstraints { make in
            make.center.equalTo(topAavtar.snp.center)
            make.size.equalTo(CGSize(width: kScaleWidth(90), height: kScaleWidth(90)))
        }
        topUserName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topheadWear.snp.bottom).offset(kScaleWidth(0))
            make.height.equalTo(kScaleWidth(24))
        }
        topCharm.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topUserName.snp.bottom).offset(kScaleWidth(0))
            make.height.equalTo(kScaleWidth(16))
        }
        blueTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(8))
            make.top.equalTo(contentimage.snp.top).offset(kScaleWidth(67))
            make.size.equalTo(CGSize(width: kScaleWidth(156), height: kScaleWidth(36)))
        }
        redTitle.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(8))
            make.top.equalTo(contentimage.snp.top).offset(kScaleWidth(67))
            make.size.equalTo(CGSize(width: kScaleWidth(156), height: kScaleWidth(36)))
        }
        tableBack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(8))
            make.top.equalTo(blueTitle.snp.bottom)
            make.height.equalTo(kScaleWidth(140))
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        closebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(contentimage.snp.top).offset(kScaleWidth(8))
            make.size.equalTo(CGSize(width: kScaleWidth(40), height: kScaleWidth(40)))
        }
        self.contentView.center = self.view.center
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @objc func closebtnAction() {
        hide()
    }
}
extension LMRMPkRankCenterView: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        kScaleWidth(44)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType:LMRMPkRankCenterCell.self, cellForRowAt: indexPath)
        var blueUser: LMtopAvatarModel?
        var redUser: LMtopAvatarModel?
        if redList.count >= indexPath.row + 1 {
            redUser = redList[indexPath.row]
        }
        if blueList.count >= indexPath.row + 1 {
            blueUser = blueList[indexPath.row]
        }
        cell.confData(blueUser: blueUser, redUser: redUser, rank: indexPath.row + 1)
        return cell
    }
}
