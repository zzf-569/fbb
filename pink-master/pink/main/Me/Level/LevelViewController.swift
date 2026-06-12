import UIKit
class LevelViewController: LMBaseVC {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: kNavigationHeight, width: kScreenWidth, height: kScreenHeight - kNavigationHeight - kTabBarSafeHeight))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    lazy var headerView: LevelHeaderView = {
        let view = LevelHeaderView()
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        titleColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setDataSoure()
    }
    private func setViewSnp() {
        let btn = UIButton(image: UIImage(named: "cm_back_white"), target: self, action: #selector(backItemDidiClick))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        title = "我的等级"
        backgroundImage = UIImage(named: "me_le_bg")
        view.addSubview(scrollView)
        scrollView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.size.equalTo(CGSize(width: kScreenWidth, height: kScaleWidth(238)))
        }
        let lineView = UIView().backgroundColor(lmColorHex("#48FFF6FF"))
        scrollView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalTo(headerView.snp.bottom)
            make.size.equalTo(CGSize(width: 4, height: 16))
        }
        let tipslb = UILabel(lmfont: lmFontASHTB(16), textColor: .white).lmtext("等级勋章")
        scrollView.addSubview(tipslb)
        tipslb.snp.makeConstraints { make in
            make.left.equalTo(lineView.snp.right).offset(kScaleWidth(8))
            make.centerY.equalTo(lineView.snp.centerY)
            make.size.equalTo(CGSize(width: kScreenWidth, height: 21))
        }
        let textlb = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#FFFFFF8F"))
            .lmtext("等级将实时关联专属身份勋章，勋章外观设计随等级提升动态升级。高等级勋章搭载专属动态流光特效，彰显您的尊享身份。\n用户达到21级后自动激活直播间入场特效，系统将根据实时等级智能匹配特效规格。高等级用户特效停留时长最高延长300%（对比基础特效）")
            .numberOfLines(0)
        scrollView.addSubview(textlb)
        textlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.width.equalTo(kScreenWidth - kScaleWidth(40))
            make.top.equalTo(lineView.snp.bottom).offset(15)
        }
        let lineViewT = UIView().backgroundColor(lmColorHex("#48FFF6FF"))
        scrollView.addSubview(lineViewT)
        lineViewT.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalTo(textlb.snp.bottom).offset(kScaleWidth(32))
            make.size.equalTo(CGSize(width: 4, height: 16))
        }
        let tipslbT = UILabel(lmfont: lmFontASHTB(16), textColor: .white).lmtext("成长值说明")
        scrollView.addSubview(tipslbT)
        tipslbT.snp.makeConstraints { make in
            make.left.equalTo(lineViewT.snp.right).offset(kScaleWidth(8))
            make.centerY.equalTo(lineViewT.snp.centerY)
            make.size.equalTo(CGSize(width: kScreenWidth, height: 21))
        }
        let textlbT = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#FFFFFF8F"))
            .lmtext("您可以通过赠送虚拟礼物及道具所产生的消费行为，将按1钻石=1成长值兑换。当累计经验值突破当前等级阈值时，系统将自动晋升用户等级，并即时解锁对应权益。\n单日通过消费获取经验值设动态封顶机制：\n• 基础经验池：500,000 成长值/日\n• 超额规则：超出上限部分不计入等级成长体系\n• 重置周期：每日00:00系统自动重置累积进度")
            .numberOfLines(0)
        scrollView.addSubview(textlbT)
        textlbT.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(kScaleWidth(20))
            make.width.equalTo(kScreenWidth - kScaleWidth(40))
            make.top.equalTo(lineViewT.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    func setDataSoure() {
        UserNetWork.UserLevel().lmrequest {[weak self] responseModel in
            guard let model = LevelItem.deserialize(from: responseModel.data as? [String: Any]) else { return }
            self?.headerView.dataSoure = model
        } failureBlock: { _ in
        }
    }
    @objc func backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
