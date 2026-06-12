import UIKit
extension SuiteAnimationView {
    func addAnimation(_ model: SuiteAnimationModel) {
        self.dataSource.append(model)
        if !aniplayer.isPlaying {
            playnext()
        }
    }
    func reConfigUI() {
        self.dataSource.removeAll()
        aniplayer.clear()
    }
}
class SuiteAnimationView: UIView {
    private var dataSource: [SuiteAnimationModel] = []
    private lazy var aniplayer: LMAnimationPlayer = {
        let player = LMAnimationPlayer(frame: self.bounds)
        player.delegate = self
        return player
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension SuiteAnimationView {
    private func setViewSnp() {
        addSubview(aniplayer)
    }
    func playnext() {
        if let nextModel = self.dataSource.first {
            aniplayer.play(url: nextModel.animationUrl, repeatCount: 1)
        }
    }
}
extension SuiteAnimationView: LMAnimationPlayerDelegate {
    func playerDidFinish(_ player: LMAnimationPlayer) {
        if self.dataSource.first != nil {
            dataSource.removeFirst()
            playnext()
        }
    }
}
