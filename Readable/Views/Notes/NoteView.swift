//
//  NoteView.swift
//  Readable
//
//  Created by Will on 27/03/2026.
//

import SwiftUI
import SwiftData

struct NoteView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.modelContext) private var modelContext
    
    @AppStorage("readingSize") private var readingSizeRawValue: String = ReadingSizePreference.system.rawValue
    @AppStorage("comfortableSpacing") private var comfortableSpacing: Bool = false
    @AppStorage("reducedVisualNoise") private var reducedVisualNoise: Bool = false
    
    @StateObject private var speechManager = SpeechManager()
    
    let note: Note
    let startsInEditMode: Bool
    @State private var isEditing: Bool
    @State private var showingAddToNote = false
    
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
    
    private var isCalmReadingMode: Bool {
        readingStyle.shouldHideSecondaryMetadata
    }
    
    init(note: Note, startsInEditMode: Bool = false) {
        self.note = note
        self.startsInEditMode = startsInEditMode
        _isEditing = State(initialValue: startsInEditMode)
    }
    
    var body: some View {
        Group {
            if isEditing {
                EditNoteView(note: note)
            } else {
                noteReadView
            }
        }
        .onDisappear {
            if startsInEditMode && note.isEmptyNote {
                modelContext.delete(note)
                
                do {
                    try modelContext.save()
                } catch {
                    print("Failed to delete empty note: \(error)")
                }
            }
        }
        .toolbar {
            if isCalmReadingMode && !isEditing {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showingAddToNote = true
                        } label: {
                            Label("Add to Note", systemImage: "plus.bubble")
                        }
                        Button {
                            speechManager.stop()
                            isEditing = true
                        } label: {
                            Label("Edit", systemImage: "square.and.pencil")
                        }
                        
                        Button {
                            if speechManager.isSpeaking {
                                speechManager.stop()
                            } else {
                                speechManager.speak(title: note.title, body: note.body)
                            }
                        } label: {
                            Label(
                                speechManager.isSpeaking ? "Stop Reading" : "Read Aloud",
                                systemImage: speechManager.isSpeaking ? "stop.fill" : "speaker.wave.3.fill"
                            )
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .accessibilityLabel("Reading options")
                }
            } else {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if !isEditing {
                            speechManager.stop()
                        }
                        isEditing.toggle()
                    } label: {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
                
                if !isEditing {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            if speechManager.isSpeaking {
                                speechManager.stop()
                            } else {
                                speechManager.speak(title: note.title, body: note.body)
                            }
                        } label: {
                            Image(systemName: speechManager.isSpeaking ? "stop.fill" : "speaker.wave.3.fill")
                        }
                        .accessibilityLabel(speechManager.isSpeaking ? "Stop reading" : "Read aloud")
                        .foregroundStyle(.secondary)
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showingAddToNote = true
                        } label: {
                            Image(systemName: "plus.bubble")
                        }
                        .accessibilityLabel("Add to note")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddToNote) {
            NavigationStack {
                AddToNoteView(note: note)
            }
        }
    }
    
    private var noteReadView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: readingStyle.verticalSpacing) {
                Text(note.title.isEmpty ? "Untitled" : note.title)
                    .font(readingStyle.titleFont)
                    .bold()
                    .foregroundStyle(readingStyle.primaryTextColor)
                
                Text(note.body.isEmpty ? "No Content" : note.body)
                    .font(readingStyle.bodyFont)
                    .foregroundStyle(readingStyle.primaryTextColor)
                    .lineSpacing(readingStyle.lineSpacing)
                    .fixedSize(horizontal: false, vertical: true)
                    .textSelection(.enabled)
                    .padding(.top, readingStyle.contentTopSpacing)
                
                Spacer(minLength: 40)
                
                if !isCalmReadingMode && !isEditing {
                    Text("Modified \(note.updatedAt.formatted(date: .abbreviated, time: .shortened))")
                        .font(readingStyle.captionFont)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, readingStyle.metadataTopSpacing)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(
                .horizontal,
                isAccessibilitySize ? Constants.horizontalPaddingLarge : Constants.horizontalPadding
            )
        }
    }
}

private func previewDefaults(
    readingSize: ReadingSizePreference = .system,
    comfortableSpacing: Bool = false,
    reducedVisualNoise: Bool = false,
    suiteName: String
) -> UserDefaults {
    let defaults = UserDefaults(suiteName: suiteName)!
    defaults.removePersistentDomain(forName: suiteName)
    
    defaults.set(readingSize.rawValue, forKey: "readingSize")
    defaults.set(comfortableSpacing, forKey: "comfortableSpacing")
    defaults.set(reducedVisualNoise, forKey: "reducedVisualNoise")
    
    return defaults
}

private func notePreview(
    readingSize: ReadingSizePreference = .system,
    comfortableSpacing: Bool = false,
    reducedVisualNoise: Bool = false,
    dynamicTypeSize: DynamicTypeSize? = nil,
    suiteName: String
) -> some View {
    let view = NavigationStack {
        NoteView(note: .mock, startsInEditMode: false)
    }
        .modelContainer(previewContainer)
        .defaultAppStorage(
            previewDefaults(
                readingSize: readingSize,
                comfortableSpacing: comfortableSpacing,
                reducedVisualNoise: reducedVisualNoise,
                suiteName: suiteName
            )
        )
    
    if let dynamicTypeSize {
        return AnyView(view.environment(\.dynamicTypeSize, dynamicTypeSize))
    } else {
        return AnyView(view)
    }
}

#Preview("Standard") {
    notePreview(
        readingSize: .system,
        comfortableSpacing: false,
        reducedVisualNoise: false,
        suiteName: "preview.standard"
    )
}

#Preview("Large Text") {
    notePreview(
        readingSize: .large,
        comfortableSpacing: false,
        reducedVisualNoise: false,
        suiteName: "preview.largeText"
    )
}

#Preview("Reduced Visual Noise") {
    notePreview(
        readingSize: .system,
        comfortableSpacing: false,
        reducedVisualNoise: true,
        suiteName: "preview.calm"
    )
}

#Preview("Comfortable Spacing") {
    notePreview(
        readingSize: .system,
        comfortableSpacing: true,
        reducedVisualNoise: false,
        suiteName: "preview.spacing"
    )
}

#Preview("Accessibility Dynamic Type") {
    notePreview(
        readingSize: .system,
        comfortableSpacing: false,
        reducedVisualNoise: false,
        dynamicTypeSize: .accessibility3,
        suiteName: "preview.accessibility"
    )
}
