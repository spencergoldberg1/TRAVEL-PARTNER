import Foundation.NSJSONSerialization
import FirebaseFirestore

/// To support a new class family, create an enum that conforms to this protocol and contains the different types.
protocol ClassFamily: Codable {
    /// Returns the class type of the object coresponding to the value.
    func getType() -> AnyObject.Type
}

fileprivate extension ClassFamily {
    static var discriminator: Discriminator { .type }
}

/// Discriminator key enum used to retrieve discriminator fields in JSON payloads.
fileprivate enum Discriminator: String, CodingKey {
    case type = "type"
}

extension JSONDecoder {
    
    /// Decode a heterogeneous list of objects.
    /// - Parameters:
    ///     - family: The ClassFamily enum type to decode with.
    ///     - data: The data to decode.
    /// - Returns: The list of decoded objects.
    func decode<T: ClassFamily, U: Decodable>(family: T.Type, from data: Data) throws -> U? {
        return try decode(ClassWrapper<T, U>.self, from: data).object
    }
    
    func decode<T: ClassFamily, U: Decodable>(family: T.Type, with snapshot: QueryDocumentSnapshot) throws -> U? {
        userInfo[CodingUserInfoKey(rawValue: "DocumentRefUserInfoKey")!] = snapshot.reference
        return try snapshot.data(as: ClassWrapper<T, U>.self).object
    }
    
    fileprivate final class ClassWrapper<T: ClassFamily, U: Decodable>: Decodable {
        /// The family enum containing the class information.
        let family: T
        /// The decoded object. Can be any subclass of U.
        let object: U?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Discriminator.self)
            
            // Decode the family with the discriminator.
            family = try container.decode(T.self, forKey: T.discriminator)
            // Decode the object by initialising the corresponding type.
            if let type = family.getType() as? U.Type {
                object = try type.init(from: decoder)
            }
            else {
                object = nil
            }
        }
    }
    
}
