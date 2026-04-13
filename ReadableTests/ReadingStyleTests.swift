import Testing
import SwiftUI
@testable import Readable

struct ReadingStyleTests {
    @Test("comfortable spacing increases line and vertical spacing")
    func comfortableSpacingPreset() {
        let compact = ReadingStyle(
            readingSize: .system,
            comfortableSpacing: false,
            reducedVisualNoise: false
        )

        let comfortable = ReadingStyle(
            readingSize: .system,
            comfortableSpacing: true,
            reducedVisualNoise: false
        )

        #expect(comfortable.lineSpacing > compact.lineSpacing)
        #expect(comfortable.verticalSpacing > compact.verticalSpacing)
        #expect(comfortable.contentTopSpacing > compact.contentTopSpacing)
    }

    @Test("reduced visual noise hides secondary metadata")
    func reducedVisualNoisePreset() {
        let style = ReadingStyle(
            readingSize: .system,
            comfortableSpacing: false,
            reducedVisualNoise: true
        )

        #expect(style.shouldHideSecondaryMetadata)
        #expect(style.rowPreviewLineLimit == 1)
    }
}
