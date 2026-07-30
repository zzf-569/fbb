import UIKit

enum LMHostCenterRoomState {
    case noRoom
    case hasRoom
}

final class LMHostCenterDashboardViewController: LMBaseVC {
    private let roomState: LMHostCenterRoomState
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    init(state: LMHostCenterRoomState) {
        self.roomState = state
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(hasRoom: Bool) {
        self.init(state: hasRoom ? .hasRoom : .noRoom)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        buildView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    private func buildView() {
        view.backgroundColor = lmColorHex("#F5F6FA")
        buildNavigation()

        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(kNavigationHeight)
            $0.left.right.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        let agentRow = makeAgentRow()
        contentView.addSubview(agentRow)
        agentRow.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(66)
        }

        let profileSection = makeProfileSection()
        contentView.addSubview(profileSection)
        profileSection.snp.makeConstraints {
            $0.top.equalTo(agentRow.snp.bottom).offset(14)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(250)
        }

        let pointsCard = makePointsCard()
        contentView.addSubview(pointsCard)
        pointsCard.snp.makeConstraints {
            $0.top.equalTo(profileSection.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(218)
        }

        let recordCard = makeRecordCard()
        contentView.addSubview(recordCard)
        recordCard.snp.makeConstraints {
            $0.top.equalTo(pointsCard.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(120)
        }

        let agencyButton = bottomButton(title: "Agency Room", highlighted: false)
        let roomButton = bottomButton(title: roomState == .hasRoom ? "My Room" : "Create Room", highlighted: true)
        let bottomStack = UIStackView(arrangedSubviews: [agencyButton, roomButton])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 16
        bottomStack.distribution = .fillEqually
        contentView.addSubview(bottomStack)
        bottomStack.snp.makeConstraints {
            $0.top.equalTo(recordCard.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 14))
        }
    }

    private func buildNavigation() {
        let navigationView = UIView()
        navigationView.backgroundColor = lmColorHex("#F5F6FA")
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(kNavigationHeight)
        }

        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = lmColorHex("#172019")
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        navigationView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-4)
            $0.size.equalTo(40)
        }

