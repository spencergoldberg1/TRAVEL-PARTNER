import SwiftUI
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import Combine

/// View that is shown when a user wants to sign in
struct SignInView<User: UserRepresentable>: View {
    private typealias Colors = Constants.Colors.Views.SignInView
    
    
    //    @ObservedObject var facebookSignInDelegate: SignInWithFacebookDelegates
    //    @ObservedObject var googleSignInDelegate: GoogleSignInDelegate
    @StateObject var phoneSignInViewModel = PhoneSignInViewModel<User>()
    @StateObject var twoFactorAuthVM = TwoFactorAuthViewModel(currentTab: .constant(4))
    @State var authError: Error? = nil

    
    @State var isAlertPresented = false
    @State var passwordResetSent = false
    @State var errDescription = ""
    @State var navigated = false
    let guestApp: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var emailOrPhoneNumber = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var showingAlert = false
    @State private var animationChange = false
    @State private var keyboardHeight : CGFloat = 0
    @State private var alertTitle = "Error :("
    @State private var alertMessage = ""
    @State private var showLoadingSpiner = false
    @State private var showPassword = false
    @State var signInTypeText: String = "Use phone Instead"
    
    @State private var isValidEmail = true
    @State private var isValidPass = true
    @State private var isValidPhone = false
    
    @State private var signInType: SignInType = .email
    
    
    var alert: Alert {
        Alert(
            title: Text(alertTitle),
            message: Text(alertMessage),
            dismissButton: .default(Text("OK"))
        )
    }
    
