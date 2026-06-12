import UIKit
import ZLPhotoBrowser
import Qiniu
class UserInfoSetViewController: LMBaseVC {
    var dataSoure: UsInfoItem = UsInfoItem() {
        didSet {
            self.avatarView.setDataSoure(rightImage: dataSoure.avatar)
            self.nickName.setDataSoure(subTitle: dataSoure.nickname)
            self.sex.setDataSoure(subTitle: dataSoure.gender == 1 ? "男":"女")
            self.age.setDataSoure(subTitle: dataSoure.birthday.isEmpty ? "未知" : dataSoure.birthday)
            self.city.setDataSoure(subTitle: dataSoure.city.isEmpty ? "未知" : dataSoure.city)
            if dataSoure.signature.isEmpty == false {
                self.sginLabrl.lmtext(dataSoure.signature)
                    .textColor(.textDefaulColor)
            } else {
                self.sginLabrl.lmtext("每个灵魂都有专属引力场～")
                    .textColor(.textDisColor)
            }
            if dataSoure.voiceUrl.isEmpty == true {
                voiceView.addSubview(addvoicebtn)
                addvoicebtn.snp.remakeConstraints { make in
                    make.center.equalToSuperview()
                    make.size.equalTo(CGSize(width: kScaleWidth(82), height: kScaleWidth(28)))
                }
            } else {
                voiceView.addSubview(addvoicebtn)
                voiceView.addSubview(voicePlayView)
                addvoicebtn.lmtitle("重录")
                addvoicebtn.snp.remakeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-kScaleWidth(16))
                    make.size.equalTo(CGSize(width: kScaleWidth(64), height: kScaleWidth(28)))
                }
                voicePlayView.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(kScaleWidth(16))
                    make.centerY.equalToSuperview()
                    make.size.equalTo(CGSize(width: kScaleWidth(83), height: kScaleWidth(28)))
                }
            }
            var acctagList: [String] = []
            acctagList = dataSoure.userLabel.accomplishmentList.map {$0.labelName}
            var instagList: [String] = []
            instagList = dataSoure.userLabel.interestList.map {$0.labelName}
            var gameList: [String] = []
            gameList = dataSoure.userLabel.gameList.map {$0.labelName}
            if acctagList.count > 0 || instagList.count > 0 || gameList.count > 0 {
                tagView.isHidden = false
                jyView.isHidden = true
                editJy.isHidden = false
                tagView.setDataSoure(acctagList + instagList + gameList)
            } else {
                tagView.isHidden = true
                jyView.isHidden = false
                editJy.isHidden = true
            }
            phoneNumlb.text = "我的照片(\(dataSoure.photoWall.count)/6)"
            self.collectionView.reloadData()
        }
    }
    var isPlayVoice: Bool = false
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: kNavigationHeight, width: kScreenWidth, height: kScreenHeight - kNavigationHeight))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    lazy var backImageCenter: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius(kScaleWidth(12))
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [MineAddPhotoCell.self])
        collectionView.dragInteractionEnabled = true 
        collectionView.reorderingCadence = .fast 
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        return collectionView
    }()
    lazy var phoneNumlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(16), textColor: .textDefaulColor)
        return lb
    }()
    lazy var sginLabrl: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: .textDisColor)
            .lmtext("每个灵魂都有专属引力场～")
            .numberOfLines(0)
        return lb
    }()
    lazy var addsginbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(12), titleColor: lmColorHex("#FF4F7DFF"))
            .image(UIImage(named: "more_pink"))
            .backgroundColor(lmColorHex("#FF4F7D14"))
            .lmtitle("去填写")
            .frame(CGRect(x: 0, y: 0, width: kScaleWidth(70), height: kScaleWidth(28)))
            .cornerRadius(kScaleWidth(14))
        btn.addTarget(self, action: #selector(turnToSginName), for: .touchUpInside)
        btn.set_ImageTitleLayout(.imgRight, spacing: 2)
        return btn
    }()
    lazy var addvoicebtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(12), titleColor: lmColorHex("#FF4F7DFF"))
            .image(UIImage(named: "more_pink"))
            .backgroundColor(lmColorHex("#FF4F7D14"))
            .lmtitle("添加声音")
            .frame(CGRect(x: 0, y: 0, width: kScaleWidth(82), height: kScaleWidth(28)))
            .cornerRadius(kScaleWidth(14))
        btn.add(self, action: #selector(turnToVoiceName))
        btn.set_ImageTitleLayout(.imgRight, spacing: 2)
        return btn
    }()
    lazy var addjybtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(12), titleColor: lmColorHex("#FF4F7DFF"))
            .image(UIImage(named: "more_pink"))
            .backgroundColor(lmColorHex("#FF4F7D14"))
            .lmtitle("添加属于自己的基因")
            .frame(CGRect(x: 0, y: 0, width: kScaleWidth(138), height: kScaleWidth(28)))
            .cornerRadius(kScaleWidth(14))
        btn.add(self, action: #selector(turnTogene))
        btn.set_ImageTitleLayout(.imgRight, spacing: 2)
        return btn
    }()
    lazy var editJy: UIButton = {
        let btn = UIButton(lmfont: lmFontR(14), titleColor: lmColorHex("#2B313DAD"))
            .image(UIImage(named: "cm_more"))
            .lmtitle("编辑")
            .frame(CGRect(x: 0, y: 0, width: kScaleWidth(44), height: kScaleWidth(28)))
            .isHidden(true)
        btn.add(self, action: #selector(turnTogene))
        btn.set_ImageTitleLayout(.imgRight, spacing: 0)
        return btn
    }()
    lazy var avatarView: LMVerticalView = {
        let view = LMVerticalView(title: "头像", type: .image, rightImage: dataSoure.avatar)
        view.cornerRadius(kScaleWidth(12))
        return view
    }()
    lazy var nickName: LMVerticalView = {
        let view = LMVerticalView(title: "昵称", type: .lbType, subTitle: dataSoure.nickname)
        return view
    }()
    lazy var sex: LMVerticalView = {
        let view = LMVerticalView(title: "性别", type: .lbType, subTitle: dataSoure.gender == 1 ? "男":"女")
        return view
    }()
    lazy var city: LMVerticalView = {
        let view = LMVerticalView(title: "城市", type: .lbType, subTitle: dataSoure.city)
        return view
    }()
    lazy var age: LMVerticalView = {
        let view = LMVerticalView(title: "年龄", type: .lbType, subTitle: dataSoure.birthday)
        return view
    }()
    lazy var jyView: UIView = {
        let jyView = UIView().backgroundColor(lmColorHex("#F8F8FAFF"))
            .cornerRadius(12)
        return jyView
    }()
    lazy var voiceView: UIView = {
        let voiceView = UIView().backgroundColor(lmColorHex("#F8F8FAFF"))
            .cornerRadius(12)
        return voiceView
    }()
    lazy var tagView: UserCardExtendTagView = {
        let view = UserCardExtendTagView()
        view.viewHeightChange = { height in
            view.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
        }
        view.isHidden = true
        return view
    }()
    lazy var voicePlayView: UserPageVoiceView = {
        let imageV = UserPageVoiceView()
        imageV.bgView.backgroundColor(.clear)
        return imageV
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataSoure()
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "个人资料"
        backgroundImage = nil
        view.backgroundColor = .white
        setViewSnp()
        configTap()
    }
    private func setViewSnp() {
        view.addSubview(scrollView)
        scrollView.addSubview(avatarView)
        scrollView.addSubview(backImageCenter)
        backImageCenter.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(0))
            make.height.equalTo(kScaleWidth(344))
        }
        scrollView.addSubview(phoneNumlb)
        phoneNumlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(12))
        }
        backImageCenter.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(56))
        }
        let tipslb = UILabel(lmfont: lmFontR(16), textColor: .textDefaulColor)
        tipslb.text = "我的签名"
        scrollView.addSubview(tipslb)
        tipslb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalTo(collectionView.snp.bottom).offset(kScaleWidth(20))
        }
        let sginView = UIView().backgroundColor(lmColorHex("#F8F8FAFF"))
            .cornerRadius(12)
        scrollView.addSubview(sginView)
        sginView.addSubview(sginLabrl)
        sginView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalTo(tipslb.snp.bottom).offset(kScaleWidth(8))
            make.width.equalTo(kScreenWidth - kScaleWidth(40))
            make.bottom.equalTo(sginLabrl.snp.bottom).offset(kScaleWidth(16))
        }
        sginLabrl.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(kScaleWidth(16))
            make.right.equalToSuperview().offset(-kScaleWidth(90))
            make.bottom.equalTo(sginView.snp.bottom).offset(-kScaleWidth(16))
        }
        sginView.addSubview(addsginbtn)
        addsginbtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.size.equalTo(CGSize(width: kScaleWidth(70), height: kScaleWidth(28)))
        }
        let voicelb = UILabel(lmfont: lmFontR(16), textColor: .textDefaulColor)
        voicelb.text = "我的声音"
        scrollView.addSubview(voicelb)
        voicelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalTo(sginView.snp.bottom).offset(kScaleWidth(20))
        }
        scrollView.addSubview(voiceView)
        voiceView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalTo(voicelb.snp.bottom).offset(kScaleWidth(6))
            make.width.equalTo(kScreenWidth - kScaleWidth(40))
            make.height.equalTo(kScaleWidth(56))
        }
        voiceView.addSubview(addvoicebtn)
        addvoicebtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(82), height: kScaleWidth(28)))
        }
        let tips = UILabel(lmfont: lmFontR(16), textColor: .textDefaulColor)
        tips.text = "我的资料"
        scrollView.addSubview(tips)
        tips.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalTo(voiceView.snp.bottom).offset(kScaleWidth(20))
        }
        avatarView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth - kScaleWidth(40), height: kScaleWidth(48)))
        }
        nickName.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth - kScaleWidth(40), height: kScaleWidth(48)))
        }
        sex.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth - kScaleWidth(40), height: kScaleWidth(48)))
        }
        city.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth - kScaleWidth(40), height: kScaleWidth(48)))
        }
        age.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth - kScaleWidth(40), height: kScaleWidth(48)))
        }
        let stackView = UIStackView(arrangedSubviews: [avatarView, nickName, sex, city, age])
        stackView.backgroundColor = lmColorHex("#F8F8FAFF")
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.set_Border(radius: kScaleWidth(12))
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(tips.snp.bottom).offset(kScaleWidth(6))
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.right.equalToSuperview().offset(-kScaleWidth(16))
        }
        let jylb = UILabel(lmfont: lmFontR(16), textColor: .textDefaulColor)
        jylb.text = "我的基因"
        scrollView.addSubview(jylb)
        jylb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalTo(stackView.snp.bottom).offset(kScaleWidth(20))
        }
        scrollView.addSubview(editJy)
        editJy.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(20))
            make.top.equalTo(stackView.snp.bottom).offset(kScaleWidth(20))
        }
        scrollView.addSubview(jyView)
        jyView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalTo(jylb.snp.bottom).offset(kScaleWidth(6))
            make.width.equalTo(kScreenWidth - kScaleWidth(40))
            make.height.equalTo(kScaleWidth(56))
        }
        jyView.addSubview(addjybtn)
        addjybtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(138), height: kScaleWidth(28)))
        }
        scrollView.addSubview(tagView)
        tagView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalTo(jylb.snp.bottom).offset(kScaleWidth(6))
            make.width.equalTo(kScreenWidth - kScaleWidth(40))
            make.height.equalTo(56)
            make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
        }
    }
    func setDataSoure() {
        UserShared.getUserInfo {[weak self] in
            guard let user = UserShared.user else {
                return
            }
            self?.dataSoure = user
        }
    }
    func configTap() {
        avatarView.addGestureTap { [weak self] _ in
            self?.uploadAvatar()
        }
        nickName.addGestureTap { [weak self] _ in
            self?.turnToEditName()
        }
        sex.addGestureTap { [weak self] _ in
            let items = [
                PickerListModel(title: "小哥哥", value: 1),
                PickerListModel(title: "小姐姐", value: 2)
            ]
            let picker = LMPickerVC(theme: .light, title: "选择性别", dataSource: items, cancel: "取消", confirm: "确定") {[weak self] item in
                guard let item = item else { return }
                guard let gender = item.value as? Int else { return }
                HUD.showLoading()
                UserNetWork.updateUserInfo(gender: gender).lmrequest {[weak self] _ in
                    self?.dataSoure.gender = gender
                    HUD.hide()
                } failureBlock: { _ in
                    HUD.hide()
                }
            }
            picker.show()
        }
        city.addGestureTap { [weak self] _ in
            let picker = LMCityDataPickerVC(title: "选择城市", pickerType: .city, cancel: "取消", confirm: "确定") {[weak self] string in
                guard let city = string else {return}
                HUD.showLoading()
                UserNetWork.updateUserInfo(city: city).lmrequest {[weak self] _ in
                    self?.dataSoure.city = city
                    self?.city.setDataSoure(subTitle: city)
                    HUD.hide()
                } failureBlock: { _ in
                    HUD.hide()
                }
            }
            picker.contentView.backgroundColor = lmColorHex("#F5F6FA")
            picker.show()
        }
        age.addGestureTap { [weak self] _ in
            let picker = LMCityDataPickerVC(title: "选择生日", pickerType: .data, cancel: "取消", confirm: "确定") {[weak self] string in
                guard let birthday = string else {return}
                HUD.showLoading()
                UserNetWork.updateUserInfo(birthday: birthday).lmrequest {[weak self] _ in
                    self?.dataSoure.birthday = birthday
                    self?.age.setDataSoure(subTitle: birthday)
                    HUD.hide()
                } failureBlock: { _ in
                    HUD.hide()
                }
            }
            picker.contentView.backgroundColor = lmColorHex("#F5F6FA")
            picker.show()
        }
    }
    func turnToEditName() {
        let view = EditNameViewController(model: self.dataSoure)
        self.navigationController?.pushViewController(view, animated: true)
    }
    @objc func turnToSginName() {
        self.navigationController?.pushViewController(EditSignViewController(model: self.dataSoure), animated: true)
    }
    @objc func turnToVoiceName() {
        self.navigationController?.pushViewController(MyRoomViewController(), animated: true)
    }
    @objc func turnTogene() {
        self.navigationController?.pushViewController(MyGeneViewController(), animated: true)
    }
    func upDatalbInfo(lbType: lbType, ListModel: [labelListModel], cuntom: String) {
    }
    @objc func voiceViewClick() {
        if self.isPlayVoice == true {
            LMAudioPlayer.shared.stop()
            self.isPlayVoice = false
            self.voicePlayView.playView.image = UIImage(named: "me_user_voicePlay")
            return
        }
        voicePlayView.playView.image = UIImage(named: "me_user_voicePause")
        LMAudioPlayer.shared.playAudio(url: dataSoure.voiceUrl, loopMode: .oneTime) {[weak self] in
            self?.voicePlayView.playView.image = UIImage(named: "me_user_voicePlay")
            self?.isPlayVoice = false
        }
        isPlayVoice = true
    }
    @objc func uploadAvatar() {
        let items = [
            LMSheetTabModel(title: "摄像头", titleColor: "#2B313D"),
            LMSheetTabModel(title: "相册", titleColor: "#2B313D")
        ]
        LMSheetTableVC(title: nil, dataSource: items, cancel: "取消") { item in
            self.navigationController?.navigationBar.isHidden = false
            guard let item = item else { return }
            if item.title == "摄像头" {
                self.clickCam(true)
            }
            if item.title == "相册" {
                self.clickPho(true)
            }
        }.show()
    }
    func clickCam(_ isAvatar: Bool) {
        let camera = ZLCustomCamera()
        camera.takeDoneBlock = { [weak self] (result, _) in
            guard let self = self else { return }
            guard let selectedImage = result else { return }
            if isAvatar {
                uploadImage(selectedImage)
            } else {
                uploadPhotoWall(selectedImage)
            }
        }
        camera.cancelBlock = {
            lmPrint("cancel select")
        }
        self.showDetailViewController(camera, sender: nil)
    }
    func clickPho(_ isAvatar: Bool) {
        let config = ZLPhotoConfiguration.default()
        config.maxSelectCount = 1
        config.allowSelectVideo = false
        let ac = ZLPhotoPreviewSheet()
        ac.selectImageBlock = { [weak self] results, _ in
            guard let self = self else { return }
            let selectedImages = results.map { $0.image }
            guard let selectedImage = selectedImages.first,
                  let imageData = selectedImage.jpegData(compressionQuality: 0.8) else { return }
            if isAvatar {
                self.uploadImage(selectedImage)
            } else {
                self.uploadPhotoWall(selectedImage)
            }
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
                        self.dataSoure.avatar = imageUrl
                        DispatchQueue.main {
                            self.avatarView.setDataSoure(rightImage: imageUrl)
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
    func uploadPhotoWall(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        HUD.showLoading("上传中...")
        UpLoadNetWork.UpToken(uploadSource: 3).lmrequest { responseModel in
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
                    UserNetWork.uploadPhoto(url: imageUrl).lmrequest {[weak self] responseModel in
                        HUD.showSuccess("上传成功")
                        guard let self = self else { HUD.hide(); return }
                        guard let model = photoWallModel.deserialize(from: responseModel.data as? [String: Any]) else { HUD.hide(); return }
                        self.dataSoure.photoWall.append(model)
                        self.dataSoure = self.dataSoure
                        self.collectionView.reloadData()
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
    func upLoadVoice(url: String, sec: Int) {
        HUD.showLoading("上传中...")
        var filedata: Data = FileManager.default.contents(atPath: url)!
        UpLoadNetWork.UpToken(uploadSource: 4).lmrequest { responseModel in
            guard let token = (responseModel.data as? [String: Any])?["token"] as? String,
                  let prefix = (responseModel.data as? [String: Any])?["prefix"] as? String else {
                HUD.hide()
                return
            }
            let key = prefix + "\(Int(Date().timeIntervalSince1970*1000))" + ".m4a"
            guard let upManager = QNUploadManager() else {
                HUD.hide()
                return
            }
            upManager.put(filedata, key: key, token: token, complete: { _, key, _ in
                if let key = key {
                    let voiceUrl = AppConfig.URL.resource + key
                    UserNetWork.updateUserInfo(voiceUrl: voiceUrl, voiceSec: sec).lmrequest {[weak self] _ in
                        guard let self = self else { HUD.hide(); return }
                        HUD.hide()
                        self.dataSoure.voiceUrl = voiceUrl
                        self.dataSoure.voiceSec = String(format: "%ld", sec)
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
extension UserInfoSetViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate, MineAddPhotoCellDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: any UICollectionViewDropCoordinator) {
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: String() as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let params = UIDragPreviewParameters()
        params.backgroundColor = .clear
        return params
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: MineAddPhotoCell.self, cellForRowAt: indexPath)
        cell.delegate = self
        if indexPath.row < dataSoure.photoWall.count {
            cell.image = dataSoure.photoWall[indexPath.row]
        } else {
            cell.image = nil
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScaleWidth(108), height: kScaleWidth(132))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: kScaleWidth(0), bottom: 0, right: kScaleWidth(0))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < dataSoure.photoWall.count {
        } else {
            uploadPhotoWall()
        }
    }
    func dg_cellClickDele(image: photoWallModel) {
        let photoWall = dataSoure.photoWall
        HUD.showLoading()
        UserNetWork.delePhoto(photoId: image.photoId).lmrequest {[weak self] _ in
            HUD.hide()
            for (index, item) in photoWall.enumerated() {
                if item.photoId == image.photoId {
                    self?.dataSoure.photoWall.remove(at: index)
                }
            }
            self?.collectionView.reloadData()
        } failureBlock: { _ in
            HUD.hide()
        }
    }
    @objc func uploadPhotoWall() {
        let items = [
            LMSheetTabModel(title: "摄像头", titleColor: "#2B313D"),
            LMSheetTabModel(title: "相册", titleColor: "#2B313D")
        ]
        LMSheetTableVC(title: nil, dataSource: items, cancel: "取消") { item in
            self.navigationController?.navigationBar.isHidden = false
            guard let item = item else { return }
            if item.title == "摄像头" {
                self.clickCam(false)
            }
            if item.title == "相册" {
                self.clickPho(false)
            }
        }.show()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
