import Combine
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

final class Table: TableRepresentable, FireBaseRepresentable, ObservableObject {
    static var resourceName: String = "tables"
    
    enum CodingKeys: String, CodingKey {
        case name
        case alias
        case guestIds
        case pendingGuestIds
        case guestsIDsCelebrating
        case personsCelebrating
        case occasion
        case serverId
        case isOpen
        case createdAt
        case code
        case otherOccasion
        case numChecks
        case guestsIDsAllergyAcknowledged
    }
    
    enum Occasion: String, Codable, CaseIterable {
        case None
        case Birthday
        case Anniversary
        case Date
        case Celebration
        case Business
        case Casual
        case Graduation
        case Other
        
        /// Function that returns the image name for a given occasion
        static func getOccasionImageName(for occasion: Occasion?) -> OccasionImageInfo {
            // If the occasion passed in doesn't exist, then return no occasion
            guard let occasion = occasion else {
                return OccasionImageInfo(imageName: "circle.slash", imageColor: .white)
            }
            
            switch occasion {
            case .None:
                return OccasionImageInfo(imageName: "circle.slash", imageColor: .white)
            case .Birthday:
                return OccasionImageInfo(imageName: "gift.fill", imageColor: .pink)
            case .Anniversary:
                return OccasionImageInfo(imageName: "heart.fill", imageColor: .red)
            case .Date:
                return OccasionImageInfo(imageName: "sparkles", imageColor: .yellow)
            case .Celebration:
                return OccasionImageInfo(imageName: "hands.sparkles.fill", imageColor: .white)
            case .Business:
                return OccasionImageInfo(imageName: "briefcase.fill", imageColor: Color(UIColor.brown))
            case .Casual:
                return OccasionImageInfo(imageName: "cup.and.saucer.fill", imageColor: .gray)
            case .Graduation:
                return OccasionImageInfo(imageName: "graduationcap.fill", imageColor: .gray)
            case .Other:
                return OccasionImageInfo(imageName: "calendar", imageColor: Color(UIColor.brown))
            }
        }
    }
    struct OccasionImageInfo {
        var imageName: String
        var imageColor: Color
    }
    
    @DocumentID var id: String?
    var name: String
    var alias: String?
    var guestIds: Set<String>
    var pendingGuestIds: Set<String>
    var guestsIDsCelebrating: Set<String>? = nil
    var personsCelebrating: String? = nil
    var occasion: Table.Occasion?
    var serverId: Server.ID = nil
    var isOpen: Bool = true
    var code: String?
    var otherOccasion: String = ""
    var numChecks: String = ""
    var guestsIDsAllergyAcknowledged: Set<String>? = nil
    
    
    
    @ServerTimestamp private var createdAt: Timestamp?
    
    @Published private(set) var guests: Set<Guest> = []
    @Published private(set) var pendingGuests: Set<Guest> = []

    
    private var bag: [AnyCancellable] = []
    
    init(name: String, guestIds: Set<String>, pendingGuestIds: Set<String> = [], guestsIDsCelebrating: Set<String>, personsCelebrating: String, occasion: Occasion?, otherOccasion: String, numChecks: String, guestsIDsAllergyAcknowledged: Set<String>? = nil) {
        self.id = nil
        self.name = name
        self.alias = nil
        self.guestIds = guestIds
        self.pendingGuestIds = pendingGuestIds
        self.guestsIDsCelebrating = guestsIDsCelebrating
        self.personsCelebrating = personsCelebrating
        self.occasion = occasion
        self.otherOccasion = otherOccasion
        self.numChecks = numChecks
        self.guestsIDsAllergyAcknowledged = guestsIDsAllergyAcknowledged
    }
    
