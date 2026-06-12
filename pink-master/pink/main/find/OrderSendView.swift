import UIKit
extension OrderSendView {
    func show(_ vc: UIViewController? = nil) {
        if let viewController = vc {
            viewController.addChild(self)
            viewController.view.addSubview(self.view)
        } else {
            UIViewController.current?.addChild(self)
            UIViewController.current?.view.addSubview(self.view)
        }
        self.view.frame = UIScreen.main.bounds
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.clear()
        }
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
class OrderSendView: UIViewController {
    private var skillList: [SkillCommonModel] = []
    private var SkillItem: SkillCommonModel?
    private var price: Int?
    private var level: String?
    private var nprice: Int?
    private var orderNum = 1
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor(lmColorHex("#000000",alpha: 0.5))
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var bdView: UIView = {
        let view = UIView()
        view.backgroundColor(.white)
        view.addGestureTap {[weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
        }
        return view
    }()
    lazy var skillInfoView: UIView = {
        let view = UIView().backgroundColor(.clear)
        return view
    }()
    lazy var skillNameView: PlaceOrderItemView = {
        let view = PlaceOrderItemView(type: .lb, title: "类型")
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            selectedSkillAction()
        }
        view.subtitleLab.text = "请选择"
        return view
    }()
    lazy var skillLevelView: PlaceOrderItemView = {
        let view = PlaceOrderItemView(type: .lb, title: "等级")
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            selectedLevelAction()
        }
        view.subtitleLab.text = "请选择"
        return view
    }()
    lazy var skillNumView: PlaceOrderItemView = {
        let view = PlaceOrderItemView(type: .num, title: "数量") {[weak self] Int in
            let string = String((self?.price ?? 0) * Int)
            self?.skillnPriceView.setDataSoure(subtitle: "\(string)钻石")
            self?.orderNum = Int
            self?.nprice = (self?.price ?? 0) * Int
        }
        view.setDataSoure(subtitle: "1")
        return view
    }()
    lazy var skillPriceView: PlaceOrderItemView = {
        let view = PlaceOrderItemView(type: .lb, title: "单价")
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            selectedPriceAction()
        }
        view.subtitleLab.text = "请选择"
        return view
    }()
    lazy var skillnPriceView: PlaceOrderItemView = {
        let view = PlaceOrderItemView(type: .lb, title: "总价")
        return view
    }()
    lazy var SkillUserName: PlaceOrderItemView = {
        let view = PlaceOrderItemView(type: .textFiled, title: "备注")
        view.textfield.font(lmFontR(14))
        view.textfield.placeholder("请输入备注")
        view.textfield.delegate = self
        return view
    }()
    lazy var sendbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(16), titleColor: .textDefaulColor, target: self, action: #selector(sendOrder))
        btn.backgroundColor(lmColorHex("#FFEC3B"))
        btn.lmtitle("发布")
        btn.cornerRadius(24)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardNotification()
        set_Subviews()
        setDataSoure()
    }
    private func set_Subviews() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(skillInfoView)
        skillInfoView.addSubview(skillNameView)
        skillInfoView.addSubview(skillLevelView)
        skillInfoView.addSubview(skillNumView)
        skillInfoView.addSubview(skillPriceView)
        skillInfoView.addSubview(skillnPriceView)
        skillInfoView.addSubview(SkillUserName)
        bdView.addSubview(sendbtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(0)
            make.height.equalTo(kScaleWidth(450))
        }
        skillInfoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(0))
            make.top.equalToSuperview().offset(kScaleWidth(40))
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
        sendbtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalTo(SkillUserName.snp.bottom).offset(12)
            make.height.equalTo(kScaleWidth(48))
        }
        view.layoutIfNeeded()
        bdView.set_Border(radius: 12, conrners: [.topLeft, .topRight])
    }
    func setDataSoure(){
        CommonNetWork.skillList().lmrequest { responseModel in
            guard let list = [SkillCommonModel].deserialize(from: responseModel.data as? [Any]) else { return }
            self.skillList = list
        } failureBlock: { _ in
        }
    }
    @objc func sendOrder() {
        guard let SkillItem = self.SkillItem else {
            HUD.show("请选择技能")
            return
        }
        guard let price = self.price else {
            HUD.show("请选择价格")
            return
        }
        OrderApi.sendCreate(bizId: SkillItem.skillId, remark: self.SkillUserName.textfield.text ?? "", level: self.level ?? "" ,num: orderNum, price: price, totalPrice: self.nprice ?? 0).lmrequest { responseModel in
            HUD.show("发布成功")
            self.hide()
        } failureBlock: { error in
            HUD.show(error.message)
        }
    }
    @objc func selectedSkillAction() {
        let items = self.skillList.map { model -> PickerListModel in
            return PickerListModel(title: model.skillName, value: model)
        }
        let picker = LMPickerVC(theme: .light, title: "请选择游戏", dataSource: items, cancel: "取消", confirm: "确定") { [weak self] item in
            guard let self = self else { return }
            guard let item = item else { return }
            guard let model = item.value as? SkillCommonModel else { return }
            self.SkillItem = model
            self.skillNameView.subtitleLab.text = model.skillName
        }
        picker.show()
    }
    @objc func selectedLevelAction() {
        let items = self.SkillItem?.skillLevel.map{ price in
            return PickerListModel(title: price, value: price)
        }
        guard let items = items else {
            HUD.show("请选择技能")
            return
        }
        let picker = LMPickerVC(theme: .light, title: "等级", dataSource: items, cancel: "取消", confirm: "确定") { [weak self] item in
            guard let self = self else { return }
            guard let item = item else { return }
            guard let model = item.value as? String else { return }
            self.skillLevelView.subtitleLab.text = model
            self.level = model
        }
        picker.show()
    }
    @objc func selectedPriceAction() {
        let items = self.SkillItem?.skillPrice.map{ price in
            return PickerListModel(title: price.toString(), value: price.toString())
        }
        guard let items = items else {
            HUD.show("请选择技能")
            return
        }
        let picker = LMPickerVC(theme: .light, title: "单价", dataSource: items, cancel: "取消", confirm: "确定") { [weak self] item in
            guard let self = self else { return }
            guard let item = item else { return }
            guard let model = item.value as? String else { return }
            self.skillPriceView.subtitleLab.text = "\(model)钻石"
            self.price = model.toInt()
            self.nprice = (model.toInt() ?? 0) * self.orderNum
            self.skillnPriceView.subtitleLab.text = "\(self.nprice?.toString() ?? "0")钻石"
        }
        picker.show()
    }
}
extension OrderSendView: UITextFieldDelegate {
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
            UIView.animate(withDuration: duration) {
                self.bdView.snp.updateConstraints { make in
                    make.top.equalTo(self.view.snp.bottom).offset(-(self.bdView.height + keyboardSize.height))
                }
                self.bdView.superview?.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
        UIView.animate(withDuration: duration) {
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
}