    var isVerificationCodeFull: Bool {
        phoneSignInViewModel.verificationCode.count == 6
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                
                if !phoneSignInViewModel.goToVerification && !twoFactorAuthVM.goToVerification {
                    // MARK: - Email field
                    VStack {
                        ZStack {
                            TextField("", text: $emailOrPhoneNumber)
                                                            .customize { textField in
                                                                textField.tag = 0
                                                                textField.layer.cornerRadius = 8

                                                                DispatchQueue.main.async {
                                                                    textField.placeholderAttributes(
                                                                        placeholderText: "Email",
                                                                        attributes: [.foregroundColor: UIColor(Colors.placeholderText)]
                                                                    )

                                                                    let toolbar = UIToolbar(
                                                                        frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
                                                                    )

                                                                    let item = UIBarButtonItem(
                                                                        title: "Use phone instead",
                                                                        primaryAction: UIAction { [weak textField] action in
                                                                           
                                                                            withAnimation {
                                                                                signInType = .phone
                                                                                isValidPhone = false
                                                                                emailOrPhoneNumber = ""
                                                                                textField?.text = ""
                                                                                
                                                                            }
                                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                                                                                textField?.superview?.superview?.superview?.viewWithTag(1)?.becomeFirstResponder()
                                                                            })
                                                                            
                                                                          
                                                                        }
                                                                    )

                                                                    toolbar.items = [item]
                                                                    toolbar.sizeToFit()
                                                                    textField.inputAccessoryView = toolbar
                                                                }
                                                            }
                                .textContentType(.emailAddress)
                                .disableAutocorrection(true)
                                .foregroundColor(Colors.textFieldText)
//                                .keyboardType(UIKeyboardType.emailAddress)
                                .autocapitalization(.none)
                                .modifier(SignInTextField())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(
                                            phoneSignInViewModel.error != nil ? Colors.errorColor : .clear,
                                            lineWidth: 2
                                        )
                                )
                                .overlay(
                                    Group {
                                        if !isValidPass && signInType == .email || !isValidEmail && signInType == .email {
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color(.red), lineWidth: 1)
                                        }
                                    }
                                )
                            
                            
                            if signInType == .phone {
                                HStack {
                                    iPhoneNumberTextField(text: $emailOrPhoneNumber, isValidNumber: $isValidPhone) { textField in
                                                                       textField.tag = 1
                                                                       textField.numberPlaceholderColor = UIColor(Colors.placeholderText)

                                                                       let toolbar = UIToolbar(
                                                                           frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
                                                                       )

                                                                       let item = UIBarButtonItem(
                                                                           title: "Use email instead",
                                                                           primaryAction: UIAction { [weak textField] action in
                                                                               withAnimation {
                                                                                   signInType = .email
                                                                                   emailOrPhoneNumber = ""
                                                                                   textField?.text = ""
                                                                                   isValidEmail = false
                                                                               }
                                                
                                                                               textField?.superview?.superview?.superview?.superview?.viewWithTag(0)?.becomeFirstResponder()
                                                                           }
                                                                       )
                                        toolbar.items = [item]
                                                                            toolbar.sizeToFit()
                                                                            textField.inputAccessoryView = toolbar
                                                                        }
                                    
                                    Image(systemName: "checkmark.circle")
                                        .foregroundColor(Colors.validColor)
                                        .scaleEffect(
                                            isValidPhone &&
                                            signInType == .phone &&
                                            phoneSignInViewModel.error == nil ? 1 : 0.01
                                        )
                                        .animation(.spring())
                                        .padding(.trailing, 10)
                                    
                                }
                                .frame(height: 56)
                                .background(Color(.white))
                                .opacity(signInType == .phone ? 1 : 0)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Colors.textfieldBorder, lineWidth: 0.5)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(
                                            Colors.validColor,
                                            lineWidth: isValidPhone && signInType == .phone ? 1 : 0
                                        )
                                        .animation(.easeInOut)
                                )
                                .overlay(
                                    Group {
                                        if let error = phoneSignInViewModel.error {
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color(.red), lineWidth: 1)
                                        }
                                    }
                                )
                            }
                           
                            HStack {
                                Spacer()
                                Button {
                                    if signInType == .email {
                                        //withAnimation {
                                            signInType = .phone
                                            //isValidPhone = false
                                            emailOrPhoneNumber = ""
                                        //}
                                    } else {
                                        //withAnimation {
                                            signInType = .email
                                            emailOrPhoneNumber = ""
                                            //isValidEmail = false
                                            password = ""
                                        //}
                                    }
                                } label: {
                                    HStack {
                                        Spacer()
                                        if signInType == .email {
                                            Image(systemName: "phone")
                                                .padding(14)
                                                .foregroundColor(User.resourceName == "guests" ? Constants.Colors.ColorPallete.DarkBrown : .black)
                                        } else {
                                            Image(systemName: "at")
                                                .padding(14)
                                                .foregroundColor(User.resourceName == "guests" ? Constants.Colors.ColorPallete.DarkBrown : .black)
                                        }
                                        
                                    }
                                    .frame(width: 50, height: 50)
                                    
                                }
                                
                            }
                        }
                        
                        if let error = phoneSignInViewModel.error {
                            Text(error.localizedDescription)
                                .font(.callout)
                                .foregroundColor(Colors.errorColor)
                                .padding(.top, 5)
                        }
                    }
                    
                    if signInType == .email {
                        HStack {
                            Group {
                                if self.showPassword {
                                    TextField("", text: self.$password)
                                        .textContentType(.password)
                                        .placeholder(when: password.isEmpty) {
                                                Text("Password").foregroundColor(Constants.Colors.placeholder)
                                        }
                                }
                                else {
                                    SecureField("", text: self.$password)
                                        .textContentType(.password)
                                        .placeholder(when: password.isEmpty) {
                                                Text("Password").foregroundColor(Constants.Colors.placeholder)
                                        }
                                }
                            }
                            .foregroundColor(Colors.textFieldText)
                            
                            Button(action: { self.showPassword.toggle()}) {
                                Image(systemName: self.showPassword ? "eye" : "eye.slash")
                                    .foregroundColor(Colors.showPasswordButton)
                            }
                        }
                        .modifier(SignInTextField())
                        .overlay(
                            Group {
                                if !isValidPass && signInType == .email || !isValidEmail && signInType == .email {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color(.red), lineWidth: 1)
                                }
                            }
                        )
                        
                        HStack {
                            if self.password.count >= 6 {
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Colors.flatButtonText)
                                Text("Password must be at least 6 characters long")
                                    .font(.system(size: 11, weight: .semibold))
                                    .fontWeight(.medium)
                                    .foregroundColor(Colors.flatButtonText)
                            } else if !self.password.isEmpty {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Colors.forgotPasswordText)
                                Text("Password must be at least 6 characters long")
                                    .font(.system(size: 11, weight: .semibold))
                                    .fontWeight(.medium)
                                    .foregroundColor(Colors.forgotPasswordText)
                            }
                            
                            Spacer()
                        }
                        
                        if !isValidEmail {
                            Text(alertMessage)
                                .lineLimit(nil)
                                .font(.callout)
                                .foregroundColor(Color(.red))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.top, .bottom], 10)
                        }
                        
                        if !self.isValidPass {
                            Text(self.alertMessage)
                                .lineLimit(nil)
                                .font(.callout)
                                .foregroundColor(Color(.red))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.top, .bottom], 10)
                        }
                        
                        
                    }
                    
                } else {
                    // this is for 2FA
                    
                }

                // MARK: - Sign in button
                Button(action: {
                    self.hideKeyboard()
                    if signInType == .email {
                        self.loginGuest()
                    }
                    if signInType == .phone {
                        !phoneSignInViewModel.goToVerification ? phoneSignInViewModel.sendVerificationCode() : phoneSignInViewModel.signInUserWithPhone(firstName: "", lastName: "")
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                        //.fill(Colors.signInButtonBackground)
                            .fill((emailOrPhoneNumber.isEmpty || phoneSignInViewModel.isLoading || showLoadingSpiner) ? Constants.Colors.Buttons.Primary.disabledBackgroundColor : Constants.Colors.Buttons.Primary.backgroundColor)
                        
                        if phoneSignInViewModel.isLoading || showLoadingSpiner {
                          
                            
                        }
                        else {
                            Text(signInType == .email || phoneSignInViewModel.goToVerification ? "Log In" : "Continue")
                                .fontWeight(.heavy)
                                .padding(15)
                                .foregroundColor(.white)
                            
                        }
                    }
                    .frame(height: 50)
                    
                }
                .padding(.top, 45)
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 50)
//                .opacity(emailOrPhoneNumber.isEmpty ? 0.7 : 1)
                .disabled(emailOrPhoneNumber.isEmpty || phoneSignInViewModel.isLoading || showLoadingSpiner)
                
                
                
                
                
                
                
                
                
                if signInType == .email && !phoneSignInViewModel.goToVerification {
                    // MARK: - Forgot password button
                    
                    Button(action: {
                        if emailOrPhoneNumber.isEmpty {
                            self.isValidPass = true
                            self.alertMessage = "Please, write your email."
                            self.isValidEmail = false
                        } else {
                            Auth.auth().sendPasswordReset(withEmail: emailOrPhoneNumber) { error in
                                if let error = error {
                                    self.isValidPass = true
                                    self.alertMessage = "Error sending password reset. \(error.localizedDescription)"
                                    self.isValidEmail = false
                                } else {
                                    passwordResetSent = true
                                }
                            }
                        }
                    }) {
                        Text("Forgot Password?")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(User.resourceName == "guests" ? Constants.Colors.ColorPallete.DarkBrown : .white)
                            .underline()
                            .padding(.top)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 25)
                    .font(.callout)
                }

                
            }
            //.animation(.default)
            .alert(isPresented: self.$showAlert, content: {self.alert})
            
        }
        .toast($passwordResetSent, role: .success) {
            Text("Password Reset Sent")
        }
        .onChange(of: isVerificationCodeFull) { newValue in
            if newValue {
                if self.signInType == .phone {
                    phoneSignInViewModel.signInUserWithPhone(firstName: "", lastName: "")
                } else {
                    Task {
                        // this will call the function to verify the user's inputted verification code and also show any error if it was returned.
                        if let error = await twoFactorAuthVM.verifyCode(
                            verificationCode: phoneSignInViewModel.verificationCode,
                            onComplete: {
                                self.showLoadingSpiner.toggle()
                            }
                        ) {
                            await MainActor.run {
                                phoneSignInViewModel.verificationCodeError = error
                            }
                        }
                    }
                }
            }
            withAnimation(.easeOut) {
                phoneSignInViewModel.verificationCode = ""
            }
        }
        .onChange(of: emailOrPhoneNumber) { newValue in
            //withAnimation {
            if let _ = phoneSignInViewModel.error {
                phoneSignInViewModel.error = nil
            }
            
            phoneSignInViewModel.phone = emailOrPhoneNumber
            //}
        }
        .animation(.default, value: phoneSignInViewModel.goToVerification)
    }
    
    //MARK: Sign In with email and password
    private func loginGuest() {
        self.showLoadingSpiner = true
        
        let impactLight = UIImpactFeedbackGenerator(style: .light)
        
        if emailOrPhoneNumber.isEmpty && phoneSignInViewModel.phone.isEmpty {
            impactLight.impactOccurred()
            self.isValidPass = true
            self.alertMessage = "Please, write your email or phone number."
            self.isValidEmail = false
            self.showLoadingSpiner = false
            
        }
        else if password.isEmpty {
            impactLight.impactOccurred()
            self.isValidEmail = true
            self.alertMessage = "Please, write your password."
            self.isValidPass = false
            self.showLoadingSpiner = false
        }
        
        if !(emailOrPhoneNumber.isEmpty && phoneSignInViewModel.phone.isEmpty) && !password.isEmpty {
            self.isValidEmail = true
            self.isValidPass = true
            
            Auth.auth().signIn(withEmail: emailOrPhoneNumber, password: password) { (AuthDataResult, error) in
                Task {
                    // checks if two factor auth is enabled and if so it sends the verification code, if not it signs in the user. Also displays any error if there was one.
                    if (error as? NSError)?.code == AuthErrorCode.secondFactorRequired.rawValue {
                        if let twoFactorAuthError = await twoFactorAuthVM.checkTwoFactorAndSendCode(
                            error: error,
                            onSignInComplete: {
                                self.showLoadingSpiner = false
                            },
                            onVerificationCodeSent: {
                                phoneSignInViewModel.goToVerification = true
                            }
                        ) {
                            await MainActor.run {
                                self.alertMessage = twoFactorAuthError.localizedDescription
                            }
                        }

                    } else {
                        await MainActor.run {
                            self.authError = error
                            if error != nil || !(AuthDataResult?.user.isEmailVerified ?? false) {
                                impactLight.impactOccurred()
                                self.alertTitle = "Register Error :("
                                self.alertMessage = "Invalid Email or Password"
                                self.showLoadingSpiner = false
                                self.isValidEmail = false
                            } else {
                                self.emailOrPhoneNumber = ""
                                self.password = ""
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func hideKeyboard() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow!.endEditing(true)
    }
}

enum SignInType {
    case email, phone
}

struct SignInTextField: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(height: 30)
            .padding(10)
            .background(Color(.white).cornerRadius(5))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 0.5)
            )
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView<Guest>(guestApp: true)
    }
}
