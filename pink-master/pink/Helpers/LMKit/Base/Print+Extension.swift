import Foundation
public func lmPrint<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let nowDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let lastName = (fileName as NSString).pathComponents.last!
    print("fb_Log_\(dateFormatter.string(from: nowDate)) [\(lastName)][第\(lineNumber)行] \n😊\(message)\n")
    #endif
}
public func kAssert<T>(_ condition: @autoclosure () -> Bool, _ message: T) {
    #if DEBUG
    let nowDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    assert(condition(), "\nfb_Assert_\(dateFormatter.string(from: nowDate))")
    #endif
}
