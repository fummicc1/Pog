//
//  WriteDiaryModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/31.
//

import Foundation
import RxSwift
import RxCocoa

protocol WriteDiaryModel {
    func persistDiary(title: String, imageURL: URL, memory: String) -> Single<Entity.Diary>
}

class WriteDiaryModelImpl: WriteDiaryModel {
    
    private let firestore: FirestoreRepository = FirestoreClient()
    private let auth: AuthRepository = AuthClient()
    private let storage: CloudStorageRepository = CloudStorageClient()
    
    func persistDiary(title: String, imageURL: URL, memory: String) -> Single<Entity.Diary> {
        .create { [weak self] (observer) -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            self.storage.persistImage(imageURL, path: "") { metadata, error in
                
            }
            return Disposables.create()
        }
    }
}
