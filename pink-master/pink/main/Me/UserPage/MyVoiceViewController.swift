import UIKit
import Qiniu
class MyRoomViewController: LMBaseVC {
    private lazy var bodyimv: UIImageView = {
        let imv = UIImageView(frame: view.bounds)
            .image(UIImage(named: "add_voice_bg"))
        return imv
    }()
    var voicePath: String = ""
    var voiceSec: Int = 0
    lazy var rec: LMAudioRecorder = {
        let rec = LMAudioRecorder()
        rec.recorderEndChangeHandler = {[weak self] string in
            self?.voicePath = string
        }
        rec.timeIntervalHandler = {[weak self] string in
            self?.voiceSec = Int(string)
            let att = NSMutableAttributedString(string: "录制中")
            att.append(NSAttributedString(string: String(format: "0:%02d ", Int(string)), attributes: [.font: lmFontR(12), .foregroundColor: lmColorHex("#FFFFFF8F")]))
            self?.statuslb.attributedText = att
        }
        return rec
    }()
    lazy var contentlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#FFFFFFB8"))
            .numberOfLines(0)
            .textAlignment(.center)
            .lmtext("正在编译你的声音诗篇\n97%拟真度声线已抵达耳蜗末梢")
        return lb
    }()
    lazy var sublb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: lmColorHex("#FFFFFFB8"))
            .numberOfLines(0)
            .textAlignment(.center)
            .lmtext("唱首歌\n说件有趣的事\n喜欢的句子\n...")
        return lb
    }()
    lazy var statuslb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#FFFFFF8F"))
            .textAlignment(.center)
            .lmtext("点击录制")
        return lb
    }()
    lazy var starbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "user_voice_star"), target: self, action: #selector(starRecoed))
            .backgroundColor(lmColorHex("#FF4F7DFF"))
            .cornerRadius(kScaleWidth(44), borderColor: lmColorHex("#FFFFFF3D"), borderWidth: 4)
        return btn
    }()
    lazy var stopbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "user_voice_end"), target: self, action: #selector(endRecoed))
            .backgroundColor(lmColorHex("#FFFFFF"))
            .cornerRadius(kScaleWidth(44), borderColor: lmColorHex("#FF4F7DFF"), borderWidth: 4)
        btn.isHidden = true
        return btn
    }()
    lazy var playbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "user_voice_play"), target: self, action: #selector(playRecoed))
            .backgroundColor(lmColorHex("#FFFFFF"))
            .cornerRadius(kScaleWidth(44), borderColor: lmColorHex("#FF4F7DFF"), borderWidth: 4)
        btn.isHidden = true
        return btn
    }()
    lazy var surebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "user_voice_sure"), target: self, action: #selector(upLoadRecoed))
            .backgroundColor(lmColorHex("#FFFFFF3D"))
            .cornerRadius(kScaleWidth(24))
        btn.isHidden = true
        return btn
    }()
    lazy var delebtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "user_voice_re"), target: self, action: #selector(resetRecoed))
            .backgroundColor(lmColorHex("#FFFFFF3D"))
            .cornerRadius(kScaleWidth(24))
        btn.isHidden = true
        return btn
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
    private func setViewSnp() {
        let btn = UIButton(image: UIImage(named: "cm_back_white"), target: self, action: #selector(backItemDidiClick))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        title = "我的声音"
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#0000008F")
        view.addSubview(bodyimv)
        view.addSubview(starbtn)
        view.addSubview(stopbtn)
        view.addSubview(playbtn)
        view.addSubview(surebtn)
        view.addSubview(delebtn)
        view.addSubview(statuslb)
        view.addSubview(contentlb)
        view.addSubview(sublb)
        contentlb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(60) + kNavigationHeight)
        }
        sublb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(148) + kNavigationHeight)
        }
        starbtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(kScaleWidth(116) + kTabBarSafeHeight))
            make.size.equalTo(CGSize(width: kScaleWidth(88), height: kScaleWidth(88)))
        }
        stopbtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(kScaleWidth(116) + kTabBarSafeHeight))
            make.size.equalTo(CGSize(width: kScaleWidth(88), height: kScaleWidth(88)))
        }
        playbtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(kScaleWidth(116) + kTabBarSafeHeight))
            make.size.equalTo(CGSize(width: kScaleWidth(88), height: kScaleWidth(88)))
        }
        surebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(59))
            make.centerY.equalTo(playbtn.snp.centerY)
            make.size.equalTo(CGSize(width: kScaleWidth(48), height: kScaleWidth(48)))
        }
        delebtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(59))
            make.centerY.equalTo(playbtn.snp.centerY)
            make.size.equalTo(CGSize(width: kScaleWidth(48), height: kScaleWidth(48)))
        }
        statuslb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(kScaleWidth(80) + kTabBarSafeHeight))
        }
    }
    @objc func backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
    func setDataSoure() {
    }
    @objc func starRecoed() {
        starbtn.isHidden = true
        stopbtn.isHidden = false
        voicePath = ""
        rec.set_upRecorder()
        rec.doRecord()
    }
    @objc func endRecoed() {
        stopbtn.isHidden = true
        playbtn.isHidden = false
        surebtn.isHidden = false
        delebtn.isHidden = false
        rec.doStop()
        let att = NSMutableAttributedString(string: "点击试听")
        att.append(NSAttributedString(string: String(format: "0:%02d ", voiceSec), attributes: [.font: lmFontR(12), .foregroundColor: lmColorHex("#FFFFFF8F")]))
        self.statuslb.attributedText = att
    }
    @objc func playRecoed() {
        LMAudioPlayer.shared.playRecordAudio(url: URL(fileURLWithPath: voicePath))
    }
    @objc func upLoadRecoed() {
        upLoadVoice(url: voicePath, sec: voiceSec)
    }
    @objc func resetRecoed() {
        stopbtn.isHidden = true
        playbtn.isHidden = true
        surebtn.isHidden = true
        delebtn.isHidden = true
        starbtn.isHidden = false
        voicePath = ""
        let att = NSMutableAttributedString(string: "点击录制")
        self.statuslb.attributedText = att
    }
    func upLoadVoice(url: String, sec: Int) {
        HUD.showLoading("上传中...")
        var filedata: Data = FileManager.default.contents(atPath: url)!
        UpLoadNetWork.UpToken(uploadSource: 4).lmrequest { responseModel in
            guard let token = (responseModel.data as? [String: Any])?["token"] as? String,
                  let prefix = (responseModel.data as? [String: Any])?["prefix"] as? String else {
                HUD.hide()
                return
            }
            let key = prefix + "\(Int(Date().timeIntervalSince1970*1000))" + ".m4a"
            guard let upManager = QNUploadManager() else {
                HUD.hide()
                return
            }
            upManager.put(filedata, key: key, token: token, complete: { _, key, _ in
                if let key = key {
                    let voiceUrl = AppConfig.URL.resource + key
                    UserNetWork.updateUserInfo(voiceUrl: voiceUrl, voiceSec: sec).lmrequest {[weak self] _ in
                        guard let self = self else { HUD.hide(); return }
                        HUD.show("上传成功")
                        self.navigationController?.popViewController(animated: true)
                    } failureBlock: { error in
                        HUD.showFailure(error.message)
                    }
                } else {
                    HUD.showFailure("上传失败")
                }
            }, option: nil)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
