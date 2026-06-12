class LMPageController: UIView {
    public var numberOfPages: Int = 0 {
        didSet {
            set_UISubViews()
        }
    }
    public var currentPage: Int = 0 {
        willSet {
            currentPageChange(oldPage: currentPage, newPage: newValue)
        }
    }
    private let normalPointSize: CGSize
    private let currentPointSize: CGSize
    private let pointSpacing: Double
    private let normalPointColor: UIColor
    private let currentPointColor: UIColor
    private lazy var contentView: UIView = {
        let view = UIView().backgroundColor(.clear)
        return view
    }()
    init(numberOfPages: Int = 0, currentPage: Int = 0, normalPointSize: CGSize = CGSize(width: 6.0, height: 6.0), currentPointSize: CGSize = CGSize(width: 12.0, height: 6.0), pointSpacing: Double = 6.0, normalPointColor: UIColor = lmColorHex("#FFFFFF", alpha: 0.2), currentPointColor: UIColor = lmColorHex("#FFFFFF"), frame: CGRect = CGRect.zero) {
        self.numberOfPages = numberOfPages
        self.currentPage = currentPage
        self.normalPointSize = normalPointSize
        self.currentPointSize = currentPointSize
        self.pointSpacing = pointSpacing
        self.normalPointColor = normalPointColor
        self.currentPointColor = currentPointColor
        super.init(frame: frame)
        set_UISubViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMPageController {
    private func set_UISubViews() {
        self.contentView.removeAllSubViews()
        self.removeAllSubViews()
        let totalWidth = getTotalWidth()
        self.addSubview(self.contentView)
        self.contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(totalWidth)
            make.height.equalToSuperview()
        }
        var tempPoint: UIView?
        for page in 0..<self.numberOfPages {
            let point = UIView().cornerRadius(self.normalPointSize.height/2)
            point.tag = page
            self.contentView.addSubview(point)
            if self.currentPage == page {
                point.backgroundColor(self.currentPointColor)
                point.snp.makeConstraints { make in
                    if let tempPoint = tempPoint {
                        make.left.equalTo(tempPoint.snp.right).offset(self.pointSpacing)
                    } else {
                        make.left.equalToSuperview()
                    }
                    make.centerY.equalToSuperview()
                    make.size.equalTo(self.currentPointSize)
                }
            } else {
                point.backgroundColor(self.normalPointColor)
                point.snp.makeConstraints { make in
                    if let tempPoint = tempPoint {
                        make.left.equalTo(tempPoint.snp.right).offset(self.pointSpacing)
                    } else {
                        make.left.equalToSuperview()
                    }
                    make.centerY.equalToSuperview()
                    make.size.equalTo(self.normalPointSize)
                }
            }
            tempPoint = point
        }
    }
    private func currentPageChange(oldPage: Int, newPage: Int) {
        guard oldPage != newPage else {
            return
        }
        var oldView: UIView?
        var newView: UIView?
        for view in self.contentView.subviews {
            if view.tag == oldPage {
                oldView = view
            }
            if view.tag == newPage {
                newView = view
            }
        }
        if let oldView = oldView, let newView = newView {
            oldView.backgroundColor(self.normalPointColor)
            newView.backgroundColor(self.currentPointColor)
            UIView.animate(withDuration: 0.3) {
                oldView.snp.updateConstraints { make in
                    make.size.equalTo(self.normalPointSize)
                }
                newView.snp.updateConstraints { make in
                    make.size.equalTo(self.currentPointSize)
                }
                self.contentView.layoutIfNeeded()
            }
        }
        if let oldView = oldView, newView == nil {
            oldView.backgroundColor(self.normalPointColor)
            UIView.animate(withDuration: 0.3) {
                oldView.snp.updateConstraints { make in
                    make.size.equalTo(self.normalPointSize)
                }
                self.contentView.layoutIfNeeded()
            }
        }
        if oldView == nil, let newView = newView {
            newView.backgroundColor(self.currentPointColor)
            UIView.animate(withDuration: 0.3) {
                newView.snp.updateConstraints { make in
                    make.size.equalTo(self.currentPointSize)
                }
                self.contentView.layoutIfNeeded()
            }
        }
    }
    func getTotalWidth() -> Double {
        var totalWidth = 0.0
        for page in 0..<self.numberOfPages {
            if self.currentPage == page {
                totalWidth += self.currentPointSize.width
            } else {
                totalWidth += self.normalPointSize.width
            }
            if page < self.numberOfPages - 1 {
                totalWidth += self.pointSpacing
            }
        }
        return totalWidth
    }
}
