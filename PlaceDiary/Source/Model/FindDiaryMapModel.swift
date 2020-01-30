//
//  FindDiaryMapModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import Foundation
import RxSwift
import RxCocoa

protocol FindDiaryMapModel {
	func fetchDiaries() -> Single<[Entity.Diary]>
}

class FindDiaryMapModelImpl: FindDiaryMapModel {
	
	private let auth: AuthRepository
	private let firestore: FirestoreRepository
	
	init(firestore: FirestoreRepository = FirestoreClient(), auth: AuthRepository = AuthClient(), diariesChanged: AnyObserver<[Entity.Diary]>) {
		self.auth = auth
		self.firestore = firestore
		firestore.listenDiaries { (result) in
			switch result {
			case .success(let diaries):
				diariesChanged.onNext(diaries)
			case .failure(let error):
				diariesChanged.onError(error)
			}
		}
	}
	
	func fetchDiaries() -> Single<[Entity.Diary]> {
		Single.create { [weak self] singleEvent -> Disposable in
			guard let self = self else { return Disposables.create() }
			self.firestore.fetchDiaries { (result) in
				switch result {
				case .success(let diaries):
					singleEvent(.success(diaries))
				case .failure(let error):
					singleEvent(.error(error))
				}
			}
			return Disposables.create()
		}
	}
}
