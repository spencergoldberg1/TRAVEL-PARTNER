//
//  UINavigationController.swift
//  Food_Preference
//
//  Created by Jonathan Yataco  on 6/22/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import UIKit

// This extension allows SwiftUI NavigationView to swipe back even when disabling the navigation bar or hiding the back button
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
