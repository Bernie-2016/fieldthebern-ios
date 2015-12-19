import UIKit

class AppVersionProvider {
    let mainBundle = NSBundle.mainBundle()
    
    func versionString() -> String {
        return "FieldTheBern/\(marketingVersion())-\(buildNumber()) (iOS \(osVersion()); \(deviceName()))"
    }
    
    func marketingVersion() -> String {
        if let version = mainBundle.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "marketing-unknown"
    }
    
    func buildNumber() -> String {
        if let build = mainBundle.infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return "build-unknown"
    }
    
    func osVersion() -> String {
        return NSProcessInfo.processInfo().operatingSystemVersionString
    }
    
    func deviceName() -> String {
        return UIDevice.currentDevice().name
    }
}