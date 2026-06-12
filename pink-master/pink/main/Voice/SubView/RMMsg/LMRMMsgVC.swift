import UIKit
extension LMRMMsgVC {
    func show(_ vc: UIViewController? = nil) {
        if let viewController = vc {
            viewController.addChild(self)
            viewController.view.addSubview(self.view)
        } else {
            UIViewController.current?.addChild(self)
            UIViewController.current?.view.addSubview(self.view)
        }
        self.view.frame = UIScreen.main.bounds
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
            self.messageVC.view.y = kScreenHeight - self.messageVC.view.height
        } completion: { _ in
        }
    }
    func hide() {
        if let chatVC = self.messageVC.children.first(where: { $0 is ChatViewController }) as? ChatViewController {
            chatVC.hide()
        } else if let systemVC = self.messageVC.children.first(where: { $0 is SystemViewController }) as? SystemViewController {
            systemVC.hide()
        } else {
            UIView.animate(withDuration: 0.3) {
                self.bgView.alpha = 0
                self.messageVC.view.y = kScreenHeight
            } completion: { _ in
                self.clear()
            }
        }
    }
}
class LMRMMsgVC: UIViewController {
    private lazy var bgView: UIView = {
        let view = UIView()
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private let messageVC = LMMsgVC(isRoom: true)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setViewSnp()
    }
}
private extension LMRMMsgVC {
    func setViewSnp() {
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.addChild(messageVC)
        self.view.addSubview(messageVC.view)
        messageVC.view.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight/5*4)
    }
    func clear() {
        self.messageVC.view.removeFromSuperview()
        self.messageVC.removeFromParent()
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
