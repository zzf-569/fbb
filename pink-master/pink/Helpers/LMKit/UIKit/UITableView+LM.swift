import UIKit
public extension UITableView {
    convenience init(target: UITableViewDataSource & UITableViewDelegate, cellTypes: [UITableViewCell.Type], frame: CGRect = CGRect.zero, style: UITableView.Style = .plain) {
        self.init(frame: frame, style: style)
        self.delegate = target
        self.dataSource = target
        self.separatorStyle = .none
        self.backgroundColor = .clear
        tableViewNeverAdjustContentInset()
        for type in cellTypes {
            self.register(cellClass: type)
        }
    }
    func tableViewNeverAdjustContentInset() {
        if #available(iOS 11, *) {
            self.estimatedRowHeight = 0
            self.estimatedSectionFooterHeight = 0
            self.estimatedSectionHeaderHeight = 0
            self.contentInsetAdjustmentBehavior = .never
        }
    }
}
public extension   UITableView {
    func register(cellClass: UITableViewCell.Type) {
        let identifier = "ID" + cellClass.className
         self.register(cellClass.self, forCellReuseIdentifier: identifier)
    }
    func register(nib: UINib) {
        let identifier = "ID" + nib.className
         self.register(nib, forCellReuseIdentifier: identifier)
    }
    func dequeueReusableCell<T: UITableViewCell>(cellType: T.Type, cellForRowAt indexPath: IndexPath) -> T {
        let identifier = "ID" + cellType.className
        return  self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
}
