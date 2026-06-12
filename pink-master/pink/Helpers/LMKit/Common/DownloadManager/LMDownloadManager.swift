import Foundation
public enum LMDownloadFileType: String {
    case pag = ".pag"
    case vap = ".mp4"
    case apng = ".png"
    case gif = ".gif"
    case jpg = ".jpg"
}
open class LMDownloadManager {
    private let operationQueue = OperationQueue()
    private let fileManager = FileManager.default
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let animationDirectoryName = "Animation"
    private let emojiDirectoryName = "Emoji"
    private let ninePngDirectoryName = "NinePng"
    init() {
        let directoryPath = documentsDirectory.appendingPathComponent(animationDirectoryName)
        do {
            try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: true, attributes: nil)
            print("动效目录创建成功")
        } catch {
            print("创建动效目录失败: \(error)")
        }
        let emojiDirectoryPath = documentsDirectory.appendingPathComponent(emojiDirectoryName)
        do {
            try fileManager.createDirectory(at: emojiDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            print("表情目录创建成功")
        } catch {
            print("创建表情目录失败: \(error)")
        }
        let nineDirectoryPath = documentsDirectory.appendingPathComponent(ninePngDirectoryName)
        do {
            try fileManager.createDirectory(at: nineDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            print(".9目录创建成功")
        } catch {
            print("创建.9目录失败: \(error)")
        }
    }
    func downloadEmoji(emojiId: String, url: String, completionHandler: @escaping (URL?, Error?) -> Void) {
        guard let downloadURL = URL(string: url) else { completionHandler(nil, LMError(code: -1, message: "url错误")); return }
        guard let filePath = emojiFilePath(emojiId: emojiId, url: url) else {
            completionHandler(nil, LMError(code: -1, message: "url错误"))
            return
        }
        if fileManager.fileExists(atPath: filePath.path) {
            print("动效文件已存在")
            completionHandler(filePath, nil)
        } else {
            print("动效文件不存在")
            download(url: downloadURL, destinationURL: filePath, completionHandler: completionHandler)
        }
    }
    func downloadAnimation(url: String, completionHandler: @escaping (URL?, Error?) -> Void) {
        guard let downloadURL = URL(string: url) else { completionHandler(nil, LMError(code: -1, message: "url错误")); return }
        guard let animationFilePath = animationFilePath(url: url) else {
            completionHandler(nil, LMError(code: -1, message: "url错误"))
            return
        }
        if fileManager.fileExists(atPath: animationFilePath.path) {
            print("动效文件已存在")
            completionHandler(animationFilePath, nil)
        } else {
            print("动效文件不存在")
            download(url: downloadURL, destinationURL: animationFilePath, completionHandler: completionHandler)
        }
    }
    func downloadNineImage(url: String, completionHandler: @escaping (URL?, Error?) -> Void) {
        guard let downloadURL = URL(string: url) else { completionHandler(nil, LMError(code: -1, message: "url错误")); return }
        guard let animationFilePath = nineImageFilePath(url: url) else {
            completionHandler(nil, LMError(code: -1, message: "url错误"))
            return
        }
        if fileManager.fileExists(atPath: animationFilePath.path) {
            print("动效文件已存在")
            completionHandler(animationFilePath, nil)
        } else {
            print("动效文件不存在")
            download(url: downloadURL, destinationURL: animationFilePath, completionHandler: completionHandler)
        }
    }
    func download(url: URL, destinationURL: URL, completionHandler: @escaping (URL?, Error?) -> Void) {
        let task = LMDownloadTask(url: url, destinationURL: destinationURL, completionHandler: completionHandler)
        operationQueue.addOperation(task)
    }
    func cancelAllDownloads() {
        operationQueue.cancelAllOperations()
    }
}
public extension LMDownloadManager {
    func animationFilePath(url: String) -> URL? {
        guard let fileSuffix = resourceFileSuffix(url) else {
            kAssert(true, "动效文件类型不匹配")
            return nil
        }
        guard let URL = URL(string: url) else {
            kAssert(true, "动效文件URL不匹配")
            return nil
        }
        let fileName = URL.lastPathComponent
        let animationPath = documentsDirectory.appendingPathComponent(animationDirectoryName)
        let animationFilePath = animationPath.appendingPathComponent(fileName)
        return animationFilePath
    }
    func emojiFilePath(emojiId: String, url: String) -> URL? {
        guard let fileSuffix = resourceFileSuffix(url) else {
            kAssert(true, "表情文件类型不匹配")
            return nil
        }
        let fileName = emojiId + fileSuffix
        let emojiPath = documentsDirectory.appendingPathComponent(emojiDirectoryName)
        let emojiFilePath = emojiPath.appendingPathComponent(fileName)
        return emojiFilePath
    }
    func nineImageFilePath(url: String) -> URL? {
        guard let URL = URL(string: url) else {
            kAssert(true, "动效文件URL不匹配")
            return nil
        }
        let fileName =  URL.lastPathComponent
        let emojiPath = documentsDirectory.appendingPathComponent(ninePngDirectoryName)
        let emojiFilePath = emojiPath.appendingPathComponent(fileName)
        return emojiFilePath
    }
    func resourceFileSuffix(_ url: String) -> String? {
        if url.hasSuffix(LMDownloadFileType.pag.rawValue) {
            return LMDownloadFileType.pag.rawValue
        }
        if url.hasSuffix(LMDownloadFileType.vap.rawValue) {
            return LMDownloadFileType.vap.rawValue
        }
        if url.hasSuffix(LMDownloadFileType.apng.rawValue) {
            return LMDownloadFileType.apng.rawValue
        }
        return nil
    }
}
