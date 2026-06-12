import UIKit
class PlaceOrderItemView: UIView {
    enum itemtype {
        case lb, textFiled, num
    }
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: .textDefaulColor)
        return lb
    }()
    lazy var subtitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: .textDefaulColor)
        lb.textAlignment = .right
        return lb
    }()
    lazy var textfield: UITextField = {
        let textfield = UITextField(lmfont: lmFontM(12), textColor: .textDefaulColor)
        textfield.textAlignment = .right
        textfield.placeholder("请输入您的游戏昵称")
        return textfield
    }()
    lazy var addbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "order_num_++"), target: self, action: #selector(a_addClick))
        return btn
    }()
    lazy var minusbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "order_num_--"), target: self, action: #selector(a_minClick))
        return btn
    }()
    var type: itemtype
    var title: String
    var callBack: ((Int) -> Void)?
    init(type: itemtype, title: String, callBack: ((Int) -> Void)? = nil) {
        self.type = type
        self.title = title
        self.callBack = callBack
        super.init(frame: .zero)
        set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func set_Subviews() {
        addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(24))
        }
        titleLab.text = title
        switch type {
        case .lb:
            addSubview(subtitleLab)
            subtitleLab.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-kScaleWidth(16))
                make.height.equalTo(kScaleWidth(22))
            }
            case .textFiled:
            addSubview(textfield)
            textfield.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-kScaleWidth(16))
                make.height.equalTo(kScaleWidth(22))
            }
            case .num:
            addSubview(addbtn)
            addSubview(minusbtn)
            addSubview(subtitleLab)
            addbtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-kScaleWidth(16))
                make.width.height.equalTo(kScaleWidth(24))
            }
            subtitleLab.textAlignment(.center)
            subtitleLab.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalTo(addbtn.snp.left).offset(-kScaleWidth(0))
                make.width.equalTo(kScaleWidth(30))
                make.height.equalTo(kScaleWidth(22))
            }
            minusbtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalTo(subtitleLab.snp.left).offset(-kScaleWidth(0))
                make.width.height.equalTo(kScaleWidth(24))
            }
        }
    }
    func setDataSoure(subtitle: String) {
        subtitleLab.text = subtitle
    }
    @objc func a_addClick() {
        guard let indexStr = subtitleLab.text, var index = Int(indexStr) else {
            return
        }
        index += 1
        subtitleLab.text = String(format: "%d", index)
        minusbtn.image(UIImage(named: "order_num_--l"))
        self.callBack?(index)
    }
    @objc func a_minClick() {
        guard let indexStr = subtitleLab.text, var index = Int(indexStr), index > 1 else {
            return
        }
        index -= 1
        if index == 1 {
            minusbtn.image(UIImage(named: "order_num_--"))
        }
        subtitleLab.text = String(format: "%d", index)
        self.callBack?(index)
    }
}
