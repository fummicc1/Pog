//
//  FindDiaryMapModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import Foundation
import RxSwift
import RxCocoa

protocol DiariesModel {
	func fetchDiaries() -> Single<[Entity.Diary]>
	func listenDiaries() -> Single<[Entity.Diary]>
}

class DiariesModelImpl: DiariesModel {
	
	private let auth: AuthRepository
	private let firestore: FirestoreRepository
	
	init(firestore: FirestoreRepository = FirestoreClient(), auth: AuthRepository = AuthClient()) {
		self.auth = auth
		self.firestore = firestore
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
	
	func listenDiaries() -> Single<[Entity.Diary]> {
		return .create { [unowned self] observer -> Disposable in
			self.firestore.listenDiaries { (result) in
				switch result {
				case .success(let diaries):
					observer(.success(diaries))
				case .failure(let error):
					observer(.error(error))
				}
			}
			return Disposables.create()
		}
	}
}
