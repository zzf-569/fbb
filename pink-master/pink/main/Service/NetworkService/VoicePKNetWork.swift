import Foundation
struct RoomPKNetWork {
    struct openPK: BaseTargetType {
        let roomId: String
        var path: String { "room/open/pk" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct closePK: BaseTargetType {
        let roomId: String
        var path: String { "room/close/pk" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct startPK: BaseTargetType {
        let roomId: String
        let pkTime: Int
        var path: String { "room/start/pk" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["pkTime"] = pkTime
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct endPK: BaseTargetType {
        let roomId: String
        let roundId: String
        var path: String { "room/end/pk" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["roundId"] = roundId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct roompklist: BaseTargetType {
        let roomId: String
        let page: Int
        let size: Int = AppConfig.pageSize
        var path: String { "room/pk/list" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["size"] = size
            dict["page"] = page
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct roompkInvite: BaseTargetType {
        let roomId: String
        let targetRoomId: String
        let pkTime: Int
        var path: String { "room/invite/pk" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["targetRoomId"] = targetRoomId
            dict["pkTime"] = pkTime
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct roomPkCancle: BaseTargetType {
        let inviteId: String
        var path: String { "room/cancel/invite" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["inviteId"] = inviteId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct roompkaccept: BaseTargetType {
        let roomId: String
        let inviteId: String
        let status: Int
        var path: String { "room/accept/pk" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["inviteId"] = inviteId
            dict["status"] = status
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct roompkmic: BaseTargetType {
        let roomId: String
        let inviteId: String
        let mute: Int
        var path: String { "room/pk/mic" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["inviteId"] = inviteId
            dict["mute"] = mute
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct roompkrecord: BaseTargetType {
        let roomId: String
        let page: Int
        let size: Int = AppConfig.pageSize
        let scene: Int
        var path: String { "room/pk/record" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["size"] = size
            dict["page"] = page
            dict["scene"] = scene
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct randomTploom: BaseTargetType {
        let tagId: String
        var path: String  = "room/ekjfe/3rrrmo1"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
    
    struct randoTpdsfoom: BaseTargetType {
        let tagId: String
        var path: String  = "room/fio31/d.fm"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
    
    struct fff22o: BaseTargetType {
        let tagId: String
        var path: String  = "room/sf/fek2"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
}
