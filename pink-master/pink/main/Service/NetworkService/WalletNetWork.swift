import Foundation
struct WalletNetWork {
    struct getAccount: BaseTargetType {
        var path: String  = "user/account"
        var parameters: [String: Any]? {
            return nil
        }
        var method: HTTPMethod { .post }
    }
    struct WalletCoinList: BaseTargetType {
        let page: Int
        var path: String  = "pay/wallet/coin"
        var parameters: [String: Any]? {
            return ["type": 0, "page": page]
        }
        var method: HTTPMethod { .post }
    }
    struct WalletCashList: BaseTargetType {
        let page: Int
        var path: String  = "pay/wallet/cash"
        var parameters: [String: Any]? {
            return ["type": 0, "page": page]
        }
        var method: HTTPMethod { .post }
    }
    struct WithdrawConfig: BaseTargetType {
        var path: String  = "pay/withdraw/config"
        var parameters: [String: Any]? {
            return [:]
        }
        var method: HTTPMethod { .post }
    }
    struct WithdrawCoin: BaseTargetType {
        let itemId: Int
        var path: String  = "pay/withdraw/coin"
        var parameters: [String: Any]? {
            return ["itemId": itemId]
        }
        var method: HTTPMethod { .post }
    }
    struct StarPay: BaseTargetType {
        let productId: String
        let hfPayType: String? = nil
        let channelId: Int
        var path: String  = "pay/start/pay"
        var parameters: [String: Any]? {
            var dict: [String: Any] = [:]
                dict["productId"] = productId
                dict["hfPayType"] = hfPayType
                dict["channelId"] = channelId
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct appleConfirm: BaseTargetType {
        let outTradeNo: String
        let receipt: String
        var path: String  = "pay/apple/confirm"
        var parameters: [String: Any]? {
            return ["outTradeNo": outTradeNo, "receipt": receipt]
        }
        var method: HTTPMethod { .post }
    }
    struct bindAccount: BaseTargetType {
        let type: String = "bank"
        let account: String
        let ext: String
        let mobile: String
        let realName: String
        let idCard: String
        var path: String  = "pay/bind/withdraw/account"
        var parameters: [String: Any]? {
            return ["type": type, "account": account, "ext": ext, "mobile": mobile, "realName": realName, "idCard": idCard]
        }
        var method: HTTPMethod { .post }
    }
    struct withdrawApply: BaseTargetType {
        let itemId: Int
        let withdrawType: Int = 1
        let account: String
        let accountName: String
        let realName: String
        let amount: Int?
        var path: String  = "pay/withdraw"
        var parameters: [String: Any]? {
            var dict: [String: Any] = ["itemId": itemId, "withdrawType": withdrawType, "account": account, "accountName": accountName, "realName": realName]
            if itemId == -1 {
                dict["amount"] = amount
            }
            return dict
        }
        var method: HTTPMethod { .post }
    }
    struct withdrawBindAccount: BaseTargetType {
        let type: String = "bank"
        let account: String
        let bankName: String
        let mobile: String
        let realName: String
        let idCard: String
        var path: String  = "pay/bind/withdraw/account"
        var parameters: [String: Any]? {
            return ["type": type, "account": account, "bankName": bankName, "mobile": mobile, "realName": realName, "idCard": idCard]
        }
        var method: HTTPMethod { .post }
    }
    struct withdrawUnbindAccount: BaseTargetType {
        let account: String
        var path: String  = "pay/unbind/withdraw/account"
        var parameters: [String: Any]? {
            return ["account": account]
        }
        var method: HTTPMethod { .post }
    }
    struct withdrawAccountList: BaseTargetType {
        var path: String  = "pay/withdraw/account/list"
        var parameters: [String: Any]? {
            return nil
        }
        var method: HTTPMethod { .post }
    }
    struct withdrawJdRealAuth: BaseTargetType {
        let frontImage: String
        let backImage: String
        var path: String  = "jd/realAuth"
        var parameters: [String: Any]? {
            return ["frontImage": frontImage, "backImage": backImage]
        }
        var method: HTTPMethod { .post }
    }
    
    
    struct paydsf: BaseTargetType {
        let tagId: String
        var path: String  = "pay/dfkdsfn/fdf223d"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
    
    struct paydsfdsf: BaseTargetType {
        let tagId: String
        var path: String  = "pay/fdkn1/dfk23"
        var parameters: [String: Any]? {
            [
                "tagId": tagId
            ]
        }
        var method: HTTPMethod { .get }
    }
}
