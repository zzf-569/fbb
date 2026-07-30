//
//  LMUserinfoVC.swift
//  pink
//
//  Created by xfffff on 2026/7/27.
//  Copyright © 2026 pink. All rights reserved.
//

import UIKit

final class LMUserinfoVC: LMBaseVC {
    private let userId: String
    private var user: UsInfoItem

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let heroContainer = UIView()
    private let heroPlaceholder = UIImageView(image: kPlaceholder_image)
    private let avatarView = UIImageView(image: kPlaceholder_avatar)
    private let nameLabel = UILabel()
    private let idLabel = UILabel()
    private let tagStack = UIStackView()
    private let followedValueLabel = UILabel()
    private let fansValueLabel = UILabel()
    private let friendsValueLabel = UILabel()
    private let bioLabel = UILabel()
    private let roomCard = UIView()
    private let roomCoverView = UIImageView(image: kPlaceholder_image)
    private let roomNameLabel = UILabel()
    private let roomTagLabel = UILabel()
    private let enterRoomButton = UIButton(type: .custom)
    private lazy var editButton = navigationButton(systemName: "square.and.pencil", action: #selector(editAction))
    private let lightedSection = LMProfileCollectionSectionView(
        title: "Lighted Up · 42",
        tintColor: lmColorHex("#6258FF"),
        colors: [lmColorHex("#FFFCE0"), lmColorHex("#C9C8FF")]
    )
    private let achievementSection = LMProfileCollectionSectionView(
        title: "Achievement Badge · 9",
        tintColor: lmColorHex("#FF8A00"),
        colors: [lmColorHex("#FFFCE6"), lmColorHex("#FFE7B6")]
    )

    lazy var photoWall: SDCycleScrollView = {
        let view = SDCycleScrollView(frame: .zero, delegate: self, placeholderImage: kPlaceholder_image)!
        view.backgroundColor = .clear
        view.bannerImageViewContentMode = .scaleAspectFill
        view.autoScroll = false
        view.infiniteLoop = false
        view.showPageControl = true
        view.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        view.currentPageDotColor = .white
        view.pageDotColor = UIColor.white.withAlphaComponent(0.45)
        return view
    }()

    required init(user: UsInfoItem) {
        self.user = user
        self.userId = user.userId
        super.init(nibName: nil, bundle: nil)
    }

    required init(userId: String) {
        self.userId = userId
        self.user = UsInfoItem()
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        if let currentUser = UserShared.user {
            self.init(user: currentUser)
        } else {
            self.init(userId: "")
        }
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
        view.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.scrollIndicatorInsets = .zero
        scrollView.contentInset = .zero

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        buildHero()
        buildProfile()
        buildRoom()

        contentView.addSubview(lightedSection)
        lightedSection.snp.makeConstraints {
            $0.top.equalTo(roomCard.snp.bottom).offset(18)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(143)
        }

        contentView.addSubview(achievementSection)
        achievementSection.snp.makeConstraints {
            $0.top.equalTo(lightedSection.snp.bottom).offset(18)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(143)
            $0.bottom.equalToSuperview().offset(-28)
        }
    }

    private func buildHero() {
        heroContainer.clipsToBounds = true
        heroContainer.backgroundColor = lmColorHex("#DADADA")
        contentView.addSubview(heroContainer)
        heroContainer.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(kScaleWidth(380))
        }

        heroPlaceholder.contentMode = .scaleAspectFill
        heroPlaceholder.clipsToBounds = true
        heroContainer.addSubview(heroPlaceholder)
        heroContainer.addSubview(photoWall)
        heroPlaceholder.snp.makeConstraints { $0.edges.equalToSuperview() }
        photoWall.snp.makeConstraints { $0.edges.equalToSuperview() }

        let shade = LMProfileGradientView()
        shade.isUserInteractionEnabled = false
        heroContainer.addSubview(shade)
        shade.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(110)
        }

