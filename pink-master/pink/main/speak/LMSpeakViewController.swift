import UIKit
import DanmakuKit
class LMSpeakViewController: UIViewController {
    private var timer: Timer?
    private var index = 0
    var dataList: [String] = []
    lazy var danmakuView: DanmakuView = {
        let danmakuView = DanmakuView(frame: CGRect(x: 0, y: kScaleWidth(240), width: kScreenWidth, height: kScaleWidth(208)))
        danmakuView.trackHeight = 40
        view.addSubview(danmakuView)
        return danmakuView
    }()
    lazy var speakBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "speak_sp"), for: .normal)
        btn.addTarget(self, action: #selector(act_send), for: .touchUpInside)
        return btn
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        act_setData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setViewSnp()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    func setViewSnp() {
        let bgImage = UIImageView(image: UIImage(named: "speak_bg"))
        bgImage.frame = self.view.bounds
        view.addSubview(bgImage)
        view.addSubview(speakBtn)
        speakBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(kScaleWidth(58) + kTabBarHeight + kTabBarSafeHeight))
        }
    }
    func act_starTimer() {
        danmakuView.play()
        timer = Timer.scheduledTimer(timeInterval: 1, repeats: true, block: { timer in
        })
    }
    func act_setData() {
        self.timer?.invalidate()
        self.timer = nil
        CommonNetWork.getSpeak().lmrequest { responseModel in
            guard let model = responseModel.data as? [[String: Any]] else { return }
            self.dataList = model.map{$0["content"] as! String}
            self.index = 0
            self.act_starTimer()
        } failureBlock: { error in
        }
    }
    @objc func act_send() {
        let view = LMSpeakPopView(frame: self.view.bounds)
        view.compate = {[weak self] string in
            CommonNetWork.sendSpeak(content: string).lmrequest { responseModel in
            } failureBlock: { error in
            }
        }
        AppConfig.keyWindow.addSubview(view)
    }
}
