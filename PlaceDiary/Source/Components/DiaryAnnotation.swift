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
	
	init(diary: Entity.Diary) {
		coordinate = .init(latitude: diary.latitude, longitude: diary.longitude)
		super.init()
	}
}
