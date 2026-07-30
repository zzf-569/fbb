import UIKit

/// The Me page is intentionally built without image assets. Add the images using
/// the names in `imageNames` when the final artwork is ready.
final class LMUserViewController: LMBaseVC {
    private let userId: String
    private var user: UsInfoItem

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let idLabel = UILabel()
    private let followedValue = UILabel()
    private let fansValue = UILabel()
    private let friendsValue = UILabel()
    private let coinsValue = UILabel()
    private let pointsValue = UILabel()
    
    lazy var vipCard: UIImageView = {
        let imageV = UIImageView().image(UIImage(named: "vipcard_bg"))
        return imageV
    }()

    required init(user: UsInfoItem, istabbar: Bool = false) {
        self.user = user
        self.userId = user.userId
        super.init(nibName: nil, bundle: nil)
    }

    required init(userId: String, istabbar: Bool = false) {
        self.userId = userId
        self.user = UsInfoItem()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        buildView()
        updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        loadUser()
    }

    private func buildView() {
        view.backgroundColor(lmColorHex("#F5F6FA"))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .clear

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
       

        let profile = card(radius: 18)
        contentView.addSubview(profile)
        profile.snp.makeConstraints {
            $0.top.equalToSuperview().offset(kStatusBarHeight + 12)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(kScaleWidth(229))
        }
        addTopButtons(to: profile)
        
        
        let layer1 = CAGradientLayer();
        layer1.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0.64).cgColor,
        UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor];
        layer1.locations = [0, 1];
        layer1.startPoint = CGPoint(x: 0.5, y: 0.74);
        layer1.endPoint = CGPoint(x: 0.5, y: 0);
        layer1.bounds = view.bounds;
        layer1.position = view.center;
        profile.layer.addSublayer(layer1);

        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 46
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.white.cgColor
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(92)
        }

        avatarView.addGestureTap {[weak self] tag in
            self?.navigationController?.pushViewController(LMUserinfoVC(), animated: true)
        }

        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .textDefaulColor
        profile.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarView.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(20)
        }

        let badges = UIStackView(arrangedSubviews: [badge("♀18", color: "#32C2F0"), badge("♀18", color: "#F17CC9")])
        badges.axis = .horizontal
        badges.spacing = 8
        profile.addSubview(badges)
        badges.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(9)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }

        idLabel.font = UIFont.systemFont(ofSize: 12)
        idLabel.textColor = .textSecondColor
        idLabel.textAlignment = .center
        profile.addSubview(idLabel)
        idLabel.snp.makeConstraints {
            $0.top.equalTo(badges.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }

        let stats = UIStackView(arrangedSubviews: [stat("Followed", value: followedValue), stat("Fans", value: fansValue), stat("Friends", value: friendsValue)])
        stats.axis = .horizontal
        stats.distribution = .fillEqually
        stats.spacing = 10
        profile.addSubview(stats)
        stats.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(18)
            $0.top.equalTo(idLabel.snp.bottom).offset(kScaleWidth(16))
            $0.height.equalTo(kScaleWidth(51))
        }

        
        contentView.addSubview(vipCard)
        vipCard.snp.makeConstraints {
            $0.top.equalTo(profile.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(kScaleWidth(44))
        }
        let vipTitle = label("VIP Club", size: 14, weight: .medium, color: .black)
        let vipSubtitle = label("Upgrade to VIP and get free coins daily.", size: 11, weight: .regular, color: .black)
        vipCard.addSubview(vipTitle)
        vipCard.addSubview(vipSubtitle)
        vipTitle.snp.makeConstraints { $0.left.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(5)}
        vipSubtitle.snp.makeConstraints { $0.left.equalTo(vipTitle); $0.top.equalTo(vipTitle.snp.bottom).offset(2) }
        let vipButton = UIButton(type: .custom)
        vipButton.setImage(UIImage(named: "open_vip"), for: .normal)
        vipButton.addTarget(self, action: #selector(openWallet), for: .touchUpInside)
        vipCard.addSubview(vipButton)
        vipButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(0);
            $0.top.equalToSuperview().offset(kScaleWidth(7));
            $0.width.equalTo(kScaleWidth(92));
            $0.height.equalTo(kScaleWidth(22)) }

        let wallets = UIStackView(arrangedSubviews: [wallet(title: "Coins", value: coinsValue, asset: "coins_bg", icon: "icon_coins"), wallet(title: "Points", value: pointsValue, asset: "points_bg", icon: "icon_points")])
        wallets.axis = .horizontal; wallets.spacing = 14; wallets.distribution = .fillEqually
        contentView.addSubview(wallets)
        wallets.snp.makeConstraints {
            $0.top.equalTo(vipCard.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(kScaleWidth(102))
        }

        let menu = card(color: .white, radius: 18)
        contentView.addSubview(menu)
        menu.snp.makeConstraints {
            $0.top.equalTo(wallets.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(kScaleWidth(212))
            $0.bottom.equalToSuperview().offset(-24)
        }
        addQuickActions(to: menu)
        addGridActions(to: menu)
    }

    private func addTopButtons(to view: UIView) {
        let back = UIButton(type: .system)
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .black
        back.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        back.isHidden = userId == UserShared.user?.userId
        view.addSubview(back)
        back.snp.makeConstraints { $0.left.top.equalToSuperview().inset(14); $0.size.equalTo(34) }
        let more = UIButton(type: .system)
        more.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        more.tintColor = .black
        more.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        more.isHidden = userId == UserShared.user?.userId
        view.addSubview(more)
        more.snp.makeConstraints { $0.right.top.equalToSuperview().inset(14); $0.size.equalTo(34) }
    }

    private func addQuickActions(to card: UIView) {
        let titles = ["Host Center", "Agency", "Coin Seller"]
        let keys = ["host", "agency", "seller"]
        let row = UIStackView(); row.axis = .horizontal; row.spacing = 12; row.distribution = .fillEqually
        card.addSubview(row)
        row.snp.makeConstraints { $0.top.equalToSuperview().offset(16); $0.left.right.equalToSuperview().inset(18); $0.height.equalTo(kScaleWidth(36)) }
        for (index, title) in titles.enumerated() {
            let button = actionButton(title: title, image: keys[index])
            button.tag = index
            button.addTarget(self, action: #selector(quickAction(_:)), for: .touchUpInside)
            row.addArrangedSubview(button)
        }
    }

    private func addGridActions(to card: UIView) {
        let titles = ["Store", "Backpack", "Task", "Invite", "Level", "Medal Wall", "Support", "Setting"]
        let keys = ["store", "backpack", "task", "invite", "level", "medal", "support", "setting"]
        let grid = UIStackView()
        grid.axis = .vertical
        grid.spacing = kScaleWidth(16)
        grid.distribution = .fillEqually
        card.addSubview(grid)
        grid.snp.makeConstraints {
            $0.top.equalToSuperview().offset(kScaleWidth(76))
            $0.left.right.equalToSuperview().inset(kScaleWidth(20))
            $0.bottom.equalToSuperview().inset(kScaleWidth(16))
        }

        for rowIndex in 0..<2 {
            let row = UIStackView()
            row.axis = .horizontal
            row.alignment = .fill
            row.distribution = .fillEqually
            row.spacing = kScaleWidth(12)

            for col in 0..<4 {
                let index = rowIndex * 4 + col
                let button = UIButton(type: .custom)
                button.size = CGSizeMake(kScaleWidth(62), kScaleWidth(52))
                button.setImage(UIImage(named: keys[index]), for: .normal)
                button.setTitle(titles[index], for: .normal)
                button.titleLabel?.font = lmFontR(12)
                button.titleLabel?.textAlignment = .center
                button.setTitleColor(.textSecondColor, for: .normal)
                button.tag = index
                button.addTarget(self, action: #selector(gridAction(_:)), for: .touchUpInside)
                button.set_ImageTitleLayout(.imgTop, spacing: 2)
                row.addArrangedSubview(button)
            }
            grid.addArrangedSubview(row)
        }
    }

    private func wallet(title: String, value: UILabel, asset: String, icon: String) -> UIView {
        let view = UIImageView().image(UIImage(named: asset))
        if title == "Coins" {
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openRecharge)))
        }
        view.addSubview(label(title, size: 20, weight: .medium, color: .white))
        let titleLabel = view.subviews.last!
        titleLabel.snp.makeConstraints { $0.left.top.equalToSuperview().inset(16) }
        let inner = card(radius: 16); view.addSubview(inner)
        inner.snp.makeConstraints { $0.left.right.bottom.equalToSuperview().inset(6); $0.height.equalTo(60) }
        let icon = UIImageView(image: UIImage(named: icon)); icon.contentMode = .scaleAspectFit; inner.addSubview(icon)
        icon.snp.makeConstraints { $0.left.bottom.equalToSuperview().inset(6);  $0.size.equalTo(48) }
        let balance = label("Balance", size: 14, weight: .regular, color: UIColor(red: 0.43, green: 0.47, blue: 0.44, alpha: 1)); inner.addSubview(balance)
        balance.snp.makeConstraints { $0.left.equalTo(icon.snp.right).offset(8); $0.top.equalToSuperview().offset(14) }
        value.font = UIFont.systemFont(ofSize: 24, weight: .medium); value.textColor = UIColor(red: 0.08, green: 0.1, blue: 0.1, alpha: 1); value.text = "0"; inner.addSubview(value)
        value.snp.makeConstraints { $0.left.equalTo(balance); $0.bottom.equalToSuperview().offset(-6) }
                
        return view
    }

    private func card(color: UIColor = .white, radius: CGFloat) -> UIView {
        let view = UIView(); view.backgroundColor = color; view.layer.cornerRadius = radius; view.clipsToBounds = true; return view
    }

    private func badge(_ title: String, color: String) -> UILabel {
        let view = label(title, size: 14, weight: .regular, color: .white); view.textAlignment = .center; view.backgroundColor = lmColorHex(color); view.layer.cornerRadius = 15; view.clipsToBounds = true; view.snp.makeConstraints { $0.width.equalTo(60); $0.height.equalTo(30) }; return view
    }

    private func stat(_ title: String, value: UILabel) -> UIView {
        let view = UIView(); value.font = UIFont.systemFont(ofSize: 25, weight: .medium); value.textAlignment = .center; value.textColor = .black; view.addSubview(value); value.snp.makeConstraints { $0.top.left.right.equalToSuperview() }; let titleLabel = label(title, size: 15, weight: .regular, color: UIColor(red: 0.43, green: 0.47, blue: 0.44, alpha: 1)); titleLabel.textAlignment = .center; view.addSubview(titleLabel); titleLabel.snp.makeConstraints { $0.top.equalTo(value.snp.bottom).offset(2); $0.left.right.bottom.equalToSuperview() }; return view
    }

    private func actionButton(title: String, image: String?) -> UIButton {
        let button = UIButton(type: .custom); button.setTitle("  \(title)", for: .normal); button.setTitleColor(UIColor(red: 0.43, green: 0.47, blue: 0.44, alpha: 1), for: .normal); button.titleLabel?.font = UIFont.systemFont(ofSize: 12); button.backgroundColor = UIColor(white: 0.94, alpha: 1); button.layer.cornerRadius = 18; if let image { button.setImage(UIImage(named: image), for: .normal) }; return button
    }

    private func label(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel { let view = UILabel(); view.text = text; view.font = UIFont.systemFont(ofSize: size, weight: weight); view.textColor = color; return view }

    private func loadUser() {
        UserNetWork.Info(userId: userId).lmrequest { [weak self] response in
            guard let self, let model = UsInfoItem.deserialize(from: response.data as? [String: Any]) else { return }
            self.user = model
            self.updateView()
        } failureBlock: { _ in }
    }

    private func updateView() {
        nameLabel.text = user.nickname.isEmpty ? "Nickname" : user.nickname
        idLabel.text = "ID · \(user.showUserId.isEmpty ? (user.userId.isEmpty ? "1234" : user.userId) : user.showUserId)   ▣"
        followedValue.text = "\(user.focusCnt)"; fansValue.text = "\(user.fansCnt)"; friendsValue.text = "\(user.collectCnt)"; coinsValue.text = "\(user.balance)"; pointsValue.text = "\(user.balance)"
        if !user.avatar.isEmpty { avatarView.set_Image(url: user.avatar) }
    }

    @objc private func backAction() { navigationController?.popViewController(animated: true) }
    @objc private func moreAction() { HUD.show("More") }
    @objc private func openWallet() { navigationController?.pushViewController(WalletViewController(), animated: true) }
    @objc private func openRecharge() { navigationController?.pushViewController(RechargeViewController(), animated: true) }
    @objc private func placeholderAction() { HUD.show("Coming soon") }
    @objc private func quickAction(_ sender: UIButton) {
        if sender.tag == 0 {
            navigationController?.pushViewController(LMHostCenterViewController(), animated: true)
        } else {
            placeholderAction()
        }
    }
    @objc private func gridAction(_ sender: UIButton) {
        if sender.tag == 0{
            navigationController?.pushViewController(LMShopVC(), animated: true)
        }
        if sender.tag == 1{
            navigationController?.pushViewController(PackageViewController(), animated: true)
        }
        if sender.tag == 4{
            navigationController?.pushViewController(LevelViewController(), animated: true)
        }
        if sender.tag == 7 { navigationController?.pushViewController(MineSettingViewController(), animated: true) }
    }
}
