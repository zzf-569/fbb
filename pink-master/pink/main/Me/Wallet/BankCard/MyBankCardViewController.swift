import UIKit
extension MyBankCardViewController {
}
class MyBankCardViewController: LMBaseVC {
    private lazy var contentView: UIView = {
        let view = UIView()
            .backgroundColor(.white)
            .cornerRadius(12.0)
        return view
    }()
    private lazy var bankNameItem: MyBankCardItemView = {
        let view = MyBankCardItemView(title: "开户银行")
        return view
    }()
    private lazy var bankCardNumItem: MyBankCardItemView = {
        let view = MyBankCardItemView(title: "银行卡号")
        return view
    }()
    private lazy var realNameItem: MyBankCardItemView = {
        let view = MyBankCardItemView(title: "真实姓名")
        return view
    }()
    private lazy var idCardItem: MyBankCardItemView = {
        let view = MyBankCardItemView(title: "身份证号")
        return view
    }()
    private lazy var mobileItem: MyBankCardItemView = {
        let view = MyBankCardItemView(title: "手机号码")
        return view
    }()
    private lazy var sendbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .white, target: self, action: #selector(sendbtnAction))
            .backgroundImage(UIImage.image(color: lmColorHex("#FF4F7D"), size: CGSize(width: kScreenWidth -  kScaleWidth(16.0) * 2, height: kScaleWidth(56.0))))
            .cornerRadius(12.0)
            .lmtitle("更换银行卡")
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "银行卡"
        view.backgroundColor = lmColorHex("#F5F6FA")
        setViewSnp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lmrequestData()
    }
}
private extension MyBankCardViewController {
    func setViewSnp() {
        view.addSubview(contentView)
        view.addSubview(sendbtn)
        contentView.addSubview(bankNameItem)
        contentView.addSubview(bankCardNumItem)
        contentView.addSubview(realNameItem)
        contentView.addSubview(idCardItem)
        contentView.addSubview(mobileItem)
        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(0))
            make.top.equalToSuperview().offset(kNavigationHeight + kScaleWidth(12.0))
        }
        bankNameItem.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(56.0))
        }
        bankCardNumItem.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(bankNameItem.snp.bottom).offset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(56.0))
        }
        realNameItem.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(bankCardNumItem.snp.bottom).offset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(56.0))
        }
        idCardItem.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(realNameItem.snp.bottom).offset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(56.0))
        }
        mobileItem.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(idCardItem.snp.bottom).offset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(56.0))
            make.bottom.equalToSuperview()
        }
        sendbtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16.0))
            make.top.equalTo(contentView.snp.bottom).offset(kScaleWidth(40.0))
            make.height.equalTo(kScaleWidth(56.0))
        }
    }
    func lmrequestData() {
        WalletNetWork.withdrawAccountList().lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            if let list = [BankCardModel].deserialize(from: responseModel.data as? [Any]), list.count > 0 {
                refreshSubviews(list[0])
            } else {
            }
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    func refreshSubviews(_ model: BankCardModel) {
        bankNameItem.text = model.bankName
        bankCardNumItem.text = model.account.replacingCharacters(range: NSRange(location: 0, length: model.account.count - 3), replacingString: "**** **** **** **** ")
        realNameItem.text = model.realName.replacingCharacters(range: NSRange(location: 1, length: 1), replacingString: "*")
        idCardItem.text = model.idCard.replacingCharacters(range: NSRange(location: 6, length: 8), replacingString: "********")
        mobileItem.text = model.mobile.replacingCharacters(range: NSRange(location: 3, length: 4), replacingString: " **** ")
    }
    @objc func sendbtnAction() {
        self.navigationController?.pushViewController(BindBankCardViewController(), animated: true)
    }
}
extension MyBankCardItemView {
}
class MyBankCardItemView: UIView {
    var text: String = "" {
        didSet {
            textlb.text = text
        }
    }
    private let title: String
    required init(title: String) {
        self.title = title
        super.init(frame: .zero)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#2B313D"))
            .lmtext(title)
        return lb
    }()
    private lazy var textlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(16), textColor: lmColorHex("#2B313D"))
        return lb
    }()
}
private extension MyBankCardItemView {
    private func setViewSnp() {
        addSubview(titleLab)
        addSubview(textlb)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16.0))
            make.centerY.equalToSuperview()
        }
        textlb.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right).offset(kScaleWidth(16.0))
            make.right.lessThanOrEqualToSuperview().offset(-kScaleWidth(16.0))
            make.centerY.equalToSuperview()
        }
    }
}
