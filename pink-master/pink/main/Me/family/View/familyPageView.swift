import UIKit
import JXPagingView
import JXSegmentedView
class familyPageView: UIView {
    lazy var pagingView = JXSegmentedListContainerView(dataSource: self)
    lazy var segmentedView = JXSegmentedView()
    let dataSource = LMLocalizedSegmentedTitleDataSource()
    var dataSoure: GuildItem = GuildItem()
    var type: Int = 0
    lazy var typebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(12), titleColor: lmColorHex("#2B313D"), target: self, action: #selector(clickType)).image(UIImage(named: "fam_arrow_down")).backgroundColor(lmColorHex("#2B313D0A"))
        btn.lmtitle("今日")
        return btn
    }()
    lazy var statesbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .whitePrimary, target: self, action: #selector(joinClick))
            .image(UIImage(named: "fam_apply_icon"))
        btn.lmtitle("加入公会")
        btn.cornerRadius(kScaleWidth(12))
        btn.backgroundColor = lmColorHex("#FF4F7DFF")
        return btn
    }()
    lazy var rolebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "fam_role"), target: self, action: #selector(RoleAction))
            .lmtitle("管理员")
            .font(lmFontF(12))
            .titleColor(lmColorHex("#2B313D8F"))
            .frame(CGRect(x: 0, y: 0, width: kScaleWidth(106), height: kScaleWidth(48)))
        btn.set_ImageTitleLayout(.imgTop, spacing: 2)
        return btn
    }()
    lazy var notibtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "fam_noti"), target: self, action: #selector(notiAction))
            .lmtitle("通知")
            .font(lmFontF(12))
            .titleColor(lmColorHex("#2B313D8F"))
            .frame(CGRect(x: 0, y: 0, width: kScaleWidth(106), height: kScaleWidth(48)))
        btn.set_ImageTitleLayout(.imgTop, spacing: 2)
        return btn
    }()
    lazy var exitbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "fam_quick"), target: self, action: #selector(extAction))
            .lmtitle("退出")
            .font(lmFontF(12))
            .titleColor(lmColorHex("#2B313D8F"))
            .frame(CGRect(x: 0, y: 0, width: kScaleWidth(106), height: kScaleWidth(48)))
        btn.set_ImageTitleLayout(.imgTop, spacing: 2)
        return btn
    }()
    init(model: GuildItem) {
        self.dataSoure = model
        super.init(frame: .zero)
        setViewSnp()
        setData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        backgroundColor(.white)
        segmentedView.delegate = self
        addSubview(statesbtn)
        statesbtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(20))
            make.size.equalTo(CGSize(width: kScaleWidth(350), height: kScaleWidth(56)))
        }
        addSubview(rolebtn)
        addSubview(notibtn)
        addSubview(exitbtn)
        rolebtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(20))
            make.size.equalTo(CGSize(width: kScaleWidth(106), height: kScaleWidth(48)))
        }
        notibtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(20))
            make.size.equalTo(CGSize(width: kScaleWidth(106), height: kScaleWidth(48)))
        }
        exitbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(20))
            make.size.equalTo(CGSize(width: kScaleWidth(106), height: kScaleWidth(48)))
        }
        addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(0))
            make.top.equalToSuperview().offset(kScaleWidth(92))
            make.right.equalToSuperview().offset(-kScaleWidth(150))
            make.height.equalTo(kScaleWidth(48))
        }
        addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom)
        }
        addSubview(typebtn)
        typebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.centerY.equalTo(segmentedView.snp.centerY)
            make.size.equalTo(CGSize(width: kScaleWidth(52), height: kScaleWidth(28)))
        }
        typebtn.set_ImageTitleLayout(.imgRight, spacing: 8)
        typebtn.set_Border(radius: 8, conrners: .allCorners)
    }
    func setData() {
        switch dataSoure.status {
        case 2:
            statesbtn.lmtitle("审核中")
            statesbtn.alpha = 0.5
            notibtn.isHidden = true
            rolebtn.isHidden = true
            exitbtn.isHidden = true
            statesbtn.isHidden = false
        case 0:
            statesbtn.lmtitle("申请加入")
            notibtn.isHidden = true
            rolebtn.isHidden = true
            exitbtn.isHidden = true
            statesbtn.isHidden = false
        default:
            if dataSoure.owner == true || dataSoure.admin == true {
                notibtn.isHidden = false
                rolebtn.isHidden = false
                exitbtn.isHidden = false
                statesbtn.isHidden = true
            } else {
                notibtn.isHidden = true
                rolebtn.isHidden = false
                exitbtn.isHidden = false
                statesbtn.isHidden = true
                rolebtn.snp.remakeConstraints { make in
                    make.left.equalToSuperview().offset(kScaleWidth(20))
                    make.top.equalToSuperview().offset(kScaleWidth(20))
                    make.size.equalTo(CGSize(width: kScaleWidth(106), height: kScaleWidth(48)))
                }
                exitbtn.snp.remakeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalToSuperview().offset(kScaleWidth(20))
                    make.size.equalTo(CGSize(width: kScaleWidth(106), height: kScaleWidth(48)))
                }
            }
            break
        }
        dataSource.titles = ["公会", "成员", "房间"]
        dataSource.titleNormalFont = lmFontR(16)
        dataSource.titleSelectedFont = lmFontR(16)
        dataSource.titleSelectedColor = lmColorHex("#2B313D")
        dataSource.titleNormalColor = lmColorHex("#2B313D3D")
        dataSource.itemSpacing = kScaleWidth(24)
        dataSource.isItemSpacingAverageEnabled = false
        segmentedView.dataSource = dataSource
        segmentedView.listContainer = pagingView
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 12.0
        indicator.indicatorHeight = 4.0
        indicator.indicatorColor = lmColorHex("#FF4F7DFF")
        indicator.verticalOffset = 5.0
        segmentedView.indicators = [indicator]
        pagingView.reloadData()
    }
    @objc func clickType() {
        let items = [
            PickerListModel(title: "今日", value: 0),
            PickerListModel(title: "本周", value: 1),
            PickerListModel(title: "上周", value: 2),
            PickerListModel(title: "本月", value: 3),
            PickerListModel(title: "上月", value: 4)
        ]
        let picker = LMPickerVC(theme: .light, title: "选择时间", dataSource: items, cancel: "取消", confirm: "确定") {[weak self] item in
            guard let item = item else { return }
            guard let type = item.value as? Int else { return }
            self?.type = type
            self?.pagingView.reloadData()
        }
        picker.show()
    }
    @objc func joinClick() {
        if dataSoure.status == 2 {
            HUD.show("申请中,请勿重复提交")
            return
        }
        GuildNetWork.joinFamile(familyId: dataSoure.familyId).lmrequest {[weak self] _ in
            HUD.showSuccess("申请成功")
            self?.statesbtn.lmtitle("审核中")
            self?.statesbtn.alpha = 0.5
            self?.dataSoure.status = 2
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func RoleAction() {
        UIViewController.current?.navigationController?.pushViewController(familyRoleViewController(model: dataSoure), animated: true)
    }
    @objc func notiAction() {
        UIViewController.current?.navigationController?.pushViewController(MyfamilyApplyViewController(familyId: dataSoure.familyId), animated: true)
    }
    @objc func extAction() {
        if dataSoure.owner == true {
            let alert = LMAlertBottomVC(theme: .light, title: "公会解散", message: "公会解散后，撤销对旗下主播的经营管理权限", cancel: "取消", confirm: "确定") {[weak self] string in
                guard let familyId = self?.dataSoure.familyId else { return }
                if string == "确定" {
                    HUD.showLoading()
                    GuildNetWork.quickFamile(familyId: familyId).lmrequest { _ in
                        HUD.showSuccess("申请成功,请等待审核")
                        UIViewController.current?.navigationController?.popViewController(animated: true)
                    } failureBlock: { error in
                        HUD.show(error.message)
                    }
                }
            }
            alert.show()
        } else {
            let alert = LMAlertBottomVC(theme: .light, title: "退出公会", message: "确定要退出公会吗？", cancel: "取消", confirm: "确定") {[weak self] string in
                guard let familyId = self?.dataSoure.familyId else { return }
                if string == "确定" {
                    HUD.showLoading()
                    GuildNetWork.quickFamile(familyId: familyId).lmrequest { _ in
                        HUD.showSuccess("申请成功,请等待审核")
                        UIViewController.current?.navigationController?.popViewController(animated: true)
                    } failureBlock: { error in
                        HUD.show(error.message)
                    }
                }
            }
            alert.show()
        }
    }
}
extension familyPageView: JXSegmentedListContainerViewDataSource, JXSegmentedViewDelegate {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        dataSource.titles.count
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> any JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            return familyInfoView(model: dataSoure)
        }
        if index == 2 {
            return familyRoomPageView(model: dataSoure, type: type)
        }
        return familyUserPageView(model: dataSoure, type: type)
    }
}
