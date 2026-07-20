//
//  LMTextFiledView.swift
//  pink
//
//  Created by xfffff on 2026/7/14.
//  Copyright © 2026 pink. All rights reserved.
//

import UIKit

class LMTextFiledView: UIView {

    lazy var leftIcon: UIImageView = {
        let imageV = UIImageView().image(UIImage(named: "textF_left"))
        return imageV
    }()
    
    lazy var rightIcon: UIImageView = {
        let imageV = UIImageView().image(UIImage(named: "textF_right"))
        return imageV
    }()
    
    lazy var textField: UITextField = {
        let textF = UITextField()
        textF.textAlignment = .center
        textF.tintColor = lmColorHex("#ffA0FA19")
        return textF
    }()
    
    init() {
        super.init(frame: .zero)
        configui()
        addDashedBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configui() {
        addSubview(leftIcon)
        addSubview(rightIcon)
        addSubview(textField)
        
        leftIcon.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(12)
        }
        
        rightIcon.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(12)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview()
        }
        
    }
    
    
    func addDashedBorder(
            cornerRadius: CGFloat = 0,
            borderWidth: CGFloat = 1,
            dashPattern: [NSNumber] = [6, 3],
            borderColor: UIColor = .lightGray
        ) {
            // 移除旧虚线层，防止重复添加
            self.textField.layer.sublayers?.forEach { layer in
                if layer.name == "DashedBorderLayer" {
                    layer.removeFromSuperlayer()
                }
            }
            
            let dashLayer = CAShapeLayer()
            dashLayer.name = "DashedBorderLayer"
            dashLayer.fillColor = UIColor.clear.cgColor
            dashLayer.strokeColor = borderColor.cgColor
            dashLayer.lineWidth = borderWidth
            // 虚线规则：\[实线长度, 空隙长度\]
            dashLayer.lineDashPattern = dashPattern
            
            // 圆角路径
            let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
            dashLayer.path = path.cgPath
            dashLayer.frame = self.bounds
            
            // 放在最底层
            self.textField.layer.insertSublayer(dashLayer, at: 0)
        }

}
