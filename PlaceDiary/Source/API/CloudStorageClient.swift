//
//  CloudStorageClient.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/31.
//

import Foundation
import FirebaseStorage
import RxSwift
import RxCocoa

enum CloudStoragePath: String {
    case diaries
}

protocol CloudStorageRepository {
    func persistImage(_ imageFileURL: URL, path: String, completion: ((StorageMetadata?, Error?) -> ())?)
}

class CloudStorageClient: CloudStorageRepository {
    func persistImage(_ imageFileURL: URL, path: String, completion: ((StorageMetadata?, Error?) -> ())?) {
        Storage.storage().reference().child("diaries").child(path).putFile(from: imageFileURL, metadata: nil, completion: completion)
    }
}
