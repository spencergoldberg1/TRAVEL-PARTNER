//
//  CacheStructWrapper.swift
//  Food_Preference
//
//  Created by Jonathan Yataco  on 8/4/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import Foundation

/// Class wrapper that can be used with any type. Should be used to wrap structs as class objects since NSCache can only work with reference types rather than value types such as structs
class CacheStructWrapper<T>: NSObject {
    let value: T
    
    init(value: T) {
        self.value = value
    }
}
