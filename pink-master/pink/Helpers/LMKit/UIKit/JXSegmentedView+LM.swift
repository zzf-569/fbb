import UIKit
import JXSegmentedView

open class LMLocalizedSegmentedTitleDataSource: JXSegmentedTitleDataSource {
    open override func preferredRefreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let titleItemModel = itemModel as? JXSegmentedTitleItemModel,
              let title = titleItemModel.title else {
            return
        }

        let localizedTitle = title.localized
        titleItemModel.title = localizedTitle
        titleItemModel.textWidth = widthForTitle(localizedTitle, index)
    }
}

public extension JXSegmentedTitleDataSource {
    func lmSetTitles(_ titles: [String]) {
        self.titles = titles
    }
}
