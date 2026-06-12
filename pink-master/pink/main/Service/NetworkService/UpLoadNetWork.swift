import Foundation
struct UpLoadNetWork {
    struct UpToken: BaseTargetType {
        let uploadSource: Int
        var path: String {
            return "upload/policy"
        }
        var parameters: [String: Any]? {
            return ["uploadSource": uploadSource]
        }
        var method: HTTPMethod { .post }
    }
}
