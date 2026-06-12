import Foundation
import AttributedString

public extension   NSAttributedString {
    var localized: NSAttributedString {
        guard length > 0 else {
            return self
        }

        let result = NSMutableAttributedString()
        enumerateAttributes(in: NSRange(location: 0, length: length), options: []) { attributes, range, _ in
            let string = (self.string as NSString).substring(with: range)
            result.append(NSAttributedString(string: string.localized, attributes: attributes))
        }
        return result
    }

    func textHeight(width: Double) -> Double {
        let attSize =  self.boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return ceil(attSize.height)
    }
    func textWidth(height: Double) -> Double {
        let attSize =  self.boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: height), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return ceil(attSize.width)
    }
    func textSize(width: Double) -> CGSize {
        let attSize =  self.boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return CGSize(width: ceil(attSize.width), height: ceil(attSize.height))
    }
}

public extension ASAttributedString {
    var localized: ASAttributedString {
        ASAttributedString(value.localized)
    }
}
