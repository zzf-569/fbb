import Foundation
struct CommonNetWork {
    struct skillList: BaseTargetType {
        var path: String { "common/skill/list" }
        var parameters: [String: Any]? {
            let dict: [String: Any] = [:]
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct typeList: BaseTargetType {
        var path: String { "common/type/list" }
        var parameters: [String: Any]? {
            let dict: [String: Any] = [:]
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct podcastTypeList: BaseTargetType {
        var path: String { "common/type/listPodcast" }
        var parameters: [String: Any]? {
            let dict: [String: Any] = [:]
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct sendSpeak: BaseTargetType {
        let content: String
        var path: String { "bottles/throw" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["content"] = content
            dict["type"] = "text"
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct getSpeak: BaseTargetType {
        var path: String { "bottles/show" }
        var parameters: [String: Any]? {
            let dict: [String: Any] = [:]
            return dict
        }
        var method: HTTPMethod { .get }
    }
    struct zodiacRecommend: BaseTargetType {
        var path: String { "zodiac/recommend" }
        var parameters: [String: Any]? {
            let dict: [String: Any] = [:]
            return dict
        }
        var method: HTTPMethod { .get }
    }
    struct zodiacOpen: BaseTargetType {
        var openLuckNumber: Bool?
        var openMatchUser: Bool?
        var path: String { "zodiac/open" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            if let openLuckNumber = openLuckNumber {
                dict["openLuckNumber"] = openLuckNumber
            }
            if let openMatchUser = openMatchUser {
                dict["openMatchUser"] = openMatchUser
            }
            return dict
        }
        var method: HTTPMethod { .post }
    }
}
