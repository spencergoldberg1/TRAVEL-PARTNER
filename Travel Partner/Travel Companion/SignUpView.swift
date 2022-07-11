//
//  SignUpView.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 7/1/22.
//

import UIKit
import SwiftUI
import AuthenticationServices
import GoogleSignIn
import FBSDKLoginKit
import Firebase
import Combine

final class SignUpViewModel<User: UserRepresentable>: SignUpViewModelProtocol {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var emailOrPhone: String = ""
    @Published var password: String = ""

    @Published private(set) var isFirstNameValid: Bool = false
    @Published private(set) var isLastNameValid: Bool = false
    @Published var isEmailValid: Bool = false
    @Published var isPhoneValid: Bool = false
    @Published private(set) var isPasswordValid: Bool = false
    @Published private(set) var isFormValid: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var passwordErrorMessage: String?
    
    @Published var signInType: SignInType = .email
    @Published var emailOrPhoneErrorMessage: String?
    @Published var alert: SignUpViewModelAlert? = nil
    
    init() {
        
        $firstName
            .map { !$0.isEmpty }
            .assign(to: &$isFirstNameValid)
        
        $lastName
            .map { !$0.isEmpty }
            .assign(to: &$isLastNameValid)

        // Check if email is valid
        $emailOrPhone
            .map { [weak self] value in
                guard self?.signInType == .email else { return false }
                guard !value.isEmpty else { return false }

                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                return value.range(of: emailRegEx, options: .regularExpression) != nil
            }
            .assign(to: &$isEmailValid)

        $password
            .map { [weak self] in self?.signInType == .email && $0.count > 5 }
            .assign(to: &$isPasswordValid)
        
        // Check if form is valid
        Publishers.CombineLatest4($isFirstNameValid, $isLastNameValid, $isEmailValid, $isPhoneValid)
            .map { $0 && $1 && ($2 || $3) }
            .combineLatest($isPasswordValid)
            .map { [weak self] in $0 && ($1 || self?.signInType == .phone) }
            .assign(to: &$isFormValid)
        
        $isPhoneValid
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { [weak self] in
                if !$0 && !(self?.emailOrPhone.isEmpty ?? true) {
                   return "Please enter a valid phone number."
                }
                return nil
            }
            .assign(to: &$emailOrPhoneErrorMessage)
        
        // On Sign-In type change, clear the emailOrPhone field
        $signInType
            .removeDuplicates()
            .map { [weak self] _ in
                self?.emailOrPhone = ""
                return nil
            }
            .assign(to: &$emailOrPhoneErrorMessage)
        
        // Remove any error messages when emailOrPhone field is empty
        $emailOrPhone
            .removeDuplicates()
            .filter(\.isEmpty)
            .map { _ in nil }
            .assign(to: &$emailOrPhoneErrorMessage)
        
        // If password is invalid, show a helpful error message
        $isPasswordValid
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .map { [weak self] value in
                guard !value && self?.signInType == .email else { return nil }
                guard !(self?.password.isEmpty ?? true) else { return nil }
                
                return "Password must be at least 6 characters"
            }
            .assign(to: &$passwordErrorMessage)
    }
    
    func signUp() {
        guard isFormValid else { return }
        
        isLoading = true
        Auth.auth().createUser(withEmail: emailOrPhone, password: password) { [weak self] result, error in
            self?.isLoading = false
            
         
            if let result = result {
                result.user.sendEmailVerification { _ in }
                
                // register the user
                let user = User(
                    id: result.user.uid,
                    isEmailVerified: result.user.isEmailVerified,
                    firstName: self?.firstName,
                    lastName: self?.lastName,
                    email: self?.emailOrPhone,
                    phoneNumber: nil,
                    photoURL: result.user.photoURL,
                    location: nil
                )
                
                UserDefaults.standard.set(false, forKey: "stopProfileNotification")
                UserDefaults.standard.set(false, forKey: "stopEmailNotification")

                try? user.upsert()
            }
        }
    }
}

struct SignUpView<User: UserRepresentable>: View {
    typealias Colors = Constants.Colors.Views.SignUpView
      
    let guestApp: Bool
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm = SignUpViewModel<User>()
    @StateObject var phoneSignInViewModel = PhoneSignInViewModel<User>()
    
    @State private var showTermsAndConditions = false
    @State private var animationChange = false
    @State private var isPasswordHidden = true
    @State private var navigated = false
    
