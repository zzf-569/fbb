import UIKit

private func lmFilterButtonWidth(title: String, font: UIFont) -> CGFloat {
    let displayTitle = "●  \(title)" as NSString
    return ceil(displayTitle.size(withAttributes: [.font: font]).width) + 24
}

class LMHearPageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let viewModel = LMHearViewModel()
    private let filterView = LMHearPageFilterView()
    private var bannerList: [BannerItem] = []
    lazy var collectionView: UICollectionView = {
        let layout = makeCollectionLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - kTabBarSafeHeight - kTabBarHeight), collectionViewLayout: layout)
        collectionView.register(LMHearPageCell.self, forCellWithReuseIdentifier: "LMHearPageCell")
        collectionView.register(LMHomeHotCell.self, forCellWithReuseIdentifier: "LMHomeHotCell")
        collectionView.register(LMHomeBannerCell.self, forCellWithReuseIdentifier: "LMHomeBannerCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        getData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        getBannerData()
    }
    func setViewSnp() {
        view.backgroundColor = lmColorHex("#F5F6FA")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        collectionView.contentInset.top = 128
        collectionView.verticalScrollIndicatorInsets.top = 128
        collectionView.addSubview(filterView)
        filterView.toggleHandler = { [weak self] expanded in
            guard let self else { return }
            self.showFilterPopup()
        }
        filterView.selectionHandler = { [weak self] type in self?.update(type: type) }
        filterView.honorHandler = { [weak self] in self?.navigationController?.pushViewController(RankVC(), animated: true) }
        filterView.activityHandler = { HUD.show("Coming soon") }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        filterView.frame = CGRect(x: 0, y: -128, width: collectionView.bounds.width, height: 128)
    }

    private func showFilterPopup() {
        let popup = LMHearFilterPopupView()
        popup.selectionHandler = { [weak self] type in
            self?.update(type: type)
        }
        popup.dismissHandler = { [weak popup] in
            popup?.removeFromSuperview()
            self.filterView.reset()
        }
        view.addSubview(popup)
        popup.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(320)
        }
        popup.show()
    }
    func getData() {
        if viewModel.type == 0 {
            viewModel.getHotList {[weak self] _ in
                self?.collectionView.reloadData()
            }
        } else {
            viewModel.getRoomList {[weak self] _ in
                self?.collectionView.reloadData()
            }
        }
    }
    private func getBannerData() {
        set_NetWork.banner(scene: 1).lmrequest { [weak self] responseModel in
            guard let self else { return }
            self.bannerList = [BannerItem].deserialize(from: responseModel.data as? [Any]) ?? []
            self.collectionView.reloadSections(IndexSet(integer: 1))
        } failureBlock: { [weak self] _ in
            self?.bannerList = []
            self?.collectionView.reloadSections(IndexSet(integer: 1))
        }
    }
    func update(type: Int) {
        viewModel.type = type
        viewModel.page = 1
        getData()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 1 ? (bannerList.isEmpty ? 0 : 1) : viewModel.roomList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LMHomeHotCell", for: indexPath) as! LMHomeHotCell
            cell.set_(model: viewModel.roomList[indexPath.item])
            return cell
        }
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LMHomeBannerCell", for: indexPath) as! LMHomeBannerCell
            cell.configure(banners: bannerList)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LMHearPageCell", for: indexPath) as! LMHearPageCell
        cell.set_(model: viewModel.roomList[indexPath.row], index: indexPath.row)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let banner = bannerList.first else { return }
            RouteService.bannerAction(banner, vc: self)
            return
        }
        viewModel.turnToRoom(roomId: viewModel.roomList[indexPath.row].roomId)
    }
    private func makeCollectionLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, environment in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(kScaleWidth(159)),
                    heightDimension: .absolute(kScaleWidth(177))
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                // 159pt 卡片以 103pt 的步进排列，让居中卡片覆盖两侧约三分之一。
                section.interGroupSpacing = -kScaleWidth(56)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: kScaleWidth(14),
                    leading: kScaleWidth(16),
                    bottom: kScaleWidth(14),
                    trailing: kScaleWidth(16)
                )
                section.visibleItemsInvalidationHandler = { visibleItems, offset, layoutEnvironment in
                    let containerWidth = layoutEnvironment.container.effectiveContentSize.width
                    let centerX = offset.x + containerWidth / 2
                    let maximumDistance = kScaleWidth(103)
                    let sideScale = CGFloat(141.0 / 159.0)
                    guard let centerItem = visibleItems.min(by: {
                        abs($0.frame.midX - centerX) < abs($1.frame.midX - centerX)
                    }) else { return }
                    let centerIndex = centerItem.indexPath.item

                    visibleItems.forEach { visibleItem in
                        let indexDistance = abs(visibleItem.indexPath.item - centerIndex)
                        guard indexDistance <= 1 else {
                            visibleItem.alpha = 0
                            visibleItem.transform = CGAffineTransform(scaleX: sideScale, y: sideScale)
                            visibleItem.zIndex = -1
                            return
                        }

                        visibleItem.alpha = 1
                        let distance = min(abs(visibleItem.frame.midX - centerX), maximumDistance)
                        let progress = distance / maximumDistance
                        let scale = 1 - progress * (1 - sideScale)
                        visibleItem.transform = CGAffineTransform(scaleX: scale, y: scale)
                        visibleItem.zIndex = visibleItem.indexPath.item == centerIndex ? 1000 : 100
                    }
                }
                return section
            }

            if sectionIndex == 1 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(kScaleWidth(80))
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: kScaleWidth(18),
                    leading: kScaleWidth(16),
                    bottom: kScaleWidth(18),
                    trailing: kScaleWidth(16)
                )
                return section
            }

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(kScaleWidth(112))
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = kScaleWidth(12)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: kScaleWidth(16),
                bottom: kScaleWidth(16),
                trailing: kScaleWidth(16)
            )
            return section
        }
    }
}

