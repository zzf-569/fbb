import UIKit
class SearchPageViewController: LMBaseViewController {
    private lazy var customNavigationView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var searchView: UIView = {
        let view = UIView()
            .act_backgroundColor(.white)
            .act_cornerRadius(40/2)
        return view
    }()
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "home_nav_search"))
        return imageView
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField(lmfont: lmFontM(16), textColor: lmColorHex("#1C1C29"), placeholder: "搜索ID或昵称", placeholderColor: lmColorHex("#1C1C293D"))
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    private lazy var cancelButton: UIButton = {
        let button = UIButton(lmfont: lmFontF(16), titleColor: lmColorHex("#1C1C29A3"), target: self, action: #selector(act_cancelButtonAction))
            .act_lmtitle("取消")
        return button
    }()
    lazy var searchReaultView = SearchViewController()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        act_setUISubViews()
        DispatchQueue.act_mainDelay(0.5) {
            self.textField.becomeFirstResponder()
        }
    }
    private func act_setUISubViews() {
        backgroundImage = nil
        backgroundImageColor = (lmColorHex("#F5F6FAFF"))
        self.addChild(searchReaultView)
        view.addSubview(searchReaultView.view)
        view.addSubview(customNavigationView)
        customNavigationView.addSubview(searchView)
        customNavigationView.addSubview(cancelButton)
        searchView.addSubview(searchImageView)
        searchView.addSubview(textField)
        customNavigationView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight)
            make.height.equalTo(kNavigationBarHeight)
        }
        searchView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(40.0)
            make.right.equalTo(cancelButton.snp.left).offset(-10.0)
        }
        cancelButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40.0)
        }
        searchImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16.0)
        }
        textField.snp.makeConstraints { make in
            make.left.equalTo(searchImageView.snp.right).offset(4.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(40.0)
            make.right.equalToSuperview().offset(-12.0)
        }
        searchReaultView.view.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight + 12)
        }
    }
    func act_search(_ keyString: String) {
        self.textField.text = keyString
        self.textField.resignFirstResponder()
        if let keyString = self.textField.text, keyString.isEmpty == false {
            searchReaultView.keyString = keyString
        }
        act_setSearchHistory(keyString)
    }
    @objc func act_cancelButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func act_setSearchHistory(_ searchKey: String) {
        var dict = UserDefaults().array(forKey: UserDefaultKeys.userSeachHistory)
        if var dictn = dict {
            if dictn.contains(where: {$0 as! String == searchKey}) {
                let data = dictn.sorted { (data1, _) -> Bool in
                    if searchKey == data1 as! String {
                        return true
                    }
                    return false
                }
                dictn = data
            } else {
                dictn.insert(searchKey, at: 0)
            }
            if dictn.count > 10 {
                dictn = Array(dictn[0...9])
            }
            UserDefaults().set(dictn, forKey: UserDefaultKeys.userSeachHistory)
        } else {
            dict = [searchKey]
            UserDefaults().set(dict, forKey: UserDefaultKeys.userSeachHistory)
        }
    }
}
extension SearchPageViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }
        self.act_search(text)
        return true
    }
}
