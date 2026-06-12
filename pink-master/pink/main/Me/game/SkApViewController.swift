import UIKit
import ZLPhotoBrowser
import Qiniu
class SkApViewController: LMBaseVC {
    var dataSoure: SkillItem = SkillItem() {
        didSet {
            title = dataSoure.skillName
        }
    }
    var imageUrl: String = "" {
        didSet {
            if imageUrl.isEmpty == false {
                self.addimv.setDataSoure(imageUrl: imageUrl)
            }
            if imageUrl.isEmpty == false && skillLevel.isEmpty == false && price > 0 {
                nextbtn.backgroundImage(UIImage(named: "skill_user_next"))
            } else {
                nextbtn.backgroundImage(UIImage(named: "skill_user_next_n"))
            }
        }
    }
    var skillLevel: String = "" {
        didSet {
            if imageUrl.isEmpty == false && skillLevel.isEmpty == false && price > 0 {
                nextbtn.backgroundImage(UIImage(named: "skill_user_next"))
            } else {
                nextbtn.backgroundImage(UIImage(named: "skill_user_next_n"))
            }
        }
    }
    var price: Int = 0 {
        didSet {
            if imageUrl.isEmpty == false && skillLevel.isEmpty == false && price > 0 {
                nextbtn.backgroundImage(UIImage(named: "skill_user_next"))
            } else {
                nextbtn.backgroundImage(UIImage(named: "skill_user_next_n"))
            }
        }
    }
    var levelbtnArray: [UIButton] = []
    lazy var levellb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: .textDefaulColor).lmtext("等级")
        return lb
    }()
    lazy var levelView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var seleIcon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "skill_seleIcon")).isHidden(true)
        return view
    }()
    lazy var imagelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: .textDefaulColor).lmtext("截图")
        return lb
    }()
    lazy var addimv: SkAplyAddimv = {
        let view = SkAplyAddimv(image: "cm_whiteAddImage") {[weak self] in
            self?.imageUrl = ""
        }
        return view
    }()
    lazy var priceView: UIView = {
        let view = UIView().backgroundColor(.clear)
        return view
    }()
    lazy var priceTipslb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: .textDefaulColor).lmtext("单价")
        return lb
    }()
    lazy var pricelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textDefaulColor)
        return lb
    }()
    lazy var nextbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: .whitePrimary, target: self, action: #selector(a_next))
        btn.backgroundImage(UIImage(named: "skill_user_next_n"))
        return btn
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configSubviews()
        configData()
    }
    private func configSubviews() {
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#F5F6FAFF")
        view.addSubview(levellb)
        view.addSubview(levelView)
        view.addSubview(imagelb)
        view.addSubview(addimv)
        view.addSubview(priceView)
        view.addSubview(nextbtn)
        view.addSubview(priceTipslb)
        view.addSubview(pricelb)
        levelView.addSubview(seleIcon)
        let lineView = UIImageView(image: UIImage(named: "rm_dispatch_release_mark"))
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.centerY.equalTo(levellb)
            make.size.equalTo(CGSize(width: kScaleWidth(3), height: kScaleWidth(12)))
        }
        levellb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(27))
            make.top.equalToSuperview().offset(kScaleWidth(25) + kNavigationHeight)
        }
        levelView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(40) + kNavigationHeight)
        }
        let lineViewT = UIImageView(image: UIImage(named: "rm_dispatch_release_mark"))
        view.addSubview(lineViewT)
        lineViewT.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.centerY.equalTo(imagelb)
            make.size.equalTo(CGSize(width: kScaleWidth(3), height: kScaleWidth(12)))
        }
        imagelb.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(kScaleWidth(27))
            make.top.equalTo(levelView.snp.bottom).offset(kScaleWidth(25))
            make.height.equalTo(kScaleWidth(20))
        }
        addimv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.top.equalTo(imagelb.snp.bottom).offset(kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(160), height: kScaleWidth(90)))
        }
        priceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalTo(addimv.snp.bottom).offset(kScaleWidth(12))
            make.height.equalTo(kScaleWidth(50))
        }
        let lineViewS = UIImageView(image: UIImage(named: "rm_dispatch_release_mark"))
        view.addSubview(lineViewS)
        lineViewS.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.centerY.equalTo(priceTipslb)
            make.size.equalTo(CGSize(width: kScaleWidth(3), height: kScaleWidth(12)))
        }
        priceTipslb.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(kScaleWidth(27))
            make.top.equalTo(priceView.snp.top).offset(kScaleWidth(13))
            make.height.equalTo(kScaleWidth(20))
        }
        pricelb.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(kScaleWidth(26))
            make.top.equalTo(priceView.snp.top).offset(kScaleWidth(13))
            make.height.equalTo(kScaleWidth(20))
        }
        nextbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(kScaleWidth(16))
            make.height.equalTo(kScaleWidth(56))
            make.width.equalTo(kScreenWidth - kScaleWidth(32))
            make.bottom.equalToSuperview().offset(-(kTabBarHeight + 40))
        }
        addimv.addGestureTap {[weak self] _ in
            self?.a_uploadSkillPhoth()
        }
        priceView.addGestureTap {[weak self] _ in
            var items: [PickerListModel] = []
            guard let skillPriceList = self?.dataSoure.skillPriceList else { return }
            for (index, string) in skillPriceList.enumerated() {
                items.append(PickerListModel(title: "\(string)柚米/小时", value: index))
            }
            let picker = LMPickerVC(theme: .light, title: "选择单价", dataSource: items, cancel: "取消", confirm: "确定") {[weak self] item in
                guard let item = item else { return }
                self?.pricelb.lmtext(item.title)
                self?.price = skillPriceList[item.value as! Int]
            }
            picker.show()
        }
    }
    func configData() {
        let levelList = dataSoure.skillLevelList
        for (index, string) in levelList.enumerated() {
            let btn = UIButton(lmfont: lmFontR(12), titleColor: .textDefaulColor, target: self, action: #selector(a_levelbtnClick)).lmtitle(string)
            levelView.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset((CGFloat((index % 4)) * kScaleWidth(92)) + kScaleWidth(12))
                make.top.equalToSuperview().offset((CGFloat((index / 4)) * kScaleWidth(48)) + kScaleWidth(12))
                make.size.equalTo(CGSize(width: kScaleWidth(80), height: kScaleWidth(36)))
                if index == levelList.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            btn.backgroundColor = lmColorHex("#2B313D0A")
            btn.set_Border(radius: 12, borderWidth: 0, borderColor: .clear)
            levelbtnArray.append(btn)
        }
        self.pricelb.lmtext("\(self.dataSoure.skillPriceList[0])柚米/小时")
        price = Int(dataSoure.skillPriceList[0])
    }
    @objc func a_next() {
        SkillApi.skillApply(skillId: dataSoure.skillId, skillLevel: skillLevel, skillUrl: imageUrl, skillName: dataSoure.skillName, skillPrice: price).lmrequest {[weak self] _ in
            guard let self = self else {return}
            let view = SkStaViewController()
            var viewMdel = self.dataSoure
            viewMdel.status = 0
            view.dataSoure = viewMdel
            self.navigationController?.pushViewController(view, animated: true)
        } failureBlock: { error in
            HUD.show(error.message)
        }
    }
    @objc func a_backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func a_levelbtnClick(sender: UIButton) {
        for btn in levelbtnArray {
            if btn == sender {
                skillLevel = btn.titleLabel?.text ?? ""
                btn.set_Border(radius: 6, borderWidth: 1, borderColor: lmColorHex("#00DBA9"))
                btn.backgroundColor = lmColorHex("#00DBA91A")
                seleIcon.snp.remakeConstraints { make in
                    make.right.top.equalTo(btn)
                    make.size.equalTo(CGSize(width: kScaleWidth(20), height: kScaleWidth(10)))
                }
                seleIcon.isHidden = false
            } else {
                btn.backgroundColor = lmColorHex("#2B313D0A")
                btn.set_Border(radius: 12, borderWidth: 0, borderColor: .clear)
            }
        }
    }
    @objc func a_uploadSkillPhoth() {
        let items: [LMSheetItemModel] = [
            LMSheetItemModel(title: "摄像头", imageName: "cm_sheet_camera"),
            LMSheetItemModel(title: "相册", imageName: "cm_sheet_photo")
        ]
        LMSheetCollectionVC.show(theme: .light, title: "上传技能图片", items: items, cancel: "取消") { item in
            guard let item = item else { return }
            if item.title == "摄像头" {
                self.clickCam()
            }
            if item.title == "相册" {
                self.clickPho()
            }
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
        UpLoadNetWork.UpToken(uploadSource: 7).lmrequest { responseModel in
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
                    self?.imageUrl = imageUrl
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
