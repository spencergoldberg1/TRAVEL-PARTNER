import Foundation.NSURL
import Firebase
import FirebaseFirestoreSwift

/**
 This Struct represents a server of our app.
 */
struct Server: ServerRepresentable, Hashable, Identifiable {
    
    static var resourceName = "servers"
    
    // MARK: - Public properties
    @DocumentID var id: String?
    var firstName: String?
    var lastName: String?
    var photoURL: URL?
    var email: String?
    var isEmailVerified: Bool
    var location: Location? = nil
    var versionNumber: String?
    var buildNumber: Int?
    var isNewUser: Bool? = nil
    var isDisabled: Bool?
    
    var phoneNumber: String?
    var birthDate: String?
    var workplace1: String?
    var workplace2: String?
    var hometown: String? = nil
    var menuURL: String? = nil
    var gender: String? = nil
    @CodableIgnored var greet: String? = nil
    var languages: [String: String] = [:]
    var compliments: [Compliment.RawValue: Int] = [:]
    var bio: String? = nil
    var friends: [String]? = nil
    var position: String? = nil
    var notifications: [AppNotification]? = nil
    var privateAccount: Bool = false
    @ServerTimestamp var createdTime: Timestamp?
    var interests: [String] = []
    var accessibility: [String: [String: String]]? = ["accessibility" : [:]]
    
    var tips: [TipModel]? = nil

    
    struct TipModel: Codable, Identifiable, Equatable, Hashable {
        var id: String // uuid String
        var guestId: String? // guest id can only be available from the guest app as server's can get tips without actually having a guest.
        var tableId: String? // table id won't be available on server app as well because as i said for guest id, we want the server to accept tips from anyone.
        var tipAmount: String
        var hasBeenAccepted: Bool
        var currency: String
        var dateRecieved: Timestamp
    }
    

    // MARK: - Constructor
    init(id: String? = nil,
         photoURL: URL? = nil,
         email: String? = nil,
         phoneNumber: String? = nil,
         isEmailVerified: Bool = false) {
        self.id = id
        self.photoURL = photoURL
        self.email = email
        self.phoneNumber = phoneNumber
        self.isEmailVerified = isEmailVerified
    }
    
    init?(firebaseUser: Firebase.User?) {
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
            email: user.email,
            phoneNumber: user.phoneNumber,
            photoURL: user.photoURL
        )
    }
    
    init(id: String, isEmailVerified: Bool, firstName: String?, lastName: String?, email: String?, phoneNumber: String?, photoURL: URL?, location: Location? = nil) {
        self.id = id
        self.isEmailVerified = isEmailVerified
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.photoURL = photoURL
        self.hometown = nil
        self.bio = nil
        self.location = location
    }
    
    static func == (lhs: Server, rhs: Server) -> Bool {
        return
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.email == rhs.email &&
            lhs.phoneNumber == rhs.phoneNumber &&
            lhs.birthDate == rhs.birthDate &&
            lhs.workplace1 == rhs.workplace1 &&
            lhs.workplace2 == rhs.workplace2 &&
            lhs.hometown == rhs.hometown &&
            lhs.menuURL == rhs.menuURL &&
            lhs.languages == rhs.languages &&
            lhs.gender == rhs.gender &&
            lhs.greet == rhs.greet &&
            lhs.location == rhs.location &&
            lhs.compliments == rhs.compliments &&
            lhs.friends == rhs.friends &&
            lhs.position == rhs.position &&
            lhs.versionNumber == rhs.versionNumber &&
            lhs.buildNumber == rhs.buildNumber &&
            lhs.position == rhs.position &&
            lhs.isNewUser == rhs.isNewUser &&
            lhs.isDisabled == rhs.isDisabled &&
            lhs.privateAccount == rhs.privateAccount &&
            lhs.interests == rhs.interests &&
            lhs.accessibility == rhs.accessibility &&
            lhs.tips == rhs.tips
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Server {
    
    // MARK: - Compliments
    enum Compliment: String, Codable, CaseIterable {
        case friendlyPersonality
        case makesGreatSuggestions
        case attentiveToGuests
        case goesAboveAndBeyond
        case knowledgeableOfMenu
        case hasAGreatMemory
        case attentionToDetail
        
        var text: String {
            switch self {
                case .friendlyPersonality:
                    return "Friendly Personality"
                case .makesGreatSuggestions:
                    return "Makes Great Suggestions"
                case .attentiveToGuests:
                    return "Attentive to Guests"
                case .goesAboveAndBeyond:
                    return "Goes Above & Beyond"
                case .knowledgeableOfMenu:
                    return "Knowledgeable of Menu"
                case .hasAGreatMemory:
                    return "Has A Great Memory"
                case .attentionToDetail:
                    return "Attention to Detail"
            }
        }
    }
}
