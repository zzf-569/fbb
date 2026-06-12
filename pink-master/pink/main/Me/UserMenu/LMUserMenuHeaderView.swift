import UIKit
class LMUserMenuHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        addSubview(leftItemV)
        addSubview(rightItemV)
        leftItemV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.0)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10.0)
        }
        rightItemV.snp.makeConstraints { make in
            make.left.equalTo(leftItemV.snp.right).offset(12.0)
            make.right.equalToSuperview().offset(-20.0)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10.0)
            make.width.equalTo(leftItemV)
        }
    }
    func setData(model: WalletItem) {
        leftItemV.setData(title: "钻石", bgImageName: "user_menu_zhuanshi", value: model.coin.toString())
        rightItemV.setData(title: "贝壳", bgImageName: "user_menu_beike", value: String(model.cash))
    }
    private lazy var leftItemV: LMUserMenuHeaderItemView = {
        let v = LMUserMenuHeaderItemView()
        v.setData(title: "钻石", bgImageName: "user_menu_zhuanshi", value: "0")
        v.addGestureTap { [weak self] _ in
                UIViewController.current?.navigationController?.pushViewController(WalletViewController(), animated: true)
            }
        return v
    }()
    private lazy var rightItemV: LMUserMenuHeaderItemView = {
        let v = LMUserMenuHeaderItemView()
        v.setData(title: "贝壳", bgImageName: "user_menu_beike", value: "0")
        v.addGestureTap { [weak self] _ in
                UIViewController.current?.navigationController?.pushViewController(WalletViewController(), animated: true)
            }
        return v
    }()
}
class LMUserMenuHeaderItemView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        addSubview(bgIV)
        addSubview(titleL)
        addSubview(valueL)
        bgIV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleL.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(13))
            make.top.equalToSuperview().offset(kScaleWidth(10))
        }
        valueL.snp.makeConstraints { make in
            make.left.equalTo(titleL)
            make.top.equalTo(titleL.snp.bottom).offset(0)
        }
    }
    func setData(title: String, bgImageName: String, value: String) {
        self.titleL.text = title
        self.bgIV.image = UIImage(named: bgImageName)
        self.valueL.text = value
    }
    private lazy var bgIV: UIImageView  = {
        let iv = UIImageView()
        return iv
    }()
    private lazy var titleL: UILabel = {
        let l = UILabel(lmfont: lmFontM(14), textColor: .white)
        return l
    }()
    private lazy var valueL: UILabel = {
        let l = UILabel(lmfont: lmFontS(18), textColor: .white)
        return l
    }()
}
