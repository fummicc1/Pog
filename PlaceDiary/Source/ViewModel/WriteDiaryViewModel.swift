//
//  WriteDiaryViewModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/31.
//

import Foundation
import RxSwift
import RxCocoa

protocol WriteDiaryViewModel {
    func pickerImageSelected(fileURL: URL)
}

final class WriteDiaryViewModelImpl: BaseViewModel, WriteDiaryViewModel {
    
    struct Input {
    }
    
    
    
    init(input: Input) {
        super.init()
    }
    
    func pickerImageSelected(fileURL: URL) {
    }
}
