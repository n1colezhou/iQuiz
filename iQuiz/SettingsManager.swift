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
}
