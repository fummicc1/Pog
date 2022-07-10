//
//  PickedUpLogAnnotation.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/06/25.
//

import Foundation
import MapKit

class PickedUpLogAnnotation: MKPointAnnotation {
    init(pickedUpLog: PlaceLog) {
        self.pickedUpLog = pickedUpLog
        super.init()
        self.coordinate = CLLocationCoordinate2D(
            latitude: pickedUpLog.lat,
            longitude: pickedUpLog.lng
        )
    }

    let pickedUpLog: PlaceLog


}
