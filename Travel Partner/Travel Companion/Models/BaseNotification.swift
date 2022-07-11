import FirebaseFirestore
import FirebaseFirestoreSwift

class AppNotification: Codable, Identifiable, Equatable, FireBaseRepresentable {
    static var resourceName: String = "notifications"
    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Timestamp?
    
    enum CodingKeys: CodingKey {
        case createdAt
    }
    
    init() {
        id = nil
    }
    
    static func ==(lhs: AppNotification, rhs: AppNotification) -> Bool {
        return lhs.id == rhs.id
    }
    
    required init(from decoder: Decoder) throws {
        if let key = CodingUserInfoKey(rawValue: "DocumentRefUserInfoKey"),
           let ref = decoder.userInfo[key] as? DocumentReference {
            self.id = ref.documentID
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decodeIfPresent(Timestamp.self, forKey: .createdAt)
    }
}

extension Timestamp: Comparable {
    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.compare(rhs) == .orderedAscending
    }
}
