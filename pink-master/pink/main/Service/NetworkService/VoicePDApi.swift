import Foundation
struct RoomPDApi {
    struct daRenlist: BaseTargetType {
        let roomId: String
        let micType: Int = 1
        var path: String { "room/mic/apply/list" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["micType"] = micType
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct applyDaRenlist: BaseTargetType {
        let roomId: String
        let seatIndex: Int?
        let micType: Int = 1
        var path: String { "room/up-seat" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            if let seatIndex = seatIndex {
                dict["seatIndex"] = seatIndex
            }
            dict["micType"] = micType
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct cancelApplyDaRenlist: BaseTargetType {
        let roomId: String
        let micType: Int = 1
        var path: String { "room/cancel/mic/apply" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["micType"] = micType
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct operateDaRenSeat: BaseTargetType {
        let roomId: String
        let toUserId: String
        let upSeat: Bool
        let seatIndex: Int?
        let micType: Int = 1
        var path: String { "room/operate/user/seat" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["toUserId"] = toUserId
            dict["upSeat"] = upSeat
            if let seatIndex = seatIndex {
                dict["seatIndex"] = seatIndex
            }
            dict["micType"] = micType
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct clearDaRenList: BaseTargetType {
        let roomId: String
        let toUserId: String?
        let micType: Int = 1
        var path: String { "room/clear/mic/order" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            if let toUserId = toUserId {
                dict["toUserId"] = toUserId
            }
            dict["micType"] = micType
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct clearSeat: BaseTargetType {
        let roomId: String
        let micType: Int = 1
        var path: String { "room/clear/seat" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["micType"] = micType
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct autoUpSeat: BaseTargetType {
        let roomId: String
        let micType: Int = 1
        var path: String { "room/auto/up-seat" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["roomId"] = roomId
            dict["micType"] = micType
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct clearsdlkdt: BaseTargetType {
       
        var path: String { "room/cleardjfkz/sd" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct romdsjfkdf: BaseTargetType {
       
        var path: String { "room/djsfjks2weuf/sd" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    
    struct romdssdfdf: BaseTargetType {
       
        var path: String { "room/flksf/sd" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
    
    struct roomjkfhd: BaseTargetType {
       
        var path: String { "room/dskhfdj/sd" }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            
            return dict
        }
        var method: HTTPMethod { .post }
    }
}
