//
//  FirestoreClient.swift
//  Count
//
//  Created by Fumiya Tanaka on 2019/10/03.
//  Copyright © 2019 app.tanaka.fummicc1. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

protocol FirestoreEntity: Codable {
    var ref: DocumentReference? { get set }
    var createdAt: Timestamp? { get }
    var updatedAt: Timestamp? { get }
}

protocol FirestoreRepository {
	func listenDiaries(onChanged: ((Result<[Entity.Diary], AppError>) -> ())?)
}

class FirestoreClient {
    
	var listenerArray: [ListenerRegistration] = []
	
	@discardableResult
	private func listenCollection<T: FirestoreEntity>(type: T.Type, ref: CollectionReference, completion: @escaping ([T]?, Error?) -> ()) -> ListenerRegistration {
        let listener = ref.addSnapshotListener(includeMetadataChanges: true) { (snapshots, error) in
            guard let snapshots = snapshots, error == nil else {
                return
            }
            if snapshots.metadata.hasPendingWrites { return }
            var list: [T] = []
            for document in snapshots.documents {
                let data = document.data()
                let decoder = Firestore.Decoder()
                guard var value = try? decoder.decode(T.self, from: data) else { continue }
                value.ref = document.reference
                list.append(value)
            }
            completion(list, nil)
        }
		return listener
    }
    
	@discardableResult
    private func listenCollection<T: FirestoreEntity>(type: T.Type, query: Query, completion: @escaping ([T]?, Error?) -> ()) -> ListenerRegistration {
        let listener = query.addSnapshotListener(includeMetadataChanges: true) { (snapshots, error) in
            guard let snapshots = snapshots, error == nil else {
                return
            }
            if snapshots.metadata.hasPendingWrites { return }
            var list: [T] = []
            for document in snapshots.documents {
                let data = document.data()
                let decoder = Firestore.Decoder()
                guard var value = try? decoder.decode(T.self, from: data) else { continue }
                value.ref = document.reference
                list.append(value)
            }
            completion(list, nil)
        }
		return listener
    }
    
    private func getDocuments<T: FirestoreEntity>(type: T.Type, query: Query, completion: @escaping ([T]?, Error?) -> ()) {
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            var list: [T] = []
            for document in snapshot.documents {
                let data = document.data()
                let decoder = Firestore.Decoder()
                guard var value = try? decoder.decode(T.self, from: data) else { continue }
                value.ref = document.reference
                list.append(value)
            }
            completion(list, nil)
        }
    }
    
    private func persist<T: FirestoreEntity>(value: T, ref: DocumentReference, completion: @escaping (Error?) -> ()) {
        let encoder = Firestore.Encoder()
        guard var data = try? encoder.encode(value) else { return }
        if value.createdAt == nil {
            data["created_at"] = FieldValue.serverTimestamp()
        }
        data["updated_at"] = FieldValue.serverTimestamp()
        ref.setData(data, merge: true) { error in
            completion(error)
        }
    }
    
    private func delete(ref: DocumentReference, completion: ((Error?) -> ())?) {
        ref.delete(completion: completion)
    }
    
    typealias BatchGroup<T: FirestoreEntity> = (value: T, ref: DocumentReference)
    
    private func batch<T: FirestoreEntity, V: FirestoreEntity>(first: BatchGroup<T>, second: BatchGroup<V>, completion: @escaping (Error?) -> ()) {
        let batch = Firestore.firestore().batch()
        if var data = try? Firestore.Encoder().encode(first.value) {
            if first.value.createdAt == nil {
                data["created_at"] = FieldValue.serverTimestamp()
            }
            data["updated_at"] = FieldValue.serverTimestamp()
            batch.setData(data, forDocument: first.ref, merge: true)
        }
        if var data = try? Firestore.Encoder().encode(second.value) {
            if second.value.createdAt == nil {
                data["created_at"] = FieldValue.serverTimestamp()
            }
            data["updated_at"] = FieldValue.serverTimestamp()
            batch.setData(data, forDocument: second.ref, merge: true)
        }
        batch.commit(completion: completion)
    }
	
	deinit {
		listenerArray.forEach { $0.remove() }
	}
}

extension FirestoreClient: FirestoreRepository {
	func listenDiaries(onChanged: ((Result<[Entity.Diary], AppError>) -> ())?) {
		let ref = Firestore.firestore().collection(FirestoreCollcetionName.diaries.rawValue)
		listenCollection(type: Entity.Diary.self, ref: ref) { (diaries, error) in
			
		}
	}
}
