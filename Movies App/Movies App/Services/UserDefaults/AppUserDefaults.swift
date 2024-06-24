//
//  UDStorage.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import Foundation

struct AppUserDefaults {
    
    enum Keys: String, CaseIterable {
        case genres
        
    }
    
    static func removeValue(_ item: AppUserDefaults.Keys) {
        UserDefaults.standard.removeObject(forKey: item.rawValue)
    }
    
    static func removeAll() {
        AppUserDefaults.Keys.allCases.forEach { removeValue($0) }
    }
    
    static func removeAll(except keysToKeep: [AppUserDefaults.Keys]) {
        let keysToKeepSet = Set(keysToKeep)
        AppUserDefaults.Keys.allCases.forEach { key in
            if !keysToKeepSet.contains(key) {
                removeValue(key)
            }
        }
    }
    
    @ObjectStorage(key: .genres, defaultValue: nil)
    static var genres: [Int: String]?
}
