//
//  WriteDiaryChoosePlaceModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/02/01.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa

protocol WriteDiaryChoosePlaceModel {
    func searchPlace(word: String) -> Single<[MKPlacemark]>
}

final class WriteDiaryChoosePlaceModelImpl: WriteDiaryChoosePlaceModel {
    func searchPlace(word: String) -> Single<[MKPlacemark]> {
        .create { observer -> Disposable in            
            return Disposables.create()
        }
    }
}
