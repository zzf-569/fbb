import UIKit
class WalletHeaderView: UIView {
    func setDataSoure(model: WalletItem) {
        cash.lmtext(String(model.cash))
        coin.lmtext(model.coin.toString())
    }
    lazy var backView: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "wallet_headbg"))
        imageV.isUserInteractionEnabled = true
        return imageV
    }()
    lazy var cashlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#FFFFFFB8"))
            .lmtext("我的贝壳")
        return lb
    }()
    lazy var coinlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#FFFFFFB8"))
            .lmtext("钻石余额")
        return lb
    }()
    lazy var coin: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: .white)
        return lb
    }()
    lazy var cash: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: .white)
        return lb
    }()
    lazy var lineView: UIView = {
        let view = UIView().backgroundColor(lmColorHex("#FFFFFF52"))
        return view
    }()
    lazy var rechargebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "wallet_recharge"), target: self, action: #selector(rechargeAction))
            .lmtitle("充值")
            .font(lmFontR(10))
            .titleColor(lmColorHex("#FFFFFFB8"))
        return btn
    }()
    lazy var withdrawalbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "wallet_withdrawal"), target: self, action: #selector(withdrawalAction))
            .lmtitle("兑换")
            .font(lmFontR(10))
            .titleColor(lmColorHex("#FFFFFFB8"))
        btn.isHidden = ConfigService.shared.reviewStatus
        return btn
    }()
    lazy var cardbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "wallet_card"), target: self, action: #selector(cardAction))
            .lmtitle("银行卡")
            .font(lmFontR(10))
            .titleColor(lmColorHex("#FFFFFFB8"))
        btn.isHidden = ConfigService.shared.reviewStatus
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        backgroundColor(.white)
        addSubview(backView)
        backView.addSubview(coinlb)
        backView.addSubview(cashlb)
        backView.addSubview(coin)
        backView.addSubview(cash)
        backView.addSubview(lineView)
        backView.addSubview(rechargebtn)
        backView.addSubview(withdrawalbtn)
        backView.addSubview(cardbtn)
        backView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(8))
            make.height.equalTo(kScaleWidth(148))
        }
        coinlb.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(20))
        }
        cashlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(183))
            make.top.equalToSuperview().offset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(20))
        }
        coin.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.top.equalTo(coinlb.snp.bottom).offset(kScaleWidth(4))
            make.height.equalTo(kScaleWidth(32))
        }
        cash.snp.makeConstraints { make in
            make.left.equalTo(cashlb.snp.left)
            make.top.equalTo(cashlb.snp.bottom).offset(kScaleWidth(4))
            make.height.equalTo(kScaleWidth(32))
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.bottom.equalToSuperview().offset(-kScaleWidth(63))
            make.height.equalTo(kScaleWidth(1))
        }
        rechargebtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.bottom.equalToSuperview().offset(-kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(85), height: kScaleWidth(40)))
        }
        withdrawalbtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(85), height: kScaleWidth(40)))
        }
        cardbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.bottom.equalToSuperview().offset(-kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(85), height: kScaleWidth(40)))
        }
        rechargebtn.set_ImageTitleLayout(.imgTop, spacing: kScaleWidth(4))
        withdrawalbtn.set_ImageTitleLayout(.imgTop, spacing: kScaleWidth(4))
        cardbtn.set_ImageTitleLayout(.imgTop, spacing: kScaleWidth(4))
    }
    @objc func rechargeAction() {
        UIViewController.current?.navigationController?.pushViewController(RechargeViewController(), animated: true)
    }
    @objc func withdrawalAction() {
        UIViewController.current?.navigationController?.pushViewController(WithdrawalViewController(), animated: true)
    }
    @objc func cardAction() {
        WalletNetWork.withdrawAccountList().lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            if let list = [BankCardModel].deserialize(from: responseModel.data as? [Any]), list.count > 0 {
                UIViewController.current?.navigationController?.pushViewController(MyBankCardViewController(), animated: true)
            } else {
                UIViewController.current?.navigationController?.pushViewController(BindBankCardViewController(), animated: true)
            }
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
