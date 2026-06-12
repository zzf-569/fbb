import Foundation
import AVFoundation
enum LMAudioLoopMode {
    case oneTime
    case loopTime
    case some(count: Int)
}
typealias Completeblock = (() -> Void)
class LMAudioPlayer: NSObject {
    static let shared = LMAudioPlayer()
    private override init() {
        super.init()
    }
    private var player = AVAudioPlayer()
    private var loopMode: LMAudioLoopMode = .oneTime
    private var runCount = 1
    private var completeblock: Completeblock?
    var isPlaying: Bool = false
    public func playAudio(url: URL, play: Bool = true, loopMode: LMAudioLoopMode = .oneTime, complete: Completeblock? = nil) {
        LMAudioPlayer.onlyActivePlay()
        self.player.stop()
        self.loopMode = loopMode
        self.runCount = 0 
        self.completeblock = complete
        let task = URLSession.shared.dataTask(with: url) {[weak self] (data, _, error) in
            guard let data = data, let self = self else {
                print("播放音频失败")
                return
            }
            do {
                player = try AVAudioPlayer(data: data)
                player.delegate = self
                if play {
                    let success = player.play()
                    if success {
                        print("播放音频成功")
                        self.isPlaying = true
                    } else {
                        print("播放音频失败")
                        if let block = self.completeblock {
                            block()
                        }
                    }
                }
            } catch let error {
                print("播放音频失败：\(error.localizedDescription)")
                if let block = self.completeblock {
                    block()
                }
            }
        }
        task.resume()  
    }
    func playRecordAudio(url: URL, play: Bool = true, loopMode: LMAudioLoopMode = .oneTime, complete: Completeblock? = nil) {
        self.player.stop()
        self.loopMode = loopMode
        self.runCount = 0 
        self.completeblock = complete
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            if play {
                let success = player.play()
                if success {
                    print("播放音频成功")
                } else {
                    print("播放音频失败")
                    if let block = self.completeblock {
                        block()
                    }
                }
            }
        } catch let error {
            print("播放音频失败：\(error.localizedDescription)")
            if let block = self.completeblock {
                block()
            }
        }
    }
    func playAudio(forResource: String, ofType: String, play: Bool = true, loopMode: LMAudioLoopMode = .oneTime, complete: Completeblock? = nil) {
        if let bundlePath = Bundle.main.path(forResource: forResource, ofType: ofType) {
            if #available(iOS 16.0, *) {
                let url = URL(filePath: bundlePath)
                playAudio(url: url, play: play, loopMode: loopMode, complete: complete)
            } else {
                let url = URL(fileURLWithPath: bundlePath)
                playAudio(url: url, play: play, loopMode: loopMode, complete: complete)
            }
        } else {
            print("播放音频失败：路径错误")
            if let block = complete {
                block()
            }
        }
    }
    func playAudio(url str: String, play: Bool = true, loopMode: LMAudioLoopMode = .oneTime, complete: Completeblock? = nil) {
        guard let url = URL(string: str) else {
            print("播放音频失败：url错误")
            if let block = complete {
                block()
            }
            return
        }
        playAudio(url: url, play: play, loopMode: loopMode, complete: complete)
    }
    func play() {
        player.play()
        isPlaying = true
    }
    func pause() {
        player.pause()
        isPlaying = false
    }
    func stop() {
        player.stop()
        isPlaying = false
    }
}
extension LMAudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        switch self.loopMode {
        case .oneTime:
            if let block = self.completeblock {
                block()
            }
        case .loopTime:
            play()
        case .some(let count):
            self.runCount += 1
            if count == self.runCount {
                if let block = self.completeblock {
                    block()
                    isPlaying = true
                }
            }
        }
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("解码错误：\(error?.localizedDescription ?? "")")
        if let block = self.completeblock {
            block()
        }
    }
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
    }
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        if flags == 1 {
            player.play()
        }
    }
}
extension LMAudioPlayer {
    static func notAffectedBackgroundPlay() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, options: [.mixWithOthers, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        }
    }
    static func onlyActivePlay() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        }
    }
}
