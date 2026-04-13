import Testing
@testable import Readable

struct NoteComposerTests {
    @Test("merge appends with paragraph spacing when the note already has content")
    func mergeWithExistingBody() {
        let merged = NoteComposer.merge(existingBody: "Existing note", addition: "New thought")

        #expect(merged == "Existing note\n\nNew thought")
    }

    @Test("merge replaces empty body without leading whitespace")
    func mergeIntoEmptyBody() {
        let merged = NoteComposer.merge(existingBody: "   \n", addition: "New thought")

        #expect(merged == "New thought")
    }

    @Test("cleanedText collapses whitespace and capitalizes the result")
    func cleanedText() {
        let cleaned = NoteComposer.cleanedText(from: "  this is\n a   rough fragment  ")

        #expect(cleaned == "This is a rough fragment")
    }

    @Test("bulletPoints converts multiple lines into a bullet list")
    func bulletPointsFromLines() {
        let bullets = NoteComposer.bulletPoints(from: "milk\neggs\nbread")

        #expect(bullets == "• milk\n• eggs\n• bread")
    }

    @Test("bulletPoints converts comma-separated content into a bullet list")
    func bulletPointsFromCommaSeparatedText() {
        let bullets = NoteComposer.bulletPoints(from: "milk, eggs, bread")

        #expect(bullets == "• milk\n• eggs\n• bread")
    }
}
