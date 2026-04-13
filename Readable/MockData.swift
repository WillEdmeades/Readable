//
//  MockData.swift
//  Readable
//
//  Created by Will on 27/03/2026.
//

import SwiftUI
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Note.self, configurations: config)

        for note in Note.mocks {
            container.mainContext.insert(note)
        }
        try container.mainContext.save()
        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()
