import Foundation
import AVFoundation
enum LMRecorderState {
    case prepareToRecord
    case recording
    case pause
    case stop
    case finish
    case failed(Error)
}
class LMAudioRecorder: NSObject {
    private var recorder: AVAudioRecorder?
    private var meterTimer: Timer?
    private var currentTimeInterval: TimeInterval = 0.0
    var recorderStateChangeHandler: ((LMRecorderState) -> Void)?
    var timeIntervalHandler: ((TimeInterval) -> Void)?
    var recorderEndChangeHandler: ((String) -> Void)?
    var isRecording: Bool {
        return self.recorder?.isRecording ?? false
    }
    override init() {
        super.init()
    }
    func set_upRecorder() {
        do {
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
                AVLinearPCMBitDepthKey: 16
            ]
            let filename = "/\(Int(Date().timeIntervalSince1970*1000)).m4a"
            let filePath = FileManager.DocumnetsDirectory() + filename
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
            recorder = try AVAudioRecorder(url: NSURL(string: filePath)! as URL, settings: settings)
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
            recorderStateChangeHandler?(.prepareToRecord)
        } catch let error {
            recorderStateChangeHandler?(.failed(error))
        }
    }
    @objc private func updateAudioMeter(timer: Timer) {
        guard let recorder = recorder else { return }
        if recorder.isRecording {
            if currentTimeInterval >= 60.0 {
                meterTimer?.invalidate()
                doStop()
                return
            }
            currentTimeInterval = currentTimeInterval + 1
            recorder.updateMeters()
            timeIntervalHandler?(recorder.currentTime)
        } else {
            meterTimer?.invalidate()
        }
    }
    func doRecord() {
        guard let recorder = recorder else { return }
        if recorder.isRecording {
            doStop()
        }
        recorder.record()
        recorder.updateMeters()
        currentTimeInterval = 0.0
        meterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateAudioMeter(timer:)), userInfo: nil, repeats: true)
        recorderStateChangeHandler?(.recording)
    }
    func doStop() {
        currentTimeInterval = 0
        guard let recorder = recorder else { return }
        guard recorder.isRecording else { return }
        do {
            recorder.stop()
            try AVAudioSession.sharedInstance().setActive(false)
            meterTimer?.invalidate()
            recorderStateChangeHandler?(.finish)
            guard let path = self.recorder?.url.absoluteString else { return }
            recorderEndChangeHandler?(path)
        } catch {
            recorder.stop()
            meterTimer?.invalidate()
            guard let path = self.recorder?.url.absoluteString else { return }
            recorderStateChangeHandler?(.finish)
            recorderEndChangeHandler?(path)
        }
    }
    func doPause() {
        guard let recorder = recorder else { return }
        guard recorder.isRecording else { return }
        recorder.pause()
        meterTimer?.invalidate()
        recorderStateChangeHandler?(.pause)
    }
    func doResume() {
        guard recorder != nil else { return }
        if recorder?.isRecording ?? true {
            self.doStop()
        }
        recorder?.record()
        meterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateAudioMeter(timer:)), userInfo: nil, repeats: true)
        recorderStateChangeHandler?(.recording)
    }
    func destory() {
        currentTimeInterval = 0
        meterTimer?.invalidate()
        recorder?.stop()
        recorder = nil
    }
}
extension LMAudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            recorderStateChangeHandler?(.finish)
        } else {
            doStop()
        }
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let e = error {
            recorderStateChangeHandler?(.failed(e))
        } else {
            doStop()
        }
    }
}
