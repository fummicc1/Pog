//
//  InquiryFormData.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/08/18.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import EasyFirebaseSwiftFirestore


class InquiryFormData: FirestoreModel {

    init(
        ref: DocumentReference? = nil,
        createdAt: Timestamp? = nil,
        updatedAt: Timestamp? = nil,
        email: String? = nil,
        message: String
    ) {
        self.ref = ref
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.email = email
        self.message = message
    }

    static var collectionName: String = "inquiry_forms"

    @DocumentID
    var ref: DocumentReference?

    @ServerTimestamp
    var createdAt: Timestamp?

    @ServerTimestamp
    var updatedAt: Timestamp?

    var email: String?

    var message: String
}
