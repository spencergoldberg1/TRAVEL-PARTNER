import Firebase
import GoogleSignIn
import Combine
import SwiftUI

/// Manager that listens for the current logged in user and decodes them to the appropriate object based on the app target
final class AuthenticationManager<User: UserRepresentable>: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var isLaunching: Bool = true
    var listener: ListenerRegistration?
    
    init() {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            // User is signed in, fetch their document
            if let user = user {                
                // Notify the counterpart watch app that the user signed in
               
                self?.isLoading = true
                self?.listener = db.collection(User.resourceName).document(user.uid).addSnapshotListener { document, error in
                    // Check and make sure there is no error. Else
                    guard error == nil else {
                        print("There was an error listening for the document of the signed in user. The error is \(error!)")
                        self?.isLaunching = false
                        self?.isLoading = false
                        return
                    }
                    
                    guard let document = document else {
                        print("Document object that was returned is nil")
                        self?.isLaunching = false
                        self?.isLoading = false
                        return
                    }
                    
                    if document.exists {
                        // If able to decode the document into user object, then set the decoded user to the current user
                        do {
                            try self?.user = document.data(as: User.self)
                            
                            // If the user's email is verified, then update it in their document if needed
                            if user.isEmailVerified && self?.user?.isEmailVerified == false {
                                try? self?.user?.updateFields(for: [ "isEmailVerified": true ])
                            }
                            
                            withAnimation {
                                self?.isLoading = false
                                self?.isLaunching = false
                            }
                        // If unable to decode the document into user object, then set the current user to nil
                        } catch {
                            print("Error while trying to decode the signed in user. The error is \(error)")
                            self?.user = nil
                            withAnimation {
                                self?.isLoading = false
                                self?.isLaunching = false
                            }
                        }
                    }
                    // Else if user's document doesn't exist then create the document
                    else {
                        let newUser = User(firebaseUser: user)
                        try? newUser?.upsert()

                    }
                }
            }
            // If the user is not signed in, set the current user to nil and remove the listener
            else {
                // Notify the counterpart watch app that the user signed out
               
                self?.user = nil
                self?.listener = nil
                withAnimation {
                    self?.isLaunching = false
                }
            }
        }
    }
}



