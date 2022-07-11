import Firebase
import Combine
import GeoFire
import CoreLocation

protocol FireBaseRepresentable: Identifiable, Codable {
    static var resourceName: String { get }
    var id: String? { get set }
}

enum FireBaseError: Error {
    case documentNotFound
    case documentNotCreated
    case decodingError
}

extension FireBaseRepresentable {
    
    static var collectionRef: CollectionReference { Firestore.firestore().collection(Self.resourceName) }
    
    func upsert(merge: Bool = true) throws {
        let ref: DocumentReference
        if let id = id {
            ref = db.collection(Self.resourceName).document(id)
        }
        else {
            ref = db.collection(Self.resourceName).document()
        }
        
        try ref.setData(from: self, merge: merge)
    }
    
    func upsert(merge: Bool = true, completion: @escaping (Result<Self, FireBaseError>) -> ()) {
        let ref: DocumentReference
        if let id = id {
            ref = db.collection(Self.resourceName).document(id)
        }
        else {
            ref = db.collection(Self.resourceName).document()
        }
        
        do {
            try ref.setData(from: self, merge: merge) { error in
                if let _ = error {
                    completion(.failure(.documentNotCreated))
                }
                else {
                    var newSelf = self
                    newSelf.id = ref.documentID
                    completion(.success(newSelf))
                }
            }
        }
        catch {
            completion(.failure(.documentNotCreated))
        }
    }
    
    /// Given a dictionary of fields and its values, only updates the fields in the document that are present in the dictionary's keys
    ///
    /// - Parameter fields: The `fields` to update in the document.
    func updateFields(for fields: [AnyHashable : Any]) throws {
        guard let id = id else { throw FireBaseError.documentNotCreated }
        
        db.collection(Self.resourceName).document(id).updateData(fields)
    }
    
