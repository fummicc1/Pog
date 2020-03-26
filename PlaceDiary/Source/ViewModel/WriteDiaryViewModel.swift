//
//  WriteDiaryViewModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/26.
//

import Foundation
import RxSwift
import RxCocoa

class WriteDiaryViewModel: BaseViewModel {
    
    enum ValidationResult {
        case noMemory
        case success
    }
    
    enum ProcessStatus {
        case idel
        case uploading
        case fail
        case complete
    }
    
    typealias Input = _Input
    
    struct _Input {
        let memoryObservable: Observable<String>
        let placeObservable: Observable<String>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    var validationResult: Observable<ValidationResult> {
        validationResultRelay.asObservable()
    }
    private let validationResultRelay: PublishRelay<ValidationResult> = .init()
    private let processStatusRelay: PublishRelay<ProcessStatus> = .init()
    var processStatus: Observable<ProcessStatus> {
        processStatusRelay.asObservable()
    }
    
    func configure(input: _Input) {
    }
}
