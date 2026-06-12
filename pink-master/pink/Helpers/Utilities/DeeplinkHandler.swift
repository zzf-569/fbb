import Foundation
class DeeplinkHandler {
    enum Path: String {
        case resetPassword = "" 
    }
    func handleDeeplink(with url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let path = getPath(from: components) else {
                return
        }
        switch path {
        case .resetPassword:
            handleResetPasword(with: components)
        }
    }
    private func getPath(from components: URLComponents) -> Path? {
        return Path(rawValue: components.path)
    }
    private func handleResetPasword(with components: URLComponents) {
    }
}
