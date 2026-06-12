import UIKit
class SkillListViewController: LMBaseVC {
    var dataList: [SkillItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [SkListTableViewCell.self])
        collectionView.backgroundColor(lmColorHex("#F7F8FAFF"))
        return collectionView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataSoure()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        set_Subviews()
        setDataSoure()
    }
    private func set_Subviews() {
        title = "技能中心"
        titleColor = .textDefaulColor
        backgroundImage = nil
        view.backgroundColor = .white
        let btn = UIButton(image: UIImage(named: "cm_back_white"), target: self, action: #selector(a_backItemDidiClick))
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44) 
        let leftBarButtonItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight)
            make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
        }
    }
    func setDataSoure() {
        SkillApi.skillList().lmrequest {[weak self] responseModel in
            self?.collectionView.endRefreshing()
            guard let model = [SkillItem].deserialize(from: responseModel.data as? [Any]) else { return }
            self?.dataList = model
        } failureBlock: { _ in
            self.collectionView.endRefreshing()
        }
    }
    @objc func a_backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SkillListViewController: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: kScaleWidth(72), height: kScaleWidth(98))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: kScaleWidth(20), left: kScaleWidth(20), bottom: kScaleWidth(20), right: kScaleWidth(20))
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: SkListTableViewCell.self, cellForRowAt: indexPath)
        cell.dataSoure = dataList[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        if model.status == -1 {
            let view = SkApViewController()
            view.dataSoure = model
            self.navigationController?.pushViewController(view, animated: true)
        } else {
            let view = SkStaViewController()
            view.dataSoure = model
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}
private extension SkillListViewController {
    func addRefresh() {
        collectionView.addHeader { [weak self] in
            guard let self = self else { return }
            self.setDataSoure()
        }
        collectionView.addFooter { [weak self] in
            guard let self = self else { return }
            self.setDataSoure()
        }
        self.collectionView.footerHidden(true)
        collectionView.headerBeginRefreshing()
    }
}
