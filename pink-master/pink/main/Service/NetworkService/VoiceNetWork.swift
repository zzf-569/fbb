import Foundation
struct RoomNetWork {
    struct create: BaseTargetType {
        let cover: String
        let title: String
        let notification: String
        var path: String {
            "room/create"
        }
        var parameters: [String: Any]? {
            [
            "cover": cover,
            "title": title,
            "notification": notification
            ]
        }
        var method: HTTPMethod { .post }
    }
    struct join: BaseTargetType {
        let roomId: String
        var path: String  = "room/join"
        var parameters: [String: Any]? {
            ["roomId": roomId]
        }
        var method: HTTPMethod { .post }
    }
    struct leave: BaseTargetType {
        let roomId: String
        var path: String  = "room/leave"
        var parameters: [String: Any]? {
            ["roomId": roomId]
        }
        var method: HTTPMethod { .post }
    }
    struct detail: BaseTargetType {
        let roomId: String
        var commandCode: String?
        var path: String  = "room/detail"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            if let commandCode = commandCode {
                dict["commandCode"] = commandCode
            }
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct upSeat: BaseTargetType {
        let roomId: String
        let seatIndex: Int?
        var path: String  = "room/up-seat"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            if let seatIndex = seatIndex {
                dict["seatIndex"] = seatIndex
            }
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct downSeat: BaseTargetType {
        let roomId: String
        var path: String  = "room/down-seat"
        var parameters: [String: Any]? {
            [
                "roomId": roomId
            ]
        }
        var method: HTTPMethod { .post }
    }
    struct operateUserSeat: BaseTargetType {
        let roomId: String
        let toUserId: String
        let upSeat: Bool
        let seatIndex: Int?
        var path: String  = "room/operate/user/seat"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["toUserId"] = toUserId
            dict["upSeat"] = upSeat
            if let seatIndex = seatIndex {
                dict["seatIndex"] = seatIndex
            }
            return dict
        }
        var method: HTTPMethod { .post }
        init(roomId: String, toUserId: String, upSeat: Bool, seatIndex: Int? = nil) {
            self.roomId = roomId
            self.toUserId = toUserId
            self.upSeat = upSeat
            self.seatIndex = seatIndex
        }
    }
    struct cancelMicApply: BaseTargetType {
        let roomId: String
        var path: String  = "room/cancel/mic/apply"
        var parameters: [String: Any]? {
            [
                "roomId": roomId
            ]
        }
        var method: HTTPMethod { .post }
    }
    struct operateUserMic: BaseTargetType {
        let roomId: String
        let toUserId: String
        let open: Bool
        var path: String  = "room/operate/user/mic"
        var parameters: [String: Any]? {
            [
                "roomId": roomId,
                "toUserId": toUserId,
                "open": open
            ]
        }
        var method: HTTPMethod { .post }
    }
    struct mic: BaseTargetType {
        let roomId: String
        let status: Int
        var path: String  = "room/mic"
        var parameters: [String: Any]? {
            [
                "roomId": roomId,
                "status": status
            ]
        }
        var method: HTTPMethod { .post }
    }
    struct updateInfo: BaseTargetType {
        let roomId: String
        let cover: String?
        let title: String?
        let notification: String?
        let path: String  = "room/update/info"
        var parameters: [String: Any]? {
            var dict = [String: Any]()
            dict["roomId"] = roomId
            if let cover = cover {
                dict["cover"] = cover
            }
            if let title = title {
                dict["title"] = title
            }
            if let notification = notification {
                dict["notification"] = notification
            }
            return dict
        }
        var method: HTTPMethod { .post }
        init(roomId: String, cover: String? = nil, title: String? = nil, notification: String? = nil) {
            self.roomId = roomId
            self.cover = cover
            self.title = title
            self.notification = notification
        }
    }
    struct operateUserSetting: BaseTargetType {
        let roomId: String
        let toUserId: String
        let admin: Bool
        var path: String  = "room/operate/user/setting"
        var parameters: [String: Any]? {
            [
                "roomId": roomId,
                "toUserId": toUserId,
                "admin": admin
            ]
        }
        var method: HTTPMethod { .post }
    }
    struct operateUserChair: BaseTargetType {
        let roomId: String
        let toUserId: String
        let chair: Bool
        var path: String  = "room/operate/user/chair"
        var parameters: [String: Any]? {
            [
                "roomId": roomId,
                "toUserId": toUserId,
                "chair": chair
            ]
        }
        var method: HTTPMethod { .post }
    }
    struct forbidUser: BaseTargetType {
        let roomId: String
        let userIdList: [String]
        let muteTime: Int
        var path: String  = "room/forbid/user"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["userIdList"] = userIdList
            dict["muteTime"] = muteTime
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct seatLock: BaseTargetType {
        let roomId: String
        let seatIndex: Int
        let type: Int
        var path: String  = "room/seat/lock"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["seatIndex"] = seatIndex
            dict["type"] = type
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct clearMicOrder: BaseTargetType {
        let roomId: String
        let toUserId: String?
        var path: String = "room/clear/mic/order"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            if let toUserId = toUserId {
                dict["toUserId"] = toUserId
            }
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct clearCharm: BaseTargetType {
        let roomId: String
        let userId: String?
        let path: String = "room/clear/charm"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            if let userId = userId {
                dict["userId"] = userId
            }
            return dict
        }
        var method: HTTPMethod { .post }
        init(roomId: String, userId: String? = nil) {
            self.roomId = roomId
            self.userId = userId
        }
    }
    struct like: BaseTargetType {
        let roomId: String
        let liked: Bool
        var path: String  = "room/like"
        var parameters: [String: Any]? {
            [
                "roomId": roomId,
                "liked": liked
            ]
        }
        var method: HTTPMethod { .post }
    }
    struct userList: BaseTargetType {
        let roomId: String
        let type: Int
        var path: String  = "room/user/list"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["type"] = type
            return dict
        }
        var method: HTTPMethod { .post }
        init(roomId: String, type: Int = 0) {
            self.roomId = roomId
            self.type = type
        }
    }
    struct micApplyList: BaseTargetType {
        let roomId: String
        let admin: Bool
        var path: String  = "room/mic/apply/list"
        var parameters: [String: Any]? {
            [
                "roomId": roomId,
                "admin": admin
            ]
        }
        var method: HTTPMethod { .post }
    }
    struct search: BaseTargetType {
        let content: String
        var path: String  = "room/search"
        var parameters: [String: Any]? {
            [
                "content": content
            ]
        }
        var method: HTTPMethod { .post }
    }
    struct list: BaseTargetType {
        let type: Int
        let page: Int
        let size: Int = AppConfig.pageSize
        var path: String  = "room/list"
        var parameters: [String: Any]? {
            [
                "page": page,
                "type": type,
                "size": size
            ]
        }
        var method: HTTPMethod { .post }
    }
    struct randomToRoom: BaseTargetType {
        let tagId: String
        var path: String  = "room/randomToRoom"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
    struct getPublicRoomId: BaseTargetType {
        var path: String  = "room/getPublicChatHall"
        var parameters: [String: Any]? {
            nil
        }
        var method: HTTPMethod { .get }
    }
    struct roomWaterFlow: BaseTargetType {
        let roomId: String
        let page: Int
        let pageSize: Int
        let type: Int
        var path: String  = "room/roomWaterFlow"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["page"] = page
            dict["pageSize"] = pageSize
            dict["type"] = type
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct close: BaseTargetType {
        let roomId: String
        var path: String  = "room/close"
        var parameters: [String: Any]? {
            ["roomId": roomId]
        }
        var method: HTTPMethod { .post }
    }
    struct openRoom: BaseTargetType {
        var roomId: String
        var cover: String?
        var roomName: String?
        var notification: String?
        var path: String  = "room/open"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
                dict["cover"] = cover
                dict["roomId"] = roomId
                dict["roomName"] = roomName
                dict["notification"] = notification
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct roomfddf: BaseTargetType {
       
        var path: String { "room/sdf/sfe" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct roomfdf32f: BaseTargetType {
       
        var path: String { "room/fkefkf3/dflm12" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct roomffekf3: BaseTargetType {
       
        var path: String { "room/ni2e/cwmefk1" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct roomfd12nif: BaseTargetType {
       
        var path: String { "room/sdfekwmff/fwekf1" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
}
