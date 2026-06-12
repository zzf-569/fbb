import UIKit
import BRPickerView
class PerFectSexAgeViewController: LMBaseVC {
    private var selectString: String?
    private var xzString: String?
    var gender: UserGenderType? {
        didSet {
            if gender == UserGenderType.boy {
                boybtn.isSelected(true)
                girlbtn.isSelected(false)
                nextbtn.backgroundColor(lmColorHex("#FF4F7D", alpha: 1))
                nextbtn.isEnabled = true
            } else if gender == UserGenderType.girl {
                boybtn.isSelected(false)
                girlbtn.isSelected(true)
                nextbtn.backgroundColor(lmColorHex("#FF4F7D", alpha: 1))
                nextbtn.isEnabled = true
            } else {
                boybtn.isSelected(false)
                girlbtn.isSelected(false)
                nextbtn.backgroundColor(lmColorHex("#FF4F7D", alpha: 0.25))
                nextbtn.isEnabled = false
            }
        }
    }
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(28), textColor: .textDefaulColor)
            .lmtext("性别&生日")
            .textAlignment(.center)
        return lb
    }()
    lazy var boybtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "login_info_boy"), target: self, action: #selector(boybtnAction))
            .cornerRadius(12)
            .lmtitle("小哥哥")
            .font(lmFontM(12))
            .titleColor(lmColorHex("#2B313D"), .normal)
            .titleColor(lmColorHex("#FFFFFF"), .selected)
            .backgroundColor(lmColorHex("#2B313D0A"))
            .image(UIImage(named: "login_info_boy_s"), .selected)
        btn.set_ImageTitleLayout(.imgTop, spacing: 2)
        return btn
    }()
    lazy var girlbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "login_info_girl"), target: self, action: #selector(girlbtnAction))
            .cornerRadius(12)
            .lmtitle("小姐姐")
            .font(lmFontM(12))
            .titleColor(lmColorHex("#2B313D"), .normal)
            .titleColor(lmColorHex("#FFFFFF"), .selected)
            .backgroundColor(lmColorHex("#2B313D0A"))
            .image(UIImage(named: "login_info_girl_s"), .selected)
        btn.set_ImageTitleLayout(.imgTop, spacing: 2)
        return btn
    }()
    private lazy var pickerView: BRDatePickerView = {
        let style = BRPickerStyle()
        style.hiddenTitleBarView = true
        style.pickerTextColor = .textDefaulColor
        style.pickerTextFont = lmFontM(18)
        style.pickerColor = .clear
        style.separatorColor = .clear
        let pickerView = BRDatePickerView(pickerMode: .YMD)
        pickerView.backgroundColor(.clear)
        pickerView.pickerHeaderView = nil
        pickerView.pickerFooterView = nil
        pickerView.pickerStyle = style
        let currentDate = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = -18
        let date18YearsAgo = calendar.date(byAdding: dateComponents, to: currentDate)
        pickerView.maxDate = date18YearsAgo
        pickerView.selectDate = date18YearsAgo
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timer = (dateFormatter.string(from: date18YearsAgo ?? Date()))
        self.selectString = timer
        xzlb.lmtext("您好,\(selectString?.getConstellation() ?? "")")
        pickerView.changeRangeBlock = {[weak self] _, _, selectValue in
            self?.selectString = selectValue
            self?.xzString = selectValue?.getConstellation()
            self?.xzlb.lmtext("您好,\(selectValue?.getConstellation() ?? "")")
        }
        return pickerView
    }()
    lazy var xzlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(18), textColor: .textDefaulColor)
            .textAlignment(.center)
        return lb
    }()
    lazy var nextbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(18), titleColor: .white, target: self, action: #selector(nextAction))
            .isEnabled(false)
            .cornerRadius(12)
            .lmtitle("下一步")
        btn.backgroundColor(lmColorHex("#FF4F7D", alpha: 0.25))
        return btn
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        gender = .boy
    }
    private func setViewSnp() {
        backgroundImage = UIImage(named: "login_bg")
        let btn = UIButton(image: UIImage(named: "login_back"), target: self, action: #selector(backItemDidiClick))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        view.addSubview(titleLab)
        view.addSubview(boybtn)
        view.addSubview(girlbtn)
        view.addSubview(pickerView)
        view.addSubview(xzlb)
        view.addSubview(nextbtn)
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24 + kNavigationHeight)
            make.centerX.equalToSuperview()
        }
        boybtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(95))
            make.top.equalToSuperview().offset(100 + kNavigationHeight)
            make.size.equalTo(CGSize(width: kScaleWidth(88), height: kScaleWidth(88)))
        }
        girlbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(95))
            make.top.equalToSuperview().offset(100 + kNavigationHeight)
            make.size.equalTo(CGSize(width: kScaleWidth(88), height: kScaleWidth(88)))
        }
        let dataView = UIView().backgroundColor(.clear)
        view.addSubview(dataView)
        dataView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(228 + kNavigationHeight)
            make.height.equalTo(kScaleWidth(280))
        }
        pickerView.addPicker(to: dataView)
        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        xzlb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextbtn.snp.top).offset(kScaleWidth(-12))
        }
        nextbtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(56 + kTabBarSafeHeight))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(310), height: kScaleWidth(56)))
        }
        boybtn.backgroundColor(lmColorHex("#328BF9"))
        girlbtn.backgroundColor(lmColorHex("#2B313D0A"))
    }
    func setDataSoure() {
    }
    @objc func boybtnAction() {
        gender = .boy
        boybtn.backgroundColor(lmColorHex("#328BF9"))
        girlbtn.backgroundColor(lmColorHex("#2B313D0A"))
    }
    @objc func girlbtnAction() {
        boybtn.backgroundColor(lmColorHex("#2B313D0A"))
        girlbtn.backgroundColor(lmColorHex("#FF4F7D"))
        gender = .girl
    }
    @objc func nextAction() {
        guard let gender = gender else { HUD.showFailure("忘记选择性别啦～"); return }
        HUD.showLoading()
        UserNetWork.updateUserInfo(gender: gender.rawValue, birthday: selectString).lmrequest {[weak self] _ in
            HUD.hide()
            guard let self = self else { return }
            self.navigationController?.pushViewController(PerFectNameViewController(), animated: true)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
