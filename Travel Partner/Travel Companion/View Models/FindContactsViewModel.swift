//
//  FindContactsViewModel.swift
//  Food_Preference
//
//  Created by Peter Khouly on 12/13/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import Foundation
import Firebase
import ContactsUI

class FindContactsViewModel<User: UserRepresentable>: ObservableObject {
    var user: User?
    let db = Firestore.firestore()
    @Published var contacts: [ContactModel] = []
    
    init() {
        self.requestAccess() { granted in }
    }
    
    struct ContactModel: Identifiable {
        let id = UUID()
        var name: String
        var number: String
        var user: [User]?
    }
    
    func requestAccess(completion: @escaping (Bool) -> ()) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            completion(granted)
        }
    }
    
    func findContacts() {
        self.contacts.removeAll()
        
        let contacts = self.getContacts()
        
        for contact in contacts {
            for phoneNumber in contact.phoneNumbers {
                let phoneString = phoneNumber.value.stringValue
                
                self.findContact(phoneNumber: phoneString) { user, error in
                    if let user = user {
                        if !user.isEmpty {
                            self.contacts.append(ContactModel(name: "\(contact.givenName) \(contact.familyName)", number: phoneString, user: user))
                        } else {
                            self.contacts.append(ContactModel(name: "\(contact.givenName) \(contact.familyName)", number: phoneString, user: nil))
                        }
                    } else {
                        self.contacts.append(ContactModel(name: "\(contact.givenName) \(contact.familyName)", number: phoneString, user: nil))
                    }
                    if let error = error {
                        self.contacts.append(ContactModel(name: "\(contact.givenName) \(contact.familyName)", number: phoneString, user: nil))
                        print(error)
                    }
                }
                

            }
        }
    }
    fileprivate func getContacts() -> [CNContact] {

            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactPhoneNumbersKey,
                CNContactEmailAddressesKey,
                CNContactThumbnailImageDataKey] as [Any]

            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }

            var results: [CNContact] = []

            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching containers")
                }
            }
            return results
        }
        
    fileprivate func findContact(phoneNumber: String, completion: @escaping ([User]?, Error?) -> ()) {
        db.collection(User.resourceName)
            .whereField("phoneNumber", isEqualTo: phoneNumber)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot else {
                    completion(nil, error)
                    print("Error fetching document: \(error)")
                    return
                }
                completion(snapshot.documents.map {
                    try! $0.data(as: User.self)
                }, nil)
            }
    }
}
