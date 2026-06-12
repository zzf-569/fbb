import UIKit
extension LMRMSeatBasePKView {
    func set_PkStatus(_ viewModel:VoiceVM, pkViewModel: LMRMPKViewModel?) {
        guard let pkViewModel = pkViewModel else {
            initNormalUI()
            return
        }
        switch pkViewModel.dataSoure.status {
        case .normal, .close:
            initNormalUI()
        case .open:
            initStartUI(viewModel)
        case .start:
            initPKUI(viewModel)
        case .end:
            initEndUI(viewModel, pkViewModel: pkViewModel)
        }
    }
    func set_PKValue(_ pkViewModel:LMRMPKViewModel) {
        if let pkview = self.pkview {
            pkview.set_PKValue(pkViewModel)
        }
    }
    func set_PKCountDown(_ time: String) {
        if time == "00:03" {
            endAnimation()
        }
        pkview?.progressView.set_Title(title: time)
    }
}
class LMRMSeatBasePKView:LMSeatBaseView {
    private var pkview:LMRMSeatPKView?
    private var pkbtn: UIButton?
    private var blueResultimv: UIImageView?
    private var redResultimv: UIImageView?
    private var hatSeat:RoomSeatItem?
}
private extension LMRMSeatBasePKView {
    func initNormalUI() {
        pkview?.removeFromSuperview()
        pkview = nil
        pkbtn?.removeFromSuperview()
        pkbtn = nil
        blueResultimv?.removeFromSuperview()
        redResultimv?.removeFromSuperview()
    }
    func initStartUI(_ viewModel:VoiceVM) {
        pkbtn?.removeFromSuperview()
        pkbtn = nil
        blueResultimv?.removeFromSuperview()
        redResultimv?.removeFromSuperview()
        if pkview == nil {
            let pkview = LMRMSeatPKView()
            insertSubview(pkview, at: 0)
            pkview.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            pkview.set_upPkSubviews(viewModel)
            self.pkview = pkview
        }
        pkview?.progressView.set_Title(title: "准备阶段")
        guard viewModel.roomItem.role != .audience else {
            return
        }
    }
    func initPKUI(_ viewModel:VoiceVM) {
        pkbtn?.removeFromSuperview()
        pkbtn = nil
        blueResultimv?.removeFromSuperview()
        redResultimv?.removeFromSuperview()
        if pkview == nil {
            let pkview = LMRMSeatPKView()
            insertSubview(pkview, at: 0)
            pkview.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            pkview.set_upPkSubviews(viewModel)
            self.pkview = pkview
        }
        startAnimation()
        guard viewModel.roomItem.role != .audience else {
            return
        }
    }
    func initEndUI(_ viewModel:VoiceVM, pkViewModel:LMRMPKViewModel?) {
        pkbtn?.removeFromSuperview()
        pkbtn = nil
        blueResultimv?.removeFromSuperview()
        redResultimv?.removeFromSuperview()
        if pkview == nil {
            let pkview = LMRMSeatPKView()
            insertSubview(pkview, at: 0)
            pkview.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            pkview.set_upPkSubviews(viewModel)
            self.pkview = pkview
        }
        pkview?.progressView.set_Title(title: "惩罚时间")
        let blueResultimv = UIImageView()
        addSubview(blueResultimv)
        let redResultimv = UIImageView()
        addSubview(redResultimv)
        let width = 72.0
        let left = ((kScreenWidth / 2) - width) / 2
        let top = 44.0
        blueResultimv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(left)
            make.top.equalToSuperview().offset(top)
            make.width.height.equalTo(width)
        }
        redResultimv.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-left)
            make.top.equalToSuperview().offset(top)
            make.width.height.equalTo(width)
        }
        self.blueResultimv = blueResultimv
        self.redResultimv = redResultimv
        switch pkViewModel?.dataSoure.result {
        case .dogfall:
            blueResultimv.image(UIImage(named: "rm_pk_pingcent"))
            redResultimv.image(UIImage(named: "rm_pk_pingcent"))
        case .blue:
            blueResultimv.image(UIImage(named: "rm_pk_win"))
            redResultimv.image(UIImage(named: "rm_pk_loss"))
        case .red:
            blueResultimv.image(UIImage(named: "rm_pk_loss"))
            redResultimv.image(UIImage(named: "rm_pk_win"))
        case nil:
            lmPrint("")
        }
        guard viewModel.roomItem.role != .audience else {
            return
        }
    }
    @objc func pkbtnAction() {
        Mediator.shared.dispatch(event: LMRMViewMethon.pkDidClickStartOrEndAction, data: "")
    }
    func startAnimation() {
    }
    func endAnimation() {
    }
}
extension LMRMSeatBasePKView: LMAnimationPlayerDelegate {
    func playerDidFinish(_ player: LMAnimationPlayer) {
    }
}
