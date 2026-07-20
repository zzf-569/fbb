import UIKit
class LMBaseVC: UIViewController {
    lazy var navtitleV: CustomtitleV = {
        let view = CustomtitleV()
            .backgroundColor(.clear)
        return view
    }()
    var backgroundImage: UIImage? {
        didSet {
            if backgroundImage != nil{
                backgroundimv.image = backgroundImage
            }
        }
    }
    private lazy var backgroundimv: UIImageView = {
        let imv = UIImageView()
            .backgroundColor(.clear)
            .contentMode(.scaleAspectFill)
        imv.clipsToBounds = true
        self.view.addSubview(imv)
        imv.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(330))
        }
        return imv
    }()
    override var title: String? {
        didSet {
            self.navigationItem.title = title?.localized
        }
    }
    var titleColor: UIColor? {
        didSet {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: titleColor  ?? UIColor.black, NSAttributedString.Key.font: lmFontM(18)]
            if #available(iOS 13, *) {
                let scrollEdgeAppearance = self.navigationController?.navigationBar.scrollEdgeAppearance
                scrollEdgeAppearance?.titleTextAttributes = titleTextAttributes
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        set_NavigationBar()
        setViewSnp()
        view.backgroundColor(.white)
        backgroundImage = UIImage(named: "base_bg")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        titleColor = .black
    }
    private func set_NavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        set_NavigationBackgroundColor(UIColor.clear)
    }
    private func setViewSnp() {
        
    }
    func configViewData() {
    }
    func reloadViewData() {
        configViewData()
    }
    func set_NavigationBackgroundColor(_ color: UIColor) {
        self.navigationController?.navigationBar.barTintColor = color
    }
    deinit {
        lmPrint("UIViewController deinit：----------------\(Self.className)已被销毁")
    }
}
class CustomtitleV: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setViewSnp() {
    }
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}
extension JXPagingListContainerView: @retroactive JXSegmentedViewListContainer {}

extension SearchPartyResultView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
