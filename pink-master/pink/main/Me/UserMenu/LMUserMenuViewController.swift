import UIKit
extension LMUserMenuViewController {
    static func show(_ vc: UIViewController? = nil) {
        let pop = LMUserMenuViewController()
        if let viewController = vc {
            viewController.addChild(pop)
            viewController.view.addSubview(pop.view)
        } else {
            UIViewController.current?.addChild(pop)
            UIViewController.current?.view.addSubview(pop.view)
        }
        pop.view.frame = UIScreen.main.bounds
    }
}
class LMUserMenuViewController: UIViewController {
    var dataList: [[LMUserMenuItemModel]] = []
    var user: UsInfoItem = UsInfoItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        buildData()
        setupUI()
        requestData()
        show()
    }
    private func buildData() {
        dataList = {
            [
                [LMUserMenuItemModel(type: .DressingCenter),
                  LMUserMenuItemModel(type: .GiftWall),
                  LMUserMenuItemModel(type: .MyLevel),
                 LMUserMenuItemModel(type: .skill),
                 LMUserMenuItemModel(type: .order)],
               [LMUserMenuItemModel(type: .MyRoom),
                 LMUserMenuItemModel(type: .MyGuild)],
               [LMUserMenuItemModel(type: .YouthMode),
                 LMUserMenuItemModel(type: .Feedback),
                 LMUserMenuItemModel(type: .AboutUs)]
            ]
        }()
    }
    func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(bgView)
        view.addSubview(contentView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.right).offset(0)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(kScaleWidth(390))
        }
        view.layoutIfNeeded()
    }
    func requestData() {
        UserNetWork.Info().lmrequest {[weak self] responseModel in
            guard let self = self else { return }
            guard let model = UsInfoItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self.user = model
        } failureBlock: { _ in
        }
        WalletNetWork.getAccount().lmrequest {[weak self] responseModel in
            guard let model = WalletItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self?.contentView.headerView.setData(model: model)
        } failureBlock: { _ in
        }
    }
    private func show(_ vc: UIViewController? = nil) {
        UIView.animate(withDuration: 0.3) {
            self.contentView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(kScaleWidth(70))
                make.top.bottom.right.equalToSuperview()
            }
            self.contentView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
    private func hide() {
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 0
            self.contentView.snp.remakeConstraints { make in
                make.left.equalTo(self.view.snp.right).offset(0)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(kScaleWidth(390))
            }
            self.contentView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.clear()
        }
    }
    private func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = lmColorHex("#000000", alpha: 0.5)
        view.addGestureTap { [weak self] _ in
                guard let self = self else { return }
                hide()
            }
        return view
    }()
    private lazy var contentView: LMUserMenuView = {
        let view = LMUserMenuView()
        view.cellClickblock = { [weak self] model in
            if model.type == .DressingCenter {
                UIViewController.current?.navigationController?.pushViewController(LMShopVC(), animated: true)
            }
            if model.type == .GiftWall {
                UIViewController.current?.navigationController?.pushViewController(GiftWallViewController(model: self?.user ?? UsInfoItem()), animated: true)
            }
            if model.type == .MyLevel {
                UIViewController.current?.navigationController?.pushViewController(LevelViewController(), animated: true)
            }
            if model.type == .YouthMode {
                UIViewController.current?.navigationController?.pushViewController(TeenagerModeViewController(), animated: true)
            }
            if model.type == .Feedback {
                UIViewController.current?.navigationController?.pushViewController(CusTomFeedBackViewController(), animated: true)
            }
            if model.type == .MyRoom {
                self?.a_turnRoom()
            }
            if model.type == .AboutUs {
                UIViewController.current?.navigationController?.pushViewController(MineAboutUsViewController(), animated: true)
            }
            if model.type == .skill {
                if UserShared.user?.realAuth == false {
                    let view = LMAuthPopVC(theme: .light, cancel: nil, confirm: "立即认证") { title in
                        if title == "立即认证" {
                            UIViewController.current?.navigationController?.pushViewController(RealAuthViewController(routetype: .toRoom), animated: true)
                        }
                    }
                    view.show()
                    return
                }
                UIViewController.current?.navigationController?.pushViewController(SkillListViewController(), animated: true)
            }
            if model.type == .order {
                UIViewController.current?.navigationController?.pushViewController(OrderPageViewController(), animated: true)
            }
            if model.type == .MyGuild {
                GuildNetWork.MyFamile().lmrequest {[weak self] responseModel in
                    guard let model = GuildItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
                    if model.status == 0 {
                        UIViewController.current?.navigationController?.pushViewController(familyListViewController(), animated: true)
                    } else {
                        if model.owner == true && model.status == 2 {
                            UIViewController.current?.navigationController?.pushViewController(familySuccessViewController(), animated: true)
                        } else {
                            if model.status == 2 {
                                UIViewController.current?.navigationController?.pushViewController(MyfamilyViewController(model: model), animated: true)
                            } else {
                                UIViewController.current?.navigationController?.pushViewController(MyfamilyViewController(model: model), animated: true)
                            }
                        }
                    }
                } failureBlock: { _ in
                }
            }
            
        }
        return view
    }()
    func a_turnRoom() {
        guard let user = UserShared.user else {
            return
        }
        if user.realAuth == false {
            RouteService.pushMyRoom(vc: self)
        } else {
            VoiceShared.turnToRM(user.roomId)
        }
    }
}
