import UIKit
import ZLPhotoBrowser
import Qiniu
class CusTomFeedBackViewController: LMBaseVC {
    lazy var bgImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "feedBack_bg"))
        return imageV
    }()
    lazy var textViewCenter: UIView = {
        let view = UIView().backgroundColor(.white).cornerRadius(12)
        return view
    }()
    lazy var starImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "cm_mustStar"))
        return imageV
    }()
    lazy var textViewTitle: UILabel = {
        let lb = UILabel(lmfont: lmFontR(16), textColor: .textDefaulColor).lmtext("问题描述")
        return lb
    }()
    lazy var textView: UITextView = {
        let textView = UITextView(lmfont: lmFontR(14), textColor: .textDefaulColor).backgroundColor(lmColorHex("#FFFFFF")).cornerRadius(8)
        textView.placeholder = "上传问题截图可以让问题快速解决哦！"
        return textView
    }()
    lazy var imageCenter: UIView = {
        let view = UIView().backgroundColor(.white).cornerRadius(12)
        return view
    }()
    lazy var imageTitle: UILabel = {
        let lb = UILabel(lmfont: lmFontR(16), textColor: .textDefaulColor).lmtext("上传图片：")
        return lb
    }()
    lazy var imageSubTitle: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textTerColor).lmtext("有利于客服人员核实")
        return lb
    }()
    lazy var imageUpdataView: LMAddPhotoView = {
        let view = LMAddPhotoView(image: "me_cunstomAddImage") {[weak self] in
        }
            .backgroundColor(lmColorHex("#2B313D0A"))
        return view
    }()
    lazy var imageUpdataViewT: LMAddPhotoView = {
        let view = LMAddPhotoView(image: "me_cunstomAddImage") {[weak self] in
        }
            .backgroundColor(lmColorHex("#2B313D0A"))
        return view
    }()
    lazy var imageUpdataViewH: LMAddPhotoView = {
        let view = LMAddPhotoView(image: "me_cunstomAddImage") {[weak self] in
        }
            .backgroundColor(lmColorHex("#2B313D0A"))
        return view
    }()
    lazy var surebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .textDefaulColor, target: self, action: #selector(upload)).lmtitle("提交反馈").backgroundColor(lmColorHex("#B9F165FF")).cornerRadius(12)
        return btn
    }()
    var imageUrlArray: [String] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
    }
    private func setViewSnp() {
        backgroundImage = nil
        view.backgroundColor = (lmColorHex("#F5F6FA"))
        title = ""
        view.addSubview(bgImage)
        view.addSubview(textViewCenter)
        textViewCenter.addSubview(starImage)
        textViewCenter.addSubview(textViewTitle)
        textViewCenter.addSubview(textView)
        let titleL = UILabel(lmfont: lmFontASHTB(21), textColor: lmColorHex("#2B313D"))
            .lmtext("意见反馈")
        view.addSubview(titleL)
        titleL.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12 + kNavigationHeight)
            make.height.equalTo(32)
        }
        let subtitle = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#2B313DAD"))
            .lmtext("Hi，给出你的小建议吧～")
        view.addSubview(subtitle)
        subtitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(48 + kNavigationHeight)
            make.height.equalTo(22)
        }
        textViewCenter.addSubview(imageUpdataView)
        textViewCenter.addSubview(imageUpdataViewT)
        textViewCenter.addSubview(imageUpdataViewH)
        view.addSubview(surebtn)
        bgImage.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kScaleWidth(370))
        }
        textViewCenter.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(90) + kNavigationHeight)
            make.height.equalTo(kScaleWidth(370))
        }
        starImage.snp.makeConstraints { make in
            make.left.equalTo(textViewTitle.snp.right)
            make.top.equalToSuperview().offset(kScaleWidth(20))
            make.size.equalTo(CGSize(width: kScaleWidth(11), height: kScaleWidth(11)))
        }
        textViewTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(24))
        }
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kScaleWidth(56))
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(120))
        }
        imageUpdataView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(284))
            make.size.equalTo(CGSize(width: kScaleWidth(70), height: kScaleWidth(70)))
        }
        imageUpdataViewT.snp.makeConstraints { make in
            make.left.equalTo(imageUpdataView.snp.right).offset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(284))
            make.size.equalTo(CGSize(width: kScaleWidth(70), height: kScaleWidth(70)))
        }
        imageUpdataViewH.snp.makeConstraints { make in
            make.left.equalTo(imageUpdataViewT.snp.right).offset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(284))
            make.size.equalTo(CGSize(width: kScaleWidth(70), height: kScaleWidth(70)))
        }
        surebtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.centerX.equalToSuperview()
            make.top.equalTo(textViewCenter.snp.bottom).offset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(56))
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        imageUpdataView.addGestureTap { [weak self] _ in
            self?.upLoadImage(type: 0)
        }
        imageUpdataViewT.addGestureTap { [weak self] _ in
            self?.upLoadImage(type: 1)
        }
        imageUpdataViewH.addGestureTap { [weak self] _ in
            self?.upLoadImage(type: 2)
        }
    }
    func setDataSoure() {
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func upload() {
        if textView.text.isEmpty == true {
            HUD.show("请填写问题描述")
            return
        }
        if imageUrlArray.count == 0 {
            HUD.show("请上传图片")
            return
        }
        UserNetWork.feedback(content: textView.text, url: imageUrlArray).lmrequest { _ in
            HUD.show("正在处理中，请耐⼼等待")
            self.navigationController?.popViewController(animated: true)
        } failureBlock: { _ in
        }
    }
    func upLoadImage(type: Int) {
        let items = [
            LMSheetTabModel(title: "摄像头", titleColor: "#2B313D"),
            LMSheetTabModel(title: "相册", titleColor: "#2B313D")
        ]
        LMSheetTableVC(title: nil, dataSource: items, cancel: "取消") { item in
            self.navigationController?.navigationBar.isHidden = false
            guard let item = item else { return }
            if item.title == "摄像头" {
                self.clickCam(type: type)
            }
            if item.title == "相册" {
                self.clickPho(type: type)
            }
        }.show()
    }
    func clickCam(type: Int) {
        let camera = ZLCustomCamera()
        camera.takeDoneBlock = { [weak self] (result, _) in
            guard let self = self else { return }
            guard let selectedImage = result else { return }
            if type == 0 {
                self.imageUpdataView.set_ImageData(image: selectedImage)
            } else if type == 1 {
                self.imageUpdataViewT.set_ImageData(image: selectedImage)
            } else if type == 2 {
                self.imageUpdataViewH.set_ImageData(image: selectedImage)
            }
        }
        camera.cancelBlock = {
            lmPrint("cancel select")
        }
        self.showDetailViewController(camera, sender: nil)
    }
    func clickPho(type: Int) {
        let config = ZLPhotoConfiguration.default()
        config.maxSelectCount = 1
        config.allowSelectVideo = false
        let ac = ZLPhotoPreviewSheet()
        ac.selectImageBlock = { [weak self] results, _ in
            guard let self = self else { return }
            let selectedImages = results.map { $0.image }
            guard let selectedImage = selectedImages.first else { return }
            if type == 0 {
                self.imageUpdataView.set_ImageData(image: selectedImage)
            } else if type == 1 {
                self.imageUpdataViewT.set_ImageData(image: selectedImage)
            } else if type == 2 {
                self.imageUpdataViewH.set_ImageData(image: selectedImage)
            }
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
        UpLoadNetWork.UpToken(uploadSource: 8).lmrequest { responseModel in
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
            upManager.put(imageData, key: key, token: token, complete: {[weak self] _, key, _ in
                if let key = key {
                    let imageUrl = AppConfig.URL.resource + key
                    self?.imageUrlArray.append(imageUrl)
                    HUD.hide()
                } else {
                    HUD.showFailure("上传失败")
                }
            }, option: nil)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
