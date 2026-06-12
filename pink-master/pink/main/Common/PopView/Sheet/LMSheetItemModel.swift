import Foundation
struct LMSheetItemModel {
    let title: String
    let imageName: String
    let isEnable: Bool
    let index: Int
    var theme: Theme = .iamgeWithTitle
    init(title: String, imageName: String, isEnable: Bool = true, index: Int = 0, theme: Theme = .iamgeWithTitle) {
        self.title = title
        self.imageName = imageName
        self.isEnable = isEnable
        self.index = index
        self.theme = theme
    }
}
enum Theme {
    case iamgeWithTitle
    case onlyImage
    case onlyTitle
}
