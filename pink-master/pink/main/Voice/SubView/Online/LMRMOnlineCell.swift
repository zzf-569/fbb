import UIKit
class LMRMOnlineCell: LMBaseTableViewCell {
    private lazy var bdView: UIView = {
        let view = UIView().backgroundColor(.clear)
        return view
    }()
    private lazy var numlb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(14), textColor: .white)
            .textAlignment(.center)
        return lb
    }()
    private lazy var userusheaderView: UIImageView = {
        let imv = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
            .cornerRadius(56/2)
        return imv
    }()
    private lazy var userNamelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: .white)
        return lb
    }()
    private lazy var idlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#FFFFFF8F"))
        return lb
    }()
    lazy var arrowimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_online_user_arrow"))
        return imv
    }()
    lazy var onSeatbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_online_user_on_seat"))
            .isHidden(true)
        return btn
    }()
    override var indexPath: IndexPath? {
        didSet {
        self.numlb.text = ((indexPath?.row ?? 0) + 1).toString()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMOnlineCell {
    func setViewSnp() {
        contentView.addSubview(bdView)
        bdView.addSubview(numlb)
        bdView.addSubview(userusheaderView)
        bdView.addSubview(userNamelb)
        bdView.addSubview(idlb)
        bdView.addSubview(arrowimv)
        bdView.addSubview(onSeatbtn)
        bdView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(56.0)
        }
        numlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(24.0)
        }
        userusheaderView.snp.makeConstraints { make in
            make.left.equalTo(numlb.snp.right).offset(12.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(56.0)
        }
        userNamelb.snp.makeConstraints { make in
            make.left.equalTo(userusheaderView.snp.right).offset(10.0)
            make.top.equalTo(userusheaderView.snp.top).offset(4.0)
            make.height.equalTo(24.0)
        }
        idlb.snp.makeConstraints { make in
            make.left.equalTo(userNamelb)
            make.top.equalTo(userNamelb.snp.bottom).offset(0)
            make.size.equalTo(CGSize(width: 200, height: 20.0))
        }
        arrowimv.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(20.0)
            make.height.equalTo(20.0)
        }
        onSeatbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-6.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40.0)
        }
    }
}
extension LMRMOnlineCell {
    func setDataSoure(_ model: UsInfoItem) {
        self.userNamelb.text = model.nickname
        self.userusheaderView.set_Image(url: model.avatar)
        idlb.text = "ID: \(model.showUserId)"
    }
}
