//
//  FetchDiaryModelMock.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import Foundation
import RxSwift
import RxCocoa

class FindDiaryModelMock: FindDiaryMapModel {
	func fetchDiaries() -> Single<[Entity.Diary]> {
		.create { (singleEvent) -> Disposable in
			
			
			
			return Disposables.create()
		}
	}
}
