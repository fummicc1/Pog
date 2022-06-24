//
//  FeatureLogAnnotation.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/06/25.
//

import Foundation
import MapKit

class FeatureLogAnnotation: MKPointAnnotation {
    init(featureLog: PlaceLog) {
        self.featureLog = featureLog
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: featureLog.lat, longitude: featureLog.lng)
    }

    let featureLog: PlaceLog


}
