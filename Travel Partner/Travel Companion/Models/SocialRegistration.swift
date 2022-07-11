//
//  SocialRegistration.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 7/1/22.
//

class SocialRegistrationViewModel: SocialRegistrationViewModelProtocol {
    
    let viewTitle: String = "Welcome!"
    let introductionContent: [(imageName: String, title: String)] = [
        ("SocialRegistrationGraphic 1", "Simply indicate your standard dining preferences"),
        ("SocialRegistrationGraphic 2", "The app provides your dining profile to your server!")
    ]
    
    let backgroundColor = Constants.Colors.appBackground
    let textColor = Constants.Colors.defaultText
}

