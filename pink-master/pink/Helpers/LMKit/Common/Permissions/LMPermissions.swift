import Foundation
import Network
public class NetworkPermissions {
    static let shared = NetworkPermissions()
    private var monitor: NWPathMonitor!
    var status = false
    var monitorblock: ((Bool) -> Void)?
    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.status = true
                DispatchQueue.main.async {
                    if let block = self.monitorblock {
                        block(self.status)
                    }
                }
                self.cancel()
                lmPrint("设备已授权网络连接")
            } else {
                self.status = false
                DispatchQueue.main.async {
                    if let block = self.monitorblock {
                        block(self.status)
                    }
                }
                lmPrint("设备未授权网络连接")
            }
        }
    }
    func start() {
        let queue = DispatchQueue(label: "networkMonitor")
        monitor.start(queue: queue)
    }
    func cancel() {
        monitor.cancel()
    }
}
