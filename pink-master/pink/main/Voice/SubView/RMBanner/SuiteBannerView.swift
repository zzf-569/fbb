import UIKit
class SuiteBannerView: UIView {
    private lazy var bannerView: SDCycleScrollView = {
        let banner = SDCycleScrollView(frame: CGRect.zero, delegate: self, placeholderImage: nil)
            .backgroundColor(.clear)
            .cornerRadius(12.0)
        banner.bannerImageViewContentMode = .scaleAspectFit
        banner.showPageControl = false
        return banner
    }()
    private lazy var pageController: LMPageController = {
        let page = LMPageController(normalPointSize: CGSize(width: 8.0, height: 2.0), currentPointSize: CGSize(width: 8.0, height: 2.0), pointSpacing: 2.0, normalPointColor: lmColorHex("#FFFFFF", alpha: 0.24), currentPointColor: lmColorHex("#FFFFFFE0"))
        return page
    }()
    private var bannerList: [BannerItem] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(bannerView)
        addSubview(pageController)
        bannerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6.0)
        }
        pageController.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(2.0)
        }
    }
    func reConfigUI() {
        self.setDataSoure([])
    }
    func setDataSoure(_ list: [BannerItem]) {
        self.bannerList = list
        let images = list.map { $0.icon }
        bannerView.imageURLStringsGroup = images
        bannerView.isHidden = list.count > 0 ? false : true
        pageController.currentPage = 0
        pageController.numberOfPages = images.count
        pageController.isHidden = list.count > 1 ? false : true
    }
}
extension SuiteBannerView: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        let baner = bannerList[index]
        Mediator.shared.dispatch(event: LMRMViewMethon.bannerDidClickItem, data: baner)
    }
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        self.pageController.currentPage = index
    }
}
