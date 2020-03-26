//
//  DiaryAnnotation.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/31.
//

import Foundation
import MapKit

class DiaryAnnotation: NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	
	init?(diary: Entity.Diary) {
        guard let latitude = diary.latitude, let longitude = diary.longitude else {
            return nil
        }
		coordinate = .init(latitude: latitude, longitude: longitude)
		super.init()
	}
}
