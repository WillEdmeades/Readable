import Foundation
import Testing
@testable import Readable

struct NoteFactoryTests {
    @Test("blank note starts empty, unpinned, and timestamped consistently")
    func makeBlankNote() {
        let now = Date(timeIntervalSince1970: 123_456)

        let note = NoteFactory.makeBlankNote(now: now)

        #expect(note.title.isEmpty)
        #expect(note.body.isEmpty)
        #expect(note.createdAt == now)
        #expect(note.updatedAt == now)
        #expect(note.isPinned == false)
        #expect(note.isEmptyNote)
    }
}
