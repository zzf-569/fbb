import Foundation
public extension  Date {
    func dateToFormatString() -> String {
        let now = Date()
        let date = self
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        let dateFormatter = DateFormatter()
        switch components {
        case let components where components.year != 0:
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            return dateFormatter.string(from: date)
        case let components where components.month != 0:
            dateFormatter.dateFormat = "MM月dd日"
            return dateFormatter.string(from: date)
        case let components where components.day! > 1:
            dateFormatter.dateFormat = "HH:mm"
            return lmLocalized("time.before_yesterday_at", dateFormatter.string(from: date))
        case let components where components.day == 1:
            return lmLocalized("time.yesterday_at", dateFormatter.string(from: date))
        case let components where components.hour! >= 1:
            return lmLocalized("time.hours_ago", components.hour!)
        case let components where components.minute! >= 1:
            return lmLocalized("time.minutes_ago", components.minute!)
        default:
            return lmLocalized("time.just_now")
        }
    }
    func dateToFormatString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    static func timestampStringToDate(_ timestampString: String) -> Date? {
        if let timestamp = TimeInterval(timestampString) {
            if timestamp > 10 {
                return Date(timeIntervalSince1970: timestamp / 1000)
            } else {
                return Date(timeIntervalSince1970: timestamp)
            }
        }
        return nil
    }
}
