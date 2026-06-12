import UIKit
extension LMShopHeaderView {
    func setDataSoure(model: ShopListItem) {
        reseat()
        self.dataSoure = model
        namelb.lmtext(model.dressUpName)
        switch model.type {
        case 1:
            headerView.isHidden = false
            headerView.set_Image(url: UserShared.user?.avatar, placeholder: kPlaceholder_avatar)
            headWear.play(url: model.resource, repeatCount: 0)
        case 2:
            headerView.isHidden = false
            headerView.set_Image(url: UserShared.user?.avatar, placeholder: kPlaceholder_avatar)
            voiceWave.play(url: model.resource, repeatCount: 0)
        case 3:
            break
        case 4:
            roomBack.isHidden = false
            UIImage.getVideoFirstImage(videoUrl: model.resource) { image in
                self.roomBack.image(image)
            }
        default:
            break
        }
    }
}
class LMShopHeaderView: UIView {
    lazy var headerView: UIImageView = {
        let imageV = UIImageView()
        imageV.cornerRadius(kScaleWidth(112/2))
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
        lb.textAlignment(.center)
        return lb
    }()
    lazy var headWear: LMAnimationPlayer = {
        let pagView = LMAnimationPlayer()
        return pagView
    }()
    lazy var voiceWave: LMAnimationPlayer = {
        let pagView = LMAnimationPlayer()
        return pagView
    }()
    lazy var textlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(20), textColor: .textDefaulColor)
            .textAlignment(.center)
            .lmtext("只是当时已茫然")
            .numberOfLines(0)
        return lb
    }()
    lazy var roomBack: UIImageView = {
        let imageV = UIImageView().cornerRadius(9).isHidden(true)
        imageV.isUserInteractionEnabled = true
        return imageV
    }()
    lazy var roomShow: UIButton = {
        let btn = UIButton(image: UIImage(named: "shoproomShow"), target: self, action: #selector(showRoom))
        return btn
    }()
    var dataSoure: ShopListItem = ShopListItem()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        backgroundColor = .clear
        addSubview(voiceWave)
        addSubview(headerView)
        addSubview(headWear)
        addSubview(namelb)
        addSubview(roomBack)
        roomBack.addSubview(roomShow)
        headerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(64))
            make.size.equalTo(CGSize(width: kScaleWidth(112), height: kScaleWidth(112)))
        }
        headWear.snp.makeConstraints { make in
            make.center.equalTo(headerView)
            make.size.equalTo(CGSize(width: kScaleWidth(144), height: kScaleWidth(144)))
        }
        voiceWave.snp.makeConstraints { make in
            make.center.equalTo(headerView)
            make.size.equalTo(CGSize(width: kScaleWidth(160), height: kScaleWidth(160)))
        }
        namelb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(kScaleWidth(60))
        }
        roomBack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(20))
            make.size.equalTo(CGSize(width: kScaleWidth(132), height: kScaleWidth(200)))
        }
        roomShow.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kScaleWidth(8))
            make.size.equalTo(CGSize(width: kScaleWidth(64), height: kScaleWidth(20)))
        }
    }
    @objc func showRoom() {
    }
}
extension LMShopHeaderView {
    private func reseat() {
        headWear.clear()
        voiceWave.clear()
        headerView.isHidden = true
        textlb.isHidden = true
        roomBack.isHidden = true
    }
}
extension LMShopHeaderView: HWDMP4PlayDelegate {
    public func shouldStartPlayMP4(_ container: UIView!, config: QGVAPConfigModel!) -> Bool {
        true
    }
    public func viewDidStartPlayMP4(_ container: UIView!) {
    }
    public func viewDidStopPlayMP4(_ lastFrameIndex: Int, view container: UIView!) {
        lmPrint("----------------viewDidStopPlayMP4")
    }
    public func viewDidFinishPlayMP4(_ totalFrameCount: Int, view container: UIView!) {
        lmPrint("----------------viewDidFinishPlayMP4")
    }
    public func viewDidFailPlayMP4(_ error: (any Error)!) {
        lmPrint("播放vap动效失败\(String(describing: error))")
    }
}
