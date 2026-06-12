import Foundation
enum IMMessageType: Int, SmartCaseDefaultable {
    static var defaultCase: IMMessageType = .unknown
    case unknown = -1
    case close_mic = 0
    case open_mic = 1
    case set_admin = 2
    case cancel_admin = 3
    case upseat = 4
    case down_seat = 5
    case kick_room = 6
    case like = 7
    case lock = 8
    case unlock = 9
    case block = 10
    case mic_change = 11
    case send_animation_gift = 12
    case float_screen_gift = 13
    case all_float_screen_gift = 14
    case close_room = 15
    case set_chair = 16
    case cancel_chair = 17
    case roomInfoUpdate = 18
    case user_down_seat = 19
    case mic_special_change = 21
    case clear_seat = 22
    case auto_upseat = 23
    case update_rm_dispatch_status = 24
    case pk_open_status = 26
    case pk_value_change = 27
    case pk_stepchange = 28
    case pk_invite = 29
    case roompk_star = 30
    case pk_cancle = 31
    
    case has_ban = 39
    case hot_value = 40
    case only_hot_value = 41
    case join_room = 47
    case join = 48
    case at_msg = 49
    case text_msg = 50
    case face_msg = 51
    case game_status = 52
    case send_dress = 53
    case seat_userRefresh = 54
    case changeBGI = 55
    case dispatch_order = 101
    case dispatch_release = 102
    case userlike = 103
}
enum IMSystemMessageStyle: String, SmartCaseDefaultable {
    static var defaultCase: IMSystemMessageStyle = .common
    case common
    case income
    case outcome
    case familyApply
    case reward
    case rule
}
