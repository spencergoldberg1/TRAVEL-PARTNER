//
//  ContentView.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 6/30/22.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var email: String = ""
    @State var password: String = ""
    var body: some View {
        VStack {
            TextField("Hello", text: $email)
            TextField("Hello", text: $password)
            
            Button {
                login()
            } label: {
                Text("Sign Up")
            }

        }
    }
    func login() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            Text("\(authResult!)")
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
