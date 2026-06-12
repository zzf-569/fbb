import UIKit
extension LMRMPDOrderInfoView {
    func setDataSoure(_ model: DispatchItem) {
        skillimv.set_Image(url: model.bizIcon)
        dispatchInfolb.text = "需求: \(model.bizName) \(model.genderText) \(model.demandPrice)"
        remarllb.text = "备注: \(model.remark)"
    }
}
class LMRMPDOrderInfoView: UIView {
    var editblock: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var bgView: UIView = {
        let view = UIView()
            .backgroundColor(lmColorHex("#FFE64026"))
            .cornerRadius(9.0, borderColor: lmColorHex("#FFE640FF"), borderWidth: 0.5)
        return view
    }()
    private lazy var skillimv: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
            .cornerRadius(56/2)
        return imv
    }()
    private lazy var dispatchInfolb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        return lb
    }()
    private lazy var remarllb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        return lb
    }()
    private lazy var editbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: lmColorHex("#04C79C"), target: self, action: #selector(editbtnAction))
            .image(UIImage(named: "rm_dispatch_order_arrow"))
            .lmtitle("编辑")
            .isHidden(true)
        return btn
    }()
}
private extension LMRMPDOrderInfoView {
    private func set_Subviews() {
        addSubview(bgView)
        addSubview(skillimv)
        addSubview(dispatchInfolb)
        addSubview(remarllb)
        addSubview(editbtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        skillimv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(56.0)
        }
        dispatchInfolb.snp.makeConstraints { make in
            make.left.equalTo(skillimv.snp.right).offset(12.0)
            make.top.equalTo(skillimv.snp.top).offset(6.0)
            make.height.equalTo(20.0)
            make.right.lessThanOrEqualTo(editbtn.snp.left).offset(-10.0)
        }
        remarllb.snp.makeConstraints { make in
            make.left.equalTo(skillimv.snp.right).offset(12.0)
            make.top.equalTo(dispatchInfolb.snp.bottom).offset(4.0)
            make.height.equalTo(20.0)
            make.right.lessThanOrEqualTo(editbtn.snp.left).offset(-10.0)
        }
        editbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(40.0)
            make.height.equalTo(40.0)
        }
        self.layoutIfNeeded()
        editbtn.set_ImageTitleLayout(.imgRight, spacing: 2.0)
    }
    @objc func editbtnAction() {
        self.editblock?()
    }
}
