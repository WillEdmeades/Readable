//
//  ReadablrApp.swift
//  Readablr
//
//  Created by Will on 26/03/2026.
//

import SwiftUI
import SwiftData

@main
struct ReadableApp: App {
    @AppStorage("hasSeededSampleNote") private var hasSeededSampleNote: Bool = false
    
    private let container: ModelContainer
    init() {
        do {
            container = try ModelContainer(for: Note.self)
            
            if !hasSeededSampleNote {
                let context = container.mainContext
                
                let sampleNote = Note(
                    title: "Welcome to Readable",
                    body: """
Welcome to Readable.

This app is designed to make notes easier to read, revisit, and focus on.

Tap the compose button in the top-right corner to create a new note. You can pin important notes so they stay at the top of your list.

Things to try:
• Open a note to read it in full
• Create a new note
• Edit a note
• Test larger text sizes in Accessibility settings

Readable is built around clarity, calm spacing, and a more comfortable reading experience.
""",
                    createdAt: .now,
                    updatedAt: .now,
                    isPinned: true
                )
                
                context.insert(sampleNote)
                try context.save()
                
                hasSeededSampleNote = true
            }
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(container)
    }
}
