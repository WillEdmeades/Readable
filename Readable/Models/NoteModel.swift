//
//  NoteModel.swift
//  Readable
//
//  Created by Will on 26/03/2026.
//

import Foundation
import SwiftData

/// Class used for Note data and metadata
@Model
final class Note {
    @Attribute(.unique) var id: UUID
    var title: String
    var body: String
    var createdAt: Date
    var updatedAt: Date
    var isPinned: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        body: String,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        isPinned: Bool = false
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isPinned = isPinned
    }
}

extension Note {
    var isEmptyNote: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension Note {
    static var mock: Note {
        Note(
            title: "Welcome to Readable",
            body: """
                This app is designed to make notes easier to read, revisit, and focus on.

                Tap the compose button in the top-right corner to create a new note. You can pin important notes so they stay at the top of your list.

                Below are a few sample notes to help you explore the layout and see how longer and shorter content behaves.

                Things to try:
                • Open a note to read it in full
                • Create a new note
                • Pin and unpin notes
                • Test larger text sizes in Accessibility settings

                Readable is built around clarity, calm spacing, and a more comfortable reading experience.
                """,
            createdAt: .now.addingTimeInterval(-1000),
            updatedAt: .now.addingTimeInterval(-500),
            isPinned: true
        )
    }
    
    static var mocks: [Note] {
        [
            mock,
            Note(
                title: "Next big holiday",
                body: "Where to go? What to eat? Plan it all out! (And maybe do it!) 🎉 🍻 🎈",
                createdAt: .now,
                updatedAt: .now.addingTimeInterval(-500),
                isPinned: true
            ),
            Note(
                title: "Shopping List",
                body: "Milk, eggs, bread",
                createdAt: .now.addingTimeInterval(-800),
                updatedAt: .now.addingTimeInterval(-400),
                isPinned: false
            ),
            Note(
                title: "Ideas",
                body: "Make this app clean, simple, and accessible.",
                createdAt: .now.addingTimeInterval(-600),
                updatedAt: .now.addingTimeInterval(-200),
                isPinned: false
            ),
            Note(
                title: "A very long note title that should wrap correctly when dynamic type is very large",
                body: "This is a much longer body preview to test how the layout behaves when users need larger text sizes and more space.",
                isPinned: true
            ),
            Note(
                title: "Short title",
                body: "Short body",
                isPinned: false
            )
        ]
    }
}

