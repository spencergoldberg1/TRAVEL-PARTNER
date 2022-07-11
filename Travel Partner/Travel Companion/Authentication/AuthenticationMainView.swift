//
//  LoginView.swift
//  Food_Preference
//
//  Created by Raul Gutierrez Niubo on 3/28/22.
//  Copyright © 2022 Cocobolo Group. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import AuthenticationServices

struct AuthenticationMainView<User: UserRepresentable>: View {
    
   
    
    
    @State private var loginView: Bool = true
    
    var body: some View {
            
            ZStack {
                Constants.Colors.appBackground.ignoresSafeArea()
                
                ScrollView {
                    Spacer()
                    VStack {
                            
                            VStack {
                                Text(loginView ? "Log In" : "Sign Up")
                                    .foregroundColor(Constants.Colors.defaultText)
                                    .font(.system(size: 24, weight: .semibold))
                                    .padding(.top, 90)
                                    .padding(.bottom, 25)
                                   
                                if !loginView {
                                    VStack {
                                        
                                        AppleSignIn<User>()
                                            .frame(height: 50)
                                            .padding(.bottom, 10)
                                            .padding(.horizontal, 40)
                                        
                                       
                                        
  
                                    }
                                    .padding(.horizontal, 35)
                                }
                                
                                if loginView {
                                    LoginEmailOrPhoneView<User>().navigationBarHidden(true)
                                } else {
                                    SignupEmailOrPhoneView<User>().navigationBarHidden(true)
                                    
                                }
                                if loginView {
                                    VStack(spacing: 10) {
                                        
                                            Text("OR")
                                                .padding(.top)
                                                .font(.system(size: 20, weight: .bold))
                                            HStack {
                                                Spacer()
                                                Text("Log in with")
                                                    .font(.system(size: 17, weight: .medium))
                                                    .foregroundColor(User.resourceName == "guests" ? Constants.Colors.ColorPallete.Black : .white)
                                                    .padding(.bottom)
                                                Spacer()
                                            }
                                        AppleSignIn<User>()
                                            .frame(height: 50)
                                            .padding(.bottom, 10)
                                            .padding(.horizontal, 40)
                                           
                                        
//                                        
//                                        HStack(spacing: 40) {
//                                            SocialSignInButton(socialType: .google, action: {
//                                                GIDSignIn.sharedInstance().delegate = googleSignInDelegate
//                                                GIDSignIn.sharedInstance().presentingViewController = UIApplication.shared.windows.first?.rootViewController
//                                                GIDSignIn.sharedInstance().signIn()
//                                            })
//                                            
//                                            SocialSignInButton(socialType: .facebook, action: {
//                                                facebookSignInDelegate.facebookLogin()
//                                            })
//                                        }
                                        
            //                            if loginView {
            //                                NavigationLink(destination: LoginEmailOrPhoneView<User>(guestApp: $guestApp).navigationBarHidden(true),
            //                                               label: {
            //                                    EmailSignInButton()
            //                                })
            //                            } else {
            //                                NavigationLink(destination: SignupEmailOrPhoneView<User>(guestApp: $guestApp).navigationBarHidden(true),
            //                                               label: {
            //                                    EmailSignInButton()
            //                                })
            //                            }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 35)
                                }
                            }
                        
                        Spacer()
                        VStack {
                          
                            HStack(spacing: 2) {
                                Text(loginView ? "Don't have an account? ": "Already have an account? ")
                                    .font(.body)
                                    .foregroundColor(User.resourceName == "guests" ? .black : .white)
                                Button {
                                    loginView.toggle()
                                } label: {
                                    Text(loginView ? "Sign Up" : "Log In")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(User.resourceName == "guests" ? Constants.Colors.ColorPallete.DarkBrown : .white)
                                        .underline()
                                }
                            }
                           
                        }
                         
                            
                        }
                }
              
                    //.background(Color(.white))
                    .navigationBarTitleDisplayMode(.inline)
                   
            }
            .navigationBarHidden(false)
         
        
        
        }
        
    }

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationMainView<Guest>()
    }
}
