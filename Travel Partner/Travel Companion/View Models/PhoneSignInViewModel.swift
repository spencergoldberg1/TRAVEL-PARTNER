//
//  PhoneSignInViewModel.swift
//  Food_Preference
//
//  Created by Peter Khouly on 7/19/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseAuth

private enum PhoneAuthError: Error, LocalizedError {
    case tooShort
    case invalidFormat
    case captchaFailed
    case quotaExceeded
    
    var errorDescription: String? {
        switch self {
        case .tooShort:
            return "Too short. Try entering the country code."
            
        case .invalidFormat:
            return "Invalid phone number."
            
        case .captchaFailed:
            return "Captcha check failed. Please try again."
            
        case .quotaExceeded:
            return "Too many failed attemps. Please try again later."
        }
    }
}

class PhoneSignInViewModel<User: UserRepresentable>: ObservableObject {
    @Published var phone = ""
    @Published var error: Error?
    @Published var verificationCodeError: Error?
    @Published var isLoading: Bool = false
    @Published var goToVerification = false
    
    // ID tied to verification code from firebase.
    private var authVerificationID = ""
    
    @Published var verificationCode = ""
    
    /// Sends a verification code to the user
    func sendVerificationCode() {
        withAnimation {
            isLoading = true
        }
        
        if !phone.contains("+") {
            phone = "+" + phone
        }
        
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        // neat way to adjust the sms code to different languages, for future use in other countries.
        // Auth.auth().languageCode = "fr"
        
        // Send verification code to user's phone.
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phone, uiDelegate: nil) { [weak self] verificationID, error in
                withAnimation {
                    self?.isLoading = false
                }
                

                // Returns the verification code id for better security as they check every auth code with its auth id.
                self?.authVerificationID = verificationID ?? ""
                withAnimation {
                    self?.goToVerification = true
                }
            }
    }
    
    /// Signs the user in with a phone number given a first and last name
    func signInUserWithPhone(firstName: String, lastName: String) {
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: authVerificationID,
          verificationCode: verificationCode
        )

        Auth.auth().signIn(with: credential) { [weak self] result, error in
            withAnimation {
                self?.isLoading = false
            }
            
            if let error = error {
                self?.verificationCodeError = error
                self?.verificationCode = ""
                print(error.localizedDescription)
                return
            }
            
            if let result = result {
                if result.additionalUserInfo?.isNewUser ?? true {
                    // register the user
                    let user = User(
                        id: result.user.uid,
                        isEmailVerified: result.user.isEmailVerified,
                        firstName: firstName,
                        lastName: lastName,
                        email: nil,
                        phoneNumber: self?.phone,
                        photoURL: result.user.photoURL,
                        location: nil
                    )
                    
                    try? user.upsert()
                }
                // user logged in successfully.
            }
        }
    }
}
