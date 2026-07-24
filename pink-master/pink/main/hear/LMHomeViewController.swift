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

        view.addSubview(pagingView)
        view.addSubview(segmentedView)
        segmentedView.frame = CGRect(x: kScaleWidth(12), y: kStatusBarHeight, width: self.view.width, height: kScaleWidth(48))
        pagingView.frame = CGRect(x: 0, y: kNavigationBarHeight + kScaleWidth(48), width: self.view.width, height: self.view.height - kTabBarSafeHeight - kTabBarHeight - kNavigationHeight - kScaleWidth(48))
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
        return LMHearVC()
    }
}
