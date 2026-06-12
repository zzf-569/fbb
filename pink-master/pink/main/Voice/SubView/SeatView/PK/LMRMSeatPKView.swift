import UIKit
class LMRMSeatPKView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var blueRankView:LMRMSeatPKRankView = {
        let view = LMRMSeatPKRankView(frame: .zero, alignment: .left)
        return view
    }()
    private lazy var backimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_pk_seatbg"))
        return imv
    }()
    private lazy var redRankView:LMRMSeatPKRankView = {
        let view = LMRMSeatPKRankView(frame: .zero, alignment: .right)
        return view
    }()
    lazy var progressView:LMRMSeatPkProgressView = {
        let view = LMRMSeatPkProgressView()
        return view
    }()
    func set_PKValue(_ pkViewModel:LMRMPKViewModel) {
        blueRankView.setDataSoure(pkViewModel.dataSoure.campValueMap?.blue.topAvatarList ?? [])
        redRankView.setDataSoure(pkViewModel.dataSoure.campValueMap?.red.topAvatarList ?? [])
        progressView.set_Progress(leftProgress: pkViewModel.dataSoure.campValueMap?.blue.pkValue ?? 0, rightProgress: pkViewModel.dataSoure.campValueMap?.red.pkValue ?? 0)
    }
    func set_upPkSubviews(_ viewModel:VoiceVM) {
        if viewModel.roomItem.roomType == .normal || viewModel.roomItem.roomType == .party {
            addSubview(blueRankView)
            addSubview(backimv)
            addSubview(redRankView)
            addSubview(progressView)
            backimv.snp.makeConstraints { make in
                make.left.right.equalToSuperview().offset(0)
                make.top.equalToSuperview().offset(0)
                make.height.equalTo(228.0)
                make.width.equalTo(kScreenWidth)
            }
            progressView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(0)
                make.right.equalToSuperview().offset(0)
                make.bottom.equalToSuperview().offset(0.0)
                make.height.equalTo(62.0)
            }
            blueRankView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(8)
                make.bottom.equalTo(progressView.snp.bottom).offset(0)
                make.width.equalTo(28 * 3)
                make.height.equalTo(28.0)
            }
            redRankView.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-8)
                make.bottom.equalTo(progressView.snp.bottom).offset(0)
                make.width.equalTo(28 * 3)
                make.height.equalTo(28.0)
            }
        }
    }
}
private extension LMRMSeatPKView {
    private func setViewSnp() {
    }
}
