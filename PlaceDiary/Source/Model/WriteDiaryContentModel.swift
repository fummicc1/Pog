//
//  WriteDiaryModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/31.
//

import Foundation
import FirebaseFirestore
import RxSwift
import RxCocoa

protocol WriteDiaryContentModel {
    var myRef: DocumentReference { get }
    func persistDiary(diary: Entity.Diary) -> Single<Entity.Diary>
    func validate(diary: Entity.Diary) -> WriteDiaryViewModel.ValidationResult
}

class WriteDiaryContentModelImpl: WriteDiaryContentModel {
    
    private let firestore: FirestoreRepository = FirestoreClient()
    private let auth: AuthRepository = AuthClient()
    private let storage: CloudStorageRepository = CloudStorageClient()
    
    var myRef: DocumentReference {
        auth.myRef ?? Firestore.firestore().collection(FirestoreCollcetionName.users.rawValue).document("Guest")
    }
    
    func persistDiary(diary: Entity.Diary) -> Single<Entity.Diary> {
        .create { [weak self] (observer) -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            let group = DispatchGroup()
            if let imageURLPath = diary.mainImagePath, let imageURL = URL(string: imageURLPath) {
                group.enter()
                self.storage.persistImage(imageURL, path: CloudStoragePath.diaries.rawValue) { metadata, error in
                    group.leave()
                }
            }
            
            return Disposables.create()
        }
    }
    
    func validate(diary: Entity.Diary) -> WriteDiaryViewModel.ValidationResult {
        if diary.memory.isEmpty {
            return .noMemory
        } else {
            return .success
        }
    }
}
