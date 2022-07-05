//
//  InterestingPlaceRepository.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/06.
//

import Foundation
import Combine

public protocol InterestingPlaceRepository {
    var interestingPlace: AnyPublisher<InterestingPlace, Never> { get }
    var error: AnyPublisher<Error, Never> { get }
    func update<Value>(keypath: ReferenceWritableKeyPath<LocationSettings, Value>, value: Value)
    func reset()
}

public class InterestingPlaceRepositoryImpl {

    private let _interestingPlace: CurrentValueSubject<InterestingPlace?, Never> = .init(nil)
    private let _error: PassthroughSubject<Error, Never> = .init()
}

extension InterestingPlaceRepositoryImpl: InterestingPlaceRepository {
    public var interestingPlace: AnyPublisher<InterestingPlace, Never> {
        _interestingPlace.compactMap{ $0 }.eraseToAnyPublisher()
    }

    public var error: AnyPublisher<Error, Never> {
        _error.eraseToAnyPublisher()
    }

    public func update<Value>(keypath: ReferenceWritableKeyPath<LocationSettings, Value>, value: Value) {
    }

    public func reset() {
    }
}
