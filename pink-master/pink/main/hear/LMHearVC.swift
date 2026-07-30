import UIKit

final class LMHearVC: UIViewController {
    private let pageViewController = LMHearPageVC()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lmColorHex("#F5F6FA")
        addPageViewController()
    }

    private func addPageViewController() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        pageViewController.didMove(toParent: self)
    }
}

extension LMHearVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView { view }
}
