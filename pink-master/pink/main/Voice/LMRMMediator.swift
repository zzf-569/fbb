import UIKit
class  Mediator {
    static let shared = Mediator()
    private var handlers: [String: (Any) -> Void] = [:]
    func register<T>(event: String, handler: @escaping (T) -> Void) {
        handlers[event] = { data in
            if let typedData = data as? T {
                handler(typedData)
            }
        }
    }
    func dispatch<T>(event: String, data: T) {
        handlers[event]?(data)
    }
}
