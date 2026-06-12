import UIKit
extension LMRMPkRankCenterCell {
    func confData(blueUser: LMtopAvatarModel?, redUser: LMtopAvatarModel?, rank: Int) {
        if let blueUser = blueUser {
            blueView.isHidden = false
            blueAvatar.set_Image(url: blueUser.avatar)
            blueName.lmtext(blueUser.nickname)
            blueCharm.lmtext(blueUser.amount.toString())
            bluerankImage.image = UIImage(named: "rm_pk_rank_blue\(rank.toString())")
        } else {
            blueView.isHidden = true
        }
        if let redUser = redUser {
            redView.isHidden = false
            redAvatar.set_Image(url: redUser.avatar)
            redName.lmtext(redUser.nickname)
            redCharm.lmtext(redUser.amount.toString())
            redrankImage.image = UIImage(named: "rm_pk_rank_red\(rank.toString())")
        } else {
            redView.isHidden = true
        }
    }
}
class LMRMPkRankCenterCell: UITableViewCell {
    lazy var blueView: UIView = {
        let view = UIView()
        return view
    }()
    lazy var bluerankImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var blueAvatar: UIImageView = {
        let imageV = UIImageView()
            .cornerRadius(kScaleWidth(18))
            .contentMode(.scaleAspectFill)
        return imageV
    }()
    lazy var blueName: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#206BD4F5"))
        return lb
    }()
    lazy var blueCharm: UILabel = {
        let lb = UILabel(lmfont: lmFontM(10), textColor: lmColorHex("#206BD4F5"))
        return lb
    }()
    lazy var redView: UIView = {
        let view = UIView()
        return view
    }()
    lazy var redrankImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var redAvatar: UIImageView = {
        let imageV = UIImageView()
            .cornerRadius(kScaleWidth(18))
            .contentMode(.scaleAspectFill)
        return imageV
    }()
    lazy var redName: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#CF1F9AF5"))
        return lb
    }()
    lazy var redCharm: UILabel = {
        let lb = UILabel(lmfont: lmFontM(10), textColor: lmColorHex("#CF1F9AF5"))
        return lb
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        selectionStyle = .none
        backgroundColor(.clear)
        contentView.backgroundColor(.clear)
        contentView.addSubview(blueView)
        contentView.addSubview(redView)
        blueView.addSubview(bluerankImage)
        blueView.addSubview(blueAvatar)
        blueView.addSubview(blueName)
        blueView.addSubview(blueCharm)
        redView.addSubview(redrankImage)
        redView.addSubview(redAvatar)
        redView.addSubview(redName)
        redView.addSubview(redCharm)
        blueView.snp.makeConstraints { make in
            make.bottom.left.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(8))
            make.right.equalTo(contentView.snp.centerX)
        }
        bluerankImage.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(24), height: kScaleWidth(24)))
        }
        blueAvatar.snp.makeConstraints { make in
            make.left.equalTo(bluerankImage.snp.right).offset(kScaleWidth(4))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(36), height: kScaleWidth(36)))
        }
        blueName.snp.makeConstraints { make in
            make.left.equalTo(blueAvatar.snp.right).offset(kScaleWidth(2))
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(1)
            make.height.equalTo(kScaleWidth(20))
        }
        blueCharm.snp.makeConstraints { make in
            make.left.equalTo(blueAvatar.snp.right).offset(kScaleWidth(2))
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(kScaleWidth(16))
        }
        redView.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(8))
            make.left.equalTo(contentView.snp.centerX)
        }
        redrankImage.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(24), height: kScaleWidth(24)))
        }
        redAvatar.snp.makeConstraints { make in
            make.left.equalTo(redrankImage.snp.right).offset(kScaleWidth(4))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(36), height: kScaleWidth(36)))
        }
        redName.snp.makeConstraints { make in
            make.left.equalTo(redAvatar.snp.right).offset(kScaleWidth(2))
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(1)
            make.height.equalTo(kScaleWidth(20))
        }
        redCharm.snp.makeConstraints { make in
            make.left.equalTo(redAvatar.snp.right).offset(kScaleWidth(2))
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(kScaleWidth(16))
        }
    }
}
