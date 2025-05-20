//
//  SettingsManager.swift
//  iQuiz
//
//  Created by Nicole Zhou on 5/14/25.
//

import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    
    private let defaults = UserDefaults.standard
    
    // Keys for UserDefaults
    private enum Keys {
        static let dataSourceURL = "dataSourceURL"
    }
    
    // Default URL
    private let defaultURL = "http://tednewardsandbox.site44.com/questions.json"
    
    var dataSourceURL: String {
        get {
            return defaults.string(forKey: Keys.dataSourceURL) ?? defaultURL
        }
        set {
            defaults.set(newValue, forKey: Keys.dataSourceURL)
        }
    }
    
    func resetToDefaultURL() {
        dataSourceURL = defaultURL
    }
    
    // Register default settings that will appear in iOS Settings app
    func registerSettingsBundle() {
        guard let settingsBundle = Bundle.main.url(forResource: "Settings", withExtension: "bundle") else {
            return
        }
        
        guard let settings = NSDictionary(contentsOf: settingsBundle.appendingPathComponent("Root.plist")) else {
            return
        }
        
        guard let preferences = settings["PreferenceSpecifiers"] as? [[String: Any]] else {
            return
        }
        
        var defaultsToRegister = [String: Any]()
        
        for preference in preferences {
            if let key = preference["Key"] as? String {
                defaultsToRegister[key] = preference["DefaultValue"]
            }
        }
        
        defaults.register(defaults: defaultsToRegister)
    }
}
