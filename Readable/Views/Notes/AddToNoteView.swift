//
//  AddToNoteView.swift
//  Readable
//
//  Created by Will on 04/04/2026.
//

import SwiftUI
import SwiftData

struct AddToNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let note: Note

    @State private var text: String = ""
    @FocusState private var isEditorFocused: Bool

    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text("What would you like to add to your note?")
                        .foregroundStyle(.secondary)
                        .padding(.top, 16)
                        .padding(.leading, 12)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $text)
                    .padding(8)
                    .focused($isEditorFocused)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            .frame(minHeight: 180)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            HStack(spacing: 12) {
                Button {
                    appendText()
                } label: {
                    Label("Append", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(trimmedInput.isEmpty)

                Button {
                    cleanAndAppend()
                } label: {
                    Label("Clean & Append", systemImage: "wand.and.stars")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(trimmedInput.isEmpty)
            }

            Button {
                appendBulletPoints()
            } label: {
                Label("Bullet Points", systemImage: "list.bullet")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(trimmedInput.isEmpty)

            Spacer()
        }
        .padding()
        .navigationTitle("Add to Note")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isEditorFocused = true
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isEditorFocused = false
                }
            }
        }
    }

    private var trimmedInput: String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func appendText() {
        guard !trimmedInput.isEmpty else { return }

        note.body = NoteComposer.merge(existingBody: note.body, addition: trimmedInput)
        note.updatedAt = .now
        saveAndDismiss()
    }

    private func cleanAndAppend() {
        guard let cleanedText = NoteComposer.cleanedText(from: trimmedInput) else { return }

        note.body = NoteComposer.merge(existingBody: note.body, addition: cleanedText)
        note.updatedAt = .now
        saveAndDismiss()
    }

    private func appendBulletPoints() {
        guard let bulletText = NoteComposer.bulletPoints(from: trimmedInput) else { return }

        note.body = NoteComposer.merge(existingBody: note.body, addition: bulletText)
        note.updatedAt = .now
        saveAndDismiss()
    }

    private func saveAndDismiss() {
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save note update: \(error)")
        }
    }
}
#Preview {
    AddToNoteView(note: .mock)
}
