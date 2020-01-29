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
	
	init(firestore: FirestoreRepository = FirestoreClient(), auth: AuthRepository = AuthClient()) {
		self.auth = auth
		self.firestore = firestore
		firestore.listenDiaries { (result) in
			switch result {
			case .success(let diaries): break
			case .failure(let error): break
			}
		}
	}
	
	func fetchDiaries() -> Single<[Entity.Diary]> {
		.create { (singleEvent) -> Disposable in			
			return Disposables.create()
		}
	}
}
