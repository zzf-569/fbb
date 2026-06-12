import UIKit
import APNGKit
import FLAnimatedImage
class LMRMSeatItemView: UIView {
    struct seatItems {
        let volumeSize: CGSize
        let headwearSize: CGSize
        let userHaederSize: CGSize
        let avatarAndNameInterval: Double
        let nameFont: UIFont
        let nameHeight: Double
        let nameAndValueInterval: Double
        let valueFont: UIFont
        let valueHeight: Double
        let volumeInterval: Double
        static func gmSeatIndexView() ->seatItems {
            seatItems(volumeSize: CGSize(width: 40.0, height: 40.0), headwearSize: CGSize(width: 36.0, height: 36.0), userHaederSize: CGSize(width: 30.0, height: 30.0), avatarAndNameInterval: 1.0, nameFont: lmFontM(8), nameHeight: 12.0, nameAndValueInterval: 0, valueFont: lmFontM(10), valueHeight: 0.0, volumeInterval: 0)
        }
        static func pdHostIndeView() ->seatItems {
            seatItems(volumeSize: CGSize(width: 80.0, height: 80.0), headwearSize: CGSize(width: 72.0, height: 72.0), userHaederSize: CGSize(width: 56.0, height: 56.0), avatarAndNameInterval: 4.0, nameFont: lmFontM(12), nameHeight: 20.0, nameAndValueInterval: -2.0, valueFont: lmFontM(10), valueHeight: 14.0, volumeInterval: 0.0)
        }
        static func pdbottomIndexView() ->seatItems {
            seatItems(volumeSize: CGSize(width: 44.0, height: 44.0), headwearSize: CGSize(width: 44.0, height: 44.0), userHaederSize: CGSize(width: 32.0, height: 32.0), avatarAndNameInterval: 8.0, nameFont: lmFontM(8), nameHeight: 12.0, nameAndValueInterval: -2.0, valueFont: lmFontM(10), valueHeight: 14.0, volumeInterval: 0.0)
        }
        static func nomalIndexView() ->seatItems {
            seatItems(volumeSize: CGSize(width: 80.0, height: 80.0), headwearSize: CGSize(width: 72.0, height: 72.0), userHaederSize: CGSize(width: 56.0, height: 56.0), avatarAndNameInterval: 4.0, nameFont: lmFontM(10), nameHeight: 16.0, nameAndValueInterval: -2.0, valueFont: lmFontM(8), valueHeight: 11.0, volumeInterval: 0.0)
        }
        static func hostIndexView() ->seatItems {
            seatItems(volumeSize: CGSize(width: 36.0, height: 36.0), headwearSize: CGSize(width: 36.0, height: 36.0), userHaederSize: CGSize(width: 28.0, height: 28.0), avatarAndNameInterval: 10.0, nameFont: lmFontM(14), nameHeight: 22.0, nameAndValueInterval: 0.0, valueFont: lmFontM(10), valueHeight: 16.0, volumeInterval: 0.0)
        }
    }
    func playEmoji(_ model: LMEmojiListModel) {
        LMDownloadManager().downloadEmoji(emojiId: model.id, url: model.animationUrl) { [weak self] url, _ in
            guard let self = self else { return }
            guard let url = url else { return }
            DispatchQueue.main {
                if model.animationUrl.hasSuffix(LMDownloadFileType.apng.rawValue) {
                    do {
                        let image = try APNGImage(fileURL: url)
                        image.numberOfPlays = 2
                        self.emojiView.image = image
                        self.emojiView.autoStartAnimationWhenSetImage = true
                    } catch {
                    }
                }
                if model.animationUrl.hasSuffix(LMDownloadFileType.gif.rawValue) {
                    do {
                        let data = try Data(contentsOf: url)
                        let image = FLAnimatedImage(gifData: data)
                        self.gifEmojiView.animatedImage = image
                    } catch {
                    }
                }
            }
        }
    }
    func playVolume(_ volume: Int) {
        if volume > 10 {
            guard let path = Bundle.main.path(forResource: "voice_volume", ofType: "pag") else { return }
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(stopVolumeAnimation), object: nil)
            if let user = self.user {
                if !self.volumeView.isPlaying {
                    if user.soundByte.isEmpty == false {
                        self.volumeView.play(url: user.soundByte, repeatCount: 0)
                    } else {
                        self.volumeView.play(path: path, repeatCount: 0)
                    }
                }
            } else {
                if !self.volumeView.isPlaying {
                    self.volumeView.play(path: path, repeatCount: 0)
                }
            }
            self.perform(#selector(stopVolumeAnimation), with: nil, afterDelay: 1.0)
        }
    }
    @objc func stopVolumeAnimation() {
        self.volumeView.clear()
    }
    let set_:seatItems
    var seatIndex = 0
    lazy var volumeView: LMAnimationPlayer = {
        let volume = LMAnimationPlayer()
        return volume
    }()
    private lazy var headwearimv: LMAnimationPlayer = {
        let volume = LMAnimationPlayer()
        return volume
    }()
    lazy var userusheaderView: UIImageView = {
        let imv = UIImageView()
            .contentMode(.scaleAspectFill)
            .cornerRadius(set_.userHaederSize.width/2)
        return imv
    }()
    private lazy var bossimv: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    private lazy var emojiView: APNGImageView = {
        let apngView = APNGImageView()
        apngView.isUserInteractionEnabled = false
        apngView.backgroundColor(.clear)
        apngView.onOnePlayDone.delegate(on: self) { (_, count) in
            lmPrint("played: \(count)")
        }
        apngView.onAllPlaysDone.delegate(on: self) { (self, _) in
            self.emojiView.image = nil
        }
        apngView.onDecodingFrameError.delegate(on: self) { (self, _) in
            self.emojiView.image = nil
        }
        return apngView
    }()
    private lazy var gifEmojiView: FLAnimatedImageView = {
        let giftView = FLAnimatedImageView()
        giftView.isUserInteractionEnabled = false
        giftView.backgroundColor = .clear
        return giftView
    }()
   
