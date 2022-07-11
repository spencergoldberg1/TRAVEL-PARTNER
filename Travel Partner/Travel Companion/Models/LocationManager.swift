//
//  LocationManager.swift
//

import CoreLocation
import Combine
import Firebase
import FirebaseFirestoreSwift
import GeoFire

class LocationManager<User: UserRepresentable>: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    @Published private(set) var status: CLAuthorizationStatus?
    @Published private(set) var location: CLLocation?
    @Published var user: User?
    
    private var bag = Set<AnyCancellable>()
    
    init(user: User? = nil) {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
        
        guard let user = user, let id = user.id else { return }
        
        User.observe(by: id) { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure:
                self.user = nil
            }
        }
        
        $location
            .compactMap { $0 }
            .removeDuplicates { $0.coordinate == $1.coordinate }
            .throttle(for: 30, scheduler: RunLoop.main, latest: true)
            .sink { location in
                self.user?.location = Location(location: location)
                try? self.user?.upsert()
            }
            .store(in: &bag)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.status = manager.authorizationStatus
    }
    
}

extension CLLocationCoordinate2D: Equatable { 
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
