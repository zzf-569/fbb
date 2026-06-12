import UIKit
extension LMRMPDReleaseSexView {
    func set_Status(_ status: LMRMPDReleaseVC.Sex) {
        changeStatus(status)
    }
}
class LMRMPDReleaseSexView: UIView {
    var clickActionblock: ((LMRMPDReleaseVC.Sex) -> Void)?
    private lazy var girlbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: lmColorHex("#FFFFFF", alpha: 0.96), target: self, action: #selector(girlbtnAction))
            .backgroundColor(lmColorHex("#000000", alpha: 0.2))
            .cornerRadius(20.0, borderColor: lmColorHex("#FFFFFF", alpha: 0.16), borderWidth: 0.5)
            .lmtitle("女")
        return btn
    }()
    private lazy var boybtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: lmColorHex("#FFFFFF", alpha: 0.96), target: self, action: #selector(boybtnAction))
            .backgroundColor(lmColorHex("#000000", alpha: 0.2))
            .cornerRadius(20.0, borderColor: lmColorHex("#FFFFFF", alpha: 0.16), borderWidth: 0.5)
            .lmtitle("男")
        return btn
    }()
    private lazy var unlimitedbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(14), titleColor: lmColorHex("#FFFFFF", alpha: 0.96), target: self, action: #selector(unlimitedbtnAction))
            .backgroundColor(lmColorHex("#000000", alpha: 0.2))
            .cornerRadius(20.0, borderColor: lmColorHex("#FFFFFF", alpha: 0.16), borderWidth: 0.5)
            .lmtitle("不限")
        return btn
    }()
    private lazy var markimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_dispatch_release_sex"))
            .isHidden(true)
        return imv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMPDReleaseSexView {
    private func set_Subviews() {
        addSubview(girlbtn)
        addSubview(boybtn)
        addSubview(unlimitedbtn)
        addSubview(markimv)
        girlbtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        boybtn.snp.makeConstraints { make in
            make.left.equalTo(girlbtn.snp.right).offset(16.0)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(girlbtn)
        }
        unlimitedbtn.snp.makeConstraints { make in
            make.left.equalTo(boybtn.snp.right).offset(16.0)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(boybtn)
        }
        markimv.snp.makeConstraints { make in
            make.top.right.equalTo(girlbtn).offset(0)
            make.width.equalTo(20.0)
            make.height.equalTo(20.0)
        }
    }
    @objc func girlbtnAction(_ btn: UIButton) {
        self.changeStatus(.girl)
        self.clickActionblock?(.girl)
    }
    @objc func boybtnAction() {
        self.changeStatus(.boy)
        self.clickActionblock?(.boy)
    }
    @objc func unlimitedbtnAction() {
        self.changeStatus(.unlimited)
        self.clickActionblock?(.unlimited)
    }
    func changeStatus(_ sex: LMRMPDReleaseVC.Sex) {
        switch sex {
        case .unlimited:
            self.unlimitedbtn.isSelected = true
            self.girlbtn.isSelected = false
            self.boybtn.isSelected = false
            self.unlimitedbtn
                .backgroundColor(lmColorHex("#00DBA9", alpha: 0.08))
                .cornerRadius(20.0, borderColor: lmColorHex("#FFE640"), borderWidth: 1.0)
            self.girlbtn
                .backgroundColor(lmColorHex("#000000", alpha: 0.2))
                .cornerRadius(20.0, borderColor: lmColorHex("#FFFFFF", alpha: 0.16), borderWidth: 0.5)
            self.boybtn
                .backgroundColor(lmColorHex("#000000", alpha: 0.2))
                .cornerRadius(20.0, borderColor: lmColorHex("#FFFFFF", alpha: 0.16), borderWidth: 0.5)
            markimv.snp.remakeConstraints { make in
                make.top.right.equalTo(unlimitedbtn).offset(0)
                make.width.equalTo(20.0)
                make.height.equalTo(10.0)
            }
        case .girl:
            self.unlimitedbtn.isSelected = false
            self.girlbtn.isSelected = true
            self.boybtn.isSelected = false
            self.girlbtn
                .backgroundColor(lmColorHex("#00DBA9", alpha: 0.08))
                .cornerRadius(20.0, borderColor: lmColorHex("#FFE640"), borderWidth: 1.0)
            self.boybtn
                .backgroundColor(lmColorHex("#000000", alpha: 0.2))
                .cornerRadius(20.0, borderColor: lmColorHex("#FFFFFF", alpha: 0.16), borderWidth: 0.5)
            self.unlimitedbtn
                .backgroundColor(lmColorHex("#000000", alpha: 0.2))
                .cornerRadius(20.0, borderColor: lmColorHex("#FFFFFF", alpha: 0.16), borderWidth: 0.5)
            markimv.snp.remakeConstraints { make in
                make.top.right.equalTo(girlbtn).offset(0)
                make.width.equalTo(20.0)
                make.height.equalTo(10.0)
            }
        case .boy:
            self.unlimitedbtn.isSelected = false
            self.girlbtn.isSelected = false
            self.boybtn.isSelected = true
            self.boybtn
                .backgroundColor(lmColorHex("#00DBA9", alpha: 0.08))
                .cornerRadius(20.0, borderColor: lmColorHex("#FFE640"), borderWidth: 1.0)
            self.girlbtn
                .backgroundColor(lmColorHex("#000000", alpha: 0.2))
                .cornerRadius(20.0, borderColor: lmColorHex("#FFFFFF", alpha: 0.16), borderWidth: 0.5)
            self.unlimitedbtn
                .backgroundColor(lmColorHex("#000000", alpha: 0.2))
                .cornerRadius(20.0, borderColor: lmColorHex("#FFFFFF", alpha: 0.16), borderWidth: 0.5)
            markimv.snp.remakeConstraints { make in
                make.top.right.equalTo(boybtn).offset(0)
                make.width.equalTo(20.0)
                make.height.equalTo(10.0)
            }
        }
        markimv.isHidden = false
    }
}
