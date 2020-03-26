//
//  User.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Entity {
    struct User: FirestoreEntity {
        
        let uid: String
        let diaries: [Diary]
        
        var createdAt: Timestamp?
        var updatedAt: Timestamp?
        var ref: DocumentReference?
        
        enum CodingKeys: String, CodingKey {
            case uid
            case diaries
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case ref
        }
    }
}
