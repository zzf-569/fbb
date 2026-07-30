import UIKit
import ZLPhotoBrowser
import Qiniu
class UserInfoSetViewController: LMBaseVC {
    var dataSoure: UsInfoItem = UsInfoItem() {
        didSet {
            nickName.setDataSoure(subTitle: dataSoure.nickname.isEmpty ? "Nickname" : dataSoure.nickname)
            sex.setDataSoure(subTitle: dataSoure.gender == 1 ? "Male" : "Female")
            age.setDataSoure(subTitle: dataSoure.birthday.isEmpty ? "Select" : dataSoure.birthday)
            city.setDataSoure(subTitle: dataSoure.city.isEmpty ? "Select" : dataSoure.city)
            sginLabrl.text = dataSoure.signature.isEmpty
                ? "This person is a bit lazy and left nothing behind"
                : dataSoure.signature
            sginLabrl.textColor = dataSoure.signature.isEmpty ? .textDisColor : .textDefaulColor
            phoneNumlb.text = "Album  (\(dataSoure.photoWall.count)/6)"
            collectionView.reloadData()
        }
    }
    var isPlayVoice: Bool = false
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
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
        collectionView.isScrollEnabled = false
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
            .lmtext("This person is a bit lazy and left nothing behind")
            .numberOfLines(0)
        return lb
    }()
    lazy var addsginbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontR(12), titleColor: lmColorHex("#B9FF63"))
            .backgroundColor(lmColorHex("#142018"))
            .lmtitle("Edit")
            .frame(CGRect(x: 0, y: 0, width: kScaleWidth(44), height: kScaleWidth(28)))
            .cornerRadius(kScaleWidth(6))
        btn.addTarget(self, action: #selector(turnToSginName), for: .touchUpInside)
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
        let view = LMVerticalView(title: "Nickname", type: .lbType, subTitle: dataSoure.nickname)
        return view
    }()
    lazy var sex: LMVerticalView = {
        let view = LMVerticalView(title: "Gender", type: .lbType, subTitle: dataSoure.gender == 1 ? "Male" : "Female")
        return view
    }()
    lazy var city: LMVerticalView = {
        let view = LMVerticalView(title: "Country", type: .lbType, subTitle: dataSoure.city)
        return view
    }()
    lazy var age: LMVerticalView = {
        let view = LMVerticalView(title: "Birthday", type: .lbType, subTitle: dataSoure.birthday)
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
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage = nil
        view.backgroundColor = lmColorHex("#F5F6FA")
        setViewSnp()
        configTap()
    }

    private func setViewSnp() {
        let navigationView = UIView()
        navigationView.backgroundColor = lmColorHex("#F5F6FA")
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(kNavigationHeight)
        }

        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = lmColorHex("#202620")
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        navigationView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-4)
            $0.size.equalTo(40)
        }

        let titleLabel = UILabel(lmfont: lmFontM(22), textColor: lmColorHex("#171C18"))
        titleLabel.text = "Edit"
        titleLabel.textAlignment = .center
        navigationView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton)
        }

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }

        scrollView.addSubview(phoneNumlb)
        phoneNumlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.top.equalToSuperview().offset(8)
        }

        collectionView.backgroundColor = .clear
        scrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(22)
            make.top.equalTo(phoneNumlb.snp.bottom).offset(12)
            make.width.equalTo(kScreenWidth - 44)
            make.height.equalTo(268)
        }

        let basicsLabel = UILabel(lmfont: lmFontR(16), textColor: lmColorHex("#202620"))
        basicsLabel.text = "Basics"
        scrollView.addSubview(basicsLabel)
        basicsLabel.snp.makeConstraints {
            $0.left.equalTo(phoneNumlb)
            $0.top.equalTo(collectionView.snp.bottom).offset(18)
        }

        [nickName, sex, age, city].forEach {
            $0.backgroundColor = .white
            $0.snp.makeConstraints { $0.height.equalTo(50) }
        }
        let stackView = UIStackView(arrangedSubviews: [nickName, sex, age, city])
        stackView.backgroundColor = .white
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 13
        stackView.clipsToBounds = true
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(basicsLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(22)
            make.width.equalTo(kScreenWidth - 44)
        }

        let signatureLabel = UILabel(lmfont: lmFontR(16), textColor: lmColorHex("#202620"))
        signatureLabel.text = "Signature"
        scrollView.addSubview(signatureLabel)
        signatureLabel.snp.makeConstraints {
            $0.left.equalTo(phoneNumlb)
            $0.top.equalTo(stackView.snp.bottom).offset(18)
        }

        let signatureView = UIView()
        signatureView.backgroundColor = .white
        signatureView.layer.cornerRadius = 13
        scrollView.addSubview(signatureView)
        signatureView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(22)
            $0.top.equalTo(signatureLabel.snp.bottom).offset(10)
            $0.width.equalTo(kScreenWidth - 44)
            $0.height.equalTo(58)
            $0.bottom.equalToSuperview().offset(-(kTabBarSafeHeight + 28))
        }

        signatureView.addSubview(sginLabrl)
        sginLabrl.numberOfLines = 1
        sginLabrl.lineBreakMode = .byTruncatingTail
        sginLabrl.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-72)
        }

        signatureView.addSubview(addsginbtn)
        addsginbtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(44)
            $0.height.equalTo(28)
        }
    }

    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
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
        nickName.addGestureTap { [weak self] _ in
            self?.turnToEditName()
        }
        sex.addGestureTap { [weak self] _ in
            let items = [
                PickerListModel(title: "Male", value: 1),
                PickerListModel(title: "Female", value: 2)
            ]
            let picker = LMPickerVC(theme: .light, title: "Gender", dataSource: items, cancel: "Cancel", confirm: "Confirm") {[weak self] item in
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
            let picker = LMCityDataPickerVC(title: "Country", pickerType: .city, cancel: "Cancel", confirm: "Confirm") {[weak self] string in
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
            let picker = LMCityDataPickerVC(title: "Birthday", pickerType: .data, cancel: "Cancel", confirm: "Confirm") {[weak self] string in
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
        let width = (collectionView.bounds.width - 24) / 3
        return CGSize(width: width, height: 128)
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