private final class LMHearPageFilterView: UIView {
    var toggleHandler: ((Bool) -> Void)?
    var selectionHandler: ((Int) -> Void)?
    var honorHandler: (() -> Void)?
    var activityHandler: (() -> Void)?

    private let panel = UIView()
    private let toggleButton = UIButton(type: .custom)
    private let honorButton = UIButton(type: .custom)
    private let activityButton = UIButton(type: .custom)
    private var featureTopConstraint: Constraint?
    private var expanded = false
    private var filterButtons: [UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func buildView() {
        clipsToBounds = true
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        addSubview(scroll)
        scroll.snp.makeConstraints { $0.left.right.top.equalToSuperview(); $0.height.equalTo(45) }
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        scroll.addSubview(stack)
        stack.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(29)
        }
        ["Hot", "Philippines", "Nigeria", "Vietnam"].enumerated().forEach { index, title in
            let button = makeFilterButton(title: title, type: index, selected: index == 0)
            stack.addArrangedSubview(button)
            button.snp.makeConstraints {
                $0.height.equalTo(29)
                $0.width.equalTo(lmFilterButtonWidth(title: title, font: lmFontR(13)))
            }
            filterButtons.append(button)
        }

        toggleButton.backgroundColor = lmColorHex("#F5F6FA")
        toggleButton.tintColor = lmColorHex("#172019")
        toggleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleAction), for: .touchUpInside)
        addSubview(toggleButton)
        toggleButton.snp.makeConstraints { $0.right.top.equalToSuperview(); $0.width.equalTo(48); $0.height.equalTo(45) }

        panel.backgroundColor = .white
        panel.layer.cornerRadius = 16
        panel.isHidden = true
        addSubview(panel)
        panel.snp.makeConstraints { $0.left.right.equalToSuperview().inset(8); $0.top.equalTo(scroll.snp.bottom).offset(8); $0.height.equalTo(244) }

        configureFeatureButton(honorButton, image: "home_honor", action: #selector(honorAction))
        configureFeatureButton(activityButton, image: "home_acti", action: #selector(activityAction))
        addSubview(honorButton)
        addSubview(activityButton)
        honorButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            featureTopConstraint = $0.top.equalTo(scroll.snp.bottom).offset(12).constraint
            $0.width.equalTo(177)
            $0.height.equalTo(60)
        }
        activityButton.snp.makeConstraints { $0.left.equalTo(honorButton.snp.right).offset(12); $0.right.equalToSuperview().offset(-16); $0.top.height.equalTo(honorButton) }
    }


    private func makeFilterButton(title: String, type: Int, selected: Bool) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = type
        button.setTitle("●  \(title)", for: .normal)
        button.titleLabel?.font = lmFontR(13)
        button.backgroundColor = selected ? lmColorHex("#172019") : .white
        button.setTitleColor(selected ? lmColorHex("#8CFF15") : lmColorHex("#172019"), for: .normal)
        button.layer.borderWidth = selected ? 0 : 1
        button.layer.borderColor = lmColorHex("#E0E2E0").cgColor
        button.layer.cornerRadius = 9
        button.addTarget(self, action: #selector(filterAction(_:)), for: .touchUpInside)
        return button
    }

    private func configureFeatureButton(_ button: UIButton, image: String, action: Selector) {
        button.setImage(UIImage(named: image), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
    }

    @objc private func toggleAction() {
        toggleHandler?(true)
    }

    func reset() {
        expanded = false
        panel.isHidden = true
        toggleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        featureTopConstraint?.update(offset: 12)
    }

    @objc private func filterAction(_ sender: UIButton) {
        if let index = filterButtons.firstIndex(of: sender) {
            for (buttonIndex, button) in filterButtons.enumerated() {
                let selected = buttonIndex == index
                button.backgroundColor = selected ? lmColorHex("#172019") : .white
                button.setTitleColor(selected ? lmColorHex("#8CFF15") : lmColorHex("#172019"), for: .normal)
            }
        }
        selectionHandler?(sender.tag)
    }

    @objc private func honorAction() { honorHandler?() }
    @objc private func activityAction() { activityHandler?() }
}

