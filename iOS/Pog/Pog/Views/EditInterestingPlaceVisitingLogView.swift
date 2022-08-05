//
//  EditInterestingPlaceVisitingLogView.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/13.
//

import SwiftUI

struct EditInterestingPlaceVisitingLogView: View {

    @Binding var editingLog: InterestingPlaceVisitingLog?

    @Environment(\.store) var store: Store

    @State private var visitedAt: Date
    @State private var exitedAt: Date?

    init(log: Binding<InterestingPlaceVisitingLog?>) {
        self._editingLog = log
        self._exitedAt = State(initialValue: log.wrappedValue!.exitedAt)
        self._visitedAt = State(initialValue: log.wrappedValue!.visitedAt!)
    }

    var body: some View {
        VStack {
            HStack {
                Text(L10n.Common.visitingTime)
                    .font(.callout)
                    .bold()
                    .foregroundColor(.secondary)
                Spacer()
                DatePicker("", selection: $visitedAt)
            }
            HStack {
                Text(L10n.Common.departureTime)
                    .font(.callout)
                    .bold()
                    .foregroundColor(.secondary)
                Spacer()
                if let exitedAt = Binding($exitedAt) {
                    DatePicker("", selection: exitedAt)
                }
            }
            Spacer().frame(height: 40)
            HStack {
                Button {
                    editingLog = nil
                } label: {
                    Text(L10n.Common.cancel)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                }
                .background(Color(uiColor: .systemGroupedBackground))
                .foregroundColor(Color(uiColor: .label))
                .cornerRadius(8)
                Button {
                    editingLog!.visitedAt = visitedAt
                    if let exitedAt = exitedAt {
                        editingLog!.exitedAt = exitedAt
                    }
                    do {
                        try store.context.save()
                        editingLog = nil
                    } catch {
                        assertionFailure("\(error)")
                    }
                } label: {
                    Text(L10n.Common.save)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                }
                .background(Color.accentColor)
                .foregroundColor(Color(uiColor: .systemBackground))
                .cornerRadius(8)
            }
        }
        .padding()
    }
}
