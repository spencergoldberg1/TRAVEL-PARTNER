//
//  UIResponder.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 7/1/22.
//

import SwiftUI
import MapKit

extension UIApplication {
    func dismissFirstResponder() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


