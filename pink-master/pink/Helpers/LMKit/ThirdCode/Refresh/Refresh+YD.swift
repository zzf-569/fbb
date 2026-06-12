import UIKit
import MJRefresh
extension   UIScrollView {
    @discardableResult
    func addHeader(_ action: @escaping () -> Void) -> MJRefreshNormalHeader {
        let header = MJRefreshNormalHeader(refreshingBlock: action)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
         self.mj_header = header
        return header
    }
    @discardableResult
    func addFooter(_ action: @escaping () -> Void) -> MJRefreshAutoNormalFooter {
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: action)
         self.mj_footer = footer
        return footer
    }
    func headerBeginRefreshing() {
         self.mj_header?.beginRefreshing()
    }
    func endRefreshing() {
         self.mj_header?.endRefreshing()
         self.mj_footer?.endRefreshing()
    }
    func footerHidden(_ isHidden: Bool) {
         self.mj_footer?.isHidden = isHidden
    }
    func noMoreData() {
        footerHidden(false)
         self.mj_footer?.endRefreshingWithNoMoreData()
    }
}
