//
//  PlaceManager.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/20.
//

import Foundation
import Combine
import MapKit

public protocol PlaceManager {
    var placesPublisher: AnyPublisher<[Place], Never> { get }
    var places: [Place] { get }

    func searchNearby(at coordinate: CLLocationCoordinate2D)
    func searchDescriptively(text: String)
}

public class PlaceManagerImpl: NSObject, PlaceManager {
    private let placesSubject: CurrentValueSubject<[Place], Never> = .init([])

    private var localSearch: MKLocalSearch?
    private var searchCompleter = MKLocalSearchCompleter()

    public override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.pointOfInterestFilter = .includingAll
        searchCompleter.resultTypes = .pointOfInterest
        searchCompleter.queryFragment = ""
    }


    public var places: [Place] {
        placesSubject.value
    }

    public var placesPublisher: AnyPublisher<[Place], Never> {
        placesSubject.eraseToAnyPublisher()
    }

    public func searchNearby(at coordinate: CLLocationCoordinate2D) {
        searchCompleter.region = .init(
            center: coordinate,
            latitudinalMeters: 1500,
            longitudinalMeters: 1500
        )
    }

    public func searchDescriptively(text: String) {
        var text = text
        if text.isEmpty {
            text = "カフェ"
        }
        searchCompleter.queryFragment = text
        placesSubject.send([])
    }
}

extension PlaceManagerImpl: MKLocalSearchCompleterDelegate {
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results
        for result in results {
            let request = MKLocalSearch.Request(completion: result)
            Task {
                self.localSearch = MKLocalSearch(request: request)
                do {
                    let response = try await self.localSearch!.start()
                    let places: [Place] = response.mapItems.map(\.placemark).map({ placemark in
                        let coordinate = placemark.coordinate
                        return Place(
                            lat: coordinate.latitude,
                            lng: coordinate.longitude,
                            name: placemark.name ?? ""
                        )
                    })
                    await MainActor.run(body: {
                        placesSubject.send(placesSubject.value + places)
                    })
                } catch {
                    print(error)
                }
            }
        }
    }
}
