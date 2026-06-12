//
//  MineCollectRoomViewController.swift
//  lime
//
//  Created by xf on 2025/9/1.
//

import UIKit
import JXSegmentedView

class MineCollectRoomViewController: LMBaseVC {
    
    
    // MARK: 构造属性
    private var page: Int = 1
    private var isEdit: Bool = false

    var dataList: [CollectRoomModel] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [MineCollectRoomCell.self])
        tableView.estimatedRowHeight = 44
        tableView.contentInset = UIEdgeInsets(top: kScaleWidth(12), left: 0, bottom: kTabBarSafeHeight, right: 0)
        return tableView
    }()
    
    lazy var editBtn: UIButton = {
        let button = UIButton(image: UIImage(named: "black_edit"), target: self, action: #selector(act_editBtnClick))
            .titleColor(lmColorHex("#1C1C29"))
       
        return button
    }()

    // MARK: 声明构造器
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUISubViews()
        addRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: - 配置子视图
    private func setUISubViews() {
        let BarButtonItem = UIBarButtonItem(customView: editBtn)
        self.navigationItem.rightBarButtonItem = BarButtonItem
        title = "收藏"
        view.addSubview(tableView)
       
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavigationHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
        }
    }
    
    // MARK: 配置数据
    func rqeuestData(){
        UserNetWork.collectList(type: 1, page: page).lmrequest {[weak self] responseModel in
            guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]), let self = self else { return }

            guard let list = [CollectRoomModel].deserialize(from: model.records) else { return }
            self.dataList = list
            self.tableView.endRefreshing()
            self.tableView.footerHidden(model.pages <= self.page)
            tableView.confEmptyView(isEmpty: dataList.count <= 0, model: LMEmptyDataModel(titleColor: lmColorHex("#1C1C29A3")))
        } failureBlock: {[weak self] error in
            guard let self = self else { return }
            self.tableView.endRefreshing()
            tableView.confEmptyView(isEmpty: dataList.count <= 0, model: LMEmptyDataModel(title: error.message, titleColor: lmColorHex("#1C1C29A3")))
        }
    }
    
    @objc func act_editBtnClick() {
        isEdit = !isEdit
        if isEdit == true {
            editBtn.setImage(nil, for: .normal)
            editBtn.setTitle("保存", for: .normal)
        }else {
            editBtn.setImage(UIImage(named: "black_edit"), for: .normal)
            editBtn.setTitle("", for: .normal)
        }
        let BarButtonItem = UIBarButtonItem(customView: editBtn)
        self.navigationItem.rightBarButtonItem = BarButtonItem
        self.page = 1
        self.rqeuestData()
    }
}

private extension MineCollectRoomViewController {
    
    func addRefresh() {
        
        tableView.addHeader { [weak self] in
            guard let self = self else { return }
            
            self.page = 1
            self.rqeuestData()
        }
        
        tableView.addFooter { [weak self] in
            guard let self = self else { return }
            
            self.page += 1
            self.rqeuestData()
        }
        self.tableView.footerHidden(true)
        
        tableView.headerBeginRefreshing()
    }
}

extension MineCollectRoomViewController:   UITableViewDataSource, UITableViewDelegate, MineCollectRoomCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        kScaleWidth(80)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: MineCollectRoomCell.self, cellForRowAt: indexPath)
        cell.model = dataList[indexPath.row]
        cell.setEdit(edit: isEdit)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let roomModel = dataList[indexPath.row]
        VoiceShared.turnToRM(roomModel.bizId)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let model = dataList[indexPath.row]
        let ex = UIContextualAction(style: .normal, title: "") {[weak self]
            (action, view, completionHandler) in
            self?.act_roomUnlike(roomId: model.bizId)
            completionHandler(true)
        }
        ex.backgroundColor = .white.withAlphaComponent(0)
        ex.image = UIImage(named: "mine_fans_dele")
        let config = UISwipeActionsConfiguration(actions: [ex])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    

    func act_roomUnlike(roomId: String) {
        HUD.showLoading()
        RoomNetWork.like(roomId: roomId, liked: false).lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            HUD.hide()
            self.rqeuestData()
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    func dg_editBtnClick(model: CollectRoomModel) {
        RoomNetWork.like(roomId: model.bizId, liked: false).lmrequest { responseModel in
            self.tableView.reloadData()
            self.rqeuestData()

        } failureBlock: { error in
            
        }

    }
    
}


extension MineCollectRoomViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
    
    
}