    var bag: [AnyCancellable] = []
    
    var isVerificationCodeFull: Bool {
        phoneSignInViewModel.verificationCode.count == 6
    }
    
    var body: some View {
        VStack {
            // Form
            VStack(alignment: .center) {
                Text("OR")
                    .padding(.top)
                    .font(.system(size: 20, weight: .bold))
                HStack {
                    Spacer()
                    Text("Register with Email/Phone Number")
                        .font(.system(size: 17, weight: .medium))
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.bottom, 30)
                // MARK: - First Name field
                    HStack {
                        TextField("", text: $vm.firstName)
                            .customize { [weak vm] textField in
                                                   textField.tag = 1

                                                   guard let vm = vm else { return }
                                let toolbar = textField.createToolbar(nextTag: 2, enabled: vm.isFirstNameValid)
                                                      textField.inputAccessoryView = toolbar
                                                      textField.reloadInputViews()
                                                  }
                            .placeholder(when: vm.firstName.isEmpty) {
                                Text("First Name").foregroundColor(Colors.placeholderText)
                            }
                        
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(Colors.validColor)
                            .scaleEffect(vm.isFirstNameValid ? 1 : 0.01)
                            .animation(.spring())
                    }
                    .disableAutocorrection(true)
                    .foregroundColor(Colors.textFieldText)
                    .frame(height: 29)
                    .padding(10)
                    .autocapitalization(.none)
                    .background(Color(.white).cornerRadius(5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Colors.textfieldBorder, lineWidth: 0.5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(
                                Colors.validColor,
                                lineWidth: vm.isFirstNameValid ? 2 : 0
                            )
                            .animation(.easeInOut)
                    )
                
                
                // MARK: - Last Name field
                    HStack {
                        TextField("", text: $vm.lastName)
                            .customize { [weak vm] textField in
                                                   textField.tag = 2
                                guard let vm = vm else { return }

                                                       let toolbar = textField.createToolbar(
                                                           nextTag: vm.signInType == .phone ? 3 : 4,
                                                           enabled: vm.isLastNameValid
                                                       )
                                                       textField.inputAccessoryView = toolbar
                                                       textField.reloadInputViews()
                                                   }
                            .placeholder(when: vm.lastName.isEmpty) {
                                Text("Last Name").foregroundColor(Colors.placeholderText)
                            }
                        
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(Colors.validColor)
                            .scaleEffect(vm.isLastNameValid ? 1 : 0.01)
                            .animation(.spring())
                    }
                    .disableAutocorrection(true)
                    .foregroundColor(Colors.textFieldText)
                    .frame(height: 29)
                    .padding(10)
                    .autocapitalization(.none)
                    .background(Color(.white).cornerRadius(5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Colors.textfieldBorder, lineWidth: 0.5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(
                                Colors.validColor,
                                lineWidth: vm.isLastNameValid ? 2 : 0
                            )
                            .animation(.easeInOut)
                    )

                if !phoneSignInViewModel.goToVerification {
                    // MARK: - Email field
                    ZStack {
                        HStack {
                            TextField("", text: $vm.emailOrPhone)
                                .customize { [weak vm] textField in
                                                                   textField.tag = 4

                                                                   guard let vm = vm else { return }
                                    textField.placeholderAttributes(
                                        placeholderText: "Email",
                                        attributes: [.foregroundColor: UIColor(Colors.placeholderText)]
                                    )

                                                                   let toolbar = textField.createToolbar(nextTag: 5, enabled: vm.isEmailValid)
                                                                   textField.reloadInputViews()

                                                                   let item = UIBarButtonItem(
                                                                       title: "Use phone instead",
                                                                       primaryAction: UIAction { [weak textField, weak vm] action in
                                                                           withAnimation {
                                                                               vm?.signInType = .phone
                                                                               vm?.isPhoneValid = false
                                                                               vm?.emailOrPhone = ""
                                                                               textField?.text = ""
                                                                           }
                                                                           textField?.superview?.superview?.superview?.viewWithTag(3)?.becomeFirstResponder()
                                                                       }
                                                                   )

                                                                   toolbar.items?.insert(item, at: 0)
                                                                   textField.inputAccessoryView = toolbar

                                                                   // Editing did end
                                                                   textField.addAction(UIAction { action in
                                                                       if !vm.isEmailValid && !vm.emailOrPhone.isEmpty {
                                                                           withAnimation {
                                                                               vm.emailOrPhoneErrorMessage = "Please enter a valid email address."
                                                                           }
                                                                       }
                                                                   }, for: .editingDidEnd)
                                                               }
                            
                            
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Colors.validColor)
                                .scaleEffect(vm.isEmailValid && vm.signInType == .email ? 1 : 0.01)
                                .animation(.spring())
                        }
                        .textContentType(.emailAddress)
                        .disableAutocorrection(true)
                        .foregroundColor(Colors.textFieldText)
                        .frame(height: 29)
                        .padding(10)
                        .autocapitalization(.none)
                        .opacity(vm.signInType == .email ? 1 : 0)
                        .background(Color(.white).cornerRadius(5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Colors.textfieldBorder, lineWidth: 0.5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(
                                    Colors.validColor,
                                    lineWidth: vm.isEmailValid &&
                                        vm.signInType == .email &&
                                        vm.emailOrPhoneErrorMessage == nil ? 2 : 0
                                )
                                .animation(.easeInOut)
                        )
                        
                        
                        if vm.signInType == .phone {
                            HStack {
                                iPhoneNumberTextField(text: $vm.emailOrPhone, isValidNumber: $vm.isPhoneValid) { textField in
                                                                    textField.tag = 1
                                                                    textField.numberPlaceholderColor = UIColor(Colors.placeholderText)

                                                                    let toolbar = UIToolbar(
                                                                        frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
                                                                    )

                                                                    let item = UIBarButtonItem(
                                                                        title: "Use email instead",
                                                                        primaryAction: UIAction { [weak textField] action in
                                                                            withAnimation {
                                                                                vm.signInType = .email
                                                                                vm.emailOrPhone = ""
                                                                                textField?.text = ""
                                                                                vm.isEmailValid = false
                                                                            }
                                                                            textField?.superview?.superview?.superview?.viewWithTag(2)?.becomeFirstResponder()
                                                                        }
                                                                    )
                                    toolbar.items = [item]
                                                                       toolbar.sizeToFit()
                                                                       textField.inputAccessoryView = toolbar
                                                                   }
                                
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(Colors.validColor)
                                    .scaleEffect(vm.isPhoneValid && vm.signInType == .phone ? 1 : 0.01)
                                    .animation(.spring())
                                    .padding(.trailing, 10)
                            }
                            .frame(height: 56)
                            .opacity(vm.signInType == .phone ? 1 : 0)
                            .background(Color(.white).cornerRadius(5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Colors.textfieldBorder, lineWidth: 0.5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(
                                        Colors.validColor,
                                        lineWidth: vm.isPhoneValid &&
                                            vm.signInType == .phone &&
                                            vm.emailOrPhoneErrorMessage == nil ? 1 : 0
                                    )
                                    .animation(.easeInOut)
                            )
                        }
                        HStack {
                            Spacer()
                            Button {
                                if vm.signInType == .email {
                                    //withAnimation {
                                    vm.signInType = .phone
                                        //isValidPhone = false
                                    vm.emailOrPhone = ""
                                    //}
                                } else {
                                    //withAnimation {
                                    vm.signInType = .email
                                    vm.emailOrPhone = ""
                                        //isValidEmail = false
                                    vm.password = ""
                                    //}
                                }
                            } label: {
                                HStack {
                                    Spacer()
                                    if vm.signInType == .email {
                                        Image(systemName: "phone")
                                            .foregroundColor(User.resourceName == "guests" ? Constants.Colors.ColorPallete.DarkBrown : .black)
                                    } else {
                                        Image(systemName: "at")
                                            .foregroundColor(User.resourceName == "guests" ? Constants.Colors.ColorPallete.DarkBrown : .black)
                                    }
                                    
                                }
                                .padding(.trailing, 38)
                                .frame(width: 50, height: 50)
                                
                            }
                            
                        }
                    }
                    .overlay(
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(
                                    vm.emailOrPhoneErrorMessage != nil ? Colors.errorColor : .clear,
                                    lineWidth: 2
                                )
                                .animation(.easeInOut)
                            
                            HStack {
                                Spacer()
                                
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(Colors.errorColor)
                                    .scaleEffect(vm.emailOrPhoneErrorMessage != nil ? 1 : 0.01)
                                    .animation(.spring())
                                    .padding(.trailing, 10)
                            }
                        }
                        .frame(height: vm.signInType == .phone ? 56 : 49)
                    )
                    
                    if let errorMsg = vm.emailOrPhoneErrorMessage {
                        Text(errorMsg)
                            .font(.callout)
                            .foregroundColor(Colors.errorColor)
                            .padding(.top, -8)
                            .animation(.easeInOut)
                    }
                    
                    if vm.signInType == .email {
                        // MARK: - Password field
                        HStack {
                            LegacyTextField(text: $vm.password, onUpdate: { [weak vm] textField in
                                guard let vm = vm else { return }
                                
                                if let toolbar = textField.inputAccessoryView as? UIToolbar {
                                    toolbar.items?.last?.isEnabled = vm.isFormValid
                                }
                                
                                guard textField.isSecureTextEntry != isPasswordHidden else { return }
                                textField.togglePasswordVisibility()
                            }) { [weak vm] textField in
                                textField.tag = 5
                                
                                guard let vm = vm else { return }
                                
                                textField.layer.cornerRadius = 5
                                textField.textContentType = .newPassword
                                textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                                textField.textColor = UIColor(Colors.textFieldText)
                                
                                textField.placeholderAttributes(
                                    placeholderText: "Password",
                                    attributes: [.foregroundColor: UIColor(Colors.placeholderText)]
                                )
                                
                                textField.inputAccessoryView = textField.createToolbar(
                                    nextTag: 0,
                                    enabled: vm.isFormValid,
                                    trailingTitle: "Sign Up",
                                    UIAction { action in signUpWithEmailOrPhone() }
                                )
                            }
                            
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Colors.validColor)
                                .scaleEffect(vm.isPasswordValid ? 1 : 0.01)
                                .animation(.spring())
                            
                            Button(action: { isPasswordHidden.toggle()}) {
                                Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                                    .foregroundColor(Colors.showPasswordButton)
                                    //.animation(.none)
                            }
                        }
                        .onAppear {
                            vm.password = ""
                        }
                        .frame(height: 29)
                        .padding(10)
                        .background(Color(.white).cornerRadius(5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Colors.textfieldBorder, lineWidth: 0.5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Colors.validColor, lineWidth: vm.isPasswordValid ? 2 : 0)
                                .animation(.easeInOut)
                        )
                        
                        if !vm.isPasswordValid, let error = vm.passwordErrorMessage {
                            HStack {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Colors.errorColor)
                                    .padding(.top, 5)

                                Text(error)
                                    .font(.system(size: 11, weight: .semibold))
                                    .fontWeight(.medium)
                                    .foregroundColor(Colors.errorColor)
                                    .padding(.top, 5)
                            }
                            .padding(.top, -8)
                            .animation(.easeInOut)
                        }
                    }
                }
                else {
                    PhoneVerificationComponent(viewModel: phoneSignInViewModel)
                }
                
                Button(action: signUpWithEmailOrPhone) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            //.fill(Colors.signUpButtonBackground)
                            .fill(!(vm.isFormValid) ? Constants.Colors.Buttons.Primary.disabledBackgroundColor : Constants.Colors.Buttons.Primary.backgroundColor)
                        
                        if phoneSignInViewModel.isLoading {
                           
                        }
                        else {
                            Text(vm.signInType == .email || phoneSignInViewModel.goToVerification ? "Sign Up" : "Continue")
                                .fontWeight(.heavy)
                                .padding(10)
                                .foregroundColor(User.resourceName == "guests" ? Colors.signUpButtonText : .white)
                        }
                    }
                    .frame(height: 50)
                }
                .frame(maxHeight: 50)
                .opacity(vm.isFormValid ? 1 : 0.7)
                .disabled(!(vm.isFormValid))
                .padding(.top, 10)
                
                
                // MARK: - Use Email/Phone instead
//                Button {
//                    if vm.signInType == .email {
//                        //withAnimation {
//                        vm.signInType = .phone
//                            //isValidPhone = false
//                        vm.emailOrPhone = ""
//                        //}
//                    } else {
//                        //withAnimation {
//                        vm.signInType = .email
//                        vm.emailOrPhone = ""
//                            //isValidEmail = false
//                        vm.password = ""
//                        //}
//                    }
//                } label: {
//                    HStack {
//                        Spacer()
//                        if vm.signInType == .email {
//                            Text("Use Phone Instead")
//                                .font(.callout)
//                                .fontWeight(.medium)
//                                .foregroundColor(guestApp ? Constants.Colors.ColorPallete.DarkBrown : .white)
//                                .underline()
//                            //.padding(.top)
//                        } else {
//                            Text("Use Email Instead")
//                                .font(.callout)
//                                .fontWeight(.medium)
//                                .foregroundColor(guestApp ? Constants.Colors.ColorPallete.DarkBrown : .white)
//                                .underline()
//                                .padding(.top)
//                        }
//                        Spacer()
//                    }
//                    .padding(.top, 5)
//                    //.padding(.trailing)
//                }
                
                
            }
            //.animation(.default)
            Spacer()
        }
        
        .frame(minWidth: 0, maxWidth: .infinity)
        .onChange(of: isVerificationCodeFull) { newValue in
            if newValue {
                phoneSignInViewModel.signInUserWithPhone(firstName: vm.firstName, lastName: vm.lastName)
            }
        }
        .onChange(of: vm.emailOrPhone) {
            phoneSignInViewModel.phone = $0
        }
        .onChange(of: phoneSignInViewModel.error?.localizedDescription) { errorMsg in
            guard let errorMsg = errorMsg else { return }
            vm.emailOrPhoneErrorMessage = errorMsg
        }
    }
}

