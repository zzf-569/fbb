import Foundation
import UIKit
public enum LMVerifyCodeInputStyle {
    case line      
    case border    
}
public class LMVerifyCodeInputView: UIView {
    fileprivate var shapeArray: [CAShapeLayer] = Array()  
    fileprivate var labelArray: [UILabel] = Array()       
    fileprivate var layerArray: [CALayer] = Array()       
    fileprivate var saveCode: String = ""
    public var codeNumber: Int = 0                        
    public var mainColor: UIColor?                        
    public var normalColor: UIColor?                      
    public var labelTextColor: UIColor?                   
    public var cursorColor: UIColor?                     
    public var style: LMVerifyCodeInputStyle?             
    public var margin: CGFloat = 12                       
    public var codeBackgroundColor: UIColor?              
    public var codeBlock: ((String) -> Void)?            
    fileprivate lazy var textField: UITextField = {
            let view = UITextField.init()
            view.tintColor = UIColor.clear
            view.backgroundColor = UIColor.clear
            view.textColor = UIColor.clear
            view.keyboardType = .numberPad
            view.font = lmFontASHTB(20)
            if #available(iOS 12.0, *) {
                view.textContentType =  .oneTimeCode  
            }
            view.addTarget(self, action: #selector(textChage( _:)), for: .editingChanged)
            return view
    }()
    public init(frame: CGRect, codeNumber: Int = 6, style: LMVerifyCodeInputStyle = .line, labelTextColor: UIColor = UIColor.black, mainColor: UIColor = UIColor.orange, normalColor: UIColor = UIColor.gray, cursorColor: UIColor = .black, margin: CGFloat = 12.0, codeBackgroundColor: UIColor = .clear) {
        super.init(frame: frame)
        self.codeNumber = codeNumber
        self.labelTextColor = labelTextColor
        self.mainColor = mainColor
        self.normalColor = normalColor
        self.cursorColor = cursorColor
        self.style = style
        self.margin = margin
        self.codeBackgroundColor = codeBackgroundColor
        set_UpSubview()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func set_UpSubview() {
        let width = (self.bounds.width - CGFloat(codeNumber-1)*margin)/CGFloat(codeNumber)
        self.addSubview(textField)
        textField.frame = self.bounds
        for index in 0..<codeNumber {
            let subView = UIView.init()
            subView.frame = CGRect.init(x: (width+margin)*CGFloat(index), y: 0, width: width, height: width)
            subView.isUserInteractionEnabled = false
            subView.backgroundColor = codeBackgroundColor
            self.addSubview(subView)
            let layer = CALayer.init()
            if style == .line {
                layer.frame = CGRect.init(x: 0, y: width-1, width: width, height: 1)
                if index == 0 {
                    layer.backgroundColor = mainColor?.cgColor
                } else {
                    layer.backgroundColor = normalColor?.cgColor
                }
                subView.layer.addSublayer(layer)
            } else {
                subView.set_Border(radius: 12.0, borderWidth: 0.5, borderColor: (index == 0 ? mainColor : normalColor) ?? UIColor.clear)
            }
            let label = UILabel.init()
            label.frame = CGRect.init(x: 0, y: 0, width: width, height: width)
            label.textAlignment = .center
            label.textColor = labelTextColor
            label.backgroundColor = UIColor.clear
            label.font = lmFontASHTB(20)
            subView.addSubview(label)
            let path  = UIBezierPath.init(rect: CGRect.init(x: width/2, y: (width/2)-8, width: 2, height: 16))
            let line = CAShapeLayer.init()
            line.path = path.cgPath
            line.fillColor = cursorColor?.cgColor
            subView.layer.addSublayer(line)
            if index == 0 {
                line.add(opacityAnimation(), forKey: "kOpacityAnimation")
                line.isHidden = false
            } else {
                line.isHidden = true
            }
            shapeArray.append(line)
            labelArray.append(label)
            layerArray.append(layer)
        }
        startEdit()
    }
}
extension LMVerifyCodeInputView {
    @objc func textChage(_ textField: UITextField) {
        var verStr: String = textField.text ?? ""
        if verStr.count > codeNumber {
            let substring = textField.text?.prefix(codeNumber)   
            textField.text = String(substring ?? "")
            verStr = textField.text ?? ""
        }
        if  verStr.count >= codeNumber, saveCode != textField.text {
            saveCode = textField.text ?? ""
            if self.codeBlock != nil {
                self.codeBlock?(textField.text ?? "")
            }
        }
        for index in 0..<codeNumber {
            let label: UILabel = labelArray[index]
            if index < verStr.count {
                let str: NSString = verStr as NSString
                label.text = str.substring(with: NSRange(location: index, length: 1))
            } else {
                label.text = ""
            }
            changeOpacityAnimalForShapeLayerWithIndex(index: index, hidden: index == verStr.count ? false : true)
            changeColorForLayerWithIndex(index: index, hidden: index > verStr.count ? false : true)
        }
    }
    fileprivate func changeColorForLayerWithIndex(index: NSInteger, hidden: Bool) {
        let layer = layerArray[index]
        if hidden {
            if style == .line {
                layer.backgroundColor = mainColor?.cgColor
            } else {
                layer.borderColor = mainColor?.cgColor
            }
        } else {
            if style == .line {
                layer.backgroundColor = normalColor?.cgColor
            } else {
                layer.borderColor = normalColor?.cgColor
            }
        }
    }
    fileprivate func changeOpacityAnimalForShapeLayerWithIndex(index: Int, hidden: Bool) {
        let line = shapeArray[index]
        if hidden {
            line.removeAnimation(forKey: "kOpacityAnimation")
        } else {
            line.add(opacityAnimation(), forKey: "kOpacityAnimation")
        }
        UIView.animate(withDuration: 0.25) {
            line.isHidden = hidden
        }
    }
    public func startEdit() {
        textField.becomeFirstResponder()
    }
    public func stopEdit() {
        textField.resignFirstResponder()
    }
    fileprivate func opacityAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.9
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName(rawValue: "easeIn"))
        return animation
    }
}
