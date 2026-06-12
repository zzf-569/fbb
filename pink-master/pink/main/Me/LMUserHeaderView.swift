import UIKit
class LMUserHeaderView: UIView {
    var offsetcompate: ((Bool) -> Void)?
    var user: UsInfoItem = UsInfoItem() {
        didSet {
            if user.avatar.isEmpty {
                avatar.image =  UIImage(named: "me_\(String(user.birthday.chineseZodiac() ?? "猪"))")
            }else {
                avatar.set_Image(url: user.avatar)
            }
           
            namelb.text = user.nickname
            userTagView.setDataSoure(LMUserTagV(richLeve: user.richLevel, medal: user.medal), maxWidth: kScreenWidth - kScaleWidth(32))
            let idWidth = "\(user.showUserId)".textWidth(height: 12, font: lmFontR(8))
            idbtn.snp.updateConstraints { make in
                make.width.equalTo(idWidth + kScaleWidth(24))
            }
            idbtn.setTitle(user.showUserId, for: .normal)
            var taglb = "\(user.age)岁 | "
            if user.gender == 1 {
                taglb += "小哥哥"
            } else {
                taglb += "小姐姐"
            }
            if user.city.isEmpty == false {
                taglb += "  |  \(user.city)"
            }
            if user.constellation.isEmpty == false {
                taglb += "  |  \(user.constellation)"
            }
            infolb.text = taglb
            if user.userId == UserShared.user?.userId {
                addbtn.isHidden = true
                editbtn.isHidden = false
                chatbtn.isHidden = true
            } else {
                chatbtn.isHidden = false
                editbtn.isHidden = true
                if user.liked == true {
                    addbtn.isHidden = true
                } else {
                    addbtn.isHidden = false
                }
            }
        }
    }
    lazy var avatar: UIImageView = {
        let imageV = UIImageView()
        imageV.cornerRadius(kScaleWidth(20))
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel()
        lb.font = lmFontASHTB(20)
        lb.textColor = lmColorHex("#2B313D")
        return lb
    }()
    lazy var editbtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "user_edit"), for: .normal)
        btn.addTarget(self, action: #selector(editClick), for: .touchUpInside)
        return btn
    }()
    lazy var addbtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "user_addfans"), for: .normal)
        btn.addTarget(self, action: #selector(likeClick), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    lazy var chatbtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = lmColorHex("#FF4F7DFF")
        btn.setTitle("私聊", for: .normal)
        btn.titleLabel?.font = lmFontM(12)
        btn.cornerRadius(kScaleWidth(16))
        btn.addTarget(self, action: #selector(chatClick), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    lazy var infolb: UILabel = {
        let lb = UILabel()
        lb.font = lmFontM(10)
        lb.textColor = lmColorHex("#2B313DAD")
        return lb
    }()
    lazy var userTagView: UserTagView = {
        let tag = UserTagView()
        return tag
    }()
    lazy var idbtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = lmFontR(8)
        btn.setTitleColor(.white, for: .normal)
        btn.cornerRadius(2)
        btn.backgroundColor = lmColorHex("#2B313D")
        btn.setImage(UIImage(named: "id_icon"), for: .normal)
        return btn
    }()
    lazy var offSetbtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "user_up"), for: .normal)
        btn.setImage(UIImage(named: "user_down"), for: .selected)
        btn.addTarget(self, action: #selector(offSetClick), for: .touchUpInside)
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
        let bgImage = UIImageView(image: UIImage(named: "user_head_bg"))
        bgImage.frame = self.bounds
        bgImage.isUserInteractionEnabled = true
        addSubview(bgImage)
        bgImage.addSubview(avatar)
        bgImage.addSubview(namelb)
        bgImage.addSubview(editbtn)
        bgImage.addSubview(addbtn)
        bgImage.addSubview(infolb)
        bgImage.addSubview(userTagView)
        bgImage.addSubview(idbtn)
        bgImage.addSubview(chatbtn)
        bgImage.addSubview(offSetbtn)
        avatar.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(24))
            make.size.equalTo(CGSize(width: kScaleWidth(40), height: kScaleWidth(40)))
        }
        chatbtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kScaleWidth(16))
            make.right.equalToSuperview().offset(-kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(64), height: kScaleWidth(32)))
        }
        namelb.snp.makeConstraints { make in
            make.centerY.equalTo(avatar.snp.centerY)
            make.left.equalTo(avatar.snp.right).offset(kScaleWidth(12))
            make.height.equalTo(kScaleWidth(28))
        }
        editbtn.snp.makeConstraints { make in
            make.centerY.equalTo(avatar.snp.centerY)
            make.left.equalTo(namelb.snp.right).offset(kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(20), height: kScaleWidth(20)))
        }
        addbtn.snp.makeConstraints { make in
            make.centerY.equalTo(avatar.snp.centerY)
            make.left.equalTo(namelb.snp.right).offset(kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(20), height: kScaleWidth(20)))
        }
        infolb.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.left)
            make.top.equalToSuperview().offset(kScaleWidth(72))
            make.height.equalTo(16)
        }
        userTagView.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.left)
            make.top.equalToSuperview().offset(kScaleWidth(96))
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        idbtn.snp.makeConstraints { make in
            make.centerY.equalTo(userTagView.snp.centerY)
            make.left.equalTo(userTagView.snp.right).offset(kScaleWidth(4))
            make.width.equalTo(100)
            make.height.equalTo(kScaleWidth(14))
        }
        offSetbtn.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().offset(-kScaleWidth(20))
            make.size.equalTo(CGSize(width: kScaleWidth(28), height: kScaleWidth(28)))
        }
    }
    @objc func editClick() {
        UIViewController.current?.navigationController?.pushViewController(UserInfoSetViewController(), animated: true)
    }
    @objc func chatClick() {
        RouteService.pushChat(user.userId, isRoom: false, vc: UIViewController.current)
    }
    @objc func likeClick() {
        HUD.showLoading()
        UserNetWork.like(toUserId: user.userId, liked: true).lmrequest { [weak self] _ in
            guard let self = self else { return }
            HUD.hide()
            self.user.liked = true
            self.addbtn.isHidden = true
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func offSetClick() {
        self.offSetbtn.isSelected = !self.offSetbtn.isSelected
        self.offsetcompate?(self.offSetbtn.isSelected)
    }
}
