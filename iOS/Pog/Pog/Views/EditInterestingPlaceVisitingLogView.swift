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
                Text("訪問時刻")
                    .font(.callout)
                    .bold()
                    .foregroundColor(.secondary)
                Spacer()
                DatePicker("訪問時刻", selection: $visitedAt)
            }
            HStack {
                Text("出発時刻")
                    .font(.callout)
                    .bold()
                    .foregroundColor(.secondary)
                Spacer()
                if let exitedAt = Binding($exitedAt) {
                    DatePicker("出発時刻", selection: exitedAt)
                }
            }
            Spacer().frame(height: 40)
            HStack {
                Button {
                    editingLog = nil
                } label: {
                    Text("キャンセル")
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
                    Text("保存")
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
