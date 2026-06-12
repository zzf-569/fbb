import UIKit
import ZLPhotoBrowser
import Qiniu
class PerFectAvatarViewController: LMBaseVC {
    var avatar: String = "" {
        didSet {
            if avatar.isEmpty == false {
                nextbtn.isEnabled = true
            }
        }
    }
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(28), textColor: .textDefaulColor)
            .lmtext("选择一张优质照片吧～")
            .textAlignment(.center)
        return lb
    }()
    lazy var avaTarView: UIImageView = {
        let iamgeV = UIImageView()
            .contentMode(.scaleAspectFill)
            .backgroundColor(lmColorHex("#2B313D0A"))
        iamgeV.set_Border(radius: 12, borderWidth: 1, borderColor: lmColorHex("#2B313D29"))
        iamgeV.addGestureTap { [weak self] _ in
            self?.uploadAvatar()
        }
        return iamgeV
    }()
    lazy var addimage: UIImageView = {
        let iamgeV = UIImageView(image: UIImage(named: "login_addPhone"))
            .contentMode(.scaleAspectFill)
        return iamgeV
    }()
    lazy var nextbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(18), titleColor: .white, target: self, action: #selector(nextAction))
            .cornerRadius(12)
            .isEnabled(false)
            .lmtitle("开始")
        btn.backgroundColor(lmColorHex("#FF4F7D", alpha: 0.25))
        return btn
    }()
    lazy var skipbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontF(16), titleColor: lmColorHex("#2B313DAD"), target: self, action: #selector(skipAction))
            .cornerRadius(12)
            .lmtitle("跳过")
        return btn
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
    private func setViewSnp() {
        backgroundImage = UIImage(named: "login_bg")
        view.addSubview(skipbtn)
        view.addSubview(titleLab)
        view.addSubview(avaTarView)
        view.addSubview(nextbtn)
        avaTarView.addSubview(addimage)
        skipbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(kStatusBarHeight + 20)
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24 + kNavigationHeight)
            make.centerX.equalToSuperview()
        }
        avaTarView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 220, height: 220))
        }
        addimage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 56, height: 56))
        }
        nextbtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(56 + kTabBarSafeHeight))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(310), height: kScaleWidth(56)))
        }
    }
    func uploadAvatar() {
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
            guard let selectedImage = selectedImages.first,
                  let imageData = selectedImage.jpegData(compressionQuality: 0.8) else { return }
            self.uploadImage(selectedImage)
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
        UpLoadNetWork.UpToken(uploadSource: 0).lmrequest { responseModel in
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
                    UserNetWork.updateUserInfo(avatar: imageUrl).lmrequest {[weak self] _ in
                        HUD.showSuccess("上传成功")
                        guard let self = self else { HUD.hide(); return }
                        self.avatar = imageUrl
                        DispatchQueue.main {
                            self.avaTarView.set_Image(url: imageUrl)
                            self.nextbtn.backgroundColor(lmColorHex("#FF4F7D", alpha: 1))
                            self.addimage.isHidden = true
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
    @objc func skipAction() {
        let login = BaseNavigationController(rootViewController: MainTabBarViewController())
        AppConfig.keyWindow.rootViewController = login
        AppConfig.keyWindow.makeKeyAndVisible()
    }
    @objc func nextAction() {
        let login = BaseNavigationController(rootViewController: MainTabBarViewController())
        AppConfig.keyWindow.rootViewController = login
        AppConfig.keyWindow.makeKeyAndVisible()
    }
}
