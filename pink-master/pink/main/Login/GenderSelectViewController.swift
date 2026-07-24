import UIKit

final class GenderSelectViewController: LMBaseVC {
    let maleImageView = UIImageView()
    let femaleImageView = UIImageView()
    let otherImageView = UIImageView()
    let maleCheckImageView = UIImageView()
    let femaleCheckImageView = UIImageView()
    let otherCheckImageView = UIImageView()

    var maleNormalImage: UIImage? { didSet { updateGenderImages() } }
    var maleSelectedImage: UIImage? { didSet { updateGenderImages() } }
    var femaleNormalImage: UIImage? { didSet { updateGenderImages() } }
    var femaleSelectedImage: UIImage? { didSet { updateGenderImages() } }
    var otherNormalImage: UIImage? { didSet { updateGenderImages() } }
    var otherSelectedImage: UIImage? { didSet { updateGenderImages() } }
    var checkNormalImage: UIImage? { didSet { updateGenderImages() } }
    var checkSelectedImage: UIImage? { didSet { updateGenderImages() } }

    private let birthday: String
    private var selectedGender: UserGenderType?
    private var cards: [GenderCardView] = []

    init(birthday: String) {
        self.birthday = birthday
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

private extension GenderSelectViewController {
    func setUpView() {
        backgroundImage = UIImage(named: "login_bg")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "skip", style: .plain, target: self, action: #selector(skipAction))
        navigationItem.rightBarButtonItem?.tintColor = lmColorHex("#192218", alpha: 0.5)

        let titleLabel = UILabel(lmfont: lmFontM(24), textColor: lmColorHex("#192218"))
            .lmtext("Select your gender")
            .textAlignment(.center)
        let subtitleLabel = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#192218", alpha: 0.55))
            .lmtext("Confirm your personal identifier~")
            .textAlignment(.center)

        let maleCard = GenderCardView(title: "Male", imageView: maleImageView, checkImageView: maleCheckImageView)
        let femaleCard = GenderCardView(title: "Female", imageView: femaleImageView, checkImageView: femaleCheckImageView)
        let otherCard = GenderCardView(title: "Other", imageView: otherImageView, checkImageView: otherCheckImageView)
        cards = [maleCard, femaleCard, otherCard]
        
        maleNormalImage = UIImage(named: "man")
        maleSelectedImage = UIImage(named: "man_sele")

        femaleNormalImage = UIImage(named: "women")
        femaleSelectedImage = UIImage(named: "women_sele")

        otherNormalImage = UIImage(named: "sex_unkonw")
        otherSelectedImage = UIImage(named: "sex_unk_sele")
        
        checkNormalImage = UIImage(named: "sex_nomor")
        checkSelectedImage = UIImage(named: "sex_sele")
        
        updateGenderImages()

        maleCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectMale)))
        femaleCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectFemale)))
        otherCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectOther)))

        let stackView = UIStackView(arrangedSubviews: cards)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12

        let enterButton = UIButton(lmfont: lmFontR(20), titleColor: lmColorHex("#A0FA19"), target: self, action: #selector(enterAction))
            .lmtitle("Enter Voiro")
            .cornerRadius(9)
        enterButton.backgroundColor = lmColorHex("#192218")

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(stackView)
        view.addSubview(enterButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavigationHeight + 24)
            make.centerX.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(44)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(208)
        }
        enterButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-146)
            make.height.equalTo(56)
        }
    }

    func selectCard(at index: Int, gender: UserGenderType) {
        selectedGender = gender
        cards.enumerated().forEach { itemIndex, card in
            card.isChosen = itemIndex == index
        }
    }

    func updateGenderImages() {
        guard cards.count == 3 else { return }
        
       
        
        
        cards[0].setImages(normal: maleNormalImage, selected: maleSelectedImage, checkNormal: checkNormalImage, checkSelected: checkSelectedImage)
        cards[1].setImages(normal: femaleNormalImage, selected: femaleSelectedImage, checkNormal: checkNormalImage, checkSelected: checkSelectedImage)
        cards[2].setImages(normal: otherNormalImage, selected: otherSelectedImage, checkNormal: checkNormalImage, checkSelected: checkSelectedImage)
    }

    @objc func selectMale() { selectCard(at: 0, gender: .boy) }
    @objc func selectFemale() { selectCard(at: 1, gender: .girl) }
    @objc func selectOther() { selectCard(at: 2, gender: .unlimited) }

    @objc func enterAction() {
        guard let selectedGender else {
            HUD.showFailure("Select your gender")
            return
        }
        HUD.showLoading()
        UserNetWork.updateUserInfo(gender: selectedGender.rawValue, birthday: birthday).lmrequest { [weak self] _ in
            HUD.hide()
            self?.navigationController?.pushViewController(SetUpProfileViewController(), animated: true)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }

    @objc func skipAction() {
        navigationController?.pushViewController(SetUpProfileViewController(), animated: true)
    }

    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

private final class GenderCardView: UIView {
    var isChosen = false {
        didSet {
            titleLabel.textColor = isChosen ? lmColorHex("#192218") : lmColorHex("#192218", alpha: 0.45)
            imageView.image = isChosen ? selectedImage : normalImage
            checkImageView.image = isChosen ? checkSelectedImage : checkNormalImage
        }
    }

    private let titleLabel = UILabel()
    private let imageView: UIImageView
    private let checkImageView: UIImageView
    private var normalImage: UIImage?
    private var selectedImage: UIImage?
    private var checkNormalImage: UIImage?
    private var checkSelectedImage: UIImage?

    init(title: String, imageView: UIImageView, checkImageView: UIImageView) {
        self.imageView = imageView
        self.checkImageView = checkImageView
        super.init(frame: .zero)
        isUserInteractionEnabled = true
        
        titleLabel.text = title
        titleLabel.font = lmFontR(18)
        titleLabel.textColor = lmColorHex("#192218", alpha: 0.45)
        titleLabel.textAlignment = .center

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        checkImageView.contentMode = .scaleAspectFit

        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(checkImageView)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(42)
        }
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(4)
            make.top.equalTo(0)
            make.height.equalTo(120)
        }
        checkImageView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 38, height: 28))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImages(normal: UIImage?, selected: UIImage?, checkNormal: UIImage?, checkSelected: UIImage?) {
        normalImage = normal
        selectedImage = selected
        checkNormalImage = checkNormal
        checkSelectedImage = checkSelected
        imageView.image = isChosen ? selected : normal
        checkImageView.image = isChosen ? checkSelected : checkNormal
    }
}
