//
//  LoginEmailOrPhoneView.swift
//  Food_Preference
//
//  Created by Raul Gutierrez Niubo on 3/30/22.
//  Copyright © 2022 Cocobolo Group. All rights reserved.
//

import SwiftUI

struct LoginEmailOrPhoneView<User: UserRepresentable>: View {
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        SignInView<User>(guestApp: User.resourceName == "guests")
                        .padding(.horizontal, 35)
            
}

struct LoginEmailOrPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        LoginEmailOrPhoneView<Guest>()
    }
}
}
