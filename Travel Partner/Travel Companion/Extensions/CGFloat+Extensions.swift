//
//  CGFloat+Extensions.swift
//  Food_Preference
//

import SwiftUI

extension CGFloat {
    
    /// Converts pixels to points based on the screen scale
    /// - Returns: A `CGFloat` as a point unit
    var pixelsToPoints: Self {
        self / UIScreen.main.scale
    }
}
