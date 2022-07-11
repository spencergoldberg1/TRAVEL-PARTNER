//
//  Collection+Extensions.swift
//  Food_Preference
//
//  Created by Zachary Goldstein on 1/4/22.
//  Copyright © 2022 Cocobolo Group. All rights reserved.
//

import Foundation

extension Collection {
    /// Allows for safe index accessing of collections
    ///
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    ///
    ///     let array = ["1", "2", "3"]
    ///     print(array[safe: 5])
    ///     // Prints "nil"
    ///
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
