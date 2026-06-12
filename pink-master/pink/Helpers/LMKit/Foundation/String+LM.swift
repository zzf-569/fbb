import Foundation
import UIKit

public enum AppLanguage: String, CaseIterable {
    case system
    case zhHans = "zh-Hans"
    case zhHant = "zh-Hant"
    case english = "en"

    var localizationIdentifier: String? {
        switch self {
        case .system:
            return nil
        case .zhHans:
            return rawValue
        case .zhHant:
            return rawValue
        case .english:
            return rawValue
        }
    }

    var displayName: String {
        switch self {
        case .system:
            return "跟随系统"
        case .zhHans:
            return "简体中文"
        case .zhHant:
            return "繁體中文"
        case .english:
            return "English"
        }
    }
}

public extension Notification.Name {
    static let appLanguageDidChange = Notification.Name("appLanguageDidChange")
}

public final class AppLanguageManager {
    public static let shared = AppLanguageManager()

    private init() {}

    public var currentLanguage: AppLanguage {
        let rawValue = UserDefaults.standard.string(forKey: UserDefaultKeys.appLanguage) ?? AppLanguage.system.rawValue
        return AppLanguage(rawValue: rawValue) ?? .system
    }

    public func setLanguage(_ language: AppLanguage) {
        UserDefaults.standard.set(language.rawValue, forKey: UserDefaultKeys.appLanguage)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .appLanguageDidChange, object: language)
    }

    public var locale: Locale {
        if let identifier = currentLanguage.localizationIdentifier {
            return Locale(identifier: identifier)
        }
        return Locale.current
    }

    public func localizedString(_ key: String) -> String {
        guard let identifier = currentLanguage.localizationIdentifier,
              let path = Bundle.main.path(forResource: identifier, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, tableName: "Localizable", bundle: .main, value: key, comment: "")
        }
        return NSLocalizedString(key, tableName: "Localizable", bundle: bundle, value: key, comment: "")
    }

    public func localizedString(_ key: String, arguments: [CVarArg]) -> String {
        String(format: localizedString(key), locale: locale, arguments: arguments)
    }
}

public extension String {
    var localized: String {
        AppLanguageManager.shared.localizedString(self)
    }

    func localized(_ arguments: CVarArg...) -> String {
        AppLanguageManager.shared.localizedString(self, arguments: arguments)
    }

    var length: Int {
        return self.count
    }
    var isBlank: Bool {
        return  self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var isNoBlank: Bool { !self.isBlank }
    func contains(find: String) -> Bool {
        return  self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool {
        return  self.range(of: find, options: .caseInsensitive) != nil
    }
    func separatedByString(with char: String) -> [String] {
        let arraySubstrings =  self.components(separatedBy: char)
        let arrayStrings: [String] = arraySubstrings.compactMap { "\($0)" }
        return arrayStrings
    }
    func removeSomeStringUseSomeString(removeString: String, replacingString: String = "") -> String {
        return  self.replacingOccurrences(of: removeString, with: replacingString)
    }
    func replacingCharacters(range: NSRange, replacingString: String = "") -> String {
        return (self as NSString).replacingCharacters(in: range, with: replacingString)
    }
    func removeCharacter(characterString: String) -> String {
        let characterSet = CharacterSet(charactersIn: characterString)
        return  self.trimmingCharacters(in: characterSet)
    }
    func sub(to index: Int) -> String {
        let end_Index = validIndex(original: index)
        return String(self[ self.startIndex ..< end_Index])
    }
    func sub(from index: Int) -> String {
        let start_index = validIndex(original: index)
        return String(self[start_index ..<  self.endIndex])
    }
    func sub(start: Int, length: Int = -1) -> String {
        var len = length
        if len == -1 || (start + length) >  self.count {
            len =  self.count - start
        }
        let st =  self.index( self.startIndex, offsetBy: start)
        let en =  self.index(st, offsetBy: len)
        let range = st ..< en
        return String(self[range]) 
    }
    func copy() {
        UIPasteboard.general.string = self
    }
}

public func lmLocalized(_ key: String) -> String {
    key.localized
}

public func lmLocalized(_ key: String, _ arguments: CVarArg...) -> String {
    AppLanguageManager.shared.localizedString(key, arguments: arguments)
}
public extension String {
    func textRect(maxWidth: Double, font: UIFont, minHeight: Double = 0.0) -> CGSize {
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let attributes = [NSAttributedString.Key.font: font]
        let rect = string.boundingRect(with: CGSize(width: maxWidth, height: 0), options: [origin, lead], attributes: attributes, context: nil)
        return rect.size
    }
    func textHeight(width: Double, font: UIFont, minHeight: Double = 0.0) -> Double {
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let attributes = [NSAttributedString.Key.font: font]
        let rect = string.boundingRect(with: CGSize(width: width, height: 0), options: [origin, lead], attributes: attributes, context: nil)
        return max(rect.height, minHeight)
    }
    func textWidth(height: Double, font: UIFont, minWidth: Double = 0.0) -> Double {
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let attributes = [NSAttributedString.Key.font: font]
        let rect = string.boundingRect(with: CGSize(width: 0, height: height), options: [origin, lead], attributes: attributes, context: nil)
        return max(rect.width, minWidth)
    }
    func singleLineWidth(lmfont: UIFont) -> Double {
        let attrs = [NSAttributedString.Key.font: lmfont]
        return  self.size(withAttributes: attrs as [NSAttributedString.Key: Any]).width
    }
    func singleLineHeight(lmfont: UIFont) -> Double {
        let attrs = [NSAttributedString.Key.font: lmfont]
        return  self.size(withAttributes: attrs as [NSAttributedString.Key: Any]).height
    }
}
public extension  String {
    func jsonStringToDictionary() -> [String: Any]? {
        let jsonString = self
        let jsonData: Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return (dict as! [String: Any])
        }
        return nil
    }
    func jsonStringToArray() -> [Any]? {
        let jsonString = self
        let jsonData: Data = jsonString.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return (array as! [Any])
        }
        return nil
    }
    
