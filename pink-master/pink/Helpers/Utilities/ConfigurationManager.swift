import Foundation
class ConfigurationManager {
    enum Configuration: String {
        case debug = "Debug"
        case release = "Release"
        case production = "Production"
    }
    static let shared = ConfigurationManager()
    private let configurationKey = "Configuration"
    private let configurationDictionaryName = "Configuration"
    private let backendUrlKey = "backendUrl"
    let activeConfiguration: Configuration
    private let activeConfigurationDictionary: NSDictionary
    init () {
        let bundle = Bundle(for: ConfigurationManager.self)
        guard let rawConfiguration = bundle.object(forInfoDictionaryKey: configurationKey) as? String,
            let activeConfiguration = Configuration(rawValue: rawConfiguration),
            let configurationDictionaryPath = bundle.path(forResource: configurationDictionaryName, ofType: "plist"),
            let configurationDictionary = NSDictionary(contentsOfFile: configurationDictionaryPath),
            let activeEnvironmentDictionary = configurationDictionary[activeConfiguration.rawValue] as? NSDictionary
            else {
                fatalError("Configuration Error")
        }
        self.activeConfiguration = activeConfiguration
        self.activeConfigurationDictionary = activeEnvironmentDictionary
    }
    private func getActiveVariableValue<V>(forKey key: String) -> V {
        guard let value = activeConfigurationDictionary[key] as?  V else {
            fatalError("No value satysfying requirements")
        }
        return value
    }
    func isRunning(in configuration: Configuration) -> Bool {
        return activeConfiguration == configuration
    }
    func getBackendUrl() -> URL {
        let backendUrlString: String = getActiveVariableValue(forKey: backendUrlKey)
        guard let backendUrl = URL(string: backendUrlString) else {
            fatalError("Backend URL missing")
        }
        return backendUrl
    }
}
