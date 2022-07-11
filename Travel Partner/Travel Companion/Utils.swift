//
//  Utils.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 7/1/22.
//

import Foundation
import UIKit
import SwiftUI

struct Utils {
    // Calling this function will show the share sheet for the passed in URL.
    // NOTE THAT IF A VIEW CONTROLLER IS ALREADY PRESENTING OVER THE ROOT VIEWCONTROLLER, IT MUST BE DISMISSED
    // OTHERWISE THE SHARE SHEET WILL NOT SHOW.
    // The share sheet will not show if the URL initializing fails as well
    static func showShareSheet(for urlString: String) -> Void {
        guard let urlShare = URL(string: urlString) else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    /// Configure the navigation bar with a specific color
    static func configureNavBar(with navBarColor: Color) {
//        UINavigationBar.appearance().barTintColor = UIColor(navBarColor)
//        UINavigationBar.appearance().isTranslucent = false
        // Removes the bottom divider from the navigation bar
        let navigationBar = UINavigationBar.appearance()
        navigationBar.shadowImage = UIImage()
        
        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = UIColor(navBarColor)
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }
    
    /// Configure the tab bar with a color and unselected color
    static func configureTabBar(with backgroundColor: Color, unselectedColor: Color) {
        UITabBar.appearance().barTintColor = UIColor(backgroundColor)
        UITabBar.appearance().backgroundColor = UIColor(backgroundColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(unselectedColor)
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    /// Dismiss any popups if there are any that are presented
    static func dismissPopups() {
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
    }
    
    /// Requests Authorization from a user for notifications. Should be called when a user is completing the first time flow or they downloaded the app and logged back in
    static func requestNotificationAuthorization(completionHandler: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("There was an error requesting authorization for push notifications")
            }
        
            if granted {
                completionHandler(granted)
            } else {
                completionHandler(granted)
            }
        }
    }
}

