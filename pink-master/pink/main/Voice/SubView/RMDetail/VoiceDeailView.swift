import UIKit
import ZLPhotoBrowser
import Qiniu
extension VoiceDeailView {
    func show(_ vc: UIViewController? = nil) {
        if let viewController = vc {
            viewController.addChild(self)
            viewController.view.addSubview(self.view)
        } else {
            UIViewController.current?.addChild(self)
            UIViewController.current?.view.addSubview(self.view)
        }
        self.view.frame = UIScreen.main.bounds
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-self.bdView.height)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.bdView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(0)
            }
            self.bdView.superview?.layoutIfNeeded()
        } completion: { _ in
            self.clear()
        }
    }
    func clear() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
class VoiceDeailView: UIViewController {
    private lazy var bgView: UIView = {
        let view = UIView()
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var bdView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var bodyimv: UIImageView = {
        let imv = UIImageView()
        let effec = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effec)
        imv.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return imv
    }()
    private lazy var idlb: UIButton = {
        let lb = UIButton(lmfont: lmFontM(10), titleColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .image(UIImage(named: "rm_topid"), .normal)
            .lmtitle("0")
        return lb
    }()
    private lazy var hotlb: UIButton = {
        let lb = UIButton(lmfont: lmFontM(10), titleColor: lmColorHex("#FFFFFF", alpha: 0.96))
            .image(UIImage(named: "rm_tophot"), .normal)
            .lmtitle("0")
        return lb
    }()
    lazy var coverImage: UIImageView = {
        let imageV = UIImageView()
            .cornerRadius(12)
        imageV.isUserInteractionEnabled = true
        return imageV
    }()
    lazy var editCoverbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: .white)
            .backgroundColor(lmColorHex("#000000A3"))
            .image(UIImage(named: "rm_edit"), .normal)
            .lmtitle("修改")
        btn.addTarget(self, action: #selector(editCover), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    lazy var namelb: UITextField = {
        let lb = UITextField(lmfont: lmFontASHTB(20), textColor: .white)
        lb.isUserInteractionEnabled = false
        return lb
    }()
    lazy var detailText: UITextView = {
        let textView = UITextView(lmfont: lmFontM(14), textColor: .white)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        return textView
    }()
    lazy var editNamebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: .white)
            .image(UIImage(named: "rm_edit"), .normal)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(editName), for: .touchUpInside)
        return btn
    }()
    lazy var editDetailbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: .white)
            .backgroundColor(lmColorHex("#000000A3"))
            .image(UIImage(named: "rm_edit"), .normal)
            .lmtitle("修改")
            .cornerRadius(kScaleWidth(16))
        btn.addTarget(self, action: #selector(editDetail), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    private var dataSoure:RoomItem
    private let role:RMRoleType
    init(model:RoomItem, role:RMRoleType) {
        self.dataSoure = model
        self.role = role
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setDataSoure()
        self.navigationController?.navigationBar.isHidden = true
    }
    private func setViewSnp() {
        view.addSubview(bgView)
        view.addSubview(bdView)
        bdView.addSubview(bodyimv)
        bdView.addSubview(coverImage)
        coverImage.addSubview(editCoverbtn)
        bdView.addSubview(namelb)
        bdView.addSubview(idlb)
        bdView.addSubview(hotlb)
        bdView.addSubview(detailText)
        bdView.addSubview(editDetailbtn)
        bdView.addSubview(editNamebtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(0)
            make.height.equalTo(kScaleWidth(640))
        }
        bodyimv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        coverImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(40))
            make.top.equalToSuperview().offset(kScaleWidth(40))
            make.size.equalTo(CGSize(width: kScaleWidth(112), height: kScaleWidth(112)))
        }
        editCoverbtn.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kScaleWidth(24))
        }
        namelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(40))
            make.top.equalTo(coverImage.snp.bottom).offset(kScaleWidth(16))
            make.width.equalTo(0)
            make.height.equalTo(kScaleWidth(28))
        }
        editNamebtn.snp.makeConstraints { make in
            make.left.equalTo(namelb.snp.right).offset(4)
            make.centerY.equalTo(namelb.snp.centerY)
            make.size.equalTo(CGSize(width: kScaleWidth(16), height: kScaleWidth(16)))
        }
        idlb.snp.makeConstraints { make in
            make.left.equalTo(self.namelb.snp.left)
            make.top.equalTo(self.namelb.snp.bottom).offset(2)
            make.height.equalTo(16.0)
            make.width.equalTo(28.0)
        }
        hotlb.snp.makeConstraints { make in
            make.left.equalTo(self.idlb.snp.right).offset(16.0)
            make.centerY.equalTo(self.idlb)
            make.height.equalTo(16.0)
            make.width.equalTo(28.0)
        }
        detailText.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(40))
            make.top.equalTo(namelb.snp.bottom).offset(44)
            make.height.equalTo(0)
        }
        editDetailbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(40))
            make.top.equalTo(detailText.snp.bottom).offset(kScaleWidth(10))
            make.size.equalTo(CGSize(width: kScaleWidth(76), height: kScaleWidth(32)))
        }
        if role == .owner {
            editNamebtn.isHidden = false
            editCoverbtn.isHidden = false
            editDetailbtn.isHidden = false
        }
        view.layoutIfNeeded()
        bdView.set_Border(radius: 16.0, conrners: [.topLeft, .topRight])
        let lineView = UIView().backgroundColor(lmColorHex("#FFFFFF3D"))
            .cornerRadius(2)
        bdView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(8))
            make.size.equalTo(CGSize(width: 48, height: 4))
        }
    }
    func setDataSoure() {
        let idText = dataSoure.showRoomId
        let idWidth = idText.singleLineWidth(lmfont: lmFontM(10))
        self.idlb.snp.updateConstraints { make in
            make.width.equalTo(idWidth + 16.0)
        }
        self.idlb.lmtitle(idText)
        let hotText = dataSoure.hotValue.toString().StringToHotVaule()
        let hotWidth = hotText.singleLineWidth(lmfont: lmFontM(10))
        self.hotlb.snp.updateConstraints { make in
            make.width.equalTo(hotWidth + 16.0)
        }
        self.hotlb.lmtitle(hotText)
        let nameText = dataSoure.roomName.StringToHotVaule()
        let nameWidth = nameText.singleLineWidth(lmfont: lmFontASHTB(20))
        namelb.snp.updateConstraints { make in
            make.width.equalTo(nameWidth)
        }
        let detail = dataSoure.notification.StringToHotVaule()
        let detailH = detail.textHeight(width: kScreenWidth - kScaleWidth(80), font: lmFontM(14), minHeight: 10)
        detailText.snp.updateConstraints { make in
            make.height.equalTo(detailH + 20)
        }
        coverImage.set_Image(url: dataSoure.cover)
        namelb.lmtext(dataSoure.roomName)
        detailText.text = dataSoure.notification
    }
    @objc func editCover() {
        let items = [
            LMSheetTabModel(title: "摄像头", titleColor: "#2B313D"),
            LMSheetTabModel(title: "相册", titleColor: "#2B313D")
        ]
        LMSheetTableVC(title: nil, dataSource: items, cancel: "取消") { item in
            self.navigationController?.navigationBar.isHidden = false
            guard let item = item else { return }
            if item.title == "摄像头" {
                self.clickCam()
            }
            if item.title == "相册" {
                self.clickPho()
            }
        }.show()
    }
    @objc func editName() {
       LMRMNamePopController.show(text: dataSoure.roomName,roomId: dataSoure.roomId) { [weak self] text in
            guard let self = self else { return }
            self.dataSoure.roomName = text
            setDataSoure()
        }
    }
    @objc func editDetail() {
       LMRMNoticePopController.show(text: dataSoure.notification,roomId: dataSoure.roomId) { [weak self] text in
            guard let self = self else { return }
            self.dataSoure.notification = text
            setDataSoure()
        }
    }
    func clickCam() {
        let camera = ZLCustomCamera()
        camera.takeDoneBlock = { [weak self] (result, _) in
            guard let self = self else { return }
            guard let selectedImage = result else { return }
            uploadImage(selectedImage)
        }
        camera.cancelBlock = {
            lmPrint("cancel select")
        }
        self.showDetailViewController(camera, sender: nil)
    }
    func clickPho() {
        let config = ZLPhotoConfiguration.default()
        config.maxSelectCount = 1
        config.allowSelectVideo = false
        let ac = ZLPhotoPreviewSheet()
        ac.selectImageBlock = { [weak self] results, _ in
            guard let self = self else { return }
            let selectedImages = results.map { $0.image }
            guard let selectedImage = selectedImages.first else { return }
            uploadImage(selectedImage)
        }
        ac.cancelBlock = {
            lmPrint("cancel select")
        }
        ac.selectImageRequestErrorBlock = { errorAssets, errorIndexs in
            lmPrint("fetch error assets: \(errorAssets), error indexs: \(errorIndexs)")
        }
        ac.showPhotoLibrary(sender: self)
    }
    func uploadImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        HUD.showLoading("上传中...")
        UpLoadNetWork.UpToken(uploadSource: 1).lmrequest { responseModel in
            guard let token = (responseModel.data as? [String: Any])?["token"] as? String,
                  let prefix = (responseModel.data as? [String: Any])?["prefix"] as? String else {
                HUD.hide()
                return
            }
            let key = prefix + "\(Date().timeIntervalSince1970*1000*1000)" + ".jpeg"
            guard let upManager = QNUploadManager() else {
                HUD.hide()
                return
            }
            upManager.put(imageData, key: key, token: token, complete: { _, key, _ in
                if let key = key {
                    let imageUrl = AppConfig.URL.resource + key
                   RoomNetWork.updateInfo(roomId: self.dataSoure.roomId, cover: imageUrl).lmrequest { [weak self] _ in
                        HUD.showSuccess("上传成功")
                        guard let self = self else { HUD.hide(); return }
                        self.dataSoure.cover = imageUrl
                        DispatchQueue.main {
                            self.coverImage.set_Image(url: imageUrl)
                        }
                    } failureBlock: { error in
                        HUD.showFailure(error.message)
                    }
                } else {
                    HUD.showFailure("上传失败")
                }
            }, option: nil)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
