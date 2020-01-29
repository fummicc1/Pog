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
		var createdAt: Timestamp?
		var updatedAt: Timestamp?
		var ref: DocumentReference?
	}
}
