//
//  UserDefaults.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 7/1/22.
//

import Foundation.NSUserDefaults
import Foundation

extension UserDefaults {
    enum Keys: String {
        case hasFoodAllergy = "hasFoodAllergy"
        case isNotFirstRun = "isNotFirstRun"
    }
    
    static func getUserDefaultAsBool(forKey defaultName: UserDefaults.Keys) -> Bool {
        return UserDefaults.standard.bool(forKey: defaultName.rawValue)
    }
    
    static func setUserDefault(_ value: Any?, forKey defaultName: UserDefaults.Keys) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
    }
}
