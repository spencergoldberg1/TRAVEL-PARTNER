////
////  FriendsViewModel.swift
////  Food_Preference_Server
////
//
//import Combine
//import CoreLocation
//import Firebase
//import SwiftUI
//
//protocol PrivacyViewModelGuestProtocol: ObservableObject {
//    var guest: Guest { get }
//    var upsert: Bool {get set}
//    var toggle: Bool {get set}
//
//    init()
//    func privateAccount()
//    func publicAccount()
//    
//}
//
//final class PrivacyViewModelGuest: PrivacyViewModelGuestProtocol {
//    var toggle: Bool = false
//
//    var upsert: Bool = false
//
//    func privateAccount () {
//        self.guest.privateAccount = true
//        self.toggle = true
//        try? self.guest.upsert()
//    }
//
//    func publicAccount () {
//        self.guest.privateAccount = false
//        self.toggle = false
//        try? self.guest.upsert()
//    }
//
//
//
//
//    //MARK: - Public Properties
//
//    var guest: Guest
//
//
//    init() {
//
//        self.guest = Guest(id: "", isEmailVerified: false, firstName: "", lastName: "", email: "", phoneNumber: "", photoURL: URL(string: ""), location: nil)
//
//        // Get the current server object and its friends
//        if let id = Auth.auth().currentUser?.uid {
//            Guest.observe(by: id) { result in
//                switch result {
//                case .success(let guest):
//                    self.guest = guest
//
//
//                case .failure(let error):
//                    print(error)
//                    return
//                }
//            }
//        }
//
//
//
//
//
//
//
//
//
//
//
//}
//
//}
