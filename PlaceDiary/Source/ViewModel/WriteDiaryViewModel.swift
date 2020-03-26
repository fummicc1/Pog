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
        let postButtonTapped: Observable<Void>
    }
    
    private let model: WriteDiaryContentModel
    
    var disposeBag: DisposeBag = DisposeBag()
    var validationResult: Observable<ValidationResult> {
        validationResultRelay.asObservable()
    }
    private let validationResultRelay: PublishRelay<ValidationResult> = .init()
    private let processStatusRelay: BehaviorRelay<ProcessStatus> = .init(value: .idel)
    var processStatus: Observable<ProcessStatus> {
        processStatusRelay.asObservable()
    }
    private let imageFileRelay: PublishRelay<URL> = .init()
    private let diaryRelay: PublishRelay<Entity.Diary> = .init()
    private var diary: Observable<Entity.Diary> {
        diaryRelay.asObservable()
    }
    
    init(model: WriteDiaryContentModel = WriteDiaryContentModelImpl()) {
        self.model = model
    }
    
    func configure(input: _Input) {
        Observable
            .combineLatest(
                input.memoryObservable,
                input.placeObservable,
                imageFileRelay.asObservable())
            .map ({
                Entity.Diary(
                    place: $0.0,
                    memory: $0.1,
                    latitude: nil,
                    longitude: nil,
                    mainImagePath: $0.2.path,
                    tags: nil,
                    sender: self.model.myRef,
                    createdAt: nil,
                    updatedAt: nil,
                    ref: nil
                )
            })
            .bind(to: diaryRelay)
            .disposed(by: disposeBag)
        
        input
            .postButtonTapped
            .filter { [weak self] _ in self?.processStatusRelay.value == .idel  }
            .withLatestFrom(diary)
            .flatMap(model.persistDiary(diary:))
            .share()
            .materialize()
        
        diary
            .map { [unowned self] diary in self.model.validate(diary: diary) }
            .bind(to: validationResultRelay)
            .disposed(by: disposeBag)
    }
    
    func didSelectImage(_ imageData: Data) {
        let temp = FileManager.default.temporaryDirectory.appendingPathComponent("write_diary_image_temp.jpg")
        do {
            try imageData.write(to: temp)
            imageFileRelay.accept(temp)
        } catch let error {
            assert(false, "\(error)")
        }
    }
}
