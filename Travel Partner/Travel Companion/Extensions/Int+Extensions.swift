//
//  Int+Extensions.swift
//  Food_Preference
//

import SwiftUI

extension Int {
    
    /// Converts pixels to points based on the screen scale
    /// - Returns: A `CGFloat` as a point unit
    var pixelsToPoints: CGFloat {
        CGFloat(self) / UIScreen.main.scale
    }
}
