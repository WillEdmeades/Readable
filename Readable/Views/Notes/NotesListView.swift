//
//  NotesListView.swift
//  Readable
//
//  Created by Will on 26/03/2026.
//

import SwiftUI
import SwiftData

struct NotesListView: View {
    @Environment(\.modelContext) private var modelContext
    
    
    @State var searchText: String = ""
    @State private var path: [Note] = []
    @State private var newNote: Note?
    @State private var showingSettings = false
    
    @Query(sort: \Note.updatedAt, order: .reverse) private var notes: [Note]
    
    private var pinnedNotes: [Note] {
        notes.filter { $0.isPinned }
    }
    
    private var otherNotes: [Note] {
        notes.filter{ !$0.isPinned }
    }
    
    var body: some View {
        let pinnedLabel = HStack {
            Image(systemName: "pin.fill")
                .foregroundStyle(.blue)
            Text("Pinned")
                .textCase(.uppercase)
                .foregroundStyle(.secondary)
                .accessibilityAddTraits(.isHeader)
        }
        
        NavigationStack (path: $path) {
            List {
                /// if there are pinned notes show section
                if !pinnedNotes.isEmpty {
                    Section (header: pinnedLabel ) {
                        ForEach(pinnedNotes) { note in
                            NavigationLink {
                                NoteView(note: note)
                            } label: {
                                NoteRowView(note: note)
                            }
                        }
                        .onDelete { offsets in
                            deleteNotes(from: pinnedNotes, at: offsets)
                        }
                    }
                }
                /// if there are non-pinned notes show the section
                if !otherNotes.isEmpty {
                    Section (header: Text("Notes")
                        .foregroundStyle(.secondary)
                        .accessibilityAddTraits(.isHeader)
                        .textCase(.uppercase)) {
                            ForEach(otherNotes) { note in
                                NavigationLink {
                                    NoteView(note: note)
                                } label: {
                                    NoteRowView(note: note)
                                }
                            }
                            .onDelete { offsets in
                                deleteNotes(from: otherNotes, at: offsets)
                            }
                        }
                }
            }
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Notes")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        newNote = createNewNote()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .navigationDestination(item: $newNote) { note in
                        NoteView(note: note, startsInEditMode: true)
                    }                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .navigationDestination(for: Note.self) { note in
                if note.isEmptyNote {
                    EditNoteView(note: note)
                } else {
                    NoteView(note: note, startsInEditMode: false)
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
    
    private func createNewNote() -> Note {
        let newNote = NoteFactory.makeBlankNote()
        
        modelContext.insert(newNote)
        do{
            try modelContext.save()
        } catch {
            print("Failed to create note: \(error)")
        }
        return newNote
    }
    
    private func deleteNotes(from source: [Note], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(source[index])
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete notes: \(error)")
        }
    }
}

#Preview ("Default") {
    NotesListView()
        .modelContainer(previewContainer)
        .environment(\.dynamicTypeSize, .medium)
}

#Preview("Dynamic Text") {
    NotesListView()
        .modelContainer(previewContainer)
        .environment(\.dynamicTypeSize, .accessibility3)
}