    private var user:LMSeatusInfoModel?
    init(_ set_:seatItems, frame: CGRect = CGRect.zero) {
        self.set_ = set_
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setViewSnp() {
        self.addSubview(self.volumeView)
        self.addSubview(self.userusheaderView)
        self.addSubview(self.headwearimv)
        self.addSubview(self.bossimv)
        self.addSubview(self.emojiView)
        self.addSubview(self.gifEmojiView)
        self.volumeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(set_.volumeInterval)
            make.size.equalTo(set_.volumeSize)
        }
        self.headwearimv.snp.makeConstraints { make in
            make.center.equalTo(self.userusheaderView)
            make.size.equalTo(set_.headwearSize)
        }
        
        self.userusheaderView.snp.makeConstraints { make in
            make.center.equalTo(self.volumeView)
            make.size.equalTo(set_.userHaederSize)
        }
        self.bossimv.snp.makeConstraints { make in
            make.center.equalTo(self.userusheaderView)
            make.size.equalTo(self.userusheaderView)
        }
        self.emojiView.snp.makeConstraints { make in
            make.edges.equalTo(self.userusheaderView)
        }
        self.gifEmojiView.snp.makeConstraints { make in
            make.edges.equalTo(self.userusheaderView)
        }
    }
    func setDataSoure(_ item:RoomSeatItem) {
        self.seatIndex = item.seatIndex
        guard let user = item.userInfo else {
            self.user = nil
            self.userusheaderView.image = item.locked ? UIImage(named: "rm_seat_lock") : UIImage(named: "rm_seat")
            self.headwearimv.clear()
            if item.seatIndex == 8 {
                self.userusheaderView.isHidden = true
                if item.locked {
                    bossimv.image = nil
                } else {
                    bossimv.image = UIImage(named: "rm_seat_boss")
                }
            }
            return
        }
        if user.headWear.isEmpty == false {
            if self.user?.headWear != user.headWear {
                self.headwearimv.play(url: user.headWear, repeatCount: 0)
            }
        } else {
            self.headwearimv.clear()
        }
        
        self.user = user
        self.userusheaderView.set_Image(url: user.avatar)
        if item.seatIndex == 8 {
            self.userusheaderView.isHidden = false
            bossimv.image = UIImage(named: "rm_seat_boss_user")
        }
    }
}
