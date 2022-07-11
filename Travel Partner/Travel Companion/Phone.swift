//
//  Phone.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 7/1/22.
//


import SwiftUI

struct PhoneVerificationComponent<User: UserRepresentable>: View {
      
    typealias Colors = Constants.Colors.Views.PhoneVerificationComponent
    
    @ObservedObject var viewModel: PhoneSignInViewModel<User>
    
    var resendCode: (()->())? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Please enter the verification code below")
                .foregroundColor(Colors.textColor)
                .font(.system(size: 13, weight: .regular))
            VStack(alignment: .center) {
                ZStack {
                    VerificationCodeView
                    TextField("", text: $viewModel.verificationCode)
                        .foregroundColor(.clear)
                        .textContentType(.oneTimeCode)
                        .disabled(viewModel.verificationCode.count >= 6)
                        .keyboardType(.numberPad)
                        .accentColor(.clear)
                }
                
                if let _ = viewModel.verificationCodeError {
                    Text("The SMS verification code was invalid. Try again or resend the verification code.")
                        .font(.callout)
                        .foregroundColor(Colors.errorColor)
                }
                
                HStack {
                    Text("Didn't Recieve Code?")
                        .foregroundColor(Colors.didntRecieveText)
                        .font(.system(size: 14, weight: .medium))
                    Button(action: {(resendCode ?? viewModel.sendVerificationCode)()}) {
                        Text("Resend Code")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Colors.resendCodeColor)
                }
            }
        }
        .padding(.top)
        .onChange(of: viewModel.verificationCode) { value in
            if let _ = viewModel.error, !value.isEmpty {
                viewModel.error = nil
            }
        }

    }
    var VerificationCodeView: some View {
        HStack {
            ForEach(0..<6) { index in
                let isIndexValid = Array(viewModel.verificationCode).indices.contains(index)
                Group {
                    if isIndexValid {
                        Image(systemName: "\(Array(viewModel.verificationCode)[index]).square.fill")
                            .foregroundColor(Colors.codeFilled)
                    } else {
                        Image(systemName: "square")
                            .foregroundColor(Colors.codeUnfilled)
                    }
                }.font(.title)
            }
        }
    }
}

struct PhoneVerificationComponent_Previews: PreviewProvider {
    static var previews: some View {
        PhoneVerificationComponent(viewModel: PhoneSignInViewModel<Guest>())
    }
}

