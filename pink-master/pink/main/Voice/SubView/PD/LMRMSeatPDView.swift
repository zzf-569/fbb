import UIKit
extension LMRMSeatPDView {
    func set_DispatchStatus(_ viewModel:VoiceVM, PDViewModel: LMRMPDViewModel?) {
        self.statusView.set_DispatchStatus(viewModel, PDViewModel: PDViewModel)
    }
    func set_DaRenCount(_ count: Int) {
        auditionbtn.setTitle("麦下达人\(count)", for: .normal)
    }
    func updateAuditionSeatUser(_ seat:RoomSeatItem) {
        statusView.updateAuditionSeatUser(seat)
    }
    func auditionUserDownSeat(_ userId: String) {
        statusView.auditionUserDownSeat(userId)
    }
    func dispatchPlayVolume(_ volume: Int, seatIndex: Int) {
        statusView.playVolume(volume, seatIndex: seatIndex)
    }
    func newUserJoinAuditionSequence(_ viewModel:VoiceVM, PDViewModel: LMRMPDViewModel?) {
        if viewModel.roomItem.role != .audience {
            if PDViewModel?.sequenceList.count ?? 0 > 0 {
                self.sequenceRedPoint.isHidden = false
            } else {
                self.sequenceRedPoint.isHidden = true
            }
        } else {
            self.sequenceRedPoint.isHidden = true
        }
    }
}
class LMRMSeatPDView:LMSeatBaseView {
    private var itemSpacing: Double {
        let contentWidth = 12.0 + 44.0 * 7 + 4.0 * 6 + 12.0
        if contentWidth > kScreenWidth - 24.0 {
            return ((kScreenWidth - 24.0 - 12.0 - 44.0 * 7 - 12.0) / 6)
        }
        return 4.0
    }
    private lazy var statusView:LMRMSeatPDStatusView = {
        let statusView = LMRMSeatPDStatusView()
        return statusView
    }()
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#FFFFFFF5"))
            .lmtext("试音达人")
        return lb
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
            .backgroundColor(.clear)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private lazy var scrollContentView: UIView = {
        let view = UIView()
            .backgroundColor(lmColorHex("#06062399"))
        view.set_Border(radius: 12, borderWidth: 0.5, borderColor: lmColorHex("#FFFFFF80"))
        return view
    }()
    private lazy var auditionbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(8), titleColor: lmColorHex("#FFFFFFF5"), target: self, action: #selector(a_auditionbtnAction))
            .backgroundImage(UIImage(named: "rm_seat_audition_bg"))
        btn.setTitle("麦下达人0", for: .normal)
        btn.titleLabel?.numberOfLines(0)
        btn.titleLabel?.textAlignment(.center)
        return btn
    }()
    private lazy var sequenceRedPoint: UIView = {
        let view = UIView()
            .backgroundColor(lmColorHex("#F5455C"))
            .cornerRadius(10/2)
            .isHidden(true)
        return view
    }()
    override func setViewSnp() {
        super.setViewSnp()
        addSubview(statusView)
        statusView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(4))
            make.width.equalTo(kScreenWidth - 16.0 * 2 - 80.0 * 2 - 12.0 * 2)
            make.height.equalTo(204)
        }
        addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.bottom.equalToSuperview().offset(-68.0)
        }
        addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(titleLab.snp.bottom).offset(8.0)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(60.0)
        }
        scrollContentView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(60.0)
            make.width.equalTo(kScreenWidth - 24)
        }
        addSubview(auditionbtn)
        auditionbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-60.0)
            make.height.equalTo(24.0)
        }
        auditionbtn.addSubview(sequenceRedPoint)
        sequenceRedPoint.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.height.equalTo(10.0)
        }
    }
    @objc func a_auditionbtnAction() {
        self.sequenceRedPoint.isHidden = true
        Mediator.shared.dispatch(event: LMRMViewMethon.dRSortAction, data: "")
    }
    override func reConfigUI() {
        super.reConfigUI()
        self.statusView.reConfigUI()
        self.statusView.removeFromSuperview()
        self.titleLab.removeFromSuperview()
        self.scrollView.removeFromSuperview()
        self.auditionbtn.removeFromSuperview()
    }
    override func set_TypeAndSeats(_ seats: [RoomSeatItem]) {
        super.set_TypeAndSeats(seats)
        for (index, seat) in seats.enumerated() {
            if index == 0 || index == 8 {
                let item = LMRMSeatItemPDView(LMRMSeatItemView.seatItems.pdHostIndeView())
                item.tag = index
                self.addSubview(item)
                item.snp.makeConstraints { make in
                    if index == 0 {
                        make.left.equalToSuperview().offset(16.0)
                    } else {
                        make.right.equalToSuperview().offset(-16.0)
                    }
                    make.top.equalToSuperview().offset(60)
                    make.width.equalTo(80.0)
                    make.height.equalTo(94.0)
                }
                item.setDataSoure(seat)
                item.addGestureTap { [weak self] tap in
                    guard let self = self else { return }
                    if let view = tap.view {
                        Mediator.shared.dispatch(event: LMRMViewMethon.seatClickAction, data: ["seatIndex": view.tag, "seatView": view])
                    }
                }
                items.append(item)
            } else {
                let itemWidth = 44.0
                let itemHeight = 4.0 + 36.0 + 8.0 + 12.0
                let item = LMRMSeatItemPDView(LMRMSeatItemView.seatItems.pdbottomIndexView())
                item.tag = index
                scrollContentView.addSubview(item)
                let x = 12.0 + Double(index - 1) * itemWidth + Double(index - 1) * itemSpacing
                let y = 6.0
                item.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(x)
                    make.top.equalToSuperview().offset(y)
                    make.width.equalTo(itemWidth)
                    make.height.equalTo(itemHeight)
                }
                item.setDataSoure(seat)
                item.addGestureTap { [weak self] tap in
                    guard let self = self else { return }
                    if let view = tap.view {
                        Mediator.shared.dispatch(event: LMRMViewMethon.seatClickAction, data: ["seatIndex": view.tag, "seatView": view])
                    }
                }
                items.append(item)
            }
        }
    }
}
