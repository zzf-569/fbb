import UIKit
import AttributedString
extension LMScrollLabel {
    func startScrolling() {
        stopScrolling()
        if textView.width - maxWidth <= maxWidth {
            scrollOneRoundblock?()
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.016, target: self, selector: #selector(scrollTextAction), userInfo: nil, repeats: true)
        }
    }
    func stopScrolling() {
        timer?.invalidate()
        timer = nil
    }
    @objc private func scrollTextAction() {
        let offsetX = scrollView.contentOffset.x
        if offsetX >= textView.width {
            scrollView.contentOffset.x = 0
        } else {
            scrollView.contentOffset.x += scrollSpeed
        }
        if offsetX >= textView.width - maxWidth {
            scrollOneRoundblock?()
        }
    }
}
public class LMScrollLabel: UIView {
    public var font: UIFont = lmFontF(10)
    public var textColor: UIColor = .red
    public var maxWidth = kScreenWidth
    var scrollSpeed: CGFloat = 1.0
    public var attributedString: ASAttributedString? {
        didSet {
            updataContent()
        }
    }
    public var scrollOneRoundblock: (() -> Void)?
    private var timer: Timer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
            .backgroundColor(.clear)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
            .backgroundColor(.clear)
        return view
    }()
    private lazy var textView: UITextView = {
        let textView = UITextView(lmfont: font, textColor: textColor)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        return textView
    }()
    private lazy var duplicatedTextView: UITextView = {
        let textView = UITextView(lmfont: font, textColor: textColor)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = false
        return textView
    }()
}
private extension LMScrollLabel {
    private func setViewSnp() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(textView)
        contentView.addSubview(duplicatedTextView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        textView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.equalTo(100.0)
            make.height.equalTo(20.0)
        }
        duplicatedTextView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.equalTo(100.0)
            make.height.equalTo(20.0)
        }
        contentView.snp.makeConstraints { make in
            make.right.equalTo(textView.snp.right).offset(0.0)
        }
    }
    func updataContent() {
        guard let attributedString = attributedString else { return }
        let localizedAttributedString = attributedString.localized
        let contentSize = localizedAttributedString.value.textSize(width: Double.greatestFiniteMagnitude)
        let contentWidth = contentSize.width + maxWidth
        let contentHeight = contentSize.height
        textView.snp.updateConstraints { make in
            make.width.equalTo(contentWidth)
            make.height.equalTo(contentHeight)
        }
        duplicatedTextView.snp.updateConstraints { make in
            make.left.equalToSuperview().offset(contentWidth)
            make.width.equalTo(contentWidth)
            make.height.equalTo(contentHeight)
        }
        contentView.snp.updateConstraints { make in
            make.right.equalTo(textView.snp.right).offset(contentWidth)
        }
        scrollView.contentSize = CGSize(width: contentWidth * 2, height: bounds.height)
        textView.attributed.text = localizedAttributedString
        duplicatedTextView.attributed.text = localizedAttributedString
    }
}
