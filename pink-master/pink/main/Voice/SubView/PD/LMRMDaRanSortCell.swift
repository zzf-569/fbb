import UIKit
class LMRMDaRanSortCell: LMBaseTableViewCell {
    private lazy var bdView: UIView = {
        let view = UIView().backgroundColor(.clear)
        return view
    }()
    private lazy var userusheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
            .cornerRadius(56/2)
        return imv
    }()
    private lazy var userNamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#FFFFFF", alpha: 0.96))
        return lb
    }()
    private lazy var skillNameslb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFF", alpha: 0.64))
        return lb
    }()
    lazy var onSeatbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_dispatch_sequence_on_seat"))
        return btn
    }()
    lazy var removebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_dispatch_sequence_remove"))
        return btn
    }()
    lazy var userbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: lmColorHex("#2B313D"), frame: .zero, backgroundColor: lmColorHex("#FFEC3BFF"), text: "找他玩")
        return btn
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMDaRanSortCell {
    func set_Subviews() {
        contentView.addSubview(bdView)
        bdView.addSubview(userusheaderView)
        bdView.addSubview(userNamelb)
        bdView.addSubview(skillNameslb)
        bdView.addSubview(onSeatbtn)
        bdView.addSubview(removebtn)
        bdView.addSubview(userbtn)
        bdView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(56.0)
        }
        userusheaderView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(56.0)
        }
        userNamelb.snp.makeConstraints { make in
            make.left.equalTo(userusheaderView.snp.right).offset(12.0)
            make.top.equalTo(userusheaderView.snp.top).offset(5.0)
            make.height.equalTo(24.0)
            make.right.lessThanOrEqualTo(onSeatbtn.snp.left).offset(-10.0)
        }
        skillNameslb.snp.makeConstraints { make in
            make.left.equalTo(userNamelb)
            make.top.equalTo(userNamelb.snp.bottom).offset(2.0)
            make.height.equalTo(20.0)
            make.right.lessThanOrEqualTo(onSeatbtn.snp.left).offset(-10.0)
        }
        onSeatbtn.snp.makeConstraints { make in
            make.right.equalTo(removebtn.snp.left).offset(-12.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(56.0)
            make.height.equalTo(28.0)
        }
        removebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(28.0)
            make.height.equalTo(28.0)
        }
        userbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(52.0)
            make.height.equalTo(32.0)
        }
    }
}
extension LMRMDaRanSortCell {
    func setDataSoure(_ model: UsInfoItem) {
        self.userNamelb.text = model.nickname
        self.userusheaderView.set_Image(url: model.avatar)
        let skillNames = model.labelList.map { $0.labelName }
        self.skillNameslb.text = skillNames.joined(separator: " | ")
    }
}
