//
//  SignupView.swift
//  Food_Preference
//
//  Created by Raul Gutierrez Niubo on 3/28/22.
//  Copyright © 2022 Cocobolo Group. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import AuthenticationServices

struct SignupEmailOrPhoneView<User: UserRepresentable>: View {

    @Environment(\.presentationMode) var mode
    
    var body: some View {
            
                    
        SignUpView<User>(guestApp: User.resourceName == "guests")
                        .padding(.horizontal, 35)
                    
            
            
            
        
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupEmailOrPhoneView<Guest>()
    }
}
