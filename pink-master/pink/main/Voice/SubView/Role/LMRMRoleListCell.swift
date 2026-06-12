import UIKit
extension LMRMRoleListCell {
    func setDataSoure(_ model: UsInfoItem) {
        self.userNamelb.text = model.nickname
        self.userusheaderView.set_Image(url: model.avatar)
        let set_ = LMUserTagV(id: model.showUserId, idColor: lmColorHex("#FFFFFF8F"))
        self.userTagView.setDataSoure(set_, maxWidth: kScreenWidth - 128.0 - 16.0)
    }
}
class LMRMRoleListCell: LMBaseTableViewCell {
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
    private lazy var userTagView: UserTagView = {
        let view = UserTagView()
        return view
    }()
    lazy var removebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "rm_more_role_remove"))
        return btn
    }()
    override var indexPath: IndexPath? {
        didSet {
            self.numlb.text = (indexPath!.row + 1).toString()
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
private extension LMRMRoleListCell {
    func setViewSnp() {
        contentView.addSubview(bdView)
        bdView.addSubview(userusheaderView)
        bdView.addSubview(userNamelb)
        bdView.addSubview(userTagView)
        bdView.addSubview(removebtn)
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
            make.left.equalTo(userusheaderView.snp.right).offset(10.0)
            make.top.equalTo(userusheaderView.snp.top).offset(4.0)
            make.height.equalTo(24.0)
        }
        userTagView.snp.makeConstraints { make in
            make.left.equalTo(userNamelb)
            make.top.equalTo(userNamelb.snp.bottom).offset(0)
            make.size.equalTo(CGSize(width: 100, height: 20.0))
        }
        removebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(32.0)
            make.height.equalTo(32.0)
        }
    }
}