    func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    
    func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
}
extension String {
    public func validIndex(original: Int) -> String.Index {
        switch original {
        case ...self.startIndex.utf16Offset(in: self):
            return  self.startIndex
        case  self.endIndex.utf16Offset(in: self)...:
            return  self.endIndex
        default:
            return  self.index( self.startIndex, offsetBy: original >  self.count ?  self.count : original)
        }
    }
    public func hide12BitsPhone(combine: String = "****") -> String {
        if  self.count >= 11 {
            let pre =  self.sub(start: 0, length: 3)
            let post =  self.sub(start: 7, length: 4)
            return pre + combine + post
        } else {
            return self
        }
    }
    public func hidePhone(combine: String = "*", digitsBefore: Int = 2, digitsAfter: Int = 2) -> String {
        let phoneLength: Int =  self.count
        if phoneLength > digitsBefore + digitsAfter {
            let combineCount: Int = phoneLength - digitsBefore - digitsAfter
            var combineContent: String = ""
            for _ in 0..<combineCount {
                combineContent = combineContent + combine
            }
            let pre =  self.sub(start: 0, length: digitsBefore)
            let post =  self.sub(start: phoneLength - digitsAfter, length: digitsAfter)
            return pre + "\(combineContent)" + post
        } else {
            return self
        }
    }
    public func hideEmail(combine: String = "*", digitsBefore: Int = 1, digitsAfter: Int = 1) -> String {
        let emailArray =  self.separatedByString(with: "@")
        if emailArray.count == 2 {
            let fistContent = emailArray[0]
            let encryptionContent = fistContent.hidePhone(combine: "*", digitsBefore: 1, digitsAfter: 1)
            return encryptionContent + "@" +  emailArray[1]
        }
        return self
    }
    public func StringToHotVaule() -> String {
        guard let vaule =  self.toFloat() else {
            return self
        }
        if vaule > 1000000 {
            return String(format: "%.2fM", vaule/1000000)
        } else if vaule > 1000 {
            return String(format: "%.2fK", vaule/1000)
        }
        return self
    }
    public func getConstellation() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = dateFormatter.date(from: self.self.sub(to: 10)) {
            guard let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) else {
                return ""
            }
            let components = calendar.components([.month, .day], from: date)
            let month = components.month!
            let day = components.day!
            let mmdd = month * 100 + day
            var result = ""
            if (mmdd >= 321 && mmdd <= 331) ||
                (mmdd >= 401 && mmdd <= 419) {
                result = "白羊座"
            } else if (mmdd >= 420 && mmdd <= 430) ||
                (mmdd >= 501 && mmdd <= 520) {
                result = "金牛座"
            } else if (mmdd >= 521 && mmdd <= 531) ||
                (mmdd >= 601 && mmdd <= 621) {
                result = "双子座"
            } else if (mmdd >= 622 && mmdd <= 630) ||
                (mmdd >= 701 && mmdd <= 722) {
                result = "巨蟹座"
            } else if (mmdd >= 723 && mmdd <= 731) ||
                (mmdd >= 801 && mmdd <= 822) {
                result = "狮子座"
            } else if (mmdd >= 823 && mmdd <= 831) ||
                (mmdd >= 901 && mmdd <= 922) {
                result = "处女座"
            } else if (mmdd >= 923 && mmdd <= 930) ||
                (mmdd >= 1001 && mmdd <= 1023) {
                result = "天秤座"
            } else if (mmdd >= 1024 && mmdd <= 1031) ||
                (mmdd >= 1101 && mmdd <= 1122) {
                result = "天蝎座"
            } else if (mmdd >= 1123 && mmdd <= 1130) ||
                (mmdd >= 1201 && mmdd <= 1221) {
                result = "射手座"
            } else if (mmdd >= 1222 && mmdd <= 1231) ||
                (mmdd >= 101 && mmdd <= 119) {
                result = "摩羯座"
            } else if (mmdd >= 120 && mmdd <= 131) ||
                (mmdd >= 201 && mmdd <= 218) {
                result = "水瓶座"
            } else if (mmdd >= 219 && mmdd <= 229) ||
                (mmdd >= 301 && mmdd <= 320) {
                result = "双鱼座"
            } else {
                print(mmdd)
                result = "日期错误"
            }
            return result
        } else {
            return "未知星座"
        }
    }
    func chineseZodiac() -> String? {
        let zodiacs = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" 
        guard let birthDate = dateFormatter.date(from: self) else {
            return nil 
        }
        let calendar = Calendar.current
        let year = calendar.component(.year, from: birthDate)
        let zodiacIndex = (year - 4) % 12 
        return zodiacs[zodiacIndex]
    }
}
