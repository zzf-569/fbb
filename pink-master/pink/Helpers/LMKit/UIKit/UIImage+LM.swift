import Foundation
import UIKit
import AVFoundation
public extension   UIImage {
    func isRoundCorner(radius: CGFloat = 3, byRoundingCorners corners: UIRectCorner = .allCorners, imageSize: CGSize?) -> UIImage? {
        let weakSize = imageSize ??  self.size
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: weakSize)
        UIGraphicsBeginImageContextWithOptions(weakSize, false, UIScreen.main.scale)
        guard let contentRef: CGContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        contentRef.addPath(UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: UIRectCorner.allCorners,
                                        cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        contentRef.clip()
         self.draw(in: rect)
        contentRef.drawPath(using: .fillStroke)
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        return output
    }
    static func getVideoFirstImage(videoUrl: String, maximumSize: CGSize = CGSize(width: 1000, height: 1000), block: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: videoUrl) else {
            block(nil)
            return
        }
        DispatchQueue.global().async {
            let opts = [AVURLAssetPreferPreciseDurationAndTimingKey: false]
            let avAsset = AVURLAsset(url: url, options: opts)
            let generator = AVAssetImageGenerator(asset: avAsset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = maximumSize
            var cgImage: CGImage?
            let time = CMTimeMake(value: 0, timescale: 600)
            var actualTime: CMTime = CMTimeMake(value: 0, timescale: 0)
            do {
                try cgImage = generator.copyCGImage(at: time, actualTime: &actualTime)
            } catch {
                DispatchQueue.main.async {
                    block(nil)
                }
                return
            }
            guard let image = cgImage else {
                DispatchQueue.main.async {
                    block(nil)
                }
                return
            }
            DispatchQueue.main.async {
                block(UIImage(cgImage: image))
            }
        }
    }
}
public enum LMImageGradientDirection {
    case horizontal
    case vertical
    case leftOblique
    case rightOblique
    case other(CGPoint, CGPoint)
    public func point(size: CGSize) -> (CGPoint, CGPoint) {
        switch self {
        case .horizontal:
            return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: 0))
        case .vertical:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: size.height))
        case .leftOblique:
            return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: size.height))
        case .rightOblique:
            return (CGPoint(x: size.width, y: 0), CGPoint(x: 0, y: size.height))
        case .other(let stat, let end):
            return (stat, end)
        }
    }
}
public extension   UIImage {
    static func image(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
        return image(color: color, size: size, corners: .allCorners, radius: 0)
    }
    static func image(color: UIColor, size: CGSize, corners: UIRectCorner, radius: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if radius > 0 {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            color.setFill()
            path.fill()
        } else {
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    static func gradient(_ hexsString: [String], size: CGSize = CGSize(width: 1, height: 1), locations: [CGFloat]? = nil, direction: LMImageGradientDirection = .horizontal) -> UIImage? {
        return gradient(hexsString.map { UIColor.hex(($0)) }, size: size, locations: locations, direction: direction)
    }
    static func gradient(_ colors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), locations: [CGFloat]? = nil, direction: LMImageGradientDirection = .horizontal) -> UIImage? {
        return gradient(colors, size: size, radius: 0, locations: locations, direction: direction)
    }
    static func gradient(_ colors: [UIColor],
                         size: CGSize = CGSize(width: 10, height: 10),
                         radius: CGFloat,
                         locations: [CGFloat]? = nil,
                         direction: LMImageGradientDirection = .horizontal) -> UIImage? {
        if colors.count == 0 { return nil }
        if colors.count == 1 {
            return image(color: colors[0])
        }
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: radius)
        path.addClip()
        context?.addPath(path.cgPath)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map {$0.cgColor} as CFArray, locations: locations?.map { CGFloat($0) }) else { return nil
        }
        let directionPoint = direction.point(size: size)
        context?.drawLinearGradient(gradient, start: directionPoint.0, end: directionPoint.1, options: .drawsBeforeStartLocation)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
public extension   UIImage {
    func strechAsBubble() -> UIImage {
        let top =  self.size.height * 0.5
        let left =  self.size.width * 0.5
        let bottom =  self.size.height * 0.5
        let right =  self.size.width * 0.5
        let edgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return  self.resizableImage(withCapInsets: edgeInsets, resizingMode: .stretch)
    }
}
