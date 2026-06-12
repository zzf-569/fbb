import UIKit
class LMPkHistoryView: LMBaseVC {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LMPkHistoryCell.self])
        return tableView
    }()
    var page = 1
    var dataSource: [VoiceCrossPkItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setViewSnp()
        lmrequestData()
        addRefresh()
    }
    private func setViewSnp() {
        backgroundImage = nil
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(8))
            make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
        }
    }
    func addRefresh() {
        tableView.addHeader { [weak self] in
            self?.page = 1
            self?.lmrequestData()
        }
        tableView.addFooter { [weak self] in
            self?.page += 1
            self?.lmrequestData()
        }
    }
    func lmrequestData() {
        guard let roomId = VoiceService.shared.roomViewController?.viewModel.roomItem.roomId else {
            return
        }
       RoomPKNetWork.roompkrecord(roomId:roomId, page: page, scene: 1).lmrequest {[weak self] responseModel in
            self?.tableView.endRefreshing()
            guard let model = PageItem.deserialize(from: responseModel.data as? [String: Any]),
                  let list = [VoiceCrossPkItem].deserialize(from: model.records), let self = self else {
                self?.tableView.footerHidden(true)
                return
            }
            self.page == 1 ? self.dataSource = list : self.dataSource.append(contentsOf: list)
            self.tableView.confEmptyView(isEmpty: self.dataSource.count <= 0, model: LMEmptyDataModel(titleColor: .textTerColor))
            self.tableView.footerHidden(model.total <= self.dataSource.count)
        } failureBlock: { _ in
        }
    }
}
extension LMPkHistoryView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType:LMPkHistoryCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(dataSource[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        kScaleWidth(60)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension LMPkHistoryView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        self.view
    }
}
