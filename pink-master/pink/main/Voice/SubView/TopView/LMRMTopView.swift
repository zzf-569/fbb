import UIKit
class LMRMTopView: UIView {
    lazy var titleImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    lazy var title: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(16), textColor: .white)
        return lb
    }()
    private lazy var idlb: UILabel = {
        let lb = UILabel().textColor(.white).font(lmFontF(10))
            
        return lb
    }()
    private lazy var hotlb: UIButton = {
        let lb = UIButton(lmfont: lmFontM(10), titleColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .image(UIImage(named: "rm_tophot"), .normal)
            .lmtitle("0")
        return lb
    }()
    private lazy var morebtn: UIButton = {
        let btn = UIButton(type: .custom)
            .image(UIImage(named: "rm_topmore"), .normal)
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.clickMoreAction, data: "")
        }
        return btn
    }()
   
    private lazy var collectbtn: UIButton = {
        let btn = UIButton(type: .custom)
            .image(UIImage(named: "rm_topcollect"), .normal)
            .image(UIImage(named: "rm_topcollect_s"), .selected)
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.topCollectAction, data: "")
            btn.isSelected = !btn.isSelected
        }
        return btn
    }()
    
    
    private lazy var sharebtn: UIButton = {
        let btn = UIButton(type: .custom)
            .image(UIImage(named: "rm_topShare"), .normal)
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.topCollectAction, data: "")
            btn.isSelected = !btn.isSelected
        }
        return btn
    }()
    
    private lazy var closebtn: UIButton = {
        let btn = UIButton(type: .custom)
            .image(UIImage(named: "rm_topClose"), .normal)
        btn.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            Mediator.shared.dispatch(event: LMRMViewMethon.topCollectAction, data: "")
            btn.isSelected = !btn.isSelected
        }
        return btn
    }()
   
    lazy var onlineView: LMUserAvatarGroupView = {
        let view = LMUserAvatarGroupView()
        return view
    }()
  
    var roomItem:RoomItem?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LMRMTopView {
    func reConfigUI() {
        
    }
    
    func setDataSoure(_ room:RoomItem) {
        titleImage.set_Image(url: room.cover)
        title.text = room.roomName
        self.roomItem = room
        let idText = "ID·\(room.showRoomId)"
        let idWidth = idText.singleLineWidth(lmfont: lmFontM(10))
        self.idlb.snp.updateConstraints { make in
            make.width.equalTo(idWidth + 16.0)
        }
        self.idlb.text = idText
        let hotText = "Hot No.1"
        let hotWidth = hotText.singleLineWidth(lmfont: lmFontM(10))
        self.hotlb.snp.updateConstraints { make in
            make.width.equalTo(hotWidth + 16.0)
        }
        self.hotlb.lmtitle(hotText)
        
        set_CollectStatus(room.like)
    }
    
    func set_CollectStatus(_ status: Bool) {
        self.collectbtn.isSelected(status)
    }
}
private extension LMRMTopView {
    private func setViewSnp() {
        self.addSubview(self.titleImage)
        self.addSubview(self.title)
        self.addSubview(self.idlb)
        self.addSubview(self.hotlb)
        self.addSubview(self.collectbtn)
        self.addSubview(self.morebtn)
        self.addSubview(self.sharebtn)
        self.addSubview(self.closebtn)
        self.addSubview(self.onlineView)

        titleImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(0)
            make.size.equalTo(CGSize(width: 42, height: 42))
        }
        title.snp.makeConstraints { make in
            make.left.equalTo(titleImage.snp.right).offset(4)
            make.top.equalTo(titleImage)
        }
       
      
        self.idlb.snp.makeConstraints { make in
            make.left.equalTo(self.title.snp.left)
            make.top.equalTo(self.title.snp.bottom)
            make.width.equalTo(16.0)
            make.height.equalTo(16.0)
        }
        self.hotlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.bottom.equalToSuperview()
            make.height.equalTo(14.0)
            make.width.equalTo(14.0)
        }
        self.closebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalToSuperview().offset(2.0)
            make.width.height.equalTo(36.0)
        }
        self.morebtn.snp.makeConstraints { make in
            make.right.equalTo(self.closebtn.snp.left).offset(-16.0)
            make.top.equalToSuperview().offset(2.0)
            make.width.height.equalTo(36.0)
        }
        self.sharebtn.snp.makeConstraints { make in
            make.right.equalTo(self.morebtn.snp.left).offset(-16.0)
            make.top.equalToSuperview().offset(2.0)
            make.width.height.equalTo(36.0)
        }
        self.collectbtn.snp.makeConstraints { make in
            make.left.equalTo(title.snp.right).offset(8.0)
            make.centerY.equalTo(titleImage)
            make.width.height.equalTo(28.0)
        }
        
        self.onlineView.snp.makeConstraints { make in
            make.centerY.equalTo(hotlb)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(24)
        }
        
    }
}
private extension LMRMTopView {
}
