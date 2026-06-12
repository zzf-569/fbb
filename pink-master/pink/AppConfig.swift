import Foundation
@_exported import UIKit
@_exported import SmartCodable
@_exported import Alamofire
@_exported import SnapKit
@_exported import JXSegmentedView
@_exported import JXPagingView
@_exported import SDCycleScrollView

typealias SmartCodable = SmartCodableX

#if DEBUG
let kdev = true
#else
let kdev = true
#endif
struct AppConfig {
    struct URL {
        static var base: String {
            if kdev {
                "http://cyanmo.com/"
            } else {
                "http://cyanmo.com/"
            }
        }
        static var resource: String {
            if kdev {
                "https://assets.cyanmo.com/"
            } else {
                "https://assets.cyanmo.com/"
            }
        }
        static let service = "https://web.cyanmo.com/agreement/user.html"
        static let privacy = "https://web.cyanmo.com/agreement/privacy.html"
        static let anchor = "https://web.cyanmo.com/agreement/streamer.html"
        static let room = "https://web.cyanmo.com/agreement/room.html"
        static let recharge = "https://web.cyanmo.com/agreement/recharge.html"
        static let minorsProtection = "https://web.cyanmo.com/agreement/minor.html"
        static let union = "https://web.cyanmo.com/agreement/family.html"
    }
    static let pageSize: Int = 20
    static let keyWindow = UIWindow(frame: UIScreen.main.bounds)
    static var channel: String {
        "appStore"
    }
    struct RTCInfo {
        static var appId: Int {
            if kdev {
                202647013
            } else {
                202647013
            }
        }
        static var appSign: String {
            if kdev {
                "9f1411682a68b3ca139ea7e1f9132ff7399d7b667e054f4b9bf37133e3adb17f"
            } else {
                "9f1411682a68b3ca139ea7e1f9132ff7399d7b667e054f4b9bf37133e3adb17f"
            }
        }
    }
    struct IMConfig {
        static var AppId: Int {
            if kdev {
                1600080970
            } else {
                1600080970
            }
        }
        static var officialIMID: String {
            if kdev {
                "pink-10000"
            } else {
                "pink-10000"
            }
        }
        static var walletIMID: String {
            if kdev {
                "pink-30000"
            } else {
                "pink-30000"
            }
        }
        static var dispatchIMID: String {
            if kdev {
                "pink-40000"
            } else {
                "pink-40000"
            }
        }
        static var customUserId: String = ""
    }
    struct FACE {
        static var appId: String {
            "IDAPAk87"
        }
        static var License: String {
            "IATN9maWhVJaBxVNUM0WEtd60vQ72vnDU5MRQi+mMhJ0btqQDZRL7+jAOabpU3zBHvKsW1KIi7v1VBoukGV8VwjYdk/d5nU7yPaQCjLrFugNsdEYtof8rMB6en8ih9PAv9Igdl/I4MLnezF9BxV9E2X4r6aWKa/jemzc8s7Ou0oKZCtZNQXODKvNGGxIuLSNKvDIeQfxjiuee5NlTrt772j274vVNhBLQatWbANrp6Vly6hNPsNSqCnN9UOc3qXly3lXRWpQv3Qpl7dlI0FTo7lIXdERxzIH9lX03r7seebShfSachwe5WgX15B/DuOGHdBaAM1o7oUgFW8Aas+bbA=="
        }
    }
}