    static func getAll(completion: @escaping (Result<[Self], Error>) -> ()) {
        db.collection(Self.resourceName).getDocuments { querySnapshot, error in
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
                            getAll { completion($0) }
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
    
    static func getAll() -> AnyPublisher<[Self], Never> {
        return Future<[Self], Never>() { promise in
            Self.getAll() { result in
                switch result {
                    case .success(let value):
                        promise(Result.success(value))
                    case .failure:
                        promise(Result.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func get(by id: String, completion: @escaping (Result<Self, Error>) -> ()) {
        db.collection(Self.resourceName).document(id).getDocument { documentSnapshot, error in
            if let document = documentSnapshot {
                if document.exists {
                    do {
                        completion(.success(try document.data(as: Self.self)))
                    }
                    catch {
                        if document.metadata.isFromCache {
                            Firestore.firestore().clearPersistence { error in
                                if let error = error { completion(.failure(error)) }
                                
                                // Retrieve new snapshot using recursion
                                get(by: id) { completion($0) }
                            }
                        }
                        else {
                            assertionFailure("Failed to decode for resource \(Self.resourceName)")
                            completion(.failure(FireBaseError.decodingError))
                        }
                    }
                }
                else {
                    completion(.failure(FireBaseError.documentNotFound))
                }
            }
            else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    static func get(by id: String) async -> (Self?, Error?) {
        do {
            let snapshot = try await db.collection(Self.resourceName).document(id).getDocument()
            
            let object = try snapshot.data(as: Self.self)
            return (object, nil)
        }
        catch {
            return (nil, error)
        }
    }

    static func get(by id: String) -> AnyPublisher<Self?, Never> {
        return Future<Self?, Never>() { promise in
            Self.get(by: id) { result in
                switch result {
                    case .success(let value):
                        promise(Result.success(value))
                    case .failure:
                        promise(Result.success(nil))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func getWithError(by id: String) -> AnyPublisher<Self, Error> {
        return Future<Self, Error>() { promise in
            Self.get(by: id) { result in
                switch result {
                case .success(let value):
                    promise(Result.success(value))
                case .failure(let error):
                    promise(Result.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func observe(by id: String, completion: @escaping (Result<Self, Error>) -> ()) {
        db.collection(Self.resourceName).document(id)
            .addSnapshotListener { docSnapshot, error in
                if let document = docSnapshot {
                    if document.exists {
                        do {
                            completion(.success(try document.data(as: Self.self)))
                        }
                        catch {
                            if document.metadata.isFromCache {
                                Firestore.firestore().clearPersistence { error in
                                    if let error = error { completion(.failure(error)) }
                                    
                                    // Retrieve new snapshot using recursion
                                    observe(by: id) { completion($0) }
                                }
                            }
                            else {
//                                assertionFailure("Failed to decode for resource \(Self.resourceName)")
                                completion(.failure(FireBaseError.decodingError))
                            }
                        }
                    }
                    else {
                        completion(.failure(FireBaseError.documentNotFound))
                    }
                }
                else if let error = error {
                    completion(.failure(error))
                }
            }
    }
    
    static func observe(by id: String) -> AnyPublisher<Self?, Never> {
        let subject = CurrentValueSubject<Self?, Never>(nil)
        Self.observe(by: id) { result in
            switch result {
                case .success(let value):
                    subject.send(value)
                case .failure:
                    subject.send(nil)
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
    /// Given an array of ids, fetches them from the database and returns an array of the given FirebaseRepresentable objects
    static func getMultiple(by ids: [String], completionHandler: @escaping ([Self]) -> ()) {
        let group = DispatchGroup()
        var results: [Self] = []
        ids.forEach {
            group.enter()
            Self.get(by: $0) { result in
                switch result {
                case .success(let object):
                    results.append(object)
                    group.leave()
                case .failure(let error):
                    print(error)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completionHandler(results)
        }
    }
    
    static func getMultiple(by ids: [String]) -> AnyPublisher<[Self], Never> {
        return Future<[Self], Never>() { promise in
            Self.getMultiple(by: ids) { result in
                promise(Result.success(result))
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func observe(by ids: [String]) -> AnyPublisher<[Self], Never> {
        guard !ids.isEmpty else {
            let subject = CurrentValueSubject<[Self], Never>([])
            subject.send([])
            return subject.eraseToAnyPublisher()
        }
        
        let subject = CurrentValueSubject<[Self], Never>([])

        let queryLimit = 10 // Firebase query limit
        let queryIds = Array(ids.prefix(upTo: min(ids.count, queryLimit)))
        
        db
            .collection(Self.resourceName)
            .whereField(FieldPath.documentID(), in: queryIds)
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    let result = querySnapshot.documents.compactMap { try? $0.data(as: Self.self) }
                    subject.send(result)
                }
                else {
                    subject.send([])
                }
            }
        
        return Publishers.MergeMany(
            Self.observe(by: Array(ids.dropFirst(queryLimit))), // Recursion
            subject.eraseToAnyPublisher()
        )
        .eraseToAnyPublisher()
    }
    
}

extension FireBaseRepresentable where Self: LocationRepresentable {
    
    /// Queries items based on the location and radius specified.
    ///
    /// - Parameter radius: The `radius` in meters.
    static func get(in radius: Double, of location: CLLocationCoordinate2D, completion: @escaping ([Self]) -> ()) {
        let group = DispatchGroup()
        var results: [Self] = []
        
        let queries: [Query] = GFUtils
            .queryBounds(
                forLocation: location,
                withRadius: radius
            )
            .compactMap { queryBound -> Query? in
                return db.collection(Self.resourceName)
                    .order(by: "location.geohash")
                    .start(at: [queryBound.startValue])
                    .end(at: [queryBound.endValue])
            }
        
        queries.forEach { query in
            group.enter()
            
            query.getDocuments { snapshot, error in
                group.leave()
                
                snapshot?.documents
                    .compactMap { document in try? document.data(as: Self.self) }
                    .forEach { result in
                        guard let lat = result.location?.lat,
                              let lng = result.location?.lng else { return }
                        
                        let coordinates = CLLocation(latitude: lat, longitude: lng)
                        let centerPoint = CLLocation(latitude: location.latitude, longitude: location.longitude)
                        
                        let distance = GFUtils.distance(from: centerPoint, to: coordinates)
                        if distance <= radius {
                            results.append(result)
                        }
                    }
            }
        }
        
        group.notify(queue: .main) {
            completion(results)
        }
        
    }
    
    
    /// Queries items based on the location and radius specified.
    ///
    /// - Parameter radius: The `radius` in meters.
    static func get(in radius: Double, of location: CLLocationCoordinate2D) -> AnyPublisher<[Self], Never> {
        return Future<[Self], Never>() { promise in
            Self.get(in: radius, of: location) { promise(Result.success($0)) }
        }
        .eraseToAnyPublisher()
    }
    
}
