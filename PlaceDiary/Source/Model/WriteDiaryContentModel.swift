//
//  WriteDiaryModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/31.
//

import Foundation
import RxSwift
import RxCocoa

protocol WriteDiaryContentModel {
    func persistDiary(memory: String, title: String?, imageURLPath: String?) -> Single<Entity.Diary>
}

class WriteDiaryContentModelImpl: WriteDiaryContentModel {
    
    private let firestore: FirestoreRepository = FirestoreClient()
    private let auth: AuthRepository = AuthClient()
    private let storage: CloudStorageRepository = CloudStorageClient()
    
    func persistDiary(memory: String, title: String? = nil, imageURLPath: String? = nil) -> Single<Entity.Diary> {
        .create { [weak self] (observer) -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            let group = DispatchGroup()
            if let imageURLPath = imageURLPath, let imageURL = URL(string: imageURLPath) {
                group.enter()
                self.storage.persistImage(imageURL, path: CloudStoragePath.diaries.rawValue) { metadata, error in
                    group.leave()
                }
            }
            
            return Disposables.create()
        }
    }
}
