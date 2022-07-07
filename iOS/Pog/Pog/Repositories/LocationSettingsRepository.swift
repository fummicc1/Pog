//
//  LocationSettingsRepository.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/06.
//

import Foundation
import Combine

public protocol LocationSettingsRepository {
    var locationSettings: AnyPublisher<LocationSettings, Never> { get }
    var error: AnyPublisher<Error, Never> { get }
}

public class LocationSettingsRepositoryImpl {

}

extension LocationSettingsRepositoryImpl {
    
}
