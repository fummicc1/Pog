//
//  InquiryFormModel.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/08/18.
//

import Combine
import EasyFirebaseSwiftFirestore
import Foundation

class InquiryFormModel: ObservableObject {

    enum Error: Swift.Error {
        case emptyMessage
        case underlying(Swift.Error)
    }

    private var cancellables: Set<AnyCancellable> = []

    @Published var email: String = ""
    @Published var message: String = ""
    @Published var error: Error?
    @Published var completeSendingMessage: Bool = false

    func save() {
        if message.isEmpty {
            error = .emptyMessage
            return
        }
        let data: InquiryFormData
        if email.isEmpty {
            data = InquiryFormData(message: message)
        }
        else {
            data = InquiryFormData(email: email, message: message)
        }
        data.write(for: .create)
            .sink { result in
                switch result {
                case .finished:
                    self.error = nil
                    self.completeSendingMessage = true
                case .failure(let error):
                    self.error = .underlying(error)
                }
            } receiveValue: { _ in
            }
            .store(in: &cancellables)

    }
}
