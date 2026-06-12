import UIKit
import AttributedString
class UserPageHeaderView: UIView {
    var user: UsInfoItem = UsInfoItem() {
        didSet {
            userHaeder.set_Image(url: user.avatar)
            userName.lmtext(user.nickname)
            userTagView.setDataSoure(LMUserTagV(richLeve: user.richLevel, medal: user.medal), maxWidth: kScreenWidth - kScaleWidth(32))
            let idWidth = "\(user.showUserId)".textWidth(height: 12, font: lmFontR(8))
            idbtn.snp.updateConstraints { make in
                make.width.equalTo(idWidth + kScaleWidth(24))
            }
            idbtn.lmtitle("\(user.showUserId)")
            var content: ASAttributedString = ASAttributedString(string: "userpage.follow_fans".localized(user.focusCnt.toString(), user.fansCnt.toString()))
            content.add(attributes: [.foreground(lmColorHex("#2B313D")), .font(lmFontM(20))], checkings: [.regex((user.focusCnt.toString()))])
            content.add(attributes: [.foreground(lmColorHex("#2B313D")), .font(lmFontM(20))], checkings: [.regex((user.fansCnt.toString()))])
            fanslbbtn.attributed.text = content
            var taglb = "user.age_years".localized(user.age) + " | "
            if user.gender == 1 {
                taglb += "小哥哥".localized
            } else {
                taglb += "小姐姐".localized
            }
            if user.city.isEmpty == false {
                taglb += "  |  \(user.city)"
            }
            if user.constellation.isEmpty == false {
                taglb += "  |  \(user.constellation)"
            }
            city.lmtext(taglb)
            if user.voiceUrl.isEmpty == false {
                voiceView.isHidden = false
                voiceView.setDataSoure(title: "\(user.voiceSec)″")
            } else {
                voiceView.isHidden = true
            }
            if user.photoWall.count == 0 {
                pageControl.lmtext("1/1")
                userPhotos.imageURLStringsGroup = [user.avatar]
            } else {
                pageControl.lmtext("1/\(user.photoWall.count)")
                var urls: [String] = []
                for url in user.photoWall {
                    urls.append(url.url)
                }
                userPhotos.imageURLStringsGroup = urls
            }
            if user.userId == UserShared.user?.userId {
                followbtn.isHidden = true
                chatbtn.isHidden = true
            } else {
                followbtn.isHidden = false
                chatbtn.isHidden = false
                if user.liked == true {
                    followbtn.isHidden = true
                } else {
                    followbtn.isHidden = false
                }
            }
        }
    }
    lazy var userPhotos: SDCycleScrollView = {
        let banner = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScaleWidth(360)), delegate: self, placeholderImage: kPlaceholder_image)
            .backgroundColor(.clear)
        banner.bannerImageViewContentMode = .scaleAspectFill
        banner.showPageControl = false
        return banner
    }()
    lazy var pageControl: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .white)
            .textAlignment(.center)
        return lb
    }()
    lazy var userHaeder: UIImageView = {
        let imageV = UIImageView()
            .cornerRadius(kScaleWidth(78/2))
        return imageV
    }()
    lazy var userName: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(20), textColor: .white)
        return lb
    }()
    lazy var userTagView: UserTagView = {
        let tag = UserTagView()
        return tag
    }()
    lazy var idbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(8), titleColor: .white)
            .backgroundColor(lmColorHex("#FFFFFF29"))
            .cornerRadius(kScaleWidth(7))
            .image(UIImage(named: "id_icon"))
        return btn
    }()
    lazy var city: UILabel = {
        let lb = UILabel(lmfont: lmFontR(10), textColor: lmColorHex("#FFFFFFB8"))
        return lb
    }()
    lazy var fanslbbtn: UITextView = {
        let textView = UITextView(lmfont: lmFontF(10), textColor: lmColorHex("#2B313DAD"))
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        return textView
    }()
    lazy var followbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: lmColorHex("#FF4F7DFF"), target: self, action: #selector(followItemDidiClick))
            .backgroundColor(.white)
            .lmtitle("+关注")
            .cornerRadius(16)
        return btn
    }()
    lazy var chatbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: .white, target: self, action: #selector(chatDidiClick))
            .backgroundColor(lmColorHex("#FF4F7DFF"))
            .lmtitle("私聊")
            .cornerRadius(16)
        return btn
    }()
    lazy var bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScaleWidth(64)))
            .backgroundColor(.white)
        return view
    }()
    lazy var voiceView: UserPageVoiceView = {
        let imageV = UserPageVoiceView()
        imageV.isHidden = true
        return imageV
    }()
    var isPlayVoice: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(userPhotos)
        self.addGradientLayer(colors: [lmColorHex("#000000FF").cgColor, lmColorHex("#00000000").cgColor, lmColorHex("#000000FF").cgColor], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1), locations: [0, 1])
        addSubview(pageControl)
        addSubview(userHaeder)
        addSubview(userName)
        addSubview(userTagView)
        addSubview(idbtn)
        addSubview(city)
        addSubview(bottomView)
        addSubview(chatbtn)
        addSubview(followbtn)
        bottomView.addSubview(fanslbbtn)
        bottomView.addSubview(voiceView)
        pageControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kStatusBarHeight + kScaleWidth(12))
            make.centerX.equalToSuperview()
            make.height.equalTo(kScaleWidth(24))
        }
        userHaeder.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kScaleWidth(230))
            make.left.equalToSuperview().offset(kScaleWidth(30))
            make.size.equalTo(CGSize(width: kScaleWidth(78), height: kScaleWidth(78)))
        }
        userName.snp.makeConstraints { make in
            make.left.equalTo(userHaeder.snp.right).offset(kScaleWidth(12))
            make.top.equalTo(userHaeder.snp.top).offset(kScaleWidth(2))
            make.height.equalTo(kScaleWidth(32))
        }
        userTagView.snp.makeConstraints { make in
            make.left.equalTo(userHaeder.snp.right).offset(kScaleWidth(12))
            make.top.equalTo(userHaeder.snp.top).offset(kScaleWidth(56))
            make.width.equalTo(10)
            make.height.equalTo(kScaleWidth(20))
        }
        idbtn.snp.makeConstraints { make in
            make.left.equalTo(userTagView.snp.right).offset(kScaleWidth(4))
            make.centerY.equalTo(userTagView)
            make.width.equalTo(10)
            make.height.equalTo(kScaleWidth(14))
        }
        city.snp.makeConstraints { make in
            make.left.equalTo(userHaeder.snp.right).offset(kScaleWidth(12))
            make.top.equalTo(userHaeder.snp.top).offset(kScaleWidth(36))
            make.height.equalTo(kScaleWidth(16))
        }
        followbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(userHaeder.snp.top).offset(4)
            make.size.equalTo(CGSize(width: 64, height: 32))
        }
        chatbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(followbtn.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 64, height: 32))
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(324))
            make.height.equalTo(kScaleWidth(64))
        }
        bottomView.set_Border(radius: 16, conrners: [.topLeft, .topRight])
        fanslbbtn.snp.makeConstraints { make in
            make.left.equalTo(bottomView.snp.left).offset(kScaleWidth(20))
            make.centerY.equalTo(bottomView)
            make.height.equalTo(kScaleWidth(30))
        }
        voiceView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(20))
            make.centerY.equalTo(bottomView)
            make.size.equalTo(CGSize(width: kScaleWidth(83), height: kScaleWidth(28)))
        }
        voiceView.addGestureTap { [weak self] _ in
            self?.voiceViewClick()
        }
        voiceView.layoutIfNeeded()
    }
    @objc func voiceViewClick() {
        if user.userId == UserShared.user?.userId {
            if user.voiceUrl.isEmpty == true {
                UIViewController.current?.navigationController?.pushViewController(UserInfoSetViewController(), animated: true)
                return
            }
        }
        if self.isPlayVoice == true {
            LMAudioPlayer.shared.stop()
            self.isPlayVoice = false
            self.voiceView.playView.image = UIImage(named: "me_user_voicePlay")
            return
        }
        voiceView.playView.image = UIImage(named: "me_user_voicePause")
        LMAudioPlayer.shared.playAudio(url: user.voiceUrl, loopMode: .oneTime) {[weak self] in
            self?.voiceView.playView.image = UIImage(named: "me_user_voicePlay")
            self?.isPlayVoice = false
        }
        isPlayVoice = true
    }
    @objc func followItemDidiClick() {
        HUD.showLoading()
        UserNetWork.like(toUserId: user.userId, liked: true).lmrequest { [weak self] _ in
            guard let self = self else { return }
            HUD.hide()
            self.user.liked = true
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
    @objc func chatDidiClick() {
        RouteService.pushChat(user.userId, isRoom: false, vc: UIViewController.current)
    }
}
extension UserPageHeaderView: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        pageControl.lmtext("\(index + 1)/\(user.photoWall.count)")
    }
}
