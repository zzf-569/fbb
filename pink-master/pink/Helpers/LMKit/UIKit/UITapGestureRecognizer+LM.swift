import UIKit
extension   UITapGestureRecognizer {
    func didTapLabelAttributedText(_ linkDic: [String], action: @escaping (String) -> Void) {
        assert((( self.view as? UILabel) != nil), "Only supports UILabel")
        guard let label =  self.view as? UILabel,
              let attributedText = label.attributedText
              else { return }
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: attributedText)
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        let locationOfTouchInLabel =  self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        linkDic.forEach { e in
            let targetRange: NSRange = (attributedText.string as NSString).range(of: e)
            let isContain = NSLocationInRange(indexOfCharacter, targetRange)
            if isContain {
                action(e)
            }
        }
    }
}
