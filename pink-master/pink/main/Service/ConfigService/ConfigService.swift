import Foundation
enum VersionStatus: Int {
    case normal = 0
    case lastVersion = 1
    case moreVersion = 2
}
class ConfigService {
    static let shared = ConfigService()
    private init() {}
    var reviewStatus: Bool = true
    func getConfig(complete: @escaping (VersionModel) -> Void) {
        set_NetWork.checkVersion().lmrequest { responseModel in
            guard let model =  VersionModel.deserialize(from: responseModel.data as? [String: Any]) else { return }
            let versionStatus = self.checkVersion(version: model.version)
            if versionStatus == .moreVersion {
                self.reviewStatus = true
            }
            if versionStatus == .normal {
                self.reviewStatus = model.status == 1 ? true : false
            }
            if versionStatus == .lastVersion {
                self.reviewStatus = false
            }
            complete(model)
        } failureBlock: { _ in
        }
    }
    func getCustomer() {
        MessageNetWork.getCustomer().lmrequest { responseModel in
            guard let customerID = responseModel.data as? String else {return }
            AppConfig.IMConfig.customUserId = customerID
        } failureBlock: { _ in
        }
    }
    func checkVersion(version: String) -> VersionStatus {
        if version == kAppShortVersion {
            return .normal
        }
        let appVersion: [String] = kAppShortVersion.components(separatedBy: ".")
        let version: [String] = version.components(separatedBy: ".")
        if Int(appVersion[0]) ?? 0 < Int(version[0]) ?? 0 {
            return .lastVersion
        }
        if Int(appVersion[1]) ?? 0 < Int(version[1]) ?? 0 {
            return .lastVersion
        }
        if Int(appVersion[2]) ?? 0 < Int(version[2]) ?? 0 {
            return .lastVersion
        }
        return .moreVersion
    }
}
