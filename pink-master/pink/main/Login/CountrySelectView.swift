import UIKit

struct CountrySelectItem {
    let name: String
    let dialCode: String
    let flag: String
}

final class CountrySelectCell: UITableViewCell {
    static let reuseIdentifier = "CountrySelectCell"

    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 17
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = lmFontR(16)
        label.textColor = lmColorHex("#192218")
        return label
    }()

    private let codeLabel: UILabel = {
        let label = UILabel()
        label.font = lmFontR(16)
        label.textColor = lmColorHex("#192218")
        label.textAlignment = .right
        return label
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = lmColorHex("#192218", alpha: 0.55)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white

        contentView.addSubview(flagImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(codeLabel)
        contentView.addSubview(arrowImageView)

        flagImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 34, height: 34))
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(flagImageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 7, height: 13))
        }
        codeLabel.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(nameLabel.snp.right).offset(12)
            make.right.equalTo(arrowImageView.snp.left).offset(-7)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: CountrySelectItem) {
        flagImageView.image = Self.flagImage(from: item.flag)
        nameLabel.text = item.name
        codeLabel.text = item.dialCode
    }

    private static func flagImage(from flag: String) -> UIImage? {
        let size = CGSize(width: 34, height: 34)
        return UIGraphicsImageRenderer(size: size).image { _ in
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 28),
                .paragraphStyle: paragraph
            ]
            flag.draw(in: CGRect(x: 0, y: 1, width: size.width, height: size.height), withAttributes: attributes)
        }
    }
}

final class CountrySelectView: UIView {
    var didSelectCountry: ((CountrySelectItem) -> Void)?

    private let countries: [CountrySelectItem]

    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = lmColorHex("#192218")
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Country"
        label.font = lmFontM(16)
        label.textColor = lmColorHex("#192218")
        label.textAlignment = .center
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorColor = lmColorHex("#192218", alpha: 0.1)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        tableView.rowHeight = 62
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CountrySelectCell.self, forCellReuseIdentifier: CountrySelectCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()

    convenience init() {
        self.init(countries: CountrySelectView.defaultCountries)
    }

    init(countries: [CountrySelectItem]) {
        self.countries = countries
        super.init(frame: .zero)
        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(in parentView: UIView? = nil) {
        guard let targetView = parentView ?? Self.keyWindow else { return }
        frame = targetView.bounds
        targetView.addSubview(self)
        layoutIfNeeded()

        dimView.alpha = 0
        contentView.transform = CGAffineTransform(translationX: 0, y: contentView.bounds.height)
        UIView.animate(withDuration: 0.25) {
            self.dimView.alpha = 1
            self.contentView.transform = .identity
        }
    }

    @objc func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.dimView.alpha = 0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.bounds.height)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}

private extension CountrySelectView {
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .first(where: { $0.isKeyWindow })
        }
        return UIApplication.shared.keyWindow
    }

    static let defaultCountries: [CountrySelectItem] = [
        CountrySelectItem(name: "中国", dialCode: "+86", flag: "🇨🇳"),
        CountrySelectItem(name: "美国", dialCode: "+1", flag: "🇺🇸"),
        CountrySelectItem(name: "中国香港", dialCode: "+852", flag: "🇭🇰"),
        CountrySelectItem(name: "中国澳门", dialCode: "+853", flag: "🇲🇴"),
        CountrySelectItem(name: "中国台湾", dialCode: "+886", flag: "🇹🇼"),
        CountrySelectItem(name: "日本", dialCode: "+81", flag: "🇯🇵"),
        CountrySelectItem(name: "韩国", dialCode: "+82", flag: "🇰🇷"),
        CountrySelectItem(name: "新加坡", dialCode: "+65", flag: "🇸🇬"),
        CountrySelectItem(name: "马来西亚", dialCode: "+60", flag: "🇲🇾"),
        CountrySelectItem(name: "英国", dialCode: "+44", flag: "🇬🇧")
    ]

    func setUpView() {
        backgroundColor = .clear
        addSubview(dimView)
        addSubview(contentView)
        contentView.addSubview(closeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tableView)

        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(153)
        }
        closeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeButton)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(58)
        }

        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        dimView.addGestureRecognizer(tap)
    }
}

extension CountrySelectView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountrySelectCell.reuseIdentifier, for: indexPath) as? CountrySelectCell else {
            return UITableViewCell()
        }
        cell.configure(with: countries[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectCountry?(countries[indexPath.row])
        dismiss()
    }
}
