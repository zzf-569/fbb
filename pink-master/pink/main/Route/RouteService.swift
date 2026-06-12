import Foundation
struct RouteService {
    @MainActor static func pushUserMainPage(_ userId: String, vc: UIViewController?) {
        vc?.navigationController?.pushViewController(LMUserViewController(userId: userId), animated: true)
    }
    @MainActor static func pushChat(_ userId: String, isRoom: Bool = false, vc: UIViewController?, commandCode: String? = "") {
        let view = ChatViewController(userId, isRoom: isRoom, commandCode: commandCode, complete: {
        })
        vc?.navigationController?.pushViewController(view, animated: true)
    }
    @MainActor static func pushRoom(_ roomId: String) {
        if let RoomVC = VoiceShared.roomViewController,RoomVC.viewModel.roomItem.roomId == roomId {
           RoomVC.navigationController?.popToRootViewController(animated: true)
            if VoiceShared.floatingView != nil {
                VoiceShared.show()
            }
        }else {
            VoiceShared.turnToRM(roomId)
        }
    }
    @MainActor static func pushMyRoom(vc: UIViewController?) {
        guard let user = UserShared.user else {
            return
        }
        if user.realAuth == false {
            let view = LMAuthPopVC(theme: .light, cancel: nil, confirm: "立即认证") { title in
                if title == "立即认证" {
                    UIViewController.current?.navigationController?.pushViewController(RealAuthViewController(routetype: .toRoom), animated: true)
                }
            }
            view.show()
        } else {
            if let RoomVC = VoiceShared.roomViewController,RoomVC.viewModel.roomItem.roomId == user.roomId {
               RoomVC.navigationController?.popToRootViewController(animated: true)
                if VoiceShared.floatingView != nil {
                    VoiceShared.show()
                }
            }else {
                VoiceShared.turnToRM(user.roomId)
            }
        }
    }
    @MainActor static func bannerAction(_ banner: BannerItem, vc: UIViewController?) {
        guard UserShared.user != nil else {
            return
        }
        if banner.iosRouter.hasPrefix("http") {
            pushWeb(banner.iosRouter, title: banner.name, vc: vc)
        }
    }
    @MainActor static func pushWeb(_ url: String, title: String, vc: UIViewController?) {
        guard url.count > 0 else {
            return
        }
        UIViewController.current?.navigationController?.pushViewController(BaseWebViewController(loadUrl: url, title: title), animated: true)
    }
}
