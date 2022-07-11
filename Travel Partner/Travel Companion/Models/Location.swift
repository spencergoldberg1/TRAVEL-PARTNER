//
//  Location.swift
//  Food_Preference
//

import CoreLocation
import Firebase
import FirebaseFirestoreSwift
import GeoFire

class Location: Identifiable, Codable, Equatable, Hashable {
    
    var geohash: String?
    var lat: Double?
    var lng: Double?
    @ServerTimestamp var timestamp: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case location
        case geohash
        case lat
        case lng
        case timestamp = "locationTimestamp"
    }
    
    func encode(to encoder: Encoder) throws {
        self.timestamp = Timestamp()
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.geohash, forKey: .geohash)
        try container.encode(self.lat, forKey: .lat)
        try container.encode(self.lng, forKey: .lng)
        try container.encode(timestamp, forKey: .timestamp)
    }
    
    init(location: CLLocation?) {
        if let location = location {
            let hash = GFUtils.geoHash(forLocation: location.coordinate)
            self.geohash = hash
            self.lat = location.coordinate.latitude
            self.lng = location.coordinate.longitude
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.geohash = try container.decodeIfPresent(String.self, forKey: .geohash)
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat)
        self.lng = try container.decodeIfPresent(Double.self, forKey: .lng)
        self.timestamp = try container.decodeIfPresent(Timestamp.self, forKey: .timestamp)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.geohash == rhs.geohash &&
            lhs.lat == rhs.lat &&
            lhs.lng == rhs.lng
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(geohash)
        hasher.combine(lat)
        hasher.combine(lng)
    }
}

extension Location {
    /// Get the CLLocationCoordinate based on a Location's latitude and longitude
    var coordinates: CLLocationCoordinate2D? {
        guard let lat = lat, let lng = lng else {
            return nil
        }
        
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
