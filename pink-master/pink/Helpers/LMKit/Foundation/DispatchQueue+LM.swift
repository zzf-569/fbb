import Foundation
public typealias LMTask = () -> Void
public extension DispatchQueue {
    private static var _onceTracker = [String]()
    static func once(token: String, block: () -> Void) {
        if _onceTracker.contains(token) {
            return
        }
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        _onceTracker.append(token)
        block()
    }
}
public extension DispatchQueue {
    @discardableResult
    static func async(_ LMTask: @escaping LMTask) -> DispatchWorkItem {
        return _asyncDelay(0, LMTask)
    }
    @discardableResult
    static func async(_ LMTask: @escaping LMTask, _ mainYDTask: @escaping LMTask) -> DispatchWorkItem {
        return _asyncDelay(0, LMTask, mainYDTask)
    }
    @discardableResult
    static func asyncDelay(_ seconds: Double, _ LMTask: @escaping LMTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, LMTask)
    }
    @discardableResult
    static func asyncDelay(_ seconds: Double,
                            _ LMTask: @escaping LMTask,
                        _ mainYDTask: @escaping LMTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, LMTask, mainYDTask)
    }
    @discardableResult
    static func mainDelay(_ seconds: Double, _ LMTask: @escaping LMTask) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: LMTask)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        return item
    }
    @discardableResult
    static func main(_ LMTask: @escaping LMTask) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: LMTask)
        DispatchQueue.main.async(execute: item)
        return item
    }
}
extension DispatchQueue {
    fileprivate static func _asyncDelay(_ seconds: Double,
                                         _ LMTask: @escaping LMTask,
                                     _ mainYDTask: LMTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: LMTask)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        if let main = mainYDTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}
