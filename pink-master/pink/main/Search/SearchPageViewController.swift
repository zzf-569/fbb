import UIKit
class SearchPageViewController: LMBaseVC {
    private lazy var customNavigationView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var searchView: UIView = {
        let view = UIView()
            .backgroundColor(.white)
            .cornerRadius(40/2)
        return view
    }()
    private lazy var searchimv: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "he_nav_search"))
        return imv
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField(lmfont: lmFontM(16), textColor: lmColorHex("#2B313D"), placeholder: "搜索ID或昵称", placeholderColor: lmColorHex("#2B313D3D"))
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    private lazy var cancelbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontF(16), titleColor: lmColorHex("#2B313DA3"), target: self, action: #selector(cancelbtnAction))
            .lmtitle("取消")
        return btn
    }()
    lazy var searchReaultView = SearchViewController()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewSnp()
        DispatchQueue.mainDelay(0.5) {
            self.textField.becomeFirstResponder()
        }
    }
    private func setViewSnp() {
        backgroundImage = nil
        view.backgroundColor = (lmColorHex("#F5F6FAFF"))
        self.addChild(searchReaultView)
        view.addSubview(searchReaultView.view)
        view.addSubview(customNavigationView)
        customNavigationView.addSubview(searchView)
        customNavigationView.addSubview(cancelbtn)
        searchView.addSubview(searchimv)
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
            make.right.equalTo(cancelbtn.snp.left).offset(-10.0)
        }
        cancelbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40.0)
        }
        searchimv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16.0)
        }
        textField.snp.makeConstraints { make in
            make.left.equalTo(searchimv.snp.right).offset(4.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(40.0)
            make.right.equalToSuperview().offset(-12.0)
        }
        searchReaultView.view.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight + 12)
        }
    }
    func search(_ keyString: String) {
        self.textField.text = keyString
        self.textField.resignFirstResponder()
        if let keyString = self.textField.text, keyString.isEmpty == false {
            searchReaultView.keyString = keyString
        }
    }
    @objc func cancelbtnAction() {
        self.navigationController?.popViewController(animated: true)
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
        self.search(text)
        return true
    }
}
