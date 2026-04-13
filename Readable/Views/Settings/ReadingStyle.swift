//
//  ReadingStyle.swift
//  Readable
//
//  Created by Will on 03/04/2026.
//

import SwiftUI

struct ReadingStyle {
    let readingSize: ReadingSizePreference
    let comfortableSpacing: Bool
    let reducedVisualNoise: Bool

    var titleFont: Font {
        switch readingSize {
        case .system:
            return .title
        case .large:
            return .largeTitle
        case .extraLarge:
            return .system(.largeTitle, design: .default).weight(.bold)
        }
    }

    var headlineFont: Font {
        switch readingSize {
        case .system:
            return .headline
        case .large:
            return .title2
        case .extraLarge:
            return .title
        }
    }

    var bodyFont: Font {
        switch readingSize {
        case .system:
            return .body
        case .large:
            return .title2
        case .extraLarge:
            return .title
        }
    }

    var subheadlineFont: Font {
        switch readingSize {
        case .system:
            return .subheadline
        case .large:
            return .body
        case .extraLarge:
            return .title3
        }
    }

    var captionFont: Font {
        switch readingSize {
        case .system:
            return .caption
        case .large:
            return .footnote
        case .extraLarge:
            return .subheadline
        }
    }

    var rowTitleFont: Font {
        switch readingSize {
        case .system:
            return .headline
        case .large:
            return .title3
        case .extraLarge:
            return .title2
        }
    }

    var rowBodyFont: Font {
        switch readingSize {
        case .system:
            return .subheadline
        case .large:
            return .body
        case .extraLarge:
            return .title3
        }
    }

    var rowDateFont: Font {
        switch readingSize {
        case .system:
            return .caption
        case .large:
            return .footnote
        case .extraLarge:
            return .subheadline
        }
    }

    var lineSpacing: CGFloat {
        comfortableSpacing ? 8 : 4
    }

    var rowLineSpacing: CGFloat {
        comfortableSpacing ? 6 : 3
    }

    var verticalSpacing: CGFloat {
        comfortableSpacing ? 12 : 8
    }

    var contentTopSpacing: CGFloat {
        comfortableSpacing ? 24 : 16
    }

    var metadataTopSpacing: CGFloat {
        comfortableSpacing ? 56 : 40
    }

    var horizontalPadding: CGFloat {
        comfortableSpacing ? 24 : 20
    }

    var primaryTextColor: Color {
        .primary
    }

    var secondaryTextColor: Color {
        .secondary
    }

    var shouldHideSecondaryMetadata: Bool {
        reducedVisualNoise
    }

    var rowPreviewLineLimit: Int {
        reducedVisualNoise ? 1 : 2
    }
}
