import Foundation
struct DispatchItem: SmartCodable {
    var bizName: String = ""
    var bizIcon: String = ""
    var bizId: String = ""
    var bizLevel: String = ""
    var createTime: String = ""
    var updateTime: String = ""
    var dismvk: String = ""
    var dispavddm: String = ""
    var dispa9mmv: String = ""
    var id: String = ""
    var tenantId: String = ""
    var gender: LMRMPDReleaseVC.Sex = .unlimited
    var genderText: String {
        switch gender {
        case .boy:
            "男"
        case .girl:
            "女"
        case .unlimited:
            "不限"
        }
    }
    var demandPrice: String = ""
    var remark: String = ""
    var dispp3f: String = ""

    var roomId: String = ""
    var guestUser: UsInfoItem?
    var anchorUser: UsInfoItem?
}
