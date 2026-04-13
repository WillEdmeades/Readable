//
//  NoteRowView.swift
//  Readable
//
//  Created by Will on 27/03/2026.
//

import SwiftUI

struct NoteRowView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @AppStorage("readingSize") private var readingSizeRawValue: String = ReadingSizePreference.system.rawValue
    @AppStorage("comfortableSpacing") private var comfortableSpacing: Bool = false
    @AppStorage("increasedContrast") private var increasedContrast: Bool = false
    @AppStorage("reducedVisualNoise") private var reducedVisualNoise: Bool = false

    let note: Note

    private var isAccessibilitySize: Bool {
        dynamicTypeSize.isAccessibilitySize
    }

    private var readingStyle: ReadingStyle {
        ReadingStyle(
            readingSize: ReadingSizePreference(rawValue: readingSizeRawValue) ?? .system,
            comfortableSpacing: comfortableSpacing,
            reducedVisualNoise: reducedVisualNoise
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: comfortableSpacing ? 8 : 4) {
            if isAccessibilitySize {
                titleView
                if !reducedVisualNoise {
                    dateView
                }
            } else {
                HStack(alignment: .firstTextBaseline) {
                    titleView
                    Spacer()
                    if !reducedVisualNoise {
                        dateView
                    }
                }
            }

            Text(note.body.isEmpty ? "No additional text" : note.body)
                .font(readingStyle.rowBodyFont)
                .lineLimit(reducedVisualNoise ? 1 : 2)
                .lineSpacing(readingStyle.lineSpacing)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint(note.isPinned ? "Pinned note" : "")
        .padding(.horizontal, Constants.horizontalPadding)
    }

    private var titleView: some View {
        Text(note.title.isEmpty ? "New Note" : note.title)
            .font(readingStyle.rowTitleFont)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
            .lineLimit(isAccessibilitySize ? 2 : 1)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var dateView: some View {
        Text(note.updatedAt, format: .dateTime.day().month())
            .font(readingStyle.rowDateFont)
            .accessibilityLabel("Last edited \(note.updatedAt.formatted(date: .complete, time: .omitted))")
    }
}

#Preview {
    NoteRowView(note: .mock)
}
