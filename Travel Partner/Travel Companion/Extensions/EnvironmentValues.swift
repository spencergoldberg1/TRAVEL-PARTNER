//
//  EnvironmentValues.swift
//  Food_Preference
//
//  Created by Jonathan Yataco  on 6/10/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//  This file defines extensions and struct definitions needed for presenting modals wrapped in a viewcontroller anywhere in the app.
//  See the extension on UIViewController on how to present a swiftUI that covers the entire screen modally throughout the app 

import SwiftUI

struct ViewControllerHolder {
    // Weak reference to prevent memory leaks
    weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
    // Defines the default value of ViewControllerKey, which is the rootViewController of the entire app
    static var defaultValue: ViewControllerHolder {
        return ViewControllerHolder(value: UIApplication.shared.windows.first?.rootViewController)
    }
}

private extension UIEdgeInsets {
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {
    // Defining getter and setters
    var viewController: UIViewController? {
        get { return self[ViewControllerKey.self].value }
        set { self[ViewControllerKey.self].value = newValue }
    }
    
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}