private final class LMHearFilterPopupView: UIView {
    var selectionHandler: ((Int) -> Void)?
    var dismissHandler: (() -> Void)?
    private let dimView = UIView()
    private let panel = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func buildView() {
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.52)
        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissAction)))
        addSubview(dimView)
        dimView.snp.makeConstraints { $0.edges.equalToSuperview() }

        panel.backgroundColor = .white
        panel.layer.cornerRadius = 22
        panel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        panel.clipsToBounds = true
        addSubview(panel)
        panel.snp.makeConstraints { $0.left.right.top.equalToSuperview(); $0.bottom.equalToSuperview().offset(-28) }

        let recommendations = popupLabel("Recommendations", color: lmColorHex("#172019"), size: 12)
        panel.addSubview(recommendations)
        recommendations.snp.makeConstraints { $0.left.equalToSuperview().offset(16); $0.top.equalToSuperview().offset(8) }
        let close = UIButton(type: .custom)
        close.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        close.tintColor = lmColorHex("#172019")
        close.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        panel.addSubview(close)
        close.snp.makeConstraints { $0.right.equalToSuperview().offset(-28); $0.centerY.equalTo(recommendations); $0.size.equalTo(30) }

        addFilterRow([popupButton("Hot", selected: true, type: 0), popupButton("Philippines", selected: false, type: 1), popupButton("Nigeria", selected: false, type: 2)], top: 32)
        addFilterRow([popupButton("Nigeria", selected: false, type: 2), popupButton("Nigeria", selected: false, type: 2)], top: 73)

        let country = popupLabel("Country", color: lmColorHex("#172019"), size: 12)
        panel.addSubview(country)
        country.snp.makeConstraints { $0.left.equalTo(recommendations); $0.top.equalToSuperview().offset(118) }
        ["Vietnam", "Nigeria", "Bangladesh", "Brazil", "Egypt", "Laos"].enumerated().forEach { index, title in
            let button = popupButton(title, selected: index == 0, type: index + 1)
            panel.addSubview(button)
            button.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16 + CGFloat(index % 3) * 112)
                $0.top.equalTo(country.snp.bottom).offset(14 + CGFloat(index / 3) * 52)
                $0.width.equalTo(lmFilterButtonWidth(title: title, font: lmFontR(14))); $0.height.equalTo(29)
            }
        }
        let language = popupLabel("Language", color: lmColorHex("#172019"), size: 12)
        panel.addSubview(language)
        language.snp.makeConstraints { $0.left.equalTo(country); $0.top.equalTo(country.snp.bottom).offset(94) }
        let english = popupButton("English", selected: true, type: 0)
        let chinese = popupButton("華語區", selected: false, type: 0)
        panel.addSubview(english); panel.addSubview(chinese)
        english.snp.makeConstraints { $0.left.equalTo(language); $0.top.equalTo(language.snp.bottom).offset(12); $0.width.equalTo(lmFilterButtonWidth(title: "English", font: lmFontR(14))); $0.height.equalTo(29) }
        chinese.snp.makeConstraints { $0.left.equalTo(english.snp.right).offset(12); $0.top.height.equalTo(english); $0.width.equalTo(lmFilterButtonWidth(title: "華語區", font: lmFontR(14))) }
    }

    private func popupLabel(_ text: String, color: UIColor, size: CGFloat) -> UILabel {
        let label = UILabel(lmfont: lmFontM(size), textColor: color)
        label.text = text
        return label
    }

    private func popupButton(_ title: String, selected: Bool, type: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = type
        button.setTitle("●  \(title)", for: .normal)
        button.titleLabel?.font = lmFontR(14)
        button.setTitleColor(selected ? lmColorHex("#8CFF15") : lmColorHex("#172019"), for: .normal)
        button.backgroundColor = selected ? lmColorHex("#172019") : .white
        button.layer.cornerRadius = 9
        button.layer.borderWidth = selected ? 0 : 1
        button.layer.borderColor = lmColorHex("#E0E2E0").cgColor
        button.addTarget(self, action: #selector(filterAction(_:)), for: .touchUpInside)
        return button
    }

    private func addFilterRow(_ buttons: [UIButton], top: CGFloat) {
        var previous: UIButton?
        for button in buttons {
            panel.addSubview(button)
            button.snp.makeConstraints {
                $0.top.equalToSuperview().offset(top); $0.height.equalTo(29)
                if let previous { $0.left.equalTo(previous.snp.right).offset(16) } else { $0.left.equalToSuperview().offset(16) }
                let title = button.title(for: .normal)?.replacingOccurrences(of: "●  ", with: "") ?? ""
                $0.width.equalTo(lmFilterButtonWidth(title: title, font: lmFontR(14)))
            }
            previous = button
        }
    }

    func show() {
        layoutIfNeeded()
        panel.transform = CGAffineTransform(translationX: 0, y: -panel.bounds.height)
        dimView.alpha = 0
        UIView.animate(withDuration: 0.28) { self.panel.transform = .identity; self.dimView.alpha = 1 }
    }

    @objc private func filterAction(_ sender: UIButton) { selectionHandler?(sender.tag) }
    @objc private func dismissAction() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dimView.alpha = 0
            self.panel.transform = CGAffineTransform(translationX: 0, y: -self.panel.bounds.height)
        }, completion: { _ in self.dismissHandler?() })
    }
}

private final class LMHomeBannerCell: UICollectionViewCell {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 14
        contentView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(banners: [BannerItem]) {
        guard let banner = banners.first else {
            imageView.image = nil
            return
        }
        imageView.set_Image(url: banner.img)
    }
}

extension LMHearPageVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
