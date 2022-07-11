//
//  QuickActionSettings.swift
//  Food_Preference
//
//  Created by Peter Khouly on 8/4/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import Foundation
import SwiftUI

var shortcutItemToProcess: UIApplicationShortcutItem?
let quickActionSettings = QuickActionSettings()

class QuickActionSettings: ObservableObject {
    
    enum QuickAction: Hashable {
        case home
        case details(name: String)
    }
    
    @Published var quickAction: QuickAction? = nil
}

class CustomSceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        shortcutItemToProcess = shortcutItem
    }
}
