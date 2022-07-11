//
//  FriendsViewModel.swift
//  Food_Preference_Server
//

import Combine
import CoreLocation
import Firebase
import SwiftUI

protocol PrivacyViewModelServerProtocol: ObservableObject {
    var server: Server { get }
    var upsert: Bool {get set}
    var toggle: Bool {get set}
    
    init()
    func privateAccount()
    func publicAccount()
    
}

final class PrivacyViewModelServer: PrivacyViewModelServerProtocol {
    var toggle: Bool = false
    
    var upsert: Bool = false
    
    func privateAccount () {
        self.server.privateAccount = true
        self.toggle = true
        try? self.server.upsert()
    }
    
    func publicAccount () {
        self.server.privateAccount = false
        self.toggle = false
        try? self.server.upsert()
    }
    
    
    
    
    //MARK: - Public Properties
    
    var server: Server
    
    init() {
        
        self.server = Server(id: "", isEmailVerified: false, firstName: "", lastName: "", email: "", phoneNumber: "", photoURL: nil)
        
        // Get the current server object and its friends
        if let id = Auth.auth().currentUser?.uid {
            Server.observe(by: id) { result in
                switch result {
                case .success(let server):
                    self.server = server
                    
                    
                case .failure(let error):
                    print(error)
                    return
                }
            }
        }
    }  // end of init
    
}
