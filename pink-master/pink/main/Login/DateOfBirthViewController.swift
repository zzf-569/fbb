import UIKit

final class DateOfBirthViewController: LMBaseVC {
    private var selectedDate: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()

    private lazy var titleLabel: UILabel = {
        UILabel(lmfont: lmFontM(24), textColor: lmColorHex("#192218"))
            .lmtext("Select your date of birth")
            .textAlignment(.center)
    }()

    private lazy var subtitleLabel: UILabel = {
        UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#192218", alpha: 0.55))
            .lmtext("Day 1 of a new world~")
            .textAlignment(.center)
    }()

    private lazy var dateField: LMTextFiledView = {
        let field = LMTextFiledView()
        field.textField.font = lmFontR(16)
        field.textField.textColor = lmColorHex("#192218")
        field.textField.isUserInteractionEnabled = false
        field.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDatePicker)))
        return field
    }()

    private lazy var tipLabel: UILabel = {
        UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#192218", alpha: 0.3))
            .lmtext("Please make sure you are over 18 years old")
            .textAlignment(.center)
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(lmfont: lmFontR(20), titleColor: lmColorHex("#A0FA19"), target: self, action: #selector(nextAction))
            .lmtitle("Next")
            .cornerRadius(9)
        button.backgroundColor = lmColorHex("#192218")
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        updateDateText()
    }
}

private extension DateOfBirthViewController {
    func setUpView() {
        backgroundImage = UIImage(named: "login_bg")

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(dateField)
        view.addSubview(tipLabel)
        view.addSubview(nextButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavigationHeight + 24)
            make.centerX.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        dateField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(44)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(42)
        }
        tipLabel.snp.makeConstraints { make in
            make.top.equalTo(dateField.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
        }
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-146)
            make.height.equalTo(56)
        }
    }

    func updateDateText() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM d, yyyy"
        dateField.textField.text = formatter.string(from: selectedDate)
    }

    @objc func showDatePicker() {
        let pickerView = DatePickerPopupView(selectedDate: selectedDate)
        pickerView.didConfirm = { [weak self] date in
            self?.selectedDate = date
            self?.updateDateText()
        }
        pickerView.show()
    }

    @objc func nextAction() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let controller = GenderSelectViewController(birthday: formatter.string(from: selectedDate))
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

private final class DatePickerPopupView: UIView {
    var didConfirm: ((Date) -> Void)?

    private let dimView = UIView()
    private let contentView = UIView()
    private let datePicker = UIDatePicker()
    private let initialDate: Date

    init(selectedDate: Date) {
        initialDate = selectedDate
        super.init(frame: .zero)
        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        frame = window.bounds
        window.addSubview(self)
        layoutIfNeeded()
        dimView.alpha = 0
        contentView.transform = CGAffineTransform(translationX: 0, y: contentView.bounds.height)
        UIView.animate(withDuration: 0.25) {
            self.dimView.alpha = 1
            self.contentView.transform = .identity
        }
    }

    private func setUpView() {
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.48)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 24
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = initialDate
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())

        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = lmColorHex("#192218")
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)

        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = lmFontR(12)
        doneButton.setTitleColor(lmColorHex("#A0FA19"), for: .normal)
        doneButton.backgroundColor = lmColorHex("#192218")
        doneButton.layer.cornerRadius = 7
        doneButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)

        addSubview(dimView)
        addSubview(contentView)
        contentView.addSubview(closeButton)
        contentView.addSubview(doneButton)
        contentView.addSubview(datePicker)

        dimView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(354)
        }
        closeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        doneButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(closeButton)
            make.size.equalTo(CGSize(width: 68, height: 34))
        }
        datePicker.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(58)
        }
    }

    @objc private func confirm() {
        didConfirm?(datePicker.date)
        dismiss()
    }

    @objc private func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.dimView.alpha = 0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.bounds.height)
        }, completion: { _ in self.removeFromSuperview() })
    }
}
