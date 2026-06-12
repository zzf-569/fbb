import UIKit
protocol RoomEmojiViewDelegate: NSObjectProtocol {
    func dg_sendFace(_ model: LMEmojiListModel)
}
extension RoomEmojiView {
    func setDataSoure(_ list: [LMEmojICateModel]) {
        self.dataSource = list
        let titles = list.map { $0.categoryName }
        self.segData.titles = titles
        self.segmentedView.reloadData()
    }
}
class RoomEmojiView: UIView {
    private var dataSource: [LMEmojICateModel] = []
    weak var delegate:RoomEmojiViewDelegate?
    let segmentedView = JXSegmentedView()
    private lazy var segData: JXSegmentedTitleDataSource = {
        let segData = LMLocalizedSegmentedTitleDataSource()
        segData.titleNormalFont = lmFontM(16)
        segData.titleNormalColor = lmColorHex("#FFFFFF66")
        segData.titleSelectedColor = lmColorHex("#FFFFFFE0")
        segData.itemSpacing = 16.0
        segData.isItemSpacingAverageEnabled = false
        return segData
    }()
    private lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    init(delegate:RoomEmojiViewDelegate) {
        self.delegate = delegate
        super.init(frame: CGRect.zero)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension RoomEmojiView {
    private func setViewSnp() {
        self.segmentedView.delegate = self
        self.segmentedView.contentEdgeInsetLeft = 0.0
        self.segmentedView.dataSource = segData
        self.segmentedView.listContainer = listContainerView
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 12.0
        indicator.indicatorHeight = 4.0
        indicator.indicatorColor = lmColorHex("#FFFFFFE0")
        indicator.verticalOffset = 12.0
        segmentedView.indicators = [indicator]
        addSubview(self.segmentedView)
        addSubview(self.listContainerView)
        self.segmentedView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalToSuperview()
            make.height.equalTo(56.0)
        }
        self.listContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.segmentedView.snp.bottom).offset(8.0)
            make.bottom.equalToSuperview()
        }
    }
}
extension RoomEmojiView: JXSegmentedViewDelegate {
}
extension RoomEmojiView: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = self.segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let model = dataSource[index]
        return LMRMEmojiListView(frame: CGRect(x: 0, y: 0, width: self.width, height: 176.0 + 14.0 + kTabBarSafeHeight), dataSource: model.emojiList, delegate: self)
    }
}
extension RoomEmojiView:LMRMEmojiListViewDelegate {
    func dg_sendFace(_ model: LMEmojiListModel) {
        self.delegate?.dg_sendFace(model)
    }
}
