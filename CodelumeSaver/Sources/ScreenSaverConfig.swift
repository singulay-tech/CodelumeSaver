//
//  ScreenSaverConfig.swift
//  CodelumeSaver
//
//  Created by 广子俞 on 2026/1/22.
//

import ScreenSaver

struct ScreenSaverConfig {
    static private let moduleName = "com.codelume.CodelumeSaver"
    
    struct Keys {
        static let screensaverType = "ScreensaverTypeKey"
        static let bundleType = "BundleTypeKey"
        static let filePath = "filePathKey"
    }
    
    struct Defaults {
        static let screensaverType: ScreensaverType = .Video
        static let bundleType: BundleType = .Video
    }
    
    private let shared: ScreenSaverDefaults? = {
        let bundleID = Bundle.main.bundleIdentifier ?? moduleName
        return ScreenSaverDefaults(forModuleWithName: bundleID)
    }()
    
    func getScreensaverType() -> ScreensaverType {
        guard let savedType = shared?.string(forKey: Keys.screensaverType),
              let type = ScreensaverType(rawValue: savedType) else {
            return Defaults.screensaverType
        }
        return type
    }
    
    func setScreensaverType(type:ScreensaverType) {
        shared?.set(type.rawValue, forKey: Keys.screensaverType)
        shared?.synchronize()
        
    }
    
    func getBundleType() -> BundleType {
        guard let bundleType = shared?.string(forKey: Keys.bundleType),
              let type = BundleType(rawValue: bundleType) else {
            return Defaults.bundleType
        }
        return type
    }
    
    func setBundleType(type:BundleType) {
        shared?.set(type.rawValue, forKey: Keys.bundleType)
        shared?.synchronize()
    }
    
    func getFilePath() -> String? {
        return shared?.string(forKey: Keys.filePath) ?? nil
    }
    
    func setFilePath(path: String) {
        shared?.set(path, forKey: Keys.filePath)
        shared?.synchronize()
    }
    
    func resetConfig() {
        setScreensaverType(type: .Video)
        setBundleType(type: .Video)
        setFilePath(path: "codelume.mp4")
        shared?.synchronize()
    }
}
