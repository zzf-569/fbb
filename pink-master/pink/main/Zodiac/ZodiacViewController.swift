import UIKit
class ZodiacViewController: UIViewController{
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabHeight))
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never

        return view
    }()
    let viewModel = ZodiacViewModel()
    var pagView: PAGView = PAGView()
    lazy var resultView: LMZodiacResaultView = {
        let view = LMZodiacResaultView()
        view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        AppConfig.keyWindow.addSubview(view)
        view.isHidden = true
        return view
    }()
    lazy var headView: ZodiacHeaderView = {
        let view = ZodiacHeaderView()
        view.frame = CGRect(x: 0, y: kStatusBarHeight, width: kScreenWidth, height: kScaleWidth(104))
        return view
    }()
   
    lazy var Avatat: UIImageView = {
        let imageV = UIImageView()
        imageV.cornerRadius(32)
        imageV.contentMode = .scaleAspectFill
        return imageV
    }()
    lazy var tips: UILabel = {
        let lb = UILabel()
        lb.font = lmFontR(10)
        lb.textColor = lmColorHex("#FFD6BF")
        lb.backgroundColor = lmColorHex("#FFD6BF1A")
        lb.cornerRadius(6)
        lb.textAlignment = .center
        lb.text = "温馨提示：生肖配对仅用于娱乐，不具有科学依据。剩余4/4次"
        return lb
    }()
    lazy var gygView: ScratchCardView = {
        let view = ScratchCardView()
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .darkGray
        setViewSnp()
        let LM = UserDefaults().bool(forKey: "firstyd")
        if LM == false {
           let view = LMZodiacYDView()
            view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
            AppConfig.keyWindow.addSubview(view)
        }
        viewModel.getzodiac { model in
            self.gygView.luckNum.text = model.luckyNumber
            self.headView.confData(model: model)
        }
    }
    func setViewSnp() {
        view.addSubview(scrollView)
        let bgImage = UIImageView(image: UIImage(named: "Zodiac_bg"))
        bgImage.frame = self.view.bounds
        scrollView.addSubview(bgImage)
        scrollView.addSubview(headView)
        pagView.add(self)
        if let resourcePath = Bundle.main.path(forResource: "xp", ofType: "pag") {
            pagView.setPath(resourcePath)
        }
        pagView.setRepeatCount(1)
        scrollView.addSubview(pagView)
        pagView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kStatusBarHeight + kScaleWidth(156))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(364), height: kScaleWidth(364)))
        }
        scrollView.addSubview(Avatat)
        Avatat.snp.makeConstraints { make in
            make.center.equalTo(pagView)
            make.size.equalTo(CGSize(width: kScaleWidth(64), height: kScaleWidth(64)))
        }
        Avatat.set_Image(url: UserShared.user?.avatar)
        scrollView.addSubview(tips)
        tips.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight + kScaleWidth(108))
            make.size.equalTo(CGSize(width: kScaleWidth(303), height: kScaleWidth(24)))
        }
        pagView.addGestureTap { _ in
            self.requestData()
            self.pagView.play()
            self.pagView.isUserInteractionEnabled = false
        }
        scrollView.addSubview(gygView)
        gygView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pagView.snp.bottom).offset(34)
            make.size.equalTo(CGSize(width: kScaleWidth(294), height: kScaleWidth(132)))
        }
        view.layoutIfNeeded()
        gygView.setup()
        let num = UserDefaults().integer(forKey: "zodiacCout")
        self.tips.text = "温馨提示：生肖配对仅用于娱乐，不具有科学依据。剩余\(4 - num)/4次"
        scrollView.contentSize = CGSize(width: kScreenWidth, height: gygView.frame.origin.y + gygView.frame.size.height )
    }
    func requestData() {
        var num = UserDefaults().integer(forKey: "zodiacCout")
        if num >= 4 {
            return
        }
        viewModel.getData { _ in
            num += 1
            UserDefaults().setValue(num, forKey: "zodiacCout")
        }
    }
   

}
extension ZodiacViewController: PAGViewListener {
    func onAnimationEnd(_ pagView: PAGView!) {
        self.pagView.isUserInteractionEnabled = true
        let num = UserDefaults().integer(forKey: "zodiacCout")
        self.tips.text = "温馨提示：生肖配对仅用于娱乐，不具有科学依据。剩余\(4 - num)/4次"
        self.resultView.tipslb.text = "剩余\(4 - num)/4次"
        resultView.item1.isHidden = true
        resultView.item2.isHidden = true
        resultView.item3.isHidden = true
        resultView.item4.isHidden = true
        resultView.item5.isHidden = true
        for (index, _) in self.viewModel.dataList.enumerated() {
            if index == 0 {
                resultView.item1.dataSoure = self.viewModel.dataList[0]
                resultView.item1.isHidden = false
                resultView.item1.headimage.image = UIImage(named: "zodiac_item_1")
            }
            if index == 1 {
                resultView.item2.dataSoure = self.viewModel.dataList[1]
                resultView.item2.isHidden = false
                resultView.item2.headimage.image = UIImage(named: "zodiac_item_2")
            }
            if index == 2 {
                resultView.item3.dataSoure = self.viewModel.dataList[2]
                resultView.item3.isHidden = false
            }
            if index == 3 {
                resultView.item4.dataSoure = self.viewModel.dataList[3]
                resultView.item4.isHidden = false
            }
            if index == 4 {
                resultView.item5.dataSoure = self.viewModel.dataList[4]
                resultView.item5.isHidden = false
            }
        }
        resultView.isHidden = false
    }
}
class ScratchCardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     var lastPoint: CGPoint?
     var scratchImage: UIImageView = UIImageView()
    lazy var luckNum: UILabel = {
        let lb = UILabel()
        lb.font = lmFontASHTB(80)
        lb.textAlignment = .center
        lb.textColor = lmColorHex("#BE923D")
        return lb
    }()
     var contentImage: UIImageView = UIImageView()
    func setup() {
        contentImage = UIImageView(image: UIImage(named: "gygbg"))
        contentImage.frame = bounds
        addSubview(contentImage)
        addSubview(luckNum)
        luckNum.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scratchImage = UIImageView(image: UIImage(named: "gyg"))
        addSubview(scratchImage)
        scratchImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(270), height: kScaleWidth(116)))
        }
        if UserDefaults().bool(forKey: "isgyged") == true {
            scratchImage.isHidden = true
        } else {
            scratchImage.isHidden = false
        }
        layoutIfNeeded()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        lastPoint = touches.first?.location(in: scratchImage)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let lastPoint = lastPoint else { return }
        let currentPoint = touch.location(in: scratchImage)
        erase(from: lastPoint, to: currentPoint)
        self.lastPoint = currentPoint
        let percentage = calculateScratchedPercentageSampling()
            if percentage > 0.6 {  
                revealAllContent()
            }
    }
    func revealAllContent() {
            UserDefaults().set(true, forKey: "isgyged")
            scratchImage.removeFromSuperview()
            UIView.animate(withDuration: 0.5, animations: {
                self.scratchImage.alpha = 0
            }) { _ in
                self.scratchImage.removeFromSuperview()
            }
        }
    private func erase(from startPoint: CGPoint, to endPoint: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(scratchImage.bounds.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            scratchImage.image?.draw(in: scratchImage.bounds)
            context.setLineCap(.round)
            context.setLineWidth(30)
            context.setBlendMode(.clear)
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.strokePath()
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            scratchImage.image = newImage
        }
        UIGraphicsEndImageContext()
    }
    func calculateScratchedPercentageSampling() -> CGFloat {
            guard let image = scratchImage.image else { return 0 }
            let sampleSize = 100  
            var transparentPoints = 0
            for _ in 0..<sampleSize {
                let randomX = CGFloat.random(in: 0..<image.size.width)
                let randomY = CGFloat.random(in: 0..<image.size.height)
                if isPixelTransparent(at: CGPoint(x: randomX, y: randomY)) {
                    transparentPoints += 1
                }
            }
            return CGFloat(transparentPoints) / CGFloat(sampleSize)
        }
    private func isPixelTransparent(at point: CGPoint) -> Bool {
            guard let image = scratchImage.image,
                  let cgImage = image.cgImage,
                  let pixelData = cgImage.dataProvider?.data,
                  let data = CFDataGetBytePtr(pixelData) else {
                return false
            }
            let x = Int(point.x)
            let y = Int(point.y)
            let width = cgImage.width
            if x < 0 || x >= width || y < 0 || y >= cgImage.height {
                return false
            }
            let pixelIndex = (width * y + x) * 4
            let alpha = data[pixelIndex + 3]
            return alpha < 50  
        }
}
