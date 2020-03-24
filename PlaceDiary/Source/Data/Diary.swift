//
//  Diary.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import Foundation
import FirebaseFirestore

extension Entity {
	struct Diary: FirestoreEntity {
        
		let place: String
		let memory: String
		let latitude: Double
		let longitude: Double
        let imagePath: String
        let tags: [String]
        let sender: DocumentReference
		
		var createdAt: Timestamp?
		var updatedAt: Timestamp?
		var ref: DocumentReference?
	}
}