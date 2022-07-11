//
//  TwoFactorAuthView.swift
//  Food_Preference
//
//  Created by Peter Khouly on 5/16/22.
//  Copyright © 2022 Cocobolo Group. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct TwoFactorAuthView<User: UserRepresentable>: View {
    private typealias SignInColors = Constants.Colors.Views.SignInView
    
    @Binding var currentTab: Int
    
    @StateObject var phoneVerificationVM = PhoneSignInViewModel<User>()
    @StateObject var vm: TwoFactorAuthViewModel
    
    @State private var emailSent = false
    
    @State private var email = Auth.auth().currentUser?.email ?? ""
    @State private var password = ""
    
    
    init(currentTab: Binding<Int>) {
        self._currentTab = currentTab
        self._vm = .init(wrappedValue: .init(currentTab: currentTab))
    }
    var body: some View {
        ZStack {
            
            Constants.Colors.appBackground.ignoresSafeArea()
            if vm.hasSignedIn {
                VStack {
                    
                    Group {
                        VStack(spacing: 7) {
                            Text("Please enter your phone number")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(Constants.Colors.defaultText)
                                .pushToTheLeft()
                            
                            if !vm.is2FAEnabled {
                                Text("The next time you sign in, you will be asked to enter a verification code that will be sent to this phone number.\n\nYou can always turn this off.")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.gray)
                                    .pushToTheLeft()
                            }
                        }
                        
                    }
                    
                    
                    if !vm.is2FAEnabled {
                        if !phoneVerificationVM.goToVerification {
//                            HStack {
//                                Text("Phone Number")
//                                    .font(.system(size: 15, weight: .medium))
//                                Spacer()
//                            }
                            
                            HStack {
                                iPhoneNumberTextField(text: $phoneVerificationVM.phone, isValidNumber: .constant(true)) { textField in
                                    textField.textColor = UIColor(SignInColors.textFieldText)
                                    textField.tintColor = UIColor(SignInColors.textFieldText)
                                    textField.numberPlaceholderColor = UIColor(SignInColors.placeholderText)
                                }
                            }
                            .frame(height: 56)
                            .background(Color(.white))
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 0.5)
                            )
                            .overlay(
                                Group {
                                    if phoneVerificationVM.error != nil {
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color(.red), lineWidth: 1)
                                    }
                                }
                            )
                            if let error = phoneVerificationVM.error {
                                Text(error.localizedDescription)
                                    .font(.callout)
                                    .foregroundColor(SignInColors.errorColor)
                                    .padding(.top, 5)
                            }
                            
                            Spacer()
                                .frame(height: 20)
                            PrimaryButton(text: phoneVerificationVM.isLoading ? "Loading..." : "Send Code") {
                                Task {
                                    await vm.sendSetUpAuthCode(phoneNumber: phoneVerificationVM.phone)
                                    if vm.errors == nil {
                                        withAnimation {
                                            phoneVerificationVM.goToVerification = true
                                        }
                                    }
                                    
                                }
                            }
                            .frame(width: 150)
                            .disabled(phoneVerificationVM.isLoading)
                            
                        } else {
                            PhoneVerificationComponent(viewModel: phoneVerificationVM)
                                .onChange(of: phoneVerificationVM.verificationCode) { new in
                                    if new.count == 6 {
                                        Task {
                                            await vm.verifySetUp(verificationCode: new)
                                            await MainActor.run {
                                                phoneVerificationVM.verificationCode = ""
                                            }
                                        }
                                    }
                                }
                                .padding()
                        }
                    } else {
                        Text("You are currently enrolled in Two-Factor Authentication with your phone number")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Constants.Colors.defaultText)
                        PrimaryButton(text: "Un-Enroll") {
                            vm.showAlert = .unenroll
                        }
                        .padding()
                    }
                    
                    error
                        .padding(.top, 10)
                    Spacer()
                    
                    Text("Two-Factor Authentication can help keep you secure your account by providing an extra layer of security for your TBD account to ensure that you are the only one who can access your account, even if someone knows your password.")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                    
                }
                //.padding()
            } else {
                if !vm.goToVerification {
                    VStack {
                        
                        Text("Please enter your password")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(Constants.Colors.defaultText)
                            .pushToTheLeft()
                            .padding(.bottom, 1)
                        
                        Text("This operation is sensitive and requires recent authentication.")
                            .font(.system(size: 12))
                            .foregroundColor(Color.gray)
                            .pushToTheLeft()
                        
                        VStack {
                            emailTextField
                            
                            divider
                            
//                            SecureFieldRow(title: "Password", placeholder: "tg58!g#d", leftIcon: "key.icloud", text: self.$password)
                        }
                        .padding(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(.systemGray5), lineWidth: 1)
                        )
                        .padding([.top, .bottom], 10)

                        PrimaryButton(text: "Authenticate") {
                            Task {
                                await vm.reauthenticateUser(email: email, password: password)
                            }
                        }
                        .frame(width: 160)
                        
                        error
                            .padding(.top, 10)
                        
                        Spacer()
                    }
                    
                } else {
                    VStack {
                        // this is for 2FA when reauthenticating
                        PhoneVerificationComponent(
                            viewModel: phoneVerificationVM,
                            resendCode: {
                                Task {
                                    await vm.checkTwoFactorAndSendCode(error: vm.reAuthError, onVerificationCodeSent: {
                                        print("toast")
                                    })
                                }
                            }
                        )
                        error
                    }
                    .onChange(of: phoneVerificationVM.verificationCode) { new in
                        if new.count == 6 {
                            Task {
                                await vm.verifyCode(verificationCode: new, onComplete: {
                                    vm.hasSignedIn = true
                                })
                                await MainActor.run {
                                    phoneVerificationVM.verificationCode = ""
                                }
                            }
                        }
                    }
                    //.padding()
                }
            }
        }
        .padding(20)
        // animate any change in the views associated to these variables to ease the transition between the different screens.
        .animation(.default, value: vm.errors)
        .animation(.default, value: vm.goToVerification)
        .animation(.default, value: vm.is2FAEnabled)
        .animation(.default, value: vm.hasSignedIn)

        .toast($emailSent, role: .success) {
            Text("Verification Email Sent")
        }
        .alert(item: $vm.showAlert, content: { alert in
            switch alert {
            case .unverifiedEmail:
                return Alert(
                    title: Text("Unverified Email"),
                    message: Text("Please verify your email address \(Auth.auth().currentUser?.email ?? "") before enrolling in 2FA."),
                    primaryButton:
                            .default(
                                Text("Send Verification Email"),
                                action: {
                                    Auth.auth().currentUser?.sendEmailVerification()
                                    self.emailSent.toggle()
                                }
                            ),
                    secondaryButton: .cancel())
                
            case .unenroll:
                return Alert(
                    title: Text("Un-Enroll in 2FA"),
                    message: Text("Are you sure you would like to un-enroll in Two-Factor Authentication"),
                    primaryButton:
                            .default(
                                Text("Un-Enroll"),
                                action: {
                                    Task {
                                        await vm.unEnroll()
                                    }
                                }
                            ),
                    secondaryButton: .cancel())
            }
        })
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("2FA")
                    .font(.system(size: 23, weight: .medium))
                    .foregroundColor(Constants.Colors.defaultText)
            }
        }
    }
    var error: some View {
        Group {
            if let errors = vm.errors {
                Text(errors)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(SignInColors.errorColor)
            }
        }
    }
    
    var emailTextField: some View {
        Group {
            if let userEmail = vm.user?.email {
                HStack {
                    Text(userEmail)
                        .onAppear {
                            self.email = userEmail
                        }
                    Spacer()
                }
                .foregroundColor(SignInColors.textFieldText)
                .frame(maxWidth: .infinity)
            } else {
//                TextFieldRow(title: "Email", placeholder: "name@email.com", leftIcon: "key.icloud", text: self.$email)
            }
        }
    }
    
    var divider: some View {
        Divider().background(Color(.systemGray6).opacity(0.5))
    }
}

struct TwoFactorAuthView_Previews: PreviewProvider {
    static var previews: some View {
        TwoFactorAuthView<Guest>(currentTab: .constant(4))
    }
}

struct LoadingScreen: View {
    
    @State private var shouldAnimate = false
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever())
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3))
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6))
        }
        .onAppear {
            self.shouldAnimate = true
        }
    }
}
