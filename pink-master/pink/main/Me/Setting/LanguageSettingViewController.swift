import UIKit

class LanguageSettingViewController: LMBaseVC {
    private var itemViews: [AppLanguage: LMVerticalView] = [:]

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "语言设置"
        backgroundImage = nil
        view.backgroundColor = .white
        setViewSnp()
        reloadLanguageState()
    }
}

private extension LanguageSettingViewController {
    func setViewSnp() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavigationHeight)
            make.left.right.bottom.equalToSuperview()
        }

        var previousView: UIView?
        for language in AppLanguage.allCases {
            let itemView = LMVerticalView(title: language.displayName, type: .lbType)
                .backgroundColor(.white)
            itemView.addGestureTap { [weak self] _ in
                self?.selectLanguage(language)
            }
            scrollView.addSubview(itemView)
            itemViews[language] = itemView

            itemView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(kScaleWidth(16))
                make.width.equalTo(kScreenWidth - kScaleWidth(32))
                make.height.equalTo(kScaleWidth(56))
                if let previousView = previousView {
                    make.top.equalTo(previousView.snp.bottom)
                } else {
                    make.top.equalToSuperview().offset(kScaleWidth(12))
                }
                if language == AppLanguage.allCases.last {
                    make.bottom.equalToSuperview()
                }
            }
            previousView = itemView
        }
    }

    func selectLanguage(_ language: AppLanguage) {
        AppLanguageManager.shared.setLanguage(language)
        reloadLanguageState()
        title = "语言设置"
        HUD.showSuccess("设置成功")
    }

    func reloadLanguageState() {
        let currentLanguage = AppLanguageManager.shared.currentLanguage
        for language in AppLanguage.allCases {
            itemViews[language]?.setDataSoure(subTitle: language == currentLanguage ? "当前" : "")
        }
    }
}
