import Foundation
typealias LMHttpSuccess = (_ responseModel: ResponseModel) -> Void
typealias LMHttpFailure = (_ error: ResponseError) -> Void
protocol BaseTargetType {
    var parameters: [String: Any]? { get }
    var method: HTTPMethod {get}
    var path: String {get}
}
extension BaseTargetType {
    

    var baseURL: String {
        AppConfig.URL.base
    }
    var task: ParameterEncoding {
        let encoding: ParameterEncoding
        switch method {
        case .post:
            encoding = JSONEncoding.default
        case .get:
            encoding = URLEncoding.default
        default:
            encoding = JSONEncoding.default
        }
        return encoding
    }
    var headers: HTTPHeaders {
        var header: HTTPHeaders = []
        header.add(name: "Content-Type", value: "application/json")
        if let LoginItem = UserShared.loginToken {
            header.add(name: "Authorization", value: "\(LoginItem.tokenType) " + LoginItem.accessToken)
        }
        header["Version"] = kAppShortVersion
        header["BundleVersion"] = kAppBundleVersion
        header["OS"] = "iOS"
        header["Channel"] = AppConfig.channel
        header["osVersion"] = UIDevice.deviceSystemVersion
        header["DeviceModel"] = UIDevice.deviceType
        return header
    }

    
    func lmrequest(successBlock: @escaping LMHttpSuccess, failureBlock: @escaping LMHttpFailure) {
        
        AF.request(baseURL + "app/" + path, method: method, parameters: parameters, encoding: task, headers: headers).responseJSON { result in
            switch result.result {
            case .success(let value):
                if JSONSerialization.isValidJSONObject(value) {
                    do {
                        let cleanData = try JSONSerialization.data(
                            withJSONObject: value,
                            options: [.withoutEscapingSlashes]
                        )
                        if let jsonString = String(data: cleanData, encoding: .utf8) {
                            print("请求接口\nurl：\n\(self.method.rawValue) \(self.baseURL)\(String(describing: self.path)) \n参数:\n\(String(describing: self.parameters)) \n结果：\n\(String(describing: jsonString.jsonFormatPrint()))")
                            guard let model = ResponseModel.deserialize(from: jsonString) else {
                                failureBlock(ResponseError(code: ResponseCode.deserializeFailed.rawValue, message: "服务器返回的数据解析模型失败", data: cleanData))
                                return
                            }
                            if model.code == ResponseCode.success.rawValue || model.code == ResponseCode.upseatSuccess.rawValue || model.code == ResponseCode.upseatApplySuccess.rawValue {
                                successBlock(model)
                            } else if model.code == ResponseCode.accountInvalid.rawValue {
                                failureBlock(ResponseError(code: model.code, message: model.message, data: model))
                                guard !UserShared.isNotified else { return }
                                UserShared.isNotified = true
                                DispatchQueue.main.async {
                                    let login = LoginViewController()
                                    AppConfig.keyWindow.rootViewController = BaseNavigationController(rootViewController: login)
                                    AppConfig.keyWindow.makeKeyAndVisible()
                                }
                            } else {
                                failureBlock(ResponseError(code: model.code, message: model.message, data: model))
                            }
                        }
                    } catch {
                        print("JSON序列化错误: \(error)")
                    }
                }
                case .failure(let error):
#if DEBUG
                    print("请求接口\nurl：\n\(self.method.rawValue) \(self.baseURL)\(String(describing: self.path)) \n参数:\n\(String(describing: self.parameters)) \n结果：\n\(error)")
#endif
                    failureBlock(ResponseError(code: error.responseCode ?? 0, message: error.localizedDescription, data: error))
                }
            }
        }
    }
    extension String {
        func jsonFormatPrint() -> String {
            if self.starts(with: "{") || self.starts(with: "[") {
                var level = 0
                var jsonFormatString = String()
                func getLevelStr(level: Int) -> String {
                    var string = ""
                    for _ in 0..<level {
                        string.append("\t")
                    }
                    return string
                }
                for char in self {
                    if level > 0 && "\n" == jsonFormatString.last {
                        jsonFormatString.append(getLevelStr(level: level))
                    }
                    switch char {
                    case "{":
                        fallthrough
                    case "[":
                        level += 1
                        jsonFormatString.append(char)
                        jsonFormatString.append("\n")
                    case ",":
                        jsonFormatString.append(char)
                        jsonFormatString.append("\n")
                    case "}":
                        fallthrough
                        case "]":
                        level -= 1
                        jsonFormatString.append("\n")
                        jsonFormatString.append(getLevelStr(level: level))
                        jsonFormatString.append(char)
                    default:
                        jsonFormatString.append(char)
                    }
                }
                return jsonFormatString
            }
            return self
        }
    }
