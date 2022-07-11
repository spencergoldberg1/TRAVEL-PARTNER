//
//  Constants.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 7/1/22.
//

import Foundation.NSUserDefaults
import SwiftUI
import Firebase

struct Constants {
    struct Colors { }
}

extension Constants.Colors {
    static let grey = "#C4C4C4"
    static let veryDarkGrey = "#252323"
    static let lightGrey = "#F5F5F5"
    static let orange = "#D37F58"
    static let rustRed = "#EA4335"
    static let darkGreen = "#336633"
    static let black = "#000000"
    static let white = "#F5F5F5"
    static let darkGrey = "#979797"
    static let lightBlue = "#92C5EA"
    static let darkBrown = "#4E2601"
    static let darkRed = "#4C0F0F"
    static let pink = "#A56FFF"
}

extension Constants {
    // Shared resources
    struct Resources {
        static let guestAppURLString = "https://cocobologroup.com"
        static let serverAppURLString = "https://cocobologroup.com"
    }
}

public let userDefaults = UserDefaults.standard
public let db = Firestore.firestore()

//Colors
public let mainColor = Color(red: 0.04, green: 0.31, blue: 0.45) //for light mode
public let buttonColor = Color(red: 0.83, green: 0.50, blue: 0.35) //for light mode
public let mainBgColor = Color(red: 0.831, green: 0.945, blue: 0.957)
public let dmMainColor = Color(red: 0.8, green: 1, blue: 1) // for dark mode
public let dmMainBGColor = Color(red: 0, green: 0.125, blue: 0.247) // for dark mode
public let secondaryColor = Color(red: 0.04, green: 0.31, blue: 0.45)
public let wineRed = Color(red: 0.686, green: 0.063, blue: 0.235)
public let mainBlue = Color(UIColor(red: 0.57, green: 0.77, blue: 0.92, alpha: 1.00))
public let backgroundColor = Color(UIColor(red: 0.15, green: 0.14, blue: 0.14, alpha: 1.00))


enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale

    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isIPhone12Mini           = idiom == .phone && ScreenSize.maxLength == 780.0
    static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0

    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}

