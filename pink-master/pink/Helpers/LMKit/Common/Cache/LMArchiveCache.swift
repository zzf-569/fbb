import Foundation
public let UserFilePath = kDocumentPath + "/" + "category"
final class LMArchiveCache: NSObject {
    @discardableResult
    public static func delete(_ filePath: String = UserFilePath, fileName: String = "") -> Bool {
        guard filePath.count > 0 || fileName.count > 0 else { return false }
        let path = filePath + "/" + fileName
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    @discardableResult
    public static func archive(_ filePath: String = UserFilePath, fileName: String, object: Any) -> Bool {
        FileManager.createFolder(folderPath: filePath)
        let path = filePath + "/" + fileName
        if #available(iOS 11.0, *) {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
                do {
                    try data.write(to: URL(fileURLWithPath: path))
                } catch {
                    assert(true, "无法写入path")
                    return false
                }
            } catch {
                assert(true, "无法生成归档数据")
                return false
            }
        } else {
            return NSKeyedArchiver.archiveRootObject(object, toFile: path)
        }
        return true
    }
    public static func unarchiveObject<T>(_ filePath: String = UserFilePath, fileName: String, object: T) -> T? where T: NSObject, T: NSCoding {
        let path = filePath + "/" + fileName
        if #available(iOS 11.0, *) {
            do {
                let data = try Data.init(contentsOf: URL(fileURLWithPath: path))
                do {
                    return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
                } catch {
                    assert(true, "用户数据解档失败")
                }
            } catch {
                assert(true, "用户数据解档路径错误")
            }
        } else {
            return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? T
        }
        return nil
    }
    public static func unarchiveArray(_ filePath: String = UserFilePath, fileName: String) -> Any {
        let path = filePath + "/" + fileName
        if #available(iOS 11.0, *) {
            do {
                let data = try Data.init(contentsOf: URL(fileURLWithPath: path))
                do {
                    return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)!
                } catch {
                    assert(true, "数据解档失败")
                }
            } catch {
                assert(true, "数据解档路径错误")
            }
        } else {
            return NSKeyedUnarchiver.unarchiveObject(withFile: path)!
        }
        return []
    }
}
