import Foundation
import UIKit
public let kDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
public let kCachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
public let kTempPath = NSTemporaryDirectory()
public let animationDirectoryName = "Animation"
public let emojiDirectoryName = "Emoji"
public let nineDirectoryName = "NinePng"
public extension   FileManager {
    static func homeDirectory() -> String { return NSHomeDirectory() }
    static func DocumnetsDirectory() -> String {
        let ducumentPath = NSHomeDirectory() + "/Documents"
        return ducumentPath
    }
    static func LibraryDirectory() -> String {
        let libraryPath = NSHomeDirectory() + "/Library"
        return libraryPath
    }
    static func CachesDirectory() -> String {
        let cachesPath = NSHomeDirectory() + "/Library/Caches"
        return cachesPath
    }
    static func preferencesDirectory() -> String {
        let preferencesPath = NSHomeDirectory() + "/Library/Preferences"
        return preferencesPath
    }
    static func TmpDirectory() -> String {
        let tmpDir = NSHomeDirectory() + "/tmp"
        return tmpDir
    }
}
public extension   FileManager {
    enum FileWriteType {
        case TextType
        case ImageType
        case ArrayType
        case DictionaryType
    }
    enum MoveOrCopyType {
        case file
        case directory
    }
    static var fileManager: FileManager {
        return FileManager.default
    }
    @discardableResult
    static func createFolder(folderPath: String) -> (isSuccess: Bool, error: String) {
        if judgeFileOrFolderExists(filePath: folderPath) {
            return (true, "")
        }
        do {
            try fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            return (true, "")
        } catch _ {
            return (false, "创建失败")
        }
    }
    @discardableResult
    static func removeFolder(folderPath: String) -> (isSuccess: Bool, error: String) {
        let filePath = "\(folderPath)"
        guard judgeFileOrFolderExists(filePath: filePath) else {
            return (true, "")
        }
        do {
            try fileManager.removeItem(atPath: filePath)
            return (true, "")
        } catch _ {
            return (false, "删除失败")
        }
    }
    @discardableResult
    static func createFile(filePath: String) -> (isSuccess: Bool, error: String) {
        guard judgeFileOrFolderExists(filePath: filePath) else {
            let createSuccess = fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
            return (createSuccess, "")
        }
        return (true, "")
    }
    @discardableResult
    static func removeFile(filePath: String) -> (isSuccess: Bool, error: String) {
        guard judgeFileOrFolderExists(filePath: filePath) else {
            return (true, "")
        }
        do {
            try fileManager.removeItem(atPath: filePath)
            return (true, "")
        } catch _ {
            return (false, "移除文件失败")
        }
    }
    @discardableResult
    static func readfile(filePath: String) -> String? {
        guard judgeFileOrFolderExists(filePath: filePath) else {
            return nil
        }
        let data = fileManager.contents(atPath: filePath)
        return String(data: data!, encoding: String.Encoding.utf8)
    }
    @discardableResult
    static func writeToFile(writeType: FileWriteType, content: Any, writePath: String) -> (isSuccess: Bool, error: String) {
        guard judgeFileOrFolderExists(filePath: directoryAtPath(path: writePath)) else {
            return (false, "不存在的文件路径")
        }
        switch writeType {
        case .TextType:
            let info = "\(content)"
            do {
                try info.write(toFile: writePath, atomically: true, encoding: String.Encoding.utf8)
                return (true, "")
            } catch _ {
                return (false, "写入失败")
            }
        case .ImageType:
            let data = content as! Data
            do {
                try data.write(to: URL(fileURLWithPath: writePath))
                return (true, "")
            } catch _ {
                return (false, "写入失败")
            }
        case .ArrayType:
            let array = content as! NSArray
            let result = array.write(toFile: writePath, atomically: true)
            if result {
                return (true, "")
            } else {
                return (false, "写入失败")
            }
        case .DictionaryType:
            let result = (content as! NSDictionary).write(toFile: writePath, atomically: true)
            if result {
                return (true, "")
            } else {
                return (false, "写入失败")
            }
        }
    }
    @discardableResult
    static func readFromFile(readType: FileWriteType, readPath: String) -> (isSuccess: Bool, content: Any?, error: String) {
        guard judgeFileOrFolderExists(filePath: readPath), let readHandler =  FileHandle(forReadingAtPath: readPath) else {
            return (false, nil, "不存在的文件路径")
        }
        let data = readHandler.readDataToEndOfFile()
        switch readType {
        case .TextType:
            let readString = String(data: data, encoding: String.Encoding.utf8)
            return (true, readString, "")
        case .ImageType:
            let image = UIImage(data: data)
            return (true, image, "")
        case .ArrayType:
            guard let readString = String(data: data, encoding: String.Encoding.utf8) else {
                return (false, nil, "读取内容失败")
            }
            return (true, readString.jsonStringToArray(), "")
        case .DictionaryType:
            guard let readString = String(data: data, encoding: String.Encoding.utf8) else {
                return (false, nil, "读取内容失败")
            }
            return (true, readString.jsonStringToDictionary(), "")
        }
    }
    @discardableResult
    static func copyFile(type: MoveOrCopyType, fromeFilePath: String, toFilePath: String, isOverwrite: Bool = true) -> (isSuccess: Bool, error: String) {
        guard judgeFileOrFolderExists(filePath: fromeFilePath) else {
            return (false, "被拷贝的(文件夹/文件)路径不存在")
        }
        let toFileFolderPath = directoryAtPath(path: toFilePath)
        if !judgeFileOrFolderExists(filePath: toFileFolderPath), type == .file ? !createFile(filePath: toFilePath).isSuccess : !createFolder(folderPath: toFileFolderPath).isSuccess {
            return (false, "拷贝后路径前一个文件夹不存在")
        }
        if isOverwrite, judgeFileOrFolderExists(filePath: toFilePath) {
            do {
                try fileManager.removeItem(atPath: toFilePath)
            } catch _ {
                return (false, "拷贝失败")
            }
        }
        do {
            try fileManager.copyItem(atPath: fromeFilePath, toPath: toFilePath)
        } catch _ {
            return (false, "拷贝失败")
        }
        return (true, "success")
    }
    @discardableResult
    static func moveFile(type: MoveOrCopyType, fromeFilePath: String, toFilePath: String, isOverwrite: Bool = true) -> (isSuccess: Bool, error: String) {
        guard judgeFileOrFolderExists(filePath: fromeFilePath) else {
            return (false, "被移动的(文件夹/文件)路径不存在")
        }
        let toFileFolderPath = directoryAtPath(path: toFilePath)
        if !judgeFileOrFolderExists(filePath: toFileFolderPath), type == .file ? !createFile(filePath: toFilePath).isSuccess : !createFolder(folderPath: toFileFolderPath).isSuccess {
            return (false, "移动后路径前一个文件夹不存在")
        }
        if isOverwrite, judgeFileOrFolderExists(filePath: toFilePath) {
            do {
                try fileManager.removeItem(atPath: toFilePath)
            } catch _ {
                return (false, "移动失败")
            }
        }
        do {
            try fileManager.moveItem(atPath: fromeFilePath, toPath: toFilePath)
        } catch _ {
            return (false, "移动失败")
        }
        return (true, "success")
    }
    static func judgeFileOrFolderExists(filePath: String) -> Bool {
        let exist = fileManager.fileExists(atPath: filePath)
        guard exist else {
            return false
        }
        return true
    }
    static func directoryAtPath(path: String) -> String {
        return (path as NSString).deletingLastPathComponent
    }
    static func judegeIsReadableFile(path: String) -> Bool {
        return fileManager.isReadableFile(atPath: path)
    }
    static func judegeIsWritableFile(path: String) -> Bool {
        return fileManager.isReadableFile(atPath: path)
    }
    static func judegeIsExecutableFile(path: String) -> Bool {
        return fileManager.isExecutableFile(atPath: path)
    }
    static func judegeIsDeletableFile(path: String) -> Bool {
        return fileManager.isDeletableFile(atPath: path)
    }
    static func fileSuffixAtPath(path: String) -> String {
        return (path as NSString).pathExtension
    }
    static func fileName(path: String, suffix: Bool = true) -> String {
        let fileName = (path as NSString).lastPathComponent
        guard suffix else {
            return (fileName as NSString).deletingPathExtension
        }
        return fileName
    }
    static func shallowSearchAllFiles(folderPath: String) -> [String]? {
        guard let contentsOfDirectoryArray = try? fileManager.contentsOfDirectory(atPath: folderPath) else {
            return nil
        }
        return contentsOfDirectoryArray
    }
    static func getAllFileNames(folderPath: String) -> [String]? {
        guard judgeFileOrFolderExists(filePath: folderPath), let subPaths = fileManager.subpaths(atPath: folderPath) else {
            return nil
        }
        return subPaths
    }
    static func deepSearchAllFiles(folderPath: String) -> [Any]? {
        guard judgeFileOrFolderExists(filePath: folderPath), let contentsOfPathArray = fileManager.enumerator(atPath: folderPath) else {
            return nil
        }
        return contentsOfPathArray.allObjects
    }
    static func fileOrDirectorySingleSize(filePath: String) -> UInt64 {
        guard judgeFileOrFolderExists(filePath: filePath) else {
            return 0
        }
        guard let fileAttributes = try? fileManager.attributesOfItem(atPath: filePath), let fileSizeValue = fileAttributes[FileAttributeKey.size] as? UInt64 else {
            return 0
        }
        return fileSizeValue
    }
    static func fileOrDirectorySize(path: String) -> String {
        if path.count == 0, !fileManager.fileExists(atPath: path) {
            return "0MB"
        }
        var fileSize: UInt64 = 0
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            for file in files {
                let path = path + "/\(file)"
                fileSize = fileSize + fileOrDirectorySingleSize(filePath: path)
            }
        } catch {
            fileSize = fileSize + fileOrDirectorySingleSize(filePath: path)
        }
        return  self.covertUInt64ToString(with: fileSize)
    }
    static func fileOrDirectorySizeNum(path: String) -> UInt64 {
        if path.count == 0, !fileManager.fileExists(atPath: path) {
            return 0
        }
        var fileSize: UInt64 = 0
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            for file in files {
                let path = path + "/\(file)"
                fileSize = fileSize + fileOrDirectorySingleSize(filePath: path)
            }
        } catch {
            fileSize = fileSize + fileOrDirectorySingleSize(filePath: path)
        }
        return fileSize
    }
    @discardableResult
    static func fileAttributes(path: String) -> ([FileAttributeKey: Any]?) {
        do {
            let attributes = try fileManager.attributesOfItem(atPath: path)
            return attributes
        } catch _ {
            return nil
        }
    }
    static func isEqual(filePath1: String, filePath2: String) -> Bool {
        guard judgeFileOrFolderExists(filePath: filePath1), judgeFileOrFolderExists(filePath: filePath2) else {
            return false
        }
        return fileManager.contentsEqual(atPath: filePath1, andPath: filePath2)
    }
    static func getAnimationSize() -> UInt64 {
        let path = kDocumentPath + "/" + animationDirectoryName
        let size =  fileOrDirectorySizeNum(path: path)
        return size
    }
    static func getEmojeSize() -> UInt64 {
        let path = kDocumentPath + "/" + emojiDirectoryName
        let size =  fileOrDirectorySizeNum(path: path)
        return size
    }
    static func getNineImageSize() -> UInt64 {
        let path = kDocumentPath + "/" + nineDirectoryName
        let size =  fileOrDirectorySizeNum(path: path)
        return size
    }
}
extension FileManager {
    static func covertUInt64ToString(with size: UInt64) -> String {
        var convertedValue: Double = Double(size)
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }
}
