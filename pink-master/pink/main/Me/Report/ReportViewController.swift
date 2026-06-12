import UIKit
import ZLPhotoBrowser
import Qiniu
extension ReportViewController {
    enum ReportType: Int {
        case user = 1
        case official = 2
        case room = 3
    }
}
class ReportViewController: LMBaseVC {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: kNavigationHeight, width: kScreenWidth, height: kScreenHeight - kNavigationHeight - 16.0 - 56.0 - 32.0 - kTabBarSafeHeight))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private lazy var contentView: UIView = {
        let view = UIView(frame: scrollView.bounds)
        return view
    }()
    private lazy var targetView: ReportTargetView = {
        let targetView = ReportTargetView()
            .backgroundColor(.white)
            .cornerRadius(16)
        return targetView
    }()
    private lazy var textReasonView: ReportReasonView = {
        let reasonView = ReportReasonView()
            .backgroundColor(.white)
        return reasonView
    }()
    private lazy var imageReasonView: Reportimv = {
        let imageReasonView = Reportimv()
            .backgroundColor(.white)
        return imageReasonView
    }()
    private lazy var sendbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontASHTB(18), titleColor: lmColorHex("#FFFFFF"), target: self, action: #selector(reportbtnAction))
            .backgroundColor(lmColorHex("#FF4F7DFF"))
            .cornerRadius(12)
            .lmtitle("提交")
        return btn
    }()
    private let reportType: ReportType
    private let usInfoItem: UsInfoItem?
    private let roomItem: RoomItem?
    private var dataSource: [ReportReasonItemModel] = []
    private var reasonText: String?
    private var selectedResults: [ZLResultModel] = []
    init(reportType: ReportType, UsInfoItem: UsInfoItem? = nil, roomItem: RoomItem? = nil) {
        self.reportType = reportType
        self.usInfoItem = UsInfoItem
        self.roomItem = roomItem
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage = nil
        view.backgroundColor = lmColorHex("#F7F8FAFF")
        setViewSnp()
        getViewData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
private extension ReportViewController {
    func setViewSnp() {
        let backV = UIImageView(image: UIImage(named: "report_bg"))
            .frame(CGRect(x: 0, y: 0, width: kScreenWidth, height: kScaleWidth(370)))
        view.addSubview(backV)
        let btn = UIButton(image: UIImage(named: "cm_back_white"), target: self, action: #selector(backItemDidiClick))
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(12))
            make.top.equalToSuperview().offset(kStatusBarHeight)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        let titleL = UILabel(lmfont: lmFontASHTB(21), textColor: .white)
            .lmtext("违规举报")
        view.addSubview(titleL)
        titleL.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12 + kNavigationHeight)
            make.height.equalTo(32)
        }
        let subtitle = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#FFFFFFA3"))
            .lmtext("Hi，给出你的小建议吧～")
        view.addSubview(subtitle)
        subtitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(48 + kNavigationHeight)
            make.height.equalTo(22)
        }
        view.addSubview(scrollView)
        view.addSubview(sendbtn)
        scrollView.addSubview(contentView)
        contentView.addSubview(targetView)
        contentView.addSubview(textReasonView)
        contentView.addSubview(imageReasonView)
        if reportType != .official {
            targetView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16.0)
                make.right.equalToSuperview().offset(-16.0)
                make.top.equalToSuperview().offset(90.0)
                make.height.equalTo(64.0)
            }
            textReasonView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16.0)
                make.right.equalToSuperview().offset(-16.0)
                make.top.equalTo(targetView.snp.bottom).offset(16.0)
                make.height.equalTo(200.0)
            }
        } else {
            textReasonView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16.0)
                make.right.equalToSuperview().offset(-16.0)
                make.top.equalToSuperview().offset(12.0)
                make.height.equalTo(200.0)
            }
        }
        imageReasonView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(textReasonView.snp.bottom).offset(0.0)
            make.height.equalTo(100.0)
        }
        sendbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(scrollView.snp.bottom).offset(16.0)
            make.height.equalTo(56.0)
        }
        view.layoutIfNeeded()
        imageReasonView.set_Border(radius: 12, conrners: [.bottomLeft, .bottomRight])
        self.contentView.height = imageReasonView.bottom + 16.0
        self.scrollView.contentSize = CGSize(width: 0, height: self.contentView.height)
        if let usInfoItem = usInfoItem {
            targetView.setDataSoure(usInfoItem)
        }
        if let roomItem = roomItem {
            targetView.setDataSoure(roomItem)
        }
        textReasonView.didHeightUpdateblock = { [weak self] height in
            guard let self = self else { return }
            self.textReasonView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
            view.layoutIfNeeded()
            textReasonView.set_Border(radius: 12, conrners: [.topLeft, .topRight])
            self.contentView.height = imageReasonView.bottom + 16.0
            self.scrollView.contentSize = CGSize(width: 0, height: self.contentView.height)
        }
        textReasonView.didClickCellblock = { [weak self] indexPath in
            guard let self = self else { return }
            self.dataSource[indexPath.row].isSelected = !self.dataSource[indexPath.row].isSelected
        }
        textReasonView.didReasonTextChangeblock = { [weak self] text in
            guard let self = self else { return }
            self.reasonText = text
        }
        imageReasonView.didHeightUpdateblock = { [weak self] height in
            guard let self = self else { return }
            self.imageReasonView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
            view.layoutIfNeeded()
            self.contentView.height = imageReasonView.bottom + 16.0
            self.scrollView.contentSize = CGSize(width: 0, height: self.contentView.height)
        }
        imageReasonView.didClickCellblock = { [weak self] _ in
            guard let self = self else { return }
            self.selectPhotoAction()
        }
    }
    func getViewData() {
        set_NetWork.reportReason().lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            guard let list = [ReportReasonItemModel].deserialize(from: responseModel.data as? [Any]) else { return }
            self.dataSource = list
            self.textReasonView.setDataSoure(list)
        } failureBlock: { _ in
        }
    }
    func refreshSubviews() {
    }
    func selectPhotoAction() {
        if self.selectedResults.count == 3 {
            self.clickPho()
        } else {
            let items = [
                LMSheetTabModel(title: "摄像头", titleColor: "#2B313D"),
                LMSheetTabModel(title: "相册", titleColor: "#2B313D")
            ]
            LMSheetTableVC(title: nil, dataSource: items, cancel: "取消") { item in
                guard let item = item else { return }
                if item.title == "摄像头" {
                    self.clickCam()
                }
                if item.title == "相册" {
                    self.clickPho()
                }
            }.show()
        }
    }
    @objc func backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
    func clickCam() {
        let camera = ZLCustomCamera()
        camera.takeDoneBlock = { [weak self] (image, _) in
            if let image = image {
                HUD.showLoading()
                ZLPhotoManager.saveImageToAlbum(image: image) { suc, asset in
                    if suc != nil, let asset = asset {
                        guard let self = self else { return }
                        let resultModel = ZLResultModel(asset: asset, image: image, isEdited: false, index: 0)
                        self.selectedResults.append(resultModel)
                        let selectedImages = self.selectedResults.map { $0.image }
                        self.imageReasonView.setDataSoure(selectedImages)
                    } else {
                        HUD.showFailure("保存图片到相册失败")
                    }
                    HUD.hide()
                }
            } else {
                HUD.showFailure("不支持视频")
            }
        }
        camera.cancelBlock = {
            lmPrint("cancel select")
        }
        self.showDetailViewController(camera, sender: nil)
    }
    func clickPho() {
        let config = ZLPhotoConfiguration.default()
        config.maxSelectCount = 3
        config.allowSelectVideo = false
        let ac = ZLPhotoPreviewSheet(results: self.selectedResults)
        ac.selectImageBlock = { [weak self] results, _ in
            guard let self = self else { return }
            self.selectedResults = results
            let selectedImages = self.selectedResults.map { $0.image }
            self.imageReasonView.setDataSoure(selectedImages)
        }
        ac.cancelBlock = {
            lmPrint("cancel select")
        }
        ac.selectImageRequestErrorBlock = { errorAssets, errorIndexs in
            lmPrint("fetch error assets: \(errorAssets), error indexs: \(errorIndexs)")
        }
        ac.showPhotoLibrary(sender: self)
    }
    @objc func reportbtnAction() {
        let selectedModels = dataSource.filter { $0.isSelected }.map { $0.desc }
        guard selectedModels.count > 0 else {
            HUD.showFailure("请选择举报原因")
            return
        }
        guard let reasonText = reasonText, reasonText.count > 0 else {
            HUD.showFailure("请输入文本描述")
            return
        }
        if selectedResults.count > 0 {
            let selectedImages = selectedResults.map { $0.image }
            HUD.showLoading("上传中...")
            var imageUrls = [String]()
            let group = DispatchGroup()
            for image in selectedImages {
                group.enter()
                let imageData = image.jpegData(compressionQuality: 0.8)
                UpLoadNetWork.UpToken(uploadSource: 0).lmrequest { responseModel in
                    guard let token = (responseModel.data as? [String: Any])?["token"] as? String,
                          let prefix = (responseModel.data as? [String: Any])?["prefix"] as? String else {
                        group.leave()
                        return
                    }
                    let key = prefix + "\(Date().timeIntervalSince1970*1000*1000)" + ".jpeg"
                    guard let upManager = QNUploadManager() else {
                        group.leave()
                        return
                    }
                    upManager.put(imageData, key: key, token: token, complete: { _, key, _ in
                        if let key = key {
                            let imageUrl = AppConfig.URL.resource + key
                            imageUrls.append(imageUrl)
                        } else {
                        }
                        group.leave()
                    }, option: nil)
                } failureBlock: { error in
                    group.leave()
                    HUD.showFailure(error.message)
                }
            }
            group.notify(queue: .main) {
                if imageUrls.count == selectedImages.count {
                    self.report(content: reasonText, images: imageUrls, reportReason: selectedModels)
                } else {
                    HUD.showFailure("上传失败")
                }
            }
        } else {
            report(content: reasonText, images: [], reportReason: selectedModels)
        }
    }
    func report(content: String, images: [String], reportReason: [String]) {
        var targetId: String = ""
        if let userId = usInfoItem?.userId {
            targetId = userId
        }
        if let roomId = roomItem?.roomId {
            targetId = roomId
        }
        HUD.showLoading("发送中...")
        set_NetWork.report(targetId: targetId, reportType: reportType.rawValue, content: content, images: images, reportReason: reportReason).lmrequest { _ in
            HUD.showSuccess("发送成功")
            self.navigationController?.popViewController(animated: true)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }
}
