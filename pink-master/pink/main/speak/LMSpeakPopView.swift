import UIKit
class LMSpeakPopView: UIView ,UITextViewDelegate{
    var compate:((String)->())? = nil
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = lmColorHex("#00000080")
        view.addGestureTap { [weak self] tap in
            self?.textView.resignFirstResponder()
        } 
        return view
    }()
    lazy var centerView: UIView = {
        let view = UIImageView(image: UIImage(named: "speakCent"))
        view.isUserInteractionEnabled = true
        return view
    }()
    var btnArrau: [UIButton] = []
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.backgroundColor = .clear
        textView.font = lmFontM(16)
        textView.delegate = self
        textView.textColor = .white
        textView.placeholder = "最多50个字"
        return textView
    }()
    lazy var sendBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "speak_send"), for: .normal)
        btn.addTarget(self, action: #selector(sendClick), for: .touchUpInside)
        return btn
    }()
    lazy var close: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "version_close"), for: .normal)
        btn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(bgView)
        addSubview(centerView)
        centerView.addSubview(textView)
        centerView.addSubview(sendBtn)
        addSubview(close)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        centerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(282))
            make.size.equalTo(CGSize(width: kScaleWidth(272), height: kScaleWidth(268)))
        }
        textView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(28)
            make.height.equalTo(kScaleWidth(160))
        }
        sendBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kScaleWidth(24))
            make.size.equalTo(CGSize(width: kScaleWidth(140), height: kScaleWidth(48)))
        }
        close.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(centerView.snp.bottom).offset(24)
            make.size.equalTo(CGSize(width: kScaleWidth(40), height: kScaleWidth(40)))
        }
        let scro = UIScrollView(frame: CGRectMake(kScaleWidth(59), kScaleWidth(230), kScreenWidth - kScaleWidth(59), kScaleWidth(28)))
        scro.showsVerticalScrollIndicator = false
        scro.showsHorizontalScrollIndicator = false
        addSubview(scro)
        let imageV = ["sp_shu","sp_niu","sp_hu","sp_tu","sp_long","sp_she","sp_ma","sp_yang","sp_hou","sp_ji","sp_gou","sp_zhu"]
        let titles = ["子鼠","丑牛","寅虎","卯兔","辰龙","巳蛇","午马","未羊","申猴","酉鸡","戌狗","亥猪"]
        for (index, string) in imageV.enumerated() {
            let btn = UIButton(lmfont: lmFontR(12), titleColor: lmColorHex("#FFFFFF"))
            btn.setImage(UIImage(named: string), for: .normal)
            btn.setTitle(titles[index], for: .normal)
            btn.backgroundColor = lmColorHex("#FFFFFF1A")
            btn.frame = CGRect(x: CGFloat(index) * kScaleWidth(84), y: 0, width: kScaleWidth(72), height: kScaleWidth(28))
            if index == 0 {
                btn.backgroundColor = lmColorHex("#FF7CC0FF")
            }
            btn.cornerRadius(kScaleWidth(14))
            scro.addSubview(btn)
            btn.addGestureTap { tap in
                for btn in self.btnArrau {
                    if btn == btn {
                        btn.backgroundColor = lmColorHex("#FF7CC0FF")
                    }else {
                        btn.backgroundColor = lmColorHex("#FFFFFF1A")
                    }
                }
            }
            btnArrau.append(btn)
        }
        scro.contentSize = CGSize(width: kScaleWidth(84) * 13, height: kScaleWidth(28))
    }
    @objc func sendClick() {
        if self.textView.text.count == 0 {
            return
        }
        compate?(self.textView.text)
    }
    @objc func closeClick() {
        self.isHidden = true
        self.removeFromSuperview()
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 50 {
            textView.text = textView.text.sub(to: 50)
        }
     }
}
