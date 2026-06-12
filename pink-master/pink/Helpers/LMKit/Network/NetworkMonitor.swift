import Alamofire
public class NetworkMonitor {
    static let shared = NetworkMonitor()
    var status: Bool {
        switch NetworkReachabilityManager.default?.status {
        case .reachable:
            true
        default:
            false
        }
    }
    var monitorblock: ((Bool) -> Void)?
    private init() {
        let queue = DispatchQueue(label: "networkMonitor")
        NetworkReachabilityManager.default?.startListening(onQueue: queue, onUpdatePerforming: { status in
            switch status {
            case .reachable:
                lmPrint("设备已连接到网络")
                DispatchQueue.main.async {
                    if let block = self.monitorblock {
                        block(self.status)
                    }
                    NotificationCenter.default.post(name: NotificationName.networkStateChange, object: ["state": true])
                }
            default:
                lmPrint("设备未连接到网络")
                DispatchQueue.main.async {
                    if let block = self.monitorblock {
                        block(self.status)
                    }
                    NotificationCenter.default.post(name: NotificationName.networkStateChange, object: ["state": false])
                }
            }
        })
    }
}
