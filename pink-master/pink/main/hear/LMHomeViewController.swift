//
//  LMHomeViewController.swift
//  pink
//
//  Created by xfffff on 2026/7/22.
//  Copyright © 2026 pink. All rights reserved.
//

import UIKit

class LMHomeViewController: LMBaseVC {

    lazy var pagingView = JXSegmentedListContainerView(dataSource: self)
    lazy var segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 48))
    let dataSource = JXSegmentedTitleImageDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func configUI() {
        dataSource.titleImageType = .onlyImage
        dataSource.titles = ["", ""]
        dataSource.normalImageInfos = ["home_left", "home_right"]
        dataSource.selectedImageInfos = ["home_left_sele", "home_right_sele"]
        dataSource.itemSpacing = kScaleWidth(2)
        dataSource.imageSize = CGSize(width: 61, height: 38)
        dataSource.isItemSpacingAverageEnabled = false
        segmentedView.backgroundColor(.clear)
        segmentedView.defaultSelectedIndex = 1
        segmentedView.dataSource = dataSource
        segmentedView.delegate = self
        segmentedView.listContainer = pagingView

        let search = UIControl()
        search.backgroundColor = .white
        search.layer.cornerRadius = 20
        search.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        view.addSubview(search)
        search.snp.makeConstraints {
            $0.left.equalToSuperview().offset(218)
            $0.top.equalToSuperview().offset(kStatusBarHeight + 4)
            $0.width.equalTo(108)
            $0.height.equalTo(40)
        }
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = lmColorHex("#A0A6A1")
        search.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { $0.left.equalToSuperview().offset(12); $0.centerY.equalToSuperview(); $0.size.equalTo(18) }
        let searchLabel = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#A0A6A1"))
        searchLabel.text = "Search"
        search.addSubview(searchLabel)
        searchLabel.snp.makeConstraints { $0.left.equalTo(searchIcon.snp.right).offset(5); $0.centerY.equalToSuperview() }

        let gift = UIButton(type: .custom)
        gift.setTitle("🎁", for: .normal)
        gift.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        gift.addTarget(self, action: #selector(giftAction), for: .touchUpInside)
        view.addSubview(gift)
        gift.snp.makeConstraints { $0.right.equalToSuperview().offset(-14); $0.centerY.equalTo(search); $0.size.equalTo(42) }

        view.addSubview(pagingView)
        view.addSubview(segmentedView)
        segmentedView.frame = CGRect(x: kScaleWidth(12), y: kStatusBarHeight, width: self.view.width, height: kScaleWidth(48))
        pagingView.frame = CGRect(x: 0, y: kNavigationBarHeight + kScaleWidth(48), width: self.view.width, height: self.view.height - kTabBarSafeHeight - kTabBarHeight - kNavigationHeight)
    }

    @objc private func searchAction() {
        navigationController?.pushViewController(SearchPageViewController(), animated: true)
    }

    @objc private func giftAction() {
        HUD.show("Coming soon")
    }

}

extension LMHomeViewController: JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        2
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> any JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            return MineCollectRoomViewController()
        }
        return LMHearPageVC()
    }
}
