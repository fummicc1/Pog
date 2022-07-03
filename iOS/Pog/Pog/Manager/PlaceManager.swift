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
    var error: AnyPublisher<Error, Never> { get }

    func searchNearby(at coordinate: CLLocationCoordinate2D)
    func search(text: String, useGooglePlaces: Bool)
}

public class PlaceManagerImpl: NSObject, PlaceManager {
    private let placesSubject: CurrentValueSubject<[Place], Never> = .init([])
    private let errorSubject: PassthroughSubject<Error, Never> = .init()

    private var localSearch: MKLocalSearch?
    private var searchCompleter = MKLocalSearchCompleter()
    private let apiClient: APIClient = APIClientImpl()

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

    public var error: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
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

    public func search(text: String, useGooglePlaces: Bool) {
        if text.isEmpty {
            return
        }
        if useGooglePlaces {
            Task {
                do {1
                    let response: PlaceSearchResponse = try await apiClient.request(with: .search(text: text))
                    let places = response.results.map{ result in
                        Place(
                            lat: result.geometry.location.lat,
                            lng: result.geometry.location.lng,
                            name: result.name
                        )
                    }
                    self.placesSubject.send(places)
                } catch {
                    print(error)
                }
            }
        } else {
            searchCompleter.queryFragment = text
            placesSubject.send([])
        }
    }
}

extension PlaceManagerImpl: MKLocalSearchCompleterDelegate {
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results
        for result in results {
            let request = MKLocalSearch.Request(completion: result)
            Task {
                if let localSearch = self.localSearch, localSearch.isSearching {
                    localSearch.cancel()
                }
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
                        placesSubject.send(places)
                    })
                } catch {
                    print(error)
                    errorSubject.send(error)
                }
            }
        }
    }
}
