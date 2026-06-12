import UIKit
class PlaOrViewController: LMBaseVC {
    var usInfoItem: UsInfoItem = UsInfoItem()
    var skillItem: SkillItem = SkillItem()
    var orderNum = 1
    var orderPrice = 0
    lazy var userInfoView: UIView = {
        let view = UIView().backgroundColor(.white).cornerRadius(12)
        return view
    }()
    lazy var headerView: UIImageView = {
        let imageV = UIImageView().cornerRadius(kScaleWidth(36))
        return imageV
    }()
    lazy var userName: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
        return lb
    }()
    lazy var userTagView: UserTagView = {
        let view = UserTagView()
        return view
    }()
    lazy var signlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textSecondColor)
        return lb
    }()
    lazy var skillInfoView: UIView = {
        let view = UIView().backgroundColor(.clear)
        return view
    }()
    lazy var skillNameView: PlaceOrderItemView = {
        let view = PlaceOrderItemView(type: .lb, title: "类型")
        return view
    }()
    lazy var skillLevelView: PlaceOrderItemView = {
        let view = PlaceOrderItemView(type: .lb, title: "等级")
        return view
    }()
    lazy var skillNumView: PlaceOrderItemView = {
        let view = PlaceOrderItemView(type: .num, title: "数量") {[weak self] Int in
            guard let price = self?.skillItem.skillPrice else { return }
            let string = String(price * Int)
            self?.skillnPriceView.setDataSoure(subtitle: "\(string)钻石")
            self?.orderPrice = price * Int
            self?.orderNum = Int
        }
        return view
    }()
    lazy var skillPriceView: PlaceOrderItemView = {
        let view = PlaceOrderItemView(type: .lb, title: "单价")
        return view
    }()
    lazy var skillnPriceView: PlaceOrderItemView = {
        let view = PlaceOrderItemView(type: .lb, title: "总价")
        return view
    }()
    lazy var SkillUserName: PlaceOrderItemView = {
        let view = PlaceOrderItemView(type: .textFiled, title: "昵称")
        return view
    }()
    lazy var nextbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .whitePrimary, target: self, action: #selector(a_next))
        btn.backgroundImage(UIImage(named: "order_pay"))
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        set_Subviews()
        setDataSoure()
    }
    private func set_Subviews() {
        title = "下单"
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#F5F6FA")
        view.addSubview(userInfoView)
        userInfoView.addSubview(userName)
        userInfoView.addSubview(headerView)
        userInfoView.addSubview(userTagView)
        userInfoView.addSubview(signlb)
        view.addSubview(skillInfoView)
        skillInfoView.addSubview(skillNameView)
        skillInfoView.addSubview(skillLevelView)
        skillInfoView.addSubview(skillNumView)
        skillInfoView.addSubview(skillPriceView)
        skillInfoView.addSubview(skillnPriceView)
        skillInfoView.addSubview(SkillUserName)
        view.addSubview(nextbtn)
        userInfoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(16) + kNavigationHeight)
            make.height.equalTo(kScaleWidth(104))
        }
        headerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(72), height: kScaleWidth(72)))
        }
        userName.snp.makeConstraints { make in
            make.left.equalTo(headerView.snp.right).offset(kScaleWidth(12))
            make.top.equalToSuperview().offset(kScaleWidth(18))
            make.height.equalTo(kScaleWidth(24))
        }
        userTagView.snp.makeConstraints { make in
            make.left.equalTo(userName)
            make.top.equalToSuperview().offset(kScaleWidth(44))
            make.size.equalTo(CGSize(width: kScreenWidth, height: kScaleWidth(20)))
        }
        signlb.snp.makeConstraints { make in
            make.left.equalTo(userName)
            make.right.equalToSuperview().offset(-kScaleWidth(24))
            make.top.equalToSuperview().offset(kScaleWidth(66))
            make.height.equalTo(kScaleWidth(20))
        }
        skillInfoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(0))
            make.top.equalTo(userInfoView.snp.bottom).offset(kScaleWidth(40))
            make.height.equalTo(kScaleWidth(288))
        }
        skillNameView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(48))
        }
        skillLevelView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalTo(skillNameView.snp.bottom)
            make.height.equalTo(kScaleWidth(48))
        }
        skillNumView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalTo(skillLevelView.snp.bottom)
            make.height.equalTo(kScaleWidth(48))
        }
        skillPriceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalTo(skillNumView.snp.bottom)
            make.height.equalTo(kScaleWidth(48))
        }
        skillnPriceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalTo(skillPriceView.snp.bottom)
            make.height.equalTo(kScaleWidth(48))
        }
        SkillUserName.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalTo(skillnPriceView.snp.bottom)
            make.height.equalTo(kScaleWidth(48))
        }
        nextbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(56))
            make.width.equalTo(kScreenWidth - kScaleWidth(21))
            make.bottom.equalToSuperview().offset(-(kTabBarHeight + 40))
        }
        self.view.addGestureTap {[weak self] _ in
            self?.SkillUserName.textfield.resignFirstResponder()
        }
    }
    func setDataSoure() {
        headerView.set_Image(url: usInfoItem.avatar)
        userName.lmtext(usInfoItem.nickname)
        userTagView.setDataSoure(LMUserTagV(sex: usInfoItem.gender, age: usInfoItem.age, richLeve: usInfoItem.richLevel, charmLevel: usInfoItem.charmLevel), maxWidth: kScreenWidth)
        signlb.lmtext(usInfoItem.signature)
        skillNameView.setDataSoure(subtitle: skillItem.skillName)
        skillLevelView.setDataSoure(subtitle: skillItem.skillLevel)
        skillNumView.setDataSoure(subtitle: "1")
        skillPriceView.setDataSoure(subtitle: "\(skillItem.skillPrice.toString())钻石")
        skillnPriceView.setDataSoure(subtitle: "\(skillItem.skillPrice.toString())钻石")
        orderPrice = skillItem.skillPrice * 1
    }
    @objc func a_next() {
        HUD.showLoading()
        OrderApi.create(targetUserId: usInfoItem.userId, bizId: skillItem.skillId, num: orderNum, totalPrice: orderPrice).lmrequest {[weak self] _ in
            HUD.showSuccess("下单成功")
            self?.navigationController?.pushViewController(OrderPageViewController(), animated: true)
        } failureBlock: { _ in
            HUD.showSuccess("下单成功")
            self.navigationController?.pushViewController(OrderPageViewController(), animated: true)
        }
    }
}
