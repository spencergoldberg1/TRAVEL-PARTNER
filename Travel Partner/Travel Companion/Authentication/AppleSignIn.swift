//
//  AppleSignIn.swift
//  Food_Preference
//
//  Created by Peter Khouly on 7/14/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import Firebase
import CryptoKit

struct AppleSignIn<User: UserRepresentable>: View {
    var body: some View {
        SignInWithAppleButton(
            .continue,
            onRequest: { request in
                //nonce is something firebase uses when authenticating
                let nonce = randomNonceString()
                currentNonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = sha256(nonce)
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                      
                            guard let nonce = currentNonce else {
                                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                            }
                            guard let appleIDToken = appleIDCredential.identityToken else {
                                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                            }
                            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                return
                            }
                         
                            //signing in to firebase
                            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
                            Auth.auth().signIn(with: credential) { (authResult, error) in
                                if (error != nil) {
                                    print(error?.localizedDescription as Any)
                                    return
                                }
                                if let userInfo = Auth.auth().currentUser {
                                    if authResult?.additionalUserInfo?.isNewUser ?? true {
                                        userInfo.sendEmailVerification { _ in }
//                                register the user in firestore
                                        let newUser = User(
                                            id: userInfo.uid,
                                            isEmailVerified: userInfo.isEmailVerified,
                                            //the user sometimes wont give us their name or email, we'll have to handle this later on potentially with a notification.
                                            firstName: (appleIDCredential.fullName?.givenName) ?? "",
                                            lastName: (appleIDCredential.fullName?.familyName) ?? "",
                                            email: (appleIDCredential.email) ?? "",
                                            phoneNumber: nil,
                                            photoURL: nil,
                                            location: nil
                                        )

                                        try? newUser.upsert()
                                        print("signed in")
                                    }
                                }
                            }
                  
                            print("\(String(describing: Auth.auth().currentUser?.uid))")
                  
                        default:
                            break
                              
                    }
                default:
                    break
                }
            }
        )
        .signInWithAppleButtonStyle(.whiteOutline)
        //.signInWithAppleButtonStyle(User.resourceName == "servers" ? .white : .black)
    }
    
       
    //boiler plate code from firebase that they use for the nonce.
    @State var currentNonce: String?

       //Hashing function using CryptoKit
       func sha256(_ input: String) -> String {
           let inputData = Data(input.utf8)
           let hashedData = SHA256.hash(data: inputData)
           let hashString = hashedData.compactMap {
           return String(format: "%02x", $0)
           }.joined()

           return hashString
       }
    
    // from https://firebase.google.com/docs/auth/ios/apple
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
      }
      return result
    }
}

//      soon to be used to check if a user stopped giving us permission to sign in with apple through the settings app.
//// ASAuthorizationAppleIDProvider.credentialRevokedNotification handler
//NotificationCenter.default.addObserver(self, selector: #selector(appleIDCredentialRevoked(_:)), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
//
//func appleIDCredentialRevoked(_ notification: Notification) {
//    let appleIDProvider = ASAuthorizationAppleIDProvider()
//    appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
//        switch credentialState {
//        case .authorized:
//            // The Apple ID credential is valid.
//            break
//        case .revoked:
//            // The Apple ID credential is revoked. Sign out.
//            break
//        case .notFound:
//            // No credential was found. Show login UI.
//            break
//        case .transferred: break
//            // The application was transferred from one development team to another.
//                      // You can use the same code used to authenticate the user adding the locally saved user identifier in the request.
//        default:
//            break
//        }
//    }
//}