        let titleLabel = label("Host Center", size: 22, color: lmColorHex("#172019"), medium: true)
        navigationView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.centerX.equalToSuperview(); $0.centerY.equalTo(backButton) }

        let helpButton = UIButton(type: .custom)
        helpButton.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        helpButton.tintColor = lmColorHex("#172019")
        navigationView.addSubview(helpButton)
        helpButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-12)
            $0.centerY.equalTo(backButton)
            $0.size.equalTo(34)
        }
    }

    private func makeAgentRow() -> UIView {
        let row = card(radius: 14)
        row.layer.borderWidth = 1
        row.layer.borderColor = lmColorHex("#E8EBE8").cgColor

        let iconContainer = UIView()
        iconContainer.backgroundColor = lmColorHex("#142018")
        iconContainer.layer.cornerRadius = 22
        row.addSubview(iconContainer)
        iconContainer.snp.makeConstraints { $0.left.equalToSuperview().offset(12); $0.centerY.equalToSuperview(); $0.size.equalTo(44) }

        let icon = UIImageView(image: UIImage(named: "agency"))
        icon.contentMode = .scaleAspectFit
        iconContainer.addSubview(icon)
        icon.snp.makeConstraints { $0.edges.equalToSuperview().inset(7) }

        let title = label("Join Agent Program", size: 14, color: lmColorHex("#172019"), medium: true)
        let subtitle = label("Get agent support and guidance.", size: 11, color: lmColorHex("#A2A7A3"))
        row.addSubview(title)
        row.addSubview(subtitle)
        title.snp.makeConstraints { $0.left.equalTo(iconContainer.snp.right).offset(10); $0.top.equalToSuperview().offset(14) }
        subtitle.snp.makeConstraints { $0.left.equalTo(title); $0.top.equalTo(title.snp.bottom).offset(3) }

        let join = smallGreenButton("Join")
        row.addSubview(join)
        join.snp.makeConstraints { $0.right.equalToSuperview().offset(-12); $0.centerY.equalToSuperview(); $0.width.equalTo(62); $0.height.equalTo(32) }
        return row
    }

    private func makeProfileSection() -> UIView {
        let container = UIView()
        let statusBar = UIView()
        statusBar.backgroundColor = lmColorHex("#8CFF15")
        statusBar.layer.cornerRadius = 14
        container.addSubview(statusBar)
        statusBar.snp.makeConstraints { $0.top.left.right.equalToSuperview(); $0.height.equalTo(38) }

        let liveTime = label("◉ 16:24", size: 11, color: lmColorHex("#172019"))
        let divider = UIView()
        divider.backgroundColor = lmColorHex("#172019")
        let agentName = roomState == .hasRoom ? "♔ AgentName 〉" : "♔ Not an Agent 〉"
        let agentLabel = label(agentName, size: 11, color: lmColorHex("#172019"))
        statusBar.addSubview(liveTime)
        statusBar.addSubview(divider)
        statusBar.addSubview(agentLabel)
        liveTime.snp.makeConstraints { $0.centerY.equalToSuperview(); $0.centerX.equalToSuperview().multipliedBy(0.55) }
        divider.snp.makeConstraints { $0.center.equalToSuperview(); $0.width.equalTo(1); $0.height.equalTo(14) }
        agentLabel.snp.makeConstraints { $0.centerY.equalToSuperview(); $0.centerX.equalToSuperview().multipliedBy(1.48) }

        let cardView = card(radius: 14)
        container.addSubview(cardView)
        cardView.snp.makeConstraints { $0.top.equalTo(statusBar.snp.bottom).offset(-6); $0.left.right.bottom.equalToSuperview() }

        let name = label(UserShared.user?.nickname.isEmpty == false ? UserShared.user?.nickname ?? "Nickname" : "Nickname", size: 20, color: lmColorHex("#172019"), medium: true)
        cardView.addSubview(name)
        name.snp.makeConstraints { $0.left.equalToSuperview().offset(16); $0.top.equalToSuperview().offset(20) }

        let hostTag = label(" H.1 ", size: 10, color: .white, medium: true)
        hostTag.backgroundColor = lmColorHex("#25D8BD")
        hostTag.layer.cornerRadius = 7
        hostTag.clipsToBounds = true
        cardView.addSubview(hostTag)
        hostTag.snp.makeConstraints { $0.left.equalTo(name.snp.right).offset(7); $0.centerY.equalTo(name); $0.height.equalTo(16) }

        let idLabel = label("ID · \(UserShared.user?.showUserId.isEmpty == false ? UserShared.user?.showUserId ?? "1234" : "1234")  ▣", size: 11, color: lmColorHex("#8A908B"))
        cardView.addSubview(idLabel)
        idLabel.snp.makeConstraints { $0.left.equalTo(name); $0.top.equalTo(name.snp.bottom).offset(5) }

        let avatar = UIImageView(image: kPlaceholder_avatar)
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 26
        if let url = UserShared.user?.avatar, !url.isEmpty { avatar.set_Image(url: url, placeholder: kPlaceholder_avatar) }
        cardView.addSubview(avatar)
        avatar.snp.makeConstraints { $0.right.equalToSuperview().offset(-16); $0.top.equalToSuperview().offset(16); $0.size.equalTo(52) }

        let line = UIView()
        line.backgroundColor = lmColorHex("#E3E6E3")
        cardView.addSubview(line)
        line.snp.makeConstraints { $0.left.right.equalToSuperview().inset(16); $0.top.equalTo(avatar.snp.bottom).offset(10); $0.height.equalTo(1) }

        let giftTitle = label("Gift Income", size: 12, color: lmColorHex("#7F8580"))
        let lastDays = tagLabel("Last 7 days")
        let hourlyTitle = label("Hourly income", size: 12, color: lmColorHex("#7F8580"))
        cardView.addSubview(giftTitle)
        cardView.addSubview(lastDays)
        cardView.addSubview(hourlyTitle)
        giftTitle.snp.makeConstraints { $0.left.equalTo(line); $0.top.equalTo(line.snp.bottom).offset(16) }
        lastDays.snp.makeConstraints { $0.left.equalTo(giftTitle.snp.right).offset(8); $0.centerY.equalTo(giftTitle) }
        hourlyTitle.snp.makeConstraints { $0.left.equalToSuperview().offset(188); $0.centerY.equalTo(giftTitle) }

        let giftValue = label("1000", size: 20, color: lmColorHex("#172019"), medium: true)
        let hourlyValue = label("600", size: 20, color: lmColorHex("#172019"), medium: true)
        let hourlyUnit = label("/h", size: 12, color: lmColorHex("#9DA29E"))
        cardView.addSubview(giftValue)
        cardView.addSubview(hourlyValue)
        cardView.addSubview(hourlyUnit)
        giftValue.snp.makeConstraints { $0.left.equalTo(giftTitle); $0.top.equalTo(giftTitle.snp.bottom).offset(7) }
        hourlyValue.snp.makeConstraints { $0.left.equalTo(hourlyTitle); $0.centerY.equalTo(giftValue) }
        hourlyUnit.snp.makeConstraints { $0.left.equalTo(hourlyValue.snp.right).offset(2); $0.bottom.equalTo(hourlyValue).offset(-2) }

        let progressText = label("24,000 points to go until 600/h", size: 11, color: lmColorHex("#FF7B42"))
        let rules = label("Rules 〉", size: 11, color: lmColorHex("#7F8580"))
        cardView.addSubview(progressText)
        cardView.addSubview(rules)
        progressText.snp.makeConstraints { $0.left.equalTo(giftTitle); $0.top.equalTo(giftValue.snp.bottom).offset(8) }
        rules.snp.makeConstraints { $0.right.equalTo(line); $0.centerY.equalTo(progressText) }

        let progressBackground = UIView()
        progressBackground.backgroundColor = lmColorHex("#D9DCD9")
        let progress = UIView()
        progress.backgroundColor = lmColorHex("#FF8A3D")
        cardView.addSubview(progressBackground)
        progressBackground.addSubview(progress)
        progressBackground.snp.makeConstraints { $0.left.right.equalTo(line); $0.top.equalTo(progressText.snp.bottom).offset(10); $0.height.equalTo(6) }
        progress.snp.makeConstraints { $0.left.top.bottom.equalToSuperview(); $0.width.equalToSuperview().multipliedBy(0.35) }

        let zero = label("0", size: 9, color: lmColorHex("#A0A5A1"))
        let total = label("24,000", size: 9, color: lmColorHex("#A0A5A1"))
        cardView.addSubview(zero)
        cardView.addSubview(total)
        zero.snp.makeConstraints { $0.left.equalTo(line); $0.top.equalTo(progressBackground.snp.bottom).offset(5) }
        total.snp.makeConstraints { $0.right.equalTo(line); $0.centerY.equalTo(zero) }
        return container
    }

    private func makePointsCard() -> UIView {
        let cardView = card(radius: 14)
        let title = label("Points Income", size: 17, color: lmColorHex("#172019"), medium: true)
        let details = label("Details 〉", size: 13, color: lmColorHex("#747A75"))
        cardView.addSubview(title)
        cardView.addSubview(details)
        title.snp.makeConstraints { $0.left.top.equalToSuperview().offset(16) }
        details.snp.makeConstraints { $0.right.equalToSuperview().offset(-16); $0.centerY.equalTo(title) }

        let tabs = UIStackView(arrangedSubviews: [tagLabel("Today", selected: true), label("Last 6 days", size: 12, color: lmColorHex("#8B918C")), label("Last 29 days", size: 12, color: lmColorHex("#8B918C"))])
        tabs.axis = .horizontal
        tabs.spacing = 26
        tabs.alignment = .center
        cardView.addSubview(tabs)
        tabs.snp.makeConstraints { $0.left.equalTo(title); $0.top.equalTo(title.snp.bottom).offset(15); $0.height.equalTo(22) }

        let firstRow = UIStackView(arrangedSubviews: [metric(value: "0", title: "Total Income"), metric(value: "0", title: "Base Salary"), metric(value: "0", title: "Gifts")])
        let secondRow = UIStackView(arrangedSubviews: [metric(value: "0", title: "Invitation"), metric(value: "0", title: "Tasks"), metric(value: "0", title: "Other")])
        [firstRow, secondRow].forEach { $0.axis = .horizontal; $0.distribution = .fillEqually }
        cardView.addSubview(firstRow)
        cardView.addSubview(secondRow)
        firstRow.snp.makeConstraints { $0.top.equalTo(tabs.snp.bottom).offset(18); $0.left.right.equalToSuperview().inset(10); $0.height.equalTo(51) }
        secondRow.snp.makeConstraints { $0.top.equalTo(firstRow.snp.bottom).offset(12); $0.left.right.height.equalTo(firstRow) }
        return cardView
    }

    private func makeRecordCard() -> UIView {
        let cardView = card(radius: 14)
        let title = label("Today Record", size: 17, color: lmColorHex("#172019"), medium: true)
        let details = label("Details 〉", size: 13, color: lmColorHex("#747A75"))
        cardView.addSubview(title)
        cardView.addSubview(details)
        title.snp.makeConstraints { $0.left.top.equalToSuperview().offset(16) }
        details.snp.makeConstraints { $0.right.equalToSuperview().offset(-16); $0.centerY.equalTo(title) }

        let metrics = UIStackView(arrangedSubviews: [metric(value: "0 mins", title: "Live duration"), metric(value: "0", title: "Gift Points"), metric(value: "1,000", title: "Reward Points")])
        metrics.axis = .horizontal
        metrics.distribution = .fillEqually
        cardView.addSubview(metrics)
        metrics.snp.makeConstraints { $0.left.right.equalToSuperview().inset(8); $0.top.equalTo(title.snp.bottom).offset(22); $0.height.equalTo(54) }
        return cardView
    }

    private func metric(value: String, title: String) -> UIView {
        let view = UIView()
        let valueLabel = label(value, size: 18, color: lmColorHex("#172019"), medium: true)
        let titleLabel = label(title, size: 11, color: lmColorHex("#8E948F"))
        valueLabel.textAlignment = .center
        titleLabel.textAlignment = .center
        view.addSubview(valueLabel)
        view.addSubview(titleLabel)
        valueLabel.snp.makeConstraints { $0.top.left.right.equalToSuperview() }
        titleLabel.snp.makeConstraints { $0.top.equalTo(valueLabel.snp.bottom).offset(5); $0.left.right.bottom.equalToSuperview() }
        return view
    }

    private func bottomButton(title: String, highlighted: Bool) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(highlighted ? lmColorHex("#8CFF15") : lmColorHex("#172019"), for: .normal)
        button.titleLabel?.font = lmFontM(18)
        button.backgroundColor = highlighted ? lmColorHex("#142018") : lmColorHex("#E3E5E4")
        button.layer.cornerRadius = 9
        return button
    }

    private func smallGreenButton(_ title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(lmColorHex("#172019"), for: .normal)
        button.titleLabel?.font = lmFontM(14)
        button.backgroundColor = lmColorHex("#8CFF15")
        button.layer.cornerRadius = 4
        return button
    }

    private func tagLabel(_ text: String, selected: Bool = false) -> UILabel {
        let label = self.label(" \(text) ", size: 10, color: selected ? lmColorHex("#8CFF15") : lmColorHex("#777D78"))
        label.backgroundColor = selected ? lmColorHex("#142018") : lmColorHex("#EEEEEE")
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }

    private func card(radius: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = radius
        return view
    }

    private func label(_ text: String, size: CGFloat, color: UIColor, medium: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = medium ? lmFontM(size) : lmFontR(size)
        label.textColor = color
        return label
    }

    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
}
