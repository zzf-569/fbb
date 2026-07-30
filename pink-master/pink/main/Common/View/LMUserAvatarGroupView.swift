import UIKit

/// A compact, self-sizing group of user avatars.
/// The first three users are shown individually. When more users exist, the
/// remaining count is displayed as the final circular item.
final class LMUserAvatarGroupView: UIView {
    private let avatarDiameter: CGFloat = 24
    private let overlap: CGFloat = 2
    private var avatarViews: [UIImageView] = []
    private var countView: UIView?
    private var adaptiveWidthConstraint: NSLayoutConstraint!

    private(set) var users: [UsInfoItem] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        adaptiveWidthConstraint = widthAnchor.constraint(equalToConstant: 0)
        adaptiveWidthConstraint.isActive = true
    }

    convenience init(users: [UsInfoItem]) {
        self.init(frame: .zero)
        setDataSource(users)
    }

   

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Replaces the displayed users and updates the view's intrinsic width.
    func setDataSource(_ users: [UsInfoItem]) {
        self.users = users
        rebuildViews()
    }

  

    override var intrinsicContentSize: CGSize {
        let itemCount = min(users.count, 3) + (users.count > 3 ? 1 : 0)
        guard itemCount > 0 else { return CGSize(width: 0, height: avatarDiameter) }
        let width = avatarDiameter * CGFloat(itemCount) - overlap * CGFloat(itemCount - 1)
        return CGSize(width: width, height: avatarDiameter)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var x: CGFloat = 0
        let views = avatarViews + (countView.map { [$0] } ?? [])
        for view in views {
            view.frame = CGRect(x: x, y: 0, width: avatarDiameter, height: avatarDiameter)
            view.layer.cornerRadius = avatarDiameter / 2
            x += avatarDiameter - overlap
        }
    }

    private func rebuildViews() {
        avatarViews.forEach { $0.removeFromSuperview() }
        countView?.removeFromSuperview()
        avatarViews.removeAll()
        countView = nil

        for user in users.prefix(3) {
            let imageView = UIImageView(image: kPlaceholder_avatar)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.borderWidth = 1.5
            imageView.layer.borderColor = UIColor.white.cgColor
            if !user.avatar.isEmpty {
                imageView.set_Image(url: user.avatar, placeholder: kPlaceholder_avatar)
            }
            addSubview(imageView)
            avatarViews.append(imageView)
        }

        if users.count > 3 {
            let remaining = users.count - 3
            let view = UIView()
            view.backgroundColor = lmColorHex("#203B3E")
            view.layer.borderWidth = 1.5
            view.layer.borderColor = UIColor.white.cgColor
            let label = UILabel()
            label.text = "\(remaining)"
            label.font = lmFontM(17)
            label.textColor = .white
            label.textAlignment = .center
            view.addSubview(label)
            label.frame = CGRect(x: 0, y: 0, width: avatarDiameter, height: avatarDiameter)
            countView = view
            addSubview(view)
        }

        invalidateIntrinsicContentSize()
        let contentSize = intrinsicContentSize
        adaptiveWidthConstraint.constant = contentSize.width
        frame.size = contentSize
        setNeedsLayout()
        superview?.setNeedsLayout()
    }
}
