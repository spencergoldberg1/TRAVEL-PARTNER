//
//  AddressSearchViewModel.swift
//

import SwiftUI
import Combine
import MapKit

struct Address: Hashable {
    let title: String
    let subtitle: String
    
    func format() -> String {
        guard !subtitle.isEmpty else { return title }
        guard let city = subtitle.split(separator: ",").dropLast().last else {
            return title
        }
        
        return "\(title), \(city.dropFirst())"
    }
}

class AddressSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    @Published var lm: LocationManager<Server>
    @Published var searchQuery: String = ""
    @Published var addresses: [Address] = []
    
    private var queryResults: [MKLocalSearchCompletion] = []
    private var queryCancellable: AnyCancellable?
    private var regionCancellable: AnyCancellable?
    private var completer = MKLocalSearchCompleter()
    
    init(resultType: MKLocalSearchCompleter.ResultType = [.pointOfInterest]) {
        self.lm = LocationManager()
        self.completer.resultTypes = resultType
        
        super.init()
        
        queryCancellable = $searchQuery
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .assign(to: \.queryFragment, on: self.completer)
        self.completer.delegate = self
        
        regionCancellable = lm.$location
            .first {
                $0 != nil
            }
            .map { (location) -> MKCoordinateRegion in
                return MKCoordinateRegion(center: location!.coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
            }
            .receive(on: RunLoop.main)
            .assign(to: \.region, on: self.completer)
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        if completer.resultTypes == .address {
            self.addresses = completer.results
                .filter { address in
                    return address.subtitle.split(separator: ",").count <= 1 &&
                        address.title.split(separator: ",").count >= 2 &&
                        !address.title.hasNumber()
                }
                .map { address in
                    return Address(title: address.title, subtitle: address.subtitle)
                }
        }
        else {
            self.addresses = completer.results.map { (address: MKLocalSearchCompletion) -> Address in
                var subtitleArray = address.subtitle.split(separator: ",").dropLast().map { String($0) } //drop country code
                if let last = subtitleArray.last {
                    let parsedLast = last.replacingOccurrences(of: "  ", with: " ") //remove double spaces between zip code and state
                    subtitleArray[subtitleArray.count-1] = parsedLast
                }
                let newSubtitle = subtitleArray.joined(separator: ",")
                return Address(title: address.title, subtitle: newSubtitle)
            }
        }
    }
}