        let backButton = navigationButton(systemName: "backicon", action: #selector(backAction))
        heroContainer.addSubview(backButton)
        heroContainer.addSubview(editButton)
        backButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(14)
            $0.top.equalToSuperview().offset(kStatusBarHeight + 12)
            $0.size.equalTo(36)
        }
        editButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-14)
            $0.top.size.equalTo(backButton)
        }
    }

    private func buildProfile() {
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 37
        avatarView.layer.borderWidth = 3
        avatarView.layer.borderColor = UIColor.white.cgColor
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(28)
            $0.centerY.equalTo(heroContainer.snp.bottom)
            $0.size.equalTo(74)
        }

        let statusStack = UIStackView(arrangedSubviews: [
            pill("▥ Live", textColor: lmColorHex("#B7FF32"), background: lmColorHex("#102213")),
            pill("● offline", textColor: lmColorHex("#9B9B9B"), background: lmColorHex("#EEEEEE")),
            pill("● online", textColor: lmColorHex("#3C6119"), background: lmColorHex("#E9FFD0"))
        ])
        statusStack.axis = .horizontal
        statusStack.spacing = 6
        contentView.addSubview(statusStack)
        statusStack.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-17)
            $0.top.equalTo(heroContainer.snp.bottom).offset(9)
            $0.height.equalTo(25)
        }

        nameLabel.font = lmFontS(20)
        nameLabel.textColor = lmColorHex("#1F2522")
        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(17)
            $0.top.equalTo(avatarView.snp.bottom).offset(8)
        }

        idLabel.font = lmFontR(12)
        idLabel.textColor = lmColorHex("#8A8F8B")
        idLabel.isUserInteractionEnabled = true
        idLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyIdAction)))
        contentView.addSubview(idLabel)
        idLabel.snp.makeConstraints {
            $0.left.equalTo(nameLabel.snp.right).offset(8)
            $0.centerY.equalTo(nameLabel)
            $0.right.lessThanOrEqualToSuperview().offset(-16)
        }

        tagStack.axis = .horizontal
        tagStack.spacing = 4
        tagStack.alignment = .center
        contentView.addSubview(tagStack)
        tagStack.snp.makeConstraints {
            $0.left.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(7)
            $0.right.lessThanOrEqualToSuperview().offset(-16)
            $0.height.equalTo(18)
        }

        let stats = UIStackView(arrangedSubviews: [
            statView(value: followedValueLabel, title: "Followed"),
            statView(value: fansValueLabel, title: "Fans"),
            statView(value: friendsValueLabel, title: "Friends")
        ])
        stats.axis = .horizontal
        stats.distribution = .fillEqually
        contentView.addSubview(stats)
        stats.snp.makeConstraints {
            $0.top.equalTo(tagStack.snp.bottom).offset(17)
            $0.left.right.equalToSuperview().inset(32)
            $0.height.equalTo(55)
        }

        let bioCard = UIView()
        bioCard.backgroundColor = lmColorHex("#F7F7F7")
        bioCard.layer.cornerRadius = 14
        contentView.addSubview(bioCard)
        bioCard.snp.makeConstraints {
            $0.top.equalTo(stats.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(17)
            $0.height.greaterThanOrEqualTo(88)
        }

        let quoteLeft = label("〝", size: 25, color: lmColorHex("#B8BCB9"))
        let quoteRight = label("〞", size: 25, color: lmColorHex("#B8BCB9"))
        bioLabel.font = lmFontR(15)
        bioLabel.textColor = lmColorHex("#242824")
        bioLabel.numberOfLines = 0
        bioCard.addSubview(quoteLeft)
        bioCard.addSubview(bioLabel)
        bioCard.addSubview(quoteRight)
        quoteLeft.snp.makeConstraints { $0.left.top.equalToSuperview().inset(12) }
        bioLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-27)
            $0.top.bottom.equalToSuperview().inset(14)
        }
        quoteRight.snp.makeConstraints { $0.right.bottom.equalToSuperview().inset(10) }
    }

    private func buildRoom() {
        roomCard.backgroundColor = lmColorHex("#F7F7F7")
        roomCard.layer.cornerRadius = 14
        contentView.addSubview(roomCard)
        roomCard.snp.makeConstraints {
            $0.top.equalTo(bioLabel.superview!.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(17)
            $0.height.equalTo(128)
        }

        let title = label("Chatroom", size: 17, color: lmColorHex("#171B18"))
        title.font = lmFontM(17)
        roomCard.addSubview(title)
        title.snp.makeConstraints { $0.left.equalToSuperview().offset(16); $0.top.equalToSuperview().offset(14) }

        let inner = UIView()
        inner.backgroundColor = .white
        inner.layer.cornerRadius = 12
        inner.layer.borderWidth = 1
        inner.layer.borderColor = lmColorHex("#D8DCD8").cgColor
        roomCard.addSubview(inner)
        inner.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview().inset(12)
            $0.top.equalTo(title.snp.bottom).offset(10)
        }

        roomCoverView.contentMode = .scaleAspectFill
        roomCoverView.clipsToBounds = true
        roomCoverView.layer.cornerRadius = 7
        inner.addSubview(roomCoverView)
        roomCoverView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(52)
        }

        roomNameLabel.font = lmFontR(14)
        roomNameLabel.textColor = lmColorHex("#202520")
        inner.addSubview(roomNameLabel)
        roomNameLabel.snp.makeConstraints {
            $0.left.equalTo(roomCoverView.snp.right).offset(12)
            $0.top.equalToSuperview().offset(13)
            $0.right.lessThanOrEqualToSuperview().offset(-80)
        }

        roomTagLabel.font = lmFontR(11)
        roomTagLabel.textColor = lmColorHex("#315900")
        roomTagLabel.backgroundColor = lmColorHex("#B8FF5A")
        roomTagLabel.layer.cornerRadius = 2
        roomTagLabel.clipsToBounds = true
        roomTagLabel.textAlignment = .center
        inner.addSubview(roomTagLabel)
        roomTagLabel.snp.makeConstraints {
            $0.left.equalTo(roomNameLabel)
            $0.top.equalTo(roomNameLabel.snp.bottom).offset(7)
            $0.width.greaterThanOrEqualTo(42)
            $0.height.equalTo(18)
        }

        enterRoomButton.setTitle("Enter", for: .normal)
        enterRoomButton.setTitleColor(lmColorHex("#B8FF5A"), for: .normal)
        enterRoomButton.titleLabel?.font = lmFontM(13)
        enterRoomButton.backgroundColor = lmColorHex("#142018")
        enterRoomButton.layer.cornerRadius = 7
        enterRoomButton.addTarget(self, action: #selector(enterRoomAction), for: .touchUpInside)
        inner.addSubview(enterRoomButton)
        enterRoomButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(66)
            $0.height.equalTo(32)
        }
    }

    private func updateView() {
        nameLabel.text = user.nickname.isEmpty ? "Nickname" : user.nickname
        let shownId = user.showUserId.isEmpty ? (user.userId.isEmpty ? "1234" : user.userId) : user.showUserId
        idLabel.text = "ID · \(shownId)  ▣"
        followedValueLabel.text = user.focusCnt.toString()
        fansValueLabel.text = user.fansCnt.toString()
        friendsValueLabel.text = user.collectCnt.toString()
        bioLabel.text = user.signature.isEmpty ? "This user has not written a bio yet." : user.signature
        editButton.isHidden = userId != UserShared.user?.userId

        if !user.avatar.isEmpty {
            avatarView.set_Image(url: user.avatar, placeholder: kPlaceholder_avatar)
        }

        let photoURLs = user.photoWall.map(\.url).filter { !$0.isEmpty }
        let heroURLs = photoURLs.isEmpty && !user.avatar.isEmpty ? [user.avatar] : photoURLs
        photoWall.imageURLStringsGroup = heroURLs
        heroPlaceholder.isHidden = !heroURLs.isEmpty
        rebuildTags()
        updateRoom()
        lightedSection.update(items: user.giftList.prefix(6).map { $0.iconUrl })
        achievementSection.update(items: Array(user.accomplishments.prefix(6)))
    }

    private func rebuildTags() {
        tagStack.arrangedSubviews.forEach {
            tagStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        tagStack.addArrangedSubview(tag("♀\(user.age)", color: lmColorHex("#34C5F0")))
        if user.richLevel > 0 { tagStack.addArrangedSubview(tag("◆\(user.richLevel)", color: lmColorHex("#EE76C8"))) }
        if user.charmLevel > 0 { tagStack.addArrangedSubview(tag("Charm \(user.charmLevel)", color: lmColorHex("#FF78B8"))) }
        for item in user.labelList.prefix(3) where !item.labelName.isEmpty {
            tagStack.addArrangedSubview(tag(item.labelName, color: lmColorHex("#FF78B8")))
        }
    }

    private func updateRoom() {
        guard let room = user.currentRoom, !room.roomId.isEmpty else {
            roomNameLabel.text = "Room Name"
            roomTagLabel.text = " Chat "
            enterRoomButton.isEnabled = false
            enterRoomButton.alpha = 0.55
            return
        }
        roomNameLabel.text = room.roomName.isEmpty ? "Room Name" : room.roomName
        roomTagLabel.text = " \(room.categoryName.isEmpty ? "Chat" : room.categoryName) "
        roomCoverView.set_Image(url: room.cover, placeholder: kPlaceholder_image)
        enterRoomButton.isEnabled = true
        enterRoomButton.alpha = 1
    }

    private func loadUser() {
        guard !userId.isEmpty else { return }
        UserNetWork.Info(userId: userId).lmrequest { [weak self] response in
            guard let self, let model = UsInfoItem.deserialize(from: response.data as? [String: Any]) else { return }
            self.user = model
            self.updateView()
        } failureBlock: { _ in }
    }

    private func navigationButton(systemName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func pill(_ text: String, textColor: UIColor, background: UIColor) -> UILabel {
        let view = label(text, size: 10, color: textColor)
        view.textAlignment = .center
        view.backgroundColor = background
        view.layer.cornerRadius = 12.5
        view.clipsToBounds = true
        view.snp.makeConstraints { $0.width.greaterThanOrEqualTo(57) }
        return view
    }

    private func tag(_ text: String, color: UIColor) -> UILabel {
        let view = label(" \(text) ", size: 10, color: .white)
        view.textAlignment = .center
        view.backgroundColor = color
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.snp.makeConstraints { $0.height.equalTo(16) }
        return view
    }

    private func statView(value: UILabel, title: String) -> UIView {
        let container = UIView()
        value.font = lmFontM(22)
        value.textAlignment = .center
        value.textColor = lmColorHex("#1B201C")
        let titleLabel = label(title, size: 12, color: lmColorHex("#858A86"))
        titleLabel.textAlignment = .center
        container.addSubview(value)
        container.addSubview(titleLabel)
        value.snp.makeConstraints { $0.top.left.right.equalToSuperview() }
        titleLabel.snp.makeConstraints { $0.top.equalTo(value.snp.bottom).offset(3); $0.left.right.bottom.equalToSuperview() }
        return container
    }

    private func label(_ text: String, size: CGFloat, color: UIColor) -> UILabel {
        let view = UILabel()
        view.text = text
        view.font = lmFontR(size)
        view.textColor = color
        return view
    }

    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func editAction() {
        guard userId == UserShared.user?.userId else { return }
        let controller = UserInfoSetViewController()
        controller.dataSoure = user
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func copyIdAction() {
        let value = user.showUserId.isEmpty ? user.userId : user.showUserId
        guard !value.isEmpty else { return }
        UIPasteboard.general.string = value
        HUD.showSuccess("Copied")
    }

    @objc private func enterRoomAction() {
        guard let room = user.currentRoom, !room.roomId.isEmpty else { return }
        RouteService.pushRoom(room.roomId)
    }
}

extension LMUserinfoVC: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {}
}

private final class LMProfileGradientView: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }

    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let gradient = layer as? CAGradientLayer else { return }
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.5).cgColor]
        gradient.locations = [0, 1]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class LMProfileCollectionSectionView: UIView {
    private let titleLabel = UILabel()
    private let itemStack = UIStackView()
    private let colors: [UIColor]

    init(title: String, tintColor: UIColor, colors: [UIColor]) {
        self.colors = colors
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = lmColorHex("#C7CBC8").cgColor

        let header = LMProfileSectionHeaderView(colors: colors)
        addSubview(header)
        header.snp.makeConstraints { $0.top.left.right.equalToSuperview(); $0.height.equalTo(52) }

        titleLabel.text = title
        titleLabel.font = lmFontR(16)
        titleLabel.textColor = tintColor
        header.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.left.equalToSuperview().offset(12); $0.centerY.equalToSuperview() }

        let gift = UILabel()
        gift.text = colors.last == lmColorHex("#C9C8FF") ? "🎁" : "🏆"
        gift.font = .systemFont(ofSize: 35)
        header.addSubview(gift)
        gift.snp.makeConstraints { $0.right.equalToSuperview().offset(-14); $0.centerY.equalToSuperview() }

        itemStack.axis = .horizontal
        itemStack.spacing = 8
        itemStack.distribution = .fillEqually
        addSubview(itemStack)
        itemStack.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.equalTo(header.snp.bottom).offset(10)
            $0.height.equalTo(62)
        }
        update(items: [])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(items: [String]) {
        itemStack.arrangedSubviews.forEach {
            itemStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        for index in 0..<6 {
            let imageView = UIImageView(image: kPlaceholder_image)
            imageView.backgroundColor = index.isMultiple(of: 2) ? lmColorHex("#E1E1E1") : colors.last?.withAlphaComponent(0.35)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 5
            if index < items.count, !items[index].isEmpty {
                imageView.set_Image(url: items[index], placeholder: kPlaceholder_image)
            }
            itemStack.addArrangedSubview(imageView)
        }
    }
}

private final class LMProfileSectionHeaderView: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }

    init(colors: [UIColor]) {
        super.init(frame: .zero)
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
        guard let gradient = layer as? CAGradientLayer else { return }
        gradient.colors = colors.map(\.cgColor)
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
