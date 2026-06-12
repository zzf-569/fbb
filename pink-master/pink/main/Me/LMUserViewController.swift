import UIKit
class LMUserViewController: UIViewController, JXSegmentedViewDelegate, JXPagingViewDelegate {
    var user: UsInfoItem = UsInfoItem() {
        
        didSet {
            if user.avatar.isEmpty {
                bgImage.image = UIImage(named: "user_" + (user.birthday.chineseZodiac() ?? "龙"))
            }else {
                bgImage.set_Image(url: user.avatar)
            }
        }
    }
    var userId: String
    let pageView = UserPageInfoView()
    let giftView = LMPageOrderView()
    var istabbar: Bool = false
    lazy var bgImage: UIImageView = {
        let bgImage = UIImageView()
        bgImage.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth)
        return bgImage
    }()
    lazy var headImage: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.cornerRadius(12)
        imageV.isHidden = true
        return imageV
    }()
    lazy var headView: LMUserHeaderView = {
        let view = LMUserHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScaleWidth(128)))
        view.offsetcompate = {[weak self]top in
            self?.pagingView.mainTableView.setContentOffset(CGPoint(x: 0, y: top == true ? kNavigationHeight + kScaleWidth(1-6) : 0), animated: true)
        }
        return view
    }()
    lazy var topView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScaleWidth(128)))
        view.backgroundColor = .clear
        view.addSubview(headView)
        view.addSubview(segmentedView)
        return view
    }()
    lazy var backbtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "user_back"), for: .normal)
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()
    lazy var morebtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "user_more"), for: .normal)
        btn.addTarget(self, action: #selector(more), for: .touchUpInside)
        return btn
    }()
    lazy var settingbtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "user_set"), for: .normal)
        btn.addTarget(self, action: #selector(set_show), for: .touchUpInside)
        return btn
    }()
    lazy var pagingView = JXPagingView(delegate: self)
    lazy var segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: kScaleWidth(128), width: kScreenWidth, height: kScaleWidth(48)))
    let dataSource = LMLocalizedSegmentedTitleDataSource()
    required init(user: UsInfoItem, istabbar: Bool = false) {
        self.user = user
        self.userId = user.userId
        self.istabbar = istabbar
        super.init(nibName: nil, bundle: nil)
    }
    required init(userId: String, istabbar: Bool = false) {
        self.userId = userId
        self.istabbar = istabbar
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        getData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
    func setViewSnp() {
        view.backgroundColor = .white
        view.addSubview(bgImage)
        view.addSubview(headImage)
        headImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(45))
            make.top.equalToSuperview().offset(kScaleWidth(128))
            make.size.equalTo(CGSize(width: kScaleWidth(300), height: kScaleWidth(400)))
        }
        dataSource.titleNormalFont = lmFontR(16)
        dataSource.titleSelectedFont = lmFontM(16)
        dataSource.titleNormalColor = .textDefaulColor
        dataSource.titleSelectedColor = .textDefaulColor
        dataSource.itemSpacing = kScaleWidth(18)
        dataSource.titles = ["关于TA", "开黑陪玩"]
        dataSource.isItemSpacingAverageEnabled = false
        segmentedView.backgroundColor = lmColorHex("#F3F3F5FF")
        segmentedView.dataSource = dataSource
        segmentedView.listContainer = pagingView.listContainerView
        segmentedView.delegate = self
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 12
        indicator.indicatorHeight = 3
        indicator.indicatorColor = lmColorHex("#FF4F7DFF")
        indicator.verticalOffset = 10.0
        segmentedView.indicators = [indicator]
        pagingView.backgroundColor(.clear)
        pagingView.mainTableView.backgroundColor(.clear)
        pagingView.listContainerView.backgroundColor(lmColorHex("#F3F3F5FF"))
        pagingView.listContainerView.listCellBackgroundColor = lmColorHex("#F3F3F5FF")
        pagingView.isListHorizontalScrollEnabled = false
        pagingView.listContainerView.isCategoryNestPagingEnabled = true
        view.addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight)
            make.bottom.equalToSuperview().offset(self.istabbar ? -(kTabBarHeight + kTabBarSafeHeight) : 0)
        }
        view.addSubview(backbtn)
        view.addSubview(morebtn)
        backbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(kNavigationBarHeight + 4)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        morebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(kNavigationBarHeight + 4)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        view.addSubview(settingbtn)
        settingbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(kNavigationBarHeight + 4)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        if userId == UserShared.user?.userId {
            settingbtn.isHidden = false
        } else {
            settingbtn.isHidden = true
        }
    }
    func getData() {
        UserNetWork.Info(userId: userId).lmrequest {[weak self] responseModel in
            guard let self = self else { return }
            guard let model = UsInfoItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self.user = model
            self.setDataSoure()
            self.headView.user = user
            self.pageView.setDataSoure(user)
        } failureBlock: { _ in
        }
        UserNetWork.relationInfo().lmrequest {[weak self] responseModel in
            guard let model = relationModel.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self?.pageView.set_set_relation(model)
        } failureBlock: { _ in
        }
    }
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func more() {
        let items: [LMSheetTabModel] = [
            LMSheetTabModel(title: "举报"),
            LMSheetTabModel(title: "拉黑")
        ]
        LMSheetTableVC(title: nil, dataSource: items, cancel: "取消") { item in
            guard let item = item else { return }
            if item.title == "举报" {
                self.navigationController?.pushViewController(ReportViewController(reportType: .user, UsInfoItem: self.user), animated: true)
            }
            if item.title == "拉黑" {
                HUD.showLoading()
                UserNetWork.block(toUserId: self.user.userId, block: true).lmrequest { _ in
                    HUD.showSuccess("拉黑成功")
                } failureBlock: { error in
                    HUD.showFailure(error.message)
                }
            }
        }.show()
    }
    @objc func set_show() {
        LMUserMenuViewController.show()
    }
    func setDataSoure() {
        headImage.set_Image(url: user.avatar)
        if user.photoWall.count > 0 {
            headImage.set_Image(url: user.photoWall.first?.url)
        } else {
            headImage.set_Image(url: user.avatar)
        }
        if userId == UserShared.user?.userId {
            backbtn.isHidden = true
            morebtn.isHidden = true
        } else {
            backbtn.isHidden = false
            morebtn.isHidden = false
        }
    }
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return Int(kScaleWidth(216))
    }
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        UIView()
    }
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        self.topView
    }
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        Int(kScaleWidth(128 + 48))
    }
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        dataSource.titles.count
    }
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if index == 0 {
            pageView.setDataSoure(user)
            return pageView
        }
        giftView.dataSoure = user
        return giftView
    }
}
extension LMUserViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        self.view
    }
}
