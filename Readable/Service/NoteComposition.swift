//
//  NoteComposition.swift
//  Readable
//
//  Created by Codex on 11/04/2026.
//

import Foundation

enum NoteFactory {
    static func makeBlankNote(now: Date = .now) -> Note {
        Note(
            title: "",
            body: "",
            createdAt: now,
            updatedAt: now,
            isPinned: false
        )
    }
}

enum NoteComposer {
    static func merge(existingBody: String, addition: String) -> String {
        let trimmedExisting = existingBody.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedExisting.isEmpty {
            return addition
        }

        return trimmedExisting + "\n\n" + addition
    }

    static func cleanedText(from input: String) -> String? {
        let cleaned = input
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: #"\\s+"#, with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleaned.isEmpty else { return nil }

        return cleaned.prefix(1).uppercased() + cleaned.dropFirst()
    }

    static func bulletPoints(from input: String) -> String? {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else { return nil }

        let lines = trimmedInput
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        if lines.count > 1 {
            return lines.map { "• \($0)" }.joined(separator: "\n")
        }

        let commaSeparatedParts = trimmedInput
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        if commaSeparatedParts.count > 1 {
            return commaSeparatedParts.map { "• \($0)" }.joined(separator: "\n")
        }

        return "• \(trimmedInput)"
    }
}