    init(name: String, guestIds: Set<String>, pendingGuestIds: Set<String> = [], guestsIDsCelebrating: Set<String>, personsCelebrating: String, occasion: Occasion?, serverId: String, isOpen: Bool, alias: String?, otherOccasion: String, numChecks: String, guestsIDsAllergyAcknowledged: Set<String>? = nil) {
        self.id = nil
        self.name = name
        self.guestIds = guestIds
        self.pendingGuestIds = pendingGuestIds
        self.guestsIDsCelebrating = guestsIDsCelebrating
        self.personsCelebrating = personsCelebrating
        self.occasion = occasion
        self.serverId = serverId
        self.isOpen = isOpen
        self.alias = alias
        self.otherOccasion = otherOccasion
        self.numChecks = numChecks
        self.guestsIDsAllergyAcknowledged = guestsIDsAllergyAcknowledged
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let key = CodingUserInfoKey(rawValue: "DocumentRefUserInfoKey"),
            let id = decoder.userInfo[key] as? DocumentReference {
            self.id = id.documentID
        }
        
        self.name = try container.decode(String.self, forKey: .name)
        self.alias = try container.decodeIfPresent(String.self, forKey: .alias)
        self.guestIds = try container.decode(Set<String>.self, forKey: .guestIds)
        self.pendingGuestIds = try container.decode(Set<String>.self, forKey: .pendingGuestIds)
        self.guestsIDsCelebrating = try? container.decode(Set<String>.self, forKey: .guestsIDsCelebrating)
        self.personsCelebrating = try? container.decode(String.self, forKey: .personsCelebrating)
        self.occasion = try container.decodeIfPresent(Occasion.self, forKey: .occasion)
        self.serverId = try? container.decode(Server.ID.self, forKey: .serverId) ?? nil
        self.isOpen = try container.decode(Bool.self, forKey: .isOpen)
        self.createdAt = try container.decodeIfPresent(Timestamp.self, forKey: .createdAt)
        self.code = try container.decodeIfPresent(String.self, forKey: .code)
        self.otherOccasion = try container.decode(String.self, forKey: .otherOccasion)
        self.numChecks = try container.decode(String.self, forKey: .numChecks)
        self.guestsIDsAllergyAcknowledged = try? container.decode(Set<String>.self, forKey: .guestsIDsAllergyAcknowledged)
        loadGuests()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(alias, forKey: .alias)
        try container.encode(guestIds, forKey: .guestIds)
        try container.encode(pendingGuestIds, forKey: .pendingGuestIds)
        try container.encodeIfPresent(guestsIDsCelebrating, forKey: .guestsIDsCelebrating)
        try container.encodeIfPresent(personsCelebrating, forKey: .personsCelebrating)
        try container.encodeIfPresent(occasion, forKey: .occasion)
        try container.encode(serverId, forKey: .serverId)
        try container.encode(isOpen, forKey: .isOpen)
        try container.encode(otherOccasion, forKey: .otherOccasion)
        try container.encode(numChecks, forKey: .numChecks)
        try container.encode(guestsIDsAllergyAcknowledged, forKey: .guestsIDsAllergyAcknowledged)
        
        if createdAt == nil {
            try container.encode(FieldValue.serverTimestamp(), forKey: .createdAt)
        }
    }
    
