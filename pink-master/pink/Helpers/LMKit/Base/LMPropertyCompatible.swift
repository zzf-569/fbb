import Foundation
internal protocol LMPropertyCompatible {
    associatedtype T
    typealias SwiftCallBack = ((T?) -> Void)
    var swiftCallBack: SwiftCallBack? { get set }
}
