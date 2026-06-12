import UIKit
public protocol LMAnimationPlayerDelegate: NSObjectProtocol {
    func playerDidFinish(_ player: LMAnimationPlayer)
}
public extension LMAnimationPlayer {
    func play(url: String, repeatCount: Int, endClear: Bool = true) {
        isDownload = true
        if url.isEmpty == true {
            clear()
            return
        }
        LMDownloadManager().downloadAnimation(url: url) { [weak self] url, error in
            guard let self = self else { return }
            if let error = error {
                print("下载失败: \(error)")
                self.isDownload = false
                self.delegate?.playerDidFinish(self)
            } else {
                guard let path = url?.path else {
                    self.isDownload = false
                    self.delegate?.playerDidFinish(self)
                    return
                }
                print("下载成功")
                DispatchQueue.main {
                    self.play(path: path, repeatCount: repeatCount, endClear: endClear)
                }
            }
        }
    }
    func play(fileName: String, fileType: String?, repeatCount: Int, endClear: Bool = true) {
        let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
        if let filepath = filepath {
            play(path: filepath, repeatCount: repeatCount, endClear: endClear)
        } else {
            delegate?.playerDidFinish(self)
        }
    }
    func play(path: String, repeatCount: Int, endClear: Bool = true) {
        clear()
        self.endClear = endClear
        if path.hasSuffix(LMDownloadFileType.pag.rawValue) {
            pagView = PAGView(frame: self.bounds)
            pagView?.add(self)
            addSubview(pagView!)
            pagView!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            pagView!.setPath(path)
            pagView!.setRepeatCount(Int32(repeatCount))
            pagView!.play()
        }
        if path.hasSuffix(LMDownloadFileType.vap.rawValue) {
            vapView = UIView(frame: self.bounds)
            self.addSubview(vapView!)
            vapView!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            vapView!.center = self.center
            vapView!.hwd_enterBackgroundOP = .doNothing
            vapView?.enableOldVersion(true)
            vapView!.playHWDMP4(path, repeatCount: repeatCount <= 0 ? -1 : repeatCount-1, delegate: self)
        }
        isDownload = false
    }
    func clear() {
        if pagView != nil {
            pagView?.stop()
            pagView?.removeFromSuperview()
            pagView = nil
        }
        if vapView != nil {
            vapView?.stopHWDMP4()
            vapView?.removeFromSuperview()
            vapView = nil
        }
    }
}
open class LMAnimationPlayer: UIView {
    weak var delegate: LMAnimationPlayerDelegate?
    public var isPlaying: Bool {
        if isDownload {
            return isDownload
        }
        if self.pagView != nil {
            return self.pagView!.isPlaying()
        }
        if self.vapView != nil {
            return true
        }
        return false
    }
    public var endClear: Bool = true
    private var isDownload: Bool = false
    private var pagView: PAGView?
    private var vapView: UIView?
    private var playUrl: String = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMAnimationPlayer {
    private func setViewSnp() {
    }
}
extension LMAnimationPlayer: HWDMP4PlayDelegate {
    public func shouldStartPlayMP4(_ container: UIView!, config: QGVAPConfigModel!) -> Bool {
        true
    }
    public func viewDidStartPlayMP4(_ container: UIView!) {
    }
    public func viewDidStopPlayMP4(_ lastFrameIndex: Int, view container: UIView!) {
        lmPrint("----------------viewDidStopPlayMP4")
        DispatchQueue.main {
            if self.endClear {
                self.vapView?.removeFromSuperview()
                self.vapView = nil
            }
            self.delegate?.playerDidFinish(self)
        }
    }
    public func viewDidFinishPlayMP4(_ totalFrameCount: Int, view container: UIView!) {
        lmPrint("----------------viewDidFinishPlayMP4")
    }
    public func viewDidFailPlayMP4(_ error: (any Error)!) {
        lmPrint("播放vap动效失败\(String(describing: error))")
        DispatchQueue.main {
            self.vapView?.removeFromSuperview()
            self.vapView = nil
            self.delegate?.playerDidFinish(self)
        }
    }
}
extension LMAnimationPlayer: PAGViewListener {
    public func onAnimationStart(_ pagView: PAGView!) {
    }
    public func onAnimationEnd(_ pagView: PAGView!) {
        DispatchQueue.main {
            if self.endClear {
                self.pagView?.removeFromSuperview()
                self.pagView = nil
            }
            self.delegate?.playerDidFinish(self)
        }
    }
    public func onAnimationRepeat(_ pagView: PAGView!) {
    }
    public func onAnimationUpdate(_ pagView: PAGView!) {
    }
}
