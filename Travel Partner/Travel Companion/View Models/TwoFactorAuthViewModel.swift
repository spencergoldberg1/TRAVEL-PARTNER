//
//  TwoFactorAuthViewModel.swift
//  Food_Preference
//
//  Created by Peter Khouly on 5/16/22.
//  Copyright © 2022 Cocobolo Group. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseAuth

class TwoFactorAuthViewModel: ObservableObject {
    private var verificationId = ""
    private var resolver: MultiFactorResolver?
    
    enum Alerts: Identifiable {
           case unverifiedEmail, unenroll

           var id: Int {
               self.hashValue
           }
    }
    
    @Published var showAlert: Alerts?
    
    @Published var reAuthError: Error?
    @Published var errors: String?
    
    @Published var isLoading = false
    @Published var hasSignedIn = false
    
    @Published var goToVerification = false
    
    let user = Auth.auth().currentUser

    @Published var is2FAEnabled = !(Auth.auth().currentUser?.multiFactor.enrolledFactors.isEmpty ?? true)
    
    @Binding var currentTab: Int
    
    init(currentTab: Binding<Int>) {
        self._currentTab = currentTab
    }
    func sendSetUpAuthCode(phoneNumber: String) async {
        await MainActor.run {
            self.isLoading = true
            self.errors = nil
        }
        
        do {
            let session = try await user?.multiFactor.session()
            // Send SMS verification code.
            let verificationId = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil, multiFactorSession: session)
            
            self.verificationId = verificationId
        }
        catch {
            await MainActor.run {
                print(error.localizedDescription)
                let authError = error as NSError
                if authError.code == AuthErrorCode.unverifiedEmail.rawValue {
                    self.showAlert = .unverifiedEmail
                }
                self.errors = error.localizedDescription
            }
        }
        
        await MainActor.run {
            self.isLoading = false
            self.currentTab = 4
        }

    }
    
    func verifySetUp(verificationCode: String) async {
        await MainActor.run {
            self.isLoading = true
            self.errors = nil
        }

        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: verificationCode)
        let assertion = PhoneMultiFactorGenerator.assertion(with: credential)
        do {
            // Complete enrollment. This will update the underlying tokens
            // and trigger ID token change listener.
            
            try await user?.multiFactor.enroll(with: assertion, displayName: nil)
            await MainActor.run {
                self.is2FAEnabled = true
            }
        }
        catch {
            await MainActor.run {
                print(error)
                self.errors = error.localizedDescription
            }
        }
        
        await MainActor.run {
            self.isLoading = false
        }
    }
    
    func unEnroll() async {
        await MainActor.run {
            self.isLoading = true
            self.errors = nil
        }

        if let multiFactorInfo = self.user?.multiFactor.enrolledFactors.first {
            do {
                try await self.user?.multiFactor.unenroll(with: multiFactorInfo)
                await MainActor.run {
                    self.is2FAEnabled = false
                    self.hasSignedIn = false
                    self.goToVerification = false
                }
            } catch {
                await MainActor.run {
                    self.errors = error.localizedDescription
                }
            }
        }
        
        await MainActor.run {
            self.isLoading = false
        }

    }
    
    
    
    func checkTwoFactorAndSendCode(error: Error?, onSignInComplete: (()->())? = nil, onVerificationCodeSent: (()->())? = nil) async -> Error? {
        await MainActor.run {
            self.isLoading = true
            self.errors = nil
        }

        let authError = error as NSError?
        if (authError == nil || authError!.code != AuthErrorCode.secondFactorRequired.rawValue) {
            // User is not enrolled with a second factor and is successfully signed in.
            // ...
            if let onSignInComplete = onSignInComplete {
                await MainActor.run {
                    onSignInComplete()
                }
            }
            await MainActor.run {
                self.isLoading = false
                self.currentTab = 4
            }
            return nil
        } else {
            do {
                resolver = authError!.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as? MultiFactorResolver

                let hint = resolver?.hints.first as! PhoneMultiFactorInfo
                // Send SMS verification code
                self.verificationId = try await PhoneAuthProvider.provider().verifyPhoneNumber(with: hint, uiDelegate: nil, multiFactorSession: resolver?.session)
                if let onVerificationCodeSent = onVerificationCodeSent {
                    await MainActor.run {
                        self.goToVerification = true
                        onVerificationCodeSent()
                    }
                }
                await MainActor.run {
                    self.isLoading = false
                    self.currentTab = 4
                }
                return nil
            }
            catch {
                print(error.localizedDescription)
                await MainActor.run {
                    self.errors = error.localizedDescription
                    self.isLoading = true
                    self.currentTab = 4
                }
                return error
            }
        }
    }
    
    func verifyCode(verificationCode: String, onComplete: (()->())? = nil) async -> Error?{
        await MainActor.run {
            self.isLoading = true
            self.errors = nil
        }

        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: verificationCode)
        let assertion = PhoneMultiFactorGenerator.assertion(with: credential);
        // Complete sign-in.
        do {
            try await resolver?.resolveSignIn(with: assertion)
            
            if let onComplete = onComplete {
                await MainActor.run {
                    onComplete()
                }
            }
            return nil
        }
        catch {
            print(error)
            await MainActor.run {
                self.errors = error.localizedDescription
            }
            return error
        }
    }
    
    
    func reauthenticateUser(email: String? = nil, password: String) async {
        await MainActor.run {
            self.errors = nil
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email ?? self.user?.email ?? "", password: password)
        do {
            try await Auth.auth().currentUser?.reauthenticate(with: credential)
            await MainActor.run {
                self.hasSignedIn = true
            }
        } catch {
            await MainActor.run {
                self.reAuthError = error
            }
            // this is where the reauthenticate error would throw the auth error of 2FA, if it isn't the 2FA error it will just send that error to the UI through the onsignincomplete, if the 2FA gets an error it will also send that to the UI
            if let error2FA = await self.checkTwoFactorAndSendCode(
                error: error,
                onSignInComplete: {
                    print(error)
                    self.errors = error.localizedDescription
                },
                onVerificationCodeSent: {
                    self.goToVerification = true
                }
            ) {
                await MainActor.run {
                    self.errors = error2FA.localizedDescription
                }
            }
            
        }
    }
}