extension SignUpView {
    
    func signUpWithEmailOrPhone() {
        UIApplication.shared.dismissFirstResponder()
        
        switch vm.signInType {
        case .email:
            vm.signUp()
        case .phone:
            !phoneSignInViewModel.goToVerification ? phoneSignInViewModel.sendVerificationCode() : phoneSignInViewModel.signInUserWithPhone(firstName: vm.firstName, lastName: vm.lastName)
        }
    }
}

fileprivate struct SignUpTextFieldStyle: TextFieldStyle {
    private typealias Colors = Constants.Colors.Views.SignUpView
    
    let isValid: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            configuration
                .frame(height: 29)
                .foregroundColor(Colors.textFieldText)
            
            Spacer()
            
            Image(systemName: "checkmark.circle")
                .foregroundColor(Colors.validColor)
                .scaleEffect(isValid ? 1 : 0.01)
                .animation(.spring())
                //.padding(.trailing, 3)
        }
        .foregroundColor(Colors.textFieldText)
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(
                    Colors.validColor,
                    lineWidth: isValid ? 2 : 0
                )
                .animation(.easeInOut)
        )
    }
}

// MARK: - Toolbar Methods
fileprivate extension UITextField {
    
    func createToolbar(nextTag: Int, enabled: Bool, trailingTitle: String = "Next",_ action: UIAction? = nil) -> UIToolbar {

        var nextButton: UIButton
        
        if let action = action {
            nextButton = NextBarButtonItem(trailingTitle, action)
        }
        else {
            nextButton = NextBarButtonItem(trailingTitle, UIAction { [weak self] action in
                self?.superview?.superview?.viewWithTag(nextTag)?.becomeFirstResponder()
            })
        }

        let nextItem = UIBarButtonItem(customView: nextButton)
        
        if nextItem.isEnabled != enabled {
            nextItem.isEnabled = enabled
        }
        
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        toolbar.items = [.flexibleSpace(), nextItem]
        toolbar.sizeToFit()
        toolbar.barTintColor = UIColor(Constants.Colors.appBackground)
        return toolbar
    }
}

class NextBarButtonItem: UIButton {
    typealias Colors = Constants.Colors.Views.SignUpView
    
    init(_ title: String, _ action: UIAction) {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 10)
        super.init(frame: frame)
        self.frame = frame
                
        setAttributedTitle(NSAttributedString(
            string: title, attributes: [
                .foregroundColor: UIColor(Colors.signUpButtonText),
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
            ]
        ), for: .normal)
        
        titleLabel?.adjustsFontSizeToFitWidth = true
        addAction(action, for: .primaryActionTriggered)
        backgroundColor = UIColor(Colors.signUpButtonBackground)
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoder not implemented")
    }
    
    override var isEnabled: Bool {
        didSet {
            layer.opacity = isEnabled ? 1 : 0.5
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.layer.opacity = 0.7
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.layer.opacity = 1
        }
        super.touchesEnded(touches, with: event)
    }
}

