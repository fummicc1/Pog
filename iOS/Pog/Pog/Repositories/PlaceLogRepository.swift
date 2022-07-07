//
//  PlaceLogRepository.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/06.
//

import Foundation
import SwiftUI
import Combine

public protocol PlaceLogRepository {
    var logs: AnyPublisher<[PlaceLog], Never> { get }
    var error: AnyPublisher<Error, Never> { get }
    func createNewLog(lat: Double, lng: Double, date: Date)
}

public class PlaceLogRepositoryImpl {
    private let _logs: CurrentValueSubject<[PlaceLog], Never> = .init([])
    private let _error: PassthroughSubject<Error, Never> = .init()
    private let store: Store
    private var cancellables: Set<AnyCancellable> = []

    public init(store: Store) {
        self.store = store
        store.logs
            .sink {
                self._logs.send($0)
            }
            .store(in: &cancellables)
    }
}

extension PlaceLogRepositoryImpl: PlaceLogRepository {
    public var logs: AnyPublisher<[PlaceLog], Never> {
        _logs.eraseToAnyPublisher()
    }

    public var error: AnyPublisher<Error, Never> {
        _error.eraseToAnyPublisher()
    }

    public func createNewLog(lat: Double, lng: Double, date: Date) {
        let log = PlaceLog(context: store.context)
        log.lat = lat
        log.lng = lng
        log.date = date
        do {
            try store.context.save()
        } catch {
            _error.send(error)
        }
    }
}
