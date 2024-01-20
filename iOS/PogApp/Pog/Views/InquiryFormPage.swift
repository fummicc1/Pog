//
//  InquiryFormPage.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/08/18.
//

import Foundation
import SwiftUI

struct InquiryFormPage: View {

    @StateObject var model: InquiryFormModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Form {
                Section(L10n.Common.emailAddress) {
                    TextField(
                        "\(L10n.Common.emailAddress)(\(L10n.Common.optional))",
                        text: $model.email
                    )
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                }

                Section(L10n.InquiryFormPage.Form.message) {
                    Text(
                        "※ \(L10n.Common.message) (\(L10n.Common.required))"
                    )
                    TextEditor(text: $model.message)
                }
            }
        }
        .alert(
            L10n.InquiryFormPage.Form.complete,
            isPresented: $model.completeSendingMessage,
            actions: {
                Button {
                    dismiss()
                } label: {
                    Text(L10n.Common.close)
                }

            }
        )
        .toolbar {
            Button {
                model.save()
            } label: {
                Text(L10n.Common.send)
            }
            .disabled(model.message.isEmpty)
        }
        .navigationTitle(L10n.InquiryFormPage.title)
        .navigationBarHidden(false)
    }
}
