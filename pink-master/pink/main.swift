import Foundation
import UIKit
private func isRunningTests() -> Bool {
    return NSClassFromString("XCTestCase") != nil
}
private func getDelegateClassName() -> String {
    return isRunningTests() ? NSStringFromClass(TestsAppDelegate.self) : NSStringFromClass(AppDelegate.self)
}
_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, getDelegateClassName())
