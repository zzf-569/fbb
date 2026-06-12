import UIKit
import AVFoundation
import Photos
class LimitsViewController: LMBaseVC {
    var dataList: [LimitsItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(target: self, cellTypes: [LimitsTableViewCell.self])
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        setDataSoure()
    }
    private func setViewSnp() {
        title = "隐私权限"
        backgroundImage = nil
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight)
        }
    }
    func setDataSoure() {
        let model = LimitsItem(title: "访问摄像头权限", subtitle: "用于图片上传时拍摄照片等", icon: "me_Camera", status: checkCameraPermission())
        let model2 = LimitsItem(title: "访问相册权限", subtitle: "用于图片上传时添加图片，修改头像等", icon: "me_Lib", status: checkPhotoLibraryPermission())
        let model3 = LimitsItem(title: "访问麦克风权限", subtitle: "用于语音房实时语音等", icon: "me_mic", status: checkMicroPermission())
        dataList = [model, model2, model3]
    }
    func checkCameraPermission() -> Bool {
        let mediaType = AVMediaType.video
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch authorizationStatus {
        case .notDetermined:  
            return false
        case .authorized:  
            return true
        case .denied:  
            return false
        case .restricted:  
            return false
        @unknown default:
            return false
        }
    }
    func checkPhotoLibraryPermission() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:  
            return false
        case .authorized:  
            return true
        case .denied:  
            return false
        case .restricted:  
            return false
        case .limited:
            return false
        @unknown default:
            return false
        }
    }
    func checkMicroPermission() -> Bool {
        let mediaType = AVMediaType.audio
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
            switch authorizationStatus {
            case .notDetermined:  
                return false
            case .authorized:  
                return true
            case .denied:  
                return false
            case .restricted:  
                return false
            @unknown default:
                return false
            }
        }
}
extension LimitsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: LimitsTableViewCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingUrl = URL(string: UIApplication.openSettingsURLString)
        if let url = settingUrl,
            UIApplication.shared.canOpenURL(url) {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
