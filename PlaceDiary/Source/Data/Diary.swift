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
        
		let place: String?
		let memory: String
		let latitude: Double?
		let longitude: Double?
        let mainImagePath: String
        let tags: [String]?
        let sender: DocumentReference
		
		var createdAt: Timestamp?
		var updatedAt: Timestamp?
		var ref: DocumentReference?
        
        enum CodingKeys: String, CodingKey {
            case place
            case memory
            case latitude
            case longitude
            case mainImagePath = "main_image_path"
            case tags
            case sender
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case ref
        }
	}
}
