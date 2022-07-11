import Foundation.NSURL
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

final class Guest: GuestRepresentable, ObservableObject {
    static var resourceName: String = "Travelers"
    
    @DocumentID var id: String?
    var isEmailVerified: Bool
    var firstName: String?
    var lastName: String?
    var photoURL: URL?
    var email: String?
    var birthDate: String?
    var phoneNumber: String?
    var location: Location?
    var hometown: String?
    var versionNumber: String?
    var buildNumber: Int?
    var isNewUser: Bool?
    var isDisabled: Bool?
    var isActive: Bool?
    
    @Published var foodPreferences: [String]? = nil
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case isEmailVerified
        case firstName
        case lastName
        case photoURL
        case email
        case birthDate
        case phoneNumber
        case bio
        case foodPreferences
        case createdTime
        case location
        case gender
        case hometown
        case versionNumber
        case buildNumber
        case isNewUser
        case isDisabled
        case favoriteServers
        case serversComplimented
        case privateAccount
        case fullname_lowercased
        case isActive
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(isEmailVerified, forKey: .isEmailVerified)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(photoURL, forKey: .photoURL)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(birthDate, forKey: .birthDate)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(foodPreferences, forKey: .foodPreferences)
        try container.encodeIfPresent(createdTime, forKey: .createdTime)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(hometown, forKey: .hometown)
        try container.encodeIfPresent(versionNumber, forKey: .versionNumber)
        try container.encodeIfPresent(buildNumber, forKey: .buildNumber)
        try container.encodeIfPresent(isNewUser, forKey: .isNewUser)
        try container.encodeIfPresent(fullName?.lowercased(), forKey: .fullname_lowercased)
        try container.encodeIfPresent(isActive, forKey: .isActive)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let key = CodingUserInfoKey(rawValue: "DocumentRefUserInfoKey"),
           let id = decoder.userInfo[key] as? DocumentReference {
            self.id = id.documentID
        }
        
        isEmailVerified = try container.decode(Bool.self, forKey: .isEmailVerified)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        photoURL = try container.decodeIfPresent(URL.self, forKey: .photoURL)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        birthDate = try container.decodeIfPresent(String.self, forKey: .birthDate)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        foodPreferences = try container.decodeIfPresent([String].self, forKey: .foodPreferences)
        createdTime = try container.decodeIfPresent(Timestamp.self, forKey: .createdTime)
        location = try container.decodeIfPresent(Location.self, forKey: .location)
        versionNumber = try container.decodeIfPresent(String.self, forKey: .versionNumber)
        buildNumber = try container.decodeIfPresent(Int.self, forKey: .buildNumber)
        isNewUser = try container.decodeIfPresent(Bool.self, forKey: .isNewUser)
        isDisabled = try container.decodeIfPresent(Bool.self, forKey: .isDisabled)
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive)
    }
    
    static func == (lhs: Guest, rhs: Guest) -> Bool {
        lhs.id == rhs.id &&
        lhs.isEmailVerified == rhs.isEmailVerified &&
        lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.photoURL == rhs.photoURL &&
        lhs.email == rhs.email &&
        lhs.birthDate == rhs.birthDate &&
        lhs.phoneNumber == rhs.phoneNumber &&
        lhs.foodPreferences == rhs.foodPreferences &&
        lhs.createdTime == rhs.createdTime &&
        lhs.location == rhs.location &&
        lhs.versionNumber == rhs.versionNumber &&
        lhs.buildNumber == rhs.buildNumber &&
        lhs.hometown == rhs.hometown &&
        lhs.isDisabled == rhs.isDisabled &&
        lhs.isActive == rhs.isActive

    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(isEmailVerified)
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(photoURL)
        hasher.combine(email)
        hasher.combine(birthDate)
        hasher.combine(phoneNumber)
        hasher.combine(location)
        hasher.combine(foodPreferences)
        hasher.combine(createdTime)
        hasher.combine(hometown)
        hasher.combine(versionNumber)
        hasher.combine(buildNumber)
        hasher.combine(isNewUser)
        hasher.combine(isDisabled)
        hasher.combine(isActive)
    }
    
    init(id: String?,
         isEmailVerified: Bool,
         firstName: String?,
         lastName: String?,
         photoURL: URL?,
         email: String?,
         phoneNumber: String?) {
        self.id = id
        self.isEmailVerified = isEmailVerified
        self.firstName = firstName
        self.lastName = lastName
        self.photoURL = photoURL
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
    convenience init?(firebaseUser: Firebase.User?) {
        guard let user = firebaseUser else { return nil }
        
        // Temp solution until we get an onboarding view to collect
        // the user's first and last name when signing up with social
        let displayName = user.displayName?
            .split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
            .map { String($0) }
        
        self.init(
            id: user.uid,
            isEmailVerified: user.isEmailVerified,
            firstName: displayName?.first,
            lastName: displayName?.last,
            photoURL: user.photoURL,
            email: user.email,
            phoneNumber: user.phoneNumber
        )
        
        if let creationDate = user.metadata.creationDate {
            self.createdTime = Timestamp(date: creationDate)
        }
    }
    
    init(id: String, isEmailVerified: Bool, firstName: String?, lastName: String?, email: String?, phoneNumber: String?, photoURL: URL?, location: Location? = nil) {
        self.id = id
        self.isEmailVerified = isEmailVerified
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.photoURL = photoURL
        self.location = location
    }
}


