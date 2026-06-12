import UIKit

class MainTabBar: UITabBar {

    override init(frame: CGRect) {
        super .init(frame: frame)
        self.layer.shadowColor = lmColorHex("#AEB1B6").cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
            super.layoutSubviews()
            var tabBarButtonIndex:CGFloat = 0

            for child in self.subviews {
                let childClass: AnyClass? = NSClassFromString("UITabBarButton")
                if child.isKind(of: childClass!) {
                    let newframe = CGRect(x:  kScreenWidth/5 * tabBarButtonIndex, y: 6, width: kScreenWidth/5, height: 48)
                    child.frame = newframe
                    tabBarButtonIndex = tabBarButtonIndex + 1
                }
            }
        }
    
}
