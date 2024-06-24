//
//  UDPropertyWrappers.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import Foundation

@propertyWrapper
struct Storage<T> {
    private let key: AppUserDefaults.Keys
    private let defaultValue: T

    init(key: AppUserDefaults.Keys, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            /// Read value from UserDefaults
            return UserDefaults.standard.object(forKey: key.rawValue) as? T ?? defaultValue
        }
        set {
            /// Set value to UserDefaults
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }
}


@propertyWrapper
struct ObjectStorage<T: Codable> {
    private let key: AppUserDefaults.Keys
    private let defaultValue: T

    init(key: AppUserDefaults.Keys, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            /// Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data else {
                /// Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            /// Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            /// Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            
            /// Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key.rawValue)
        }
    }
}
