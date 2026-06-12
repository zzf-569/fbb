import UIKit
import AVFoundation
class SuiteBackGroundView: UIView {
    lazy var backImage: UIImageView = {
        let imageV = UIImageView(frame: self.bounds)
            .contentMode(.scaleAspectFill)
            .image(UIImage(named: "rm_normal_bg"))
        return imageV
    }()
    lazy var playerView: UIView = {
        let view = UIView(frame: self.bounds)
        return view
    }()
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        backgroundColor(.clear)
        addSubview(backImage)
    }
    @objc func playerDidFinishPlaying() {
        player?.seek(to: .zero) 
        player?.play()
    }
    func setDataSoure(url: String, placeholder: String) {
        if url.isEmpty == true {
            self.backImage.set_Image(url: url, placeholder: UIImage(named: placeholder))
            self.clearInit()
            return
        }
        self.backImage.image = UIImage(named: placeholder)
        if url.hasSuffix(LMDownloadFileType.vap.rawValue) {
            LMDownloadManager().downloadAnimation(url: url) { pathurl, _ in
                guard let path = pathurl else {
                    return
                }
                self.player = AVPlayer(url: path)
                self.playerLayer = AVPlayerLayer(player: self.player)
                self.playerView.removeFromSuperview()
                self.playerLayer?.frame = self.bounds
                self.playerLayer?.videoGravity = .resizeAspectFill 
                if let playerLayer = self.playerLayer {
                    DispatchQueue.main {
                        self.addSubview(self.playerView)
                        self.playerView.layer.addSublayer(playerLayer)
                    }
                }
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(self.playerDidFinishPlaying),
                                                       name: .AVPlayerItemDidPlayToEndTime,
                                                       object: self.player?.currentItem)
                self.player?.play()
            }
        } else {
            self.clearInit()
            self.backImage.isHidden = false
            self.backImage.set_Image(url: url, placeholder: UIImage(named: placeholder))
        }
    }
    func clearInit() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: self.player?.currentItem)
        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
        self.player = nil
        self.playerView.removeFromSuperview()
    }
}
