import Foundation
struct UserNetWork {
    struct Info: BaseTargetType {
        let userId: String?
        let commandCode: String?
        var path: String {
            if userId == nil || userId == UserShared.user?.userId {
                return "user/info"
            }
            return "user/target/info"
        }
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            if let userId = userId, userId != UserShared.user?.userId {
                dict["targetUserId"] = userId
                dict["commandCode"] = commandCode
            }
            return dict
        }
        var method: HTTPMethod {
            if userId == nil || userId == UserShared.user?.userId {
                return .get
            }
            return .post
        }
        init(userId: String? = nil, commandCode: String? = nil) {
            self.userId = userId
            self.commandCode = commandCode
        }
    }
    struct updateUserInfo: BaseTargetType {
        var avatar: String?
        var nickname: String?
        var gender: Int?
        var city: String?
        var birthday: String?
        var photoWall: [String]?
        var signature: String?
        var timbre: String?
        var voiceUrl: String?
        var voiceSec: Int?
        var path: String  = "user/update/profile"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
                dict["avatar"] = avatar
                dict["nickname"] = nickname
                dict["gender"] = gender
                dict["city"] = city
                dict["birthday"] = birthday
                dict["photoWall"] = photoWall
                dict["signature"] = signature
                dict["timbre"] = timbre
                dict["voiceUrl"] = voiceUrl
                dict["voiceSec"] = voiceSec
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct auth: BaseTargetType {
        let cardNo: String
        let name: String
        var path: String  = "real/auth"
        var parameters: [String: Any]? {
            ["cardNo": cardNo, "name": name]
        }
        var method: HTTPMethod { .get }
    }
    struct imToken: BaseTargetType {
        var path: String  = "user/token"
        var parameters: [String: Any]? {
            nil
        }
        var method: HTTPMethod { .get }
    }
    struct like: BaseTargetType {
        let toUserId: String
        let liked: Bool
        var path: String  = "user/like"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["toUserId"] = toUserId
            dict["liked"] = liked
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct friendList: BaseTargetType {
        let type: Int
        let page: Int
        var path: String  = "user/friend/list"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["type"] = type
            dict["page"] = page
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct relationInfo: BaseTargetType {
        var path: String  = "user/relation/info"
        var parameters: [String: Any]? {
            return nil
        }
        var method: HTTPMethod { .post }
    }
    struct collectList: BaseTargetType {
        let type: Int
        let page: Int
        var path: String  = "user/collect/list"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["type"] = type
            dict["page"] = page
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct uploadPhoto: BaseTargetType {
        let url: String?
        var path: String  = "user/upload/photo"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["url"] = url
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct delePhoto: BaseTargetType {
        let photoId: Int
        var path: String  = "user/delete/photo"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["photoId"] = photoId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct search: BaseTargetType {
        let content: String
        let page: Int
        var path: String  = "user/search"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["content"] = content
            dict["page"] = page
            dict["size"] = AppConfig.pageSize
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct block: BaseTargetType {
        let toUserId: String
        let block: Bool
        var path: String  = "user/block"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["toUserId"] = toUserId
            dict["block"] = block
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct blockList: BaseTargetType {
        let page: Int
        var path: String  = "user/block/list"
        var parameters: [String: Any]? {
            let dict: [String: Any] = ["page": page]
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct emojiList: BaseTargetType {
        var path: String  = "emoji/list"
        var parameters: [String: Any]? {
            let dict: [String: Any] = [:]
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct getFaceId: BaseTargetType {
        let name: String
        let idCard: String
        var path: String  = "auth/face/getFaceId"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["name"] = name
            dict["idCard"] = idCard
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct faceCheck: BaseTargetType {
        let orderNo: String
        var path: String  = "auth/face/check"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            dict["orderNo"] = orderNo
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct logoff: BaseTargetType {
        var path: String  = "user/logoff"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct MobileCheck: BaseTargetType {
        let mobile: String
        let verifyCode: String
        var path: String  = "user/mobile/check"
        var parameters: [String: Any]? {
            ["mobile": mobile, "verifyCode": verifyCode]
        }
        var method: HTTPMethod { .post }
    }
    struct ReplaceCheck: BaseTargetType {
        let mobile: String
        let verifyCode: String
        var path: String  = "user/replace/mobile"
        var parameters: [String: Any]? {
            ["mobile": mobile, "verifyCode": verifyCode]
        }
        var method: HTTPMethod { .post }
    }
    struct IncomeList: BaseTargetType {
        let type: Int
        let dateTime: String
        let page: Int
        var path: String  = "user/income/list"
        var parameters: [String: Any]? {
            ["type": type, "dateTime": dateTime.appending("-01 00:00:00"), "page": page]
        }
        var method: HTTPMethod { .post }
    }
    struct GiftWall: BaseTargetType {
        let type: Int
        let userId: String
        var path: String  = "gift/show"
        var parameters: [String: Any]? {
            ["type": type, "userId": userId]
        }
        var method: HTTPMethod { .post }
    }
    struct IhList: BaseTargetType {
        let userId: String
        var path: String  = "ih/ihList"
        var parameters: [String: Any]? {
            ["userId": userId]
        }
        var method: HTTPMethod { .get }
    }
    struct IhDetail: BaseTargetType {
        let id: Int
        var path: String  = "ih/ihDetail"
        var parameters: [String: Any]? {
            ["id": id]
        }
        var method: HTTPMethod { .get }
    }
    struct UserLevel: BaseTargetType {
        var path: String  = "user/level"
        var parameters: [String: Any]? {
            return nil
        }
        var method: HTTPMethod { .post }
    }
    struct PartnerUserList: BaseTargetType {
        var path: String  = "host/recommend/next"
        var parameters: [String: Any]? {
            return [:]
        }
        var method: HTTPMethod { .get }
    }
    struct LikeUserList: BaseTargetType {
        var page: Int = 1
        var size: Int = AppConfig.pageSize
        var type: Int = 1
        var path: String  = "user/like/list"
        var parameters: [String: Any]? {
            return ["page": page, "size": size, "type": type]
        }
        var method: HTTPMethod { .post }
    }
    struct hostlike: BaseTargetType {
        var like: Bool = true
        var userId: String = ""
        var bodyMd5: String = ""
        var path: String  = "host/like"
        var parameters: [String: Any]? {
            return ["like": like, "userId": userId, "bodyMd5": bodyMd5]
        }
        var method: HTTPMethod { .post }
    }
    struct userLikeCount: BaseTargetType {
        var path: String  = "user/like/count"
        var parameters: [String: Any]? {
            return [:]
        }
        var method: HTTPMethod { .get }
    }
    struct userBaseInfo: BaseTargetType {
        var targetUserId: String
        var path: String  = "user/search/userId"
        var parameters: [String: Any]? {
            return ["targetUserId": targetUserId]
        }
        var method: HTTPMethod { .post }
    }
    struct randomList: BaseTargetType {
        var path: String  = "user/random/list"
        var parameters: [String: Any]? {
            return [:]
        }
        var method: HTTPMethod { .post }
    }
    struct realAuth: BaseTargetType {
        var path: String  = "user/real/auth"
        var parameters: [String: Any]? {
            return [:]
        }
        var method: HTTPMethod { .post }
    }
    struct feedback: BaseTargetType {
        var content: String = ""
        var url: [String] = []
        var path: String  = "user/feedback"
        var parameters: [String: Any]? {
            return ["content": content, "url": url]
        }
        var method: HTTPMethod { .post }
    }
    
    
    struct dfmkd: BaseTargetType {
        let tagId: String
        var path: String  = "user/dfk/223d"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
    
    struct dfmefdkd: BaseTargetType {
        let tagId: String
        var path: String  = "user/dfkewkf/1we2"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
    
    struct fdsf12: BaseTargetType {
        let tagId: String
        var path: String  = "user/amsf/"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
    
    struct dfmfsdnkd: BaseTargetType {
        let tagId: String
        var path: String  = "user/sdfm2/dfk"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
    
    struct fdskf2: BaseTargetType {
        let tagId: String
        var path: String  = "user/dfd/2@df23d"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
}
