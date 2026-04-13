//
//  EditNote.swift
//  Readable
//
//  Created by Will on 30/03/2026.
//

import SwiftUI
import SwiftData

struct EditNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @FocusState private var focusedField: Field?

    @AppStorage("readingSize") private var readingSizeRawValue: String = ReadingSizePreference.system.rawValue
    @AppStorage("comfortableSpacing") private var comfortableSpacing: Bool = false
    @AppStorage("reducedVisualNoise") private var reducedVisualNoise: Bool = false

    enum Field {
        case title
        case body
    }

    let note: Note

    private var readingStyle: ReadingStyle {
        ReadingStyle(
            readingSize: ReadingSizePreference(rawValue: readingSizeRawValue) ?? .system,
            comfortableSpacing: comfortableSpacing,
            reducedVisualNoise: reducedVisualNoise
        )
    }

    var wordCount: Int {
        note.body.split { $0.isWhitespace || $0.isNewline }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: readingStyle.verticalSpacing) {
            TextField(
                "Title",
                text: Binding(
                    get: { note.title },
                    set: { newValue in
                        note.title = newValue
                        note.updatedAt = .now
                        save()
                    }
                ),
                axis: .vertical
            )
            .font(readingStyle.titleFont)
            .fontWeight(.semibold)
            .lineLimit(1...3)
            .padding(.top, 12)
            .focused($focusedField, equals: .title)

            TextEditor(
                text: Binding(
                    get: { note.body },
                    set: { newValue in
                        note.body = newValue
                        note.updatedAt = .now
                        save()
                    }
                )
            )
            .font(readingStyle.bodyFont)
            .foregroundStyle(readingStyle.primaryTextColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .scrollContentBackground(.hidden)
            .lineSpacing(readingStyle.lineSpacing)
            .focused($focusedField, equals: .body)

            if !readingStyle.shouldHideSecondaryMetadata {
                HStack {
                    Text(note.updatedAt.formatted(date: .abbreviated, time: .omitted))
                    Text("\(wordCount) \(wordCount == 1 ? "Word" : "Words")")
                }
                .font(readingStyle.captionFont)
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .onAppear {
            if note.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                focusedField = .title
            } else {
                focusedField = .body
            }
        }
    }

    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save note: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        EditNoteView(note: .mock)
    }
}