    static func getAll(completion: @escaping (Result<[Self], Error>) -> ()) {
        db.collection(Self.resourceName)
            .whereField("isOpen", isEqualTo: true)
            .getDocuments { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    do {
                        completion(.success(
                            try querySnapshot.documents.map { try $0.data(as: Self.self) }
                        ))
                    }
                    catch {
                        if querySnapshot.metadata.isFromCache {
                            Firestore.firestore().clearPersistence { error in
                                if let error = error { completion(.failure(error)) }
                                
                                // Retrieve new snapshot using recursion
                                _ = getAll { completion($0) }
                            }
                        }
                        else {
                            assertionFailure("Failed to decode for resource \(Self.resourceName)")
                            completion(.failure(FireBaseError.decodingError))
                        }
                    }
                }
                else if let error = error {
                    completion(.failure(error))
                }
            }
    }
    
    static func observeAll(completion: @escaping (Result<[Self], Error>) -> ()) {
        db.collection(Self.resourceName)
            .whereField("isOpen", isEqualTo: true)
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    do {
                        completion(.success(
                            try querySnapshot.documents.map { try $0.data(as: Self.self) }
                        ))
                    }
                    catch {
                        if querySnapshot.metadata.isFromCache {
                            Firestore.firestore().clearPersistence { error in
                                if let error = error { completion(.failure(error)) }
                                
                                // Retrieve new snapshot using recursion
                                _ = observeAll { completion($0) }
                            }
                        }
                        else {
                            assertionFailure("Failed to decode for resource \(Self.resourceName)")
                            completion(.failure(FireBaseError.decodingError))
                        }
                    }
                }
                else if let error = error {
                    completion(.failure(error))
                }
            }
    }
    
    static func observeAll(for guestId: String, findPending: Bool, completion: @escaping (Result<[Self], Error>) -> ()) {
        db.collection(Self.resourceName)
            .whereField("isOpen", isEqualTo: true)
            .whereField(findPending ? Table.CodingKeys.pendingGuestIds.rawValue : "guestIds", arrayContains: guestId)
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    do {
                        completion(.success(
                            try querySnapshot.documents.map { try $0.data(as: Self.self) }
                        ))
                    }
                    catch {
                        if querySnapshot.metadata.isFromCache {
                            Firestore.firestore().clearPersistence { error in
                                if let error = error { completion(.failure(error)) }
                                
                                // Retrieve new snapshot using recursion
                                _ = observeAll(for: guestId, findPending: findPending) { completion($0) }
                            }
                        }
                        else {
                            assertionFailure("Failed to decode for resource \(Self.resourceName)")
                            completion(.failure(FireBaseError.decodingError))
                        }
                    }
                }
                else if let error = error {
                    completion(.failure(error))
                }
            }
    }
    
    
    static func observeAll(for guestId: String, findPending: Bool = false) -> AnyPublisher<[Table], Never> {
        let subject = CurrentValueSubject<[Table], Never>([])
        Self.observeAll(for: guestId, findPending: findPending) { result in
            switch result {
                case .success(let value):
                    subject.send(value)
                case .failure:
                    subject.send([])
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
    func loadGuests() {
        Guest.getMultiple(by: Array(guestIds))
            .map { guestArr in
                self.guests.union(guestArr)
            }
            .assign(to: &$guests)

        Guest.getMultiple(by: Array(pendingGuestIds))
            .map { guestArr in
                self.pendingGuests.union(guestArr)
            }
            .assign(to: &$pendingGuests)
    }
    
    func observeGuests() {
        Guest.observe(by: Array(guestIds))
            .map(Set.init)
            .assign(to: &$guests)
        
        Guest.getMultiple(by: Array(pendingGuestIds))
            .map(Set.init)
            .assign(to: &$pendingGuests)
    }
    
    func addGuest(guestId: String) {
        guard let id = self.id else { return }
        
        let ref = db.collection(Self.resourceName).document(id)
        ref.updateData([
            "guestIds": FieldValue.arrayUnion([guestId])
        ])
        ref.updateData([
            Table.CodingKeys.pendingGuestIds.rawValue : FieldValue.arrayRemove([guestId])
        ])
    }
    
    /// Computed property that returns the guests with occasions at the table as a string delimited by commas
    var guestsWithOccasion: String {
        var guests: [String] = self.guests.compactMap { guest in
            // First check if there are people in the table celebrating an occasion. If not return nil
            guard let guestIdsCelebrating = self.guestsIDsCelebrating else {
                return nil
            }
            
            // If there are people in the table celebrating an occasion, then check if their id matches an ID found in the guestIdsCelebrating set.
            // If it does then return their first Name
            if guestIdsCelebrating.contains(guest.id!) {
                return guest.firstName ?? nil
            } else {
                return nil
            }
        }
        let pendingGuests: [String] = self.pendingGuests.compactMap { pendingGuest in
            guard let guestIdsCelebrating = self.guestsIDsCelebrating else {
                return nil
            }
            if guestIdsCelebrating.contains(pendingGuest.id!) {
                return pendingGuest.firstName ?? nil
            } else {
                return nil
            }
        }
        guests += pendingGuests
        
        if let extraPersonCelebrating = self.personsCelebrating {
            guests.append(extraPersonCelebrating)
        }
        
        // Removing the last two characters from the returned string so that we don't have trailing ", " in our string
        return String(guests.joined(separator: ", ").dropLast(2))
    }

    var allGuests : [Guest] {
        return Array(guests) + Array(pendingGuests)
    }
    
}
